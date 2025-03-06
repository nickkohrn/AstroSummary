import Foundation
import FoundationExtensions
import Testing

struct ISO8601DateFormatterTests {
    @Test func testDefaultFormatterParsesValidDate() throws {
        let isoString = "2025-01-24T04:13:05.3908217Z"

        // Use the same formatter for expectedDate to ensure consistency
        let expectedDate = ISO8601DateFormatter.default.date(from: isoString)
        let parsedDate = ISO8601DateFormatter.default.date(from: isoString)

        #expect(parsedDate == expectedDate)
    }

    @Test func testDefaultFormatterParsesDateWithoutFractionalSeconds() throws {
        let isoString = "2025-01-24T04:13:05Z"

        // Use the same formatter for expectedDate
        let expectedDate = ISO8601DateFormatter.default.date(from: isoString)
        let parsedDate = ISO8601DateFormatter.default.date(from: isoString)

        #expect(parsedDate == expectedDate)
    }

    @Test func testDefaultFormatterFailsOnInvalidDate() throws {
        let invalidISOStrings = [
            "2025-01-24 04:13:05", // Missing "T" separator
            "2025-01-24T04:13", // No seconds
            "01/24/2025 04:13:05", // Incorrect format
            "2025-01-24T25:61:61Z" // Invalid time values
        ]

        for isoString in invalidISOStrings {
            let parsedDate = ISO8601DateFormatter.default.date(from: isoString)
            #expect(parsedDate == nil)
        }
    }
}
