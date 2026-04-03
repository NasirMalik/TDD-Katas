// Invoice Standardization System — INSTAVOICED Kata
// https://sammancoaching.org/kata_descriptions/instavoiced.html
//
// Architectural kata:
//   Receive PDFs from ~200 European suppliers in multiple languages.
//   Standardize to XML in English and deliver to BIGCO's FTP once per day.
//   Archive invoices for 10-year retrieval.
//
// This file models the core domain objects and pipeline for unit testing.
// The actual integration (FTP, POST_TO_PDF) would use injected ports.

import Foundation

// MARK: - Domain

struct Invoice {
    let id:           String
    let supplierID:   String
    let language:     String
    let rawPDFData:   Data
    let receivedAt:   Date
}

struct StandardizedInvoice {
    let id:          String
    let supplierID:  String
    let xmlContent:  String
    let processedAt: Date
}

// MARK: - Ports (dependency injection for testability)

protocol InvoiceRepository {
    func fetchPending() -> [Invoice]
    func archive(_ invoice: Invoice)
}

protocol OCREngine {
    func extractFields(from pdf: Data, supplierID: String) -> [String: String]
}

protocol XMLSerializer {
    func serialize(fields: [String: String], invoiceID: String) -> String
}

protocol FTPDelivery {
    func deliver(_ xml: String, as filename: String) throws
}

// MARK: - Pipeline

struct InstavoicedPipeline {
    private let repository:  InvoiceRepository
    private let ocr:         OCREngine
    private let serializer:  XMLSerializer
    private let ftp:         FTPDelivery

    init(repository: InvoiceRepository, ocr: OCREngine,
         serializer: XMLSerializer, ftp: FTPDelivery) {
        self.repository = repository
        self.ocr        = ocr
        self.serializer = serializer
        self.ftp        = ftp
    }

    func processDailyBatch() throws -> Int {
        let invoices = repository.fetchPending()
        var processed = 0

        for invoice in invoices {
            let fields    = ocr.extractFields(from: invoice.rawPDFData, supplierID: invoice.supplierID)
            let xml       = serializer.serialize(fields: fields, invoiceID: invoice.id)
            try ftp.deliver(xml, as: "invoice_\(invoice.id).xml")
            repository.archive(invoice)
            processed += 1
        }

        return processed
    }
}

// MARK: - Stubs

class SpyFTPDelivery: FTPDelivery {
    private(set) var delivered: [(filename: String, xml: String)] = []
    func deliver(_ xml: String, as filename: String) throws {
        delivered.append((filename: filename, xml: xml))
    }
}

struct StubOCREngine: OCREngine {
    func extractFields(from pdf: Data, supplierID: String) -> [String: String] {
        ["invoiceNumber": "INV-001", "amount": "500.00", "currency": "EUR"]
    }
}

struct StubXMLSerializer: XMLSerializer {
    func serialize(fields: [String: String], invoiceID: String) -> String {
        "<invoice id=\"\(invoiceID)\">\(fields.map { "<\($0.key)>\($0.value)</\($0.key)>" }.joined())</invoice>"
    }
}

class InMemoryInvoiceRepository: InvoiceRepository {
    private var invoices: [Invoice]
    private(set) var archived: [Invoice] = []

    init(invoices: [Invoice]) { self.invoices = invoices }

    func fetchPending() -> [Invoice] { invoices }
    func archive(_ invoice: Invoice) {
        invoices.removeAll { $0.id == invoice.id }
        archived.append(invoice)
    }
}

// MARK: - Test Helpers

func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ label: String = "") {
    if actual == expected {
        print("PASS\(label.isEmpty ? "" : " [\(label)]")")
    } else {
        print("FAIL\(label.isEmpty ? "" : " [\(label)]") — expected \"\(expected)\", got \"\(actual)\"")
    }
}

// MARK: - Tests

func runTests() {
    let invoices = [
        Invoice(id: "1", supplierID: "SUP-FR-001", language: "fr",
                rawPDFData: Data(), receivedAt: Date()),
        Invoice(id: "2", supplierID: "SUP-DE-007", language: "de",
                rawPDFData: Data(), receivedAt: Date())
    ]

    let repo       = InMemoryInvoiceRepository(invoices: invoices)
    let ftp        = SpyFTPDelivery()
    let pipeline   = InstavoicedPipeline(
        repository: repo,
        ocr:        StubOCREngine(),
        serializer: StubXMLSerializer(),
        ftp:        ftp
    )

    let count = try! pipeline.processDailyBatch()
    assertEqual(count, 2, "all invoices processed")
    assertEqual(ftp.delivered.count, 2, "two files delivered to FTP")
    assertEqual(ftp.delivered[0].filename, "invoice_1.xml", "first filename")
    assertEqual(ftp.delivered[1].filename, "invoice_2.xml", "second filename")
    assertEqual(repo.archived.count, 2, "all invoices archived")

    // Re-run on empty → 0 processed
    let count2 = try! pipeline.processDailyBatch()
    assertEqual(count2, 0, "no pending invoices on second run")
}

runTests()
