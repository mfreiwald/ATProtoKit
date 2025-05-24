import XCTest
@testable import ATProtoKit

final class ATProtoKitTests: XCTestCase {
    func testExample() async throws {
        let config = ATProtocolConfiguration()
        try await config.authenticate(with: "", password: "")
        let kit = await ATProtoKit(sessionConfiguration: config)
        var cursor: String?
        repeat {
            let result = try await kit.getAuthorFeed(by: "jay.bsky.team", limit: 100, cursor: cursor)
            cursor = result.cursor
        } while cursor != nil
    }
}
