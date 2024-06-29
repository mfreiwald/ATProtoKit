//
//  AppBskyActorProfile.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-17.
//

import Foundation

extension AppBskyLexicon.Actor {

    /// The main data model definition for an actor.
    ///
    /// - Note: According to the AT Protocol specifications: "A declaration of a Bluesky
    /// account profile."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.profile`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/profile.json
    public struct ProfileRecord: ATRecordProtocol {

        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static private(set) var type: String = "app.bsky.actor.profile"

        /// The display name of the profile. Optional.
        public let displayName: String?

        /// The description of the profile. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Free-form profile
        /// description text."
        public let description: String?

        /// The avatar image URL of the profile. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Small image to be displayed next
        /// to posts from account. AKA, 'profile picture'"
        ///
        /// - Note: Only JPEGs and PNGs are accepted.
        public let avatarBlob: ComAtprotoLexicon.Repository.BlobContainer?

        /// The banner image URL of the profile. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Larger horizontal image to
        /// display behind profile view."
        ///
        /// - Note: Only JPEGs and PNGs are accepted.
        public let bannerBlob: ComAtprotoLexicon.Repository.BlobContainer?

        /// An array of user-defined labels. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Self-label values, specific to
        /// the Bluesky application, on the overall account."
        public let labels: [ComAtprotoLexicon.Label.SelfLabelsDefinition]?

        /// The starter pack the user account used to join Bluesky. Optional.
        public let joinedViaStarterPack: ComAtprotoLexicon.Repository.StrongReference?

        /// The date and time the profile was created. Optional.
        @DateFormattingOptional public var createdAt: Date?

        public init(type: String, displayName: String?, description: String?, avatarBlob: ComAtprotoLexicon.Repository.BlobContainer?,
                    bannerBlob: ComAtprotoLexicon.Repository.BlobContainer?, labels: [ComAtprotoLexicon.Label.SelfLabelsDefinition]?,
                    joinedViaStarterPack: ComAtprotoLexicon.Repository.StrongReference?, createdAt: Date? = nil) {
            self.displayName = displayName
            self.description = description
            self.avatarBlob = avatarBlob
            self.bannerBlob = bannerBlob
            self.labels = labels
            self.joinedViaStarterPack = joinedViaStarterPack
            self._createdAt = DateFormattingOptional(wrappedValue: createdAt)
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.avatarBlob = try container.decodeIfPresent(ComAtprotoLexicon.Repository.BlobContainer.self, forKey: .avatarBlob)
            self.bannerBlob = try container.decodeIfPresent(ComAtprotoLexicon.Repository.BlobContainer.self, forKey: .bannerBlob)
            self.labels = try container.decodeIfPresent([ComAtprotoLexicon.Label.SelfLabelsDefinition].self, forKey: .labels)
            self.joinedViaStarterPack = try container.decodeIfPresent(ComAtprotoLexicon.Repository.StrongReference.self, forKey: .joinedViaStarterPack)
            self.createdAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .createdAt)?.wrappedValue
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.displayName, forKey: .displayName)
            try container.encodeIfPresent(self.description, forKey: .description)
            try container.encodeIfPresent(self.avatarBlob, forKey: .avatarBlob)
            try container.encodeIfPresent(self.bannerBlob, forKey: .bannerBlob)
            try container.encodeIfPresent(self.labels, forKey: .labels)
            try container.encodeIfPresent(self.joinedViaStarterPack, forKey: .joinedViaStarterPack)
            try container.encode(self._createdAt, forKey: .createdAt)
        }

        enum CodingKeys: String, CodingKey {
            case displayName
            case description
            case avatarBlob = "avatar"
            case bannerBlob = "banner"
            case labels
            case joinedViaStarterPack
            case createdAt
        }
    }
}
