//
//  AppBskyFeedLike.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Feed {

    /// The record model definition for a like record.
    ///
    /// - Note: According to the AT Protocol specifications: "Record declaring a 'like' of a piece
    /// of subject content."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.feed.like`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/feed/like.json
    public struct LikeRecord: ATRecordProtocol, Sendable {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.feed.like"

        /// The strong reference of the like.
        ///
        /// - Note: According to the AT Protocol specifications: "Record declaring a 'like' of a
        /// piece of subject content."
        public let subject: ComAtprotoLexicon.Repository.StrongReference

        /// The date the like record was created.
        ///
        /// This is the date where the user "liked" a post.
        public let createdAt: Date

        init(subject: ComAtprotoLexicon.Repository.StrongReference, createdAt: Date) {
            self.subject = subject
            self.createdAt = createdAt
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.subject = try container.decode(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .subject)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.subject, forKey: .subject)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case subject
            case createdAt
        }
    }
}
