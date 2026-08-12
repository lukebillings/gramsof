import Foundation
import UIKit

enum ProteinDataExport {
    private static let csvHeader = "id,name,grams,loggedAt"

    static func csv(from entries: [ProteinEntry]) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        var lines = [csvHeader]
        for entry in entries.sorted(by: { $0.loggedAt < $1.loggedAt }) {
            let name = csvEscape(entry.name)
            let date = formatter.string(from: entry.loggedAt)
            lines.append("\(entry.id.uuidString),\(name),\(entry.grams),\(date)")
        }
        return lines.joined(separator: "\n")
    }

    static func parseCSV(_ text: String) throws -> [ProteinEntry] {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let rows = text
            .split(whereSeparator: \.isNewline)
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard let first = rows.first else { return [] }

        let startIndex = first.lowercased().hasPrefix("id,") || first.lowercased().hasPrefix("name,") ? 1 : 0
        var entries: [ProteinEntry] = []

        for row in rows.dropFirst(startIndex) {
            let columns = splitCSVLine(row)
            guard columns.count >= 3 else {
                throw ProteinDataError.invalidCSVRow(row)
            }

            let hasID = columns.count >= 4 && UUID(uuidString: columns[0]) != nil
            let id = hasID ? UUID(uuidString: columns[0])! : UUID()
            let nameIndex = hasID ? 1 : 0
            let gramsIndex = hasID ? 2 : 1
            let dateIndex = hasID ? 3 : 2

            guard columns.count > dateIndex,
                  let grams = Int(columns[gramsIndex].trimmingCharacters(in: .whitespacesAndNewlines)),
                  grams > 0,
                  let loggedAt = formatter.date(from: columns[dateIndex].trimmingCharacters(in: .whitespacesAndNewlines))
            else {
                throw ProteinDataError.invalidCSVRow(row)
            }

            let name = columns[nameIndex].trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty else { throw ProteinDataError.invalidCSVRow(row) }

            entries.append(ProteinEntry(id: id, name: name, grams: grams, loggedAt: loggedAt))
        }

        return entries
    }

    @MainActor
    static func pdfData(from entries: [ProteinEntry], dailyGoal: Int) -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 40
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

        let sorted = entries.sorted { $0.loggedAt > $1.loggedAt }
        let titleFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        let subtitleFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        let rowFont = UIFont.systemFont(ofSize: 11, weight: .regular)
        let headerFont = UIFont.systemFont(ofSize: 11, weight: .semibold)

        return renderer.pdfData { context in
            var y: CGFloat = 0

            func beginPage() {
                context.beginPage()
                y = margin
                "Gramsof protein log".draw(
                    at: CGPoint(x: margin, y: y),
                    withAttributes: [.font: titleFont, .foregroundColor: UIColor.label]
                )
                y += 28
                "Daily goal: \(dailyGoal)g  ·  \(sorted.count) entries".draw(
                    at: CGPoint(x: margin, y: y),
                    withAttributes: [.font: subtitleFont, .foregroundColor: UIColor.secondaryLabel]
                )
                y += 28
                drawRow(
                    date: "Date",
                    name: "Food",
                    grams: "Protein",
                    font: headerFont,
                    color: UIColor.secondaryLabel,
                    at: &y,
                    pageWidth: pageWidth,
                    margin: margin
                )
                y += 6
            }

            beginPage()

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short

            for entry in sorted {
                if y > pageHeight - margin - 20 {
                    beginPage()
                }

                drawRow(
                    date: dateFormatter.string(from: entry.loggedAt),
                    name: entry.name,
                    grams: "\(entry.grams)g",
                    font: rowFont,
                    color: UIColor.label,
                    at: &y,
                    pageWidth: pageWidth,
                    margin: margin
                )
                y += 4
            }
        }
    }

    private static func drawRow(
        date: String,
        name: String,
        grams: String,
        font: UIFont,
        color: UIColor,
        at y: inout CGFloat,
        pageWidth: CGFloat,
        margin: CGFloat
    ) {
        let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        date.draw(at: CGPoint(x: margin, y: y), withAttributes: attrs)
        name.draw(at: CGPoint(x: margin + 150, y: y), withAttributes: attrs)
        let gramsSize = (grams as NSString).size(withAttributes: attrs)
        grams.draw(at: CGPoint(x: pageWidth - margin - gramsSize.width, y: y), withAttributes: attrs)
        y += 16
    }

    private static func csvEscape(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return value
    }

    private static func splitCSVLine(_ line: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false
        var iterator = line.makeIterator()

        while let char = iterator.next() {
            if char == "\"" {
                if inQuotes, let next = iterator.next() {
                    if next == "\"" {
                        current.append("\"")
                    } else {
                        inQuotes = false
                        if next == "," {
                            fields.append(current)
                            current = ""
                        } else {
                            current.append(next)
                        }
                    }
                } else {
                    inQuotes.toggle()
                }
            } else if char == "," && !inQuotes {
                fields.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }

        fields.append(current)
        return fields
    }
}

enum ProteinDataError: LocalizedError {
    case invalidCSVRow(String)

    var errorDescription: String? {
        switch self {
        case .invalidCSVRow(let row):
            return "Couldn’t read CSV row: \(row)"
        }
    }
}
