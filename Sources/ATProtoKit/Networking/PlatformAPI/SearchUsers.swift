//
//  SearchUsers.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

extension ATProtoKit {
    /// Looks for user profiles (actors) matching the search term.
    /// 
    /// This will search for the display names, descriptions, and handles within the user profiles. However, this API call can only return results of a matching handle. If you want search suggestion
    ///  (where it returns results based on a partial term instead of the exact term), a different method is needed.
    ///
    /// - Bug: According to the AT Protocol specifications, this API call does not require authentication. However, there's an issue where it asks for authentication if there's no `accessToken`.
    /// It's unknown whether this is an issue on the AT Protocol's end or `AKProtoKit`'s end. For now, use the `shouldAuthenticate` parameter when using this method.
    ///
    /// - Parameters:
    ///   - query: The string used against a list of actors.
    ///   - limit: The number of suggested users to follow. Optional. Defaults to 25. Can only choose between 1 and 100.
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - accessToken: The access token
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///   - shouldAuthenticate: Indicates whether the method will use the access token when sending the request. Defaults to `false`.
    /// - Returns: A `Result`, containing either ``ActorSearchActorsOutput`` if successful, and an `Error` if not.
    public func searchUsers(by query: String, limit: Int? = 25, cursor: String? = nil,
                            pdsURL: String? = nil,
                            shouldAuthenticate: Bool = false) async throws -> Result<ActorSearchActorsOutput, Error> {
        var accessToken: String? = nil

        if shouldAuthenticate == true {
            guard session != nil,
                  accessToken == session?.accessToken else {
                throw ATRequestPrepareError.missingActiveSession
            }
        }

        let finalPDSURL = determinePDSURL(customPDSURL: pdsURL)
        
        guard let requestURL = URL(string: "\(finalPDSURL)/xrpc/app.bsky.actor.searchActors") else {
            return .failure(ATRequestPrepareError.invalidRequestURL)
        }

        // Use guard to check if accessToken is non-nil and non-empty, otherwise set authorizationValue to nil.
        let authorizationValue: String? = {
            guard let token = accessToken, !token.isEmpty else { return nil }
            return "Bearer \(token)"
        }()

        // Make sure limit is between 1 and 100. If no value is given, set it to 25.
        let finalLimit = max(1, min(limit ?? 25, 100))

        var queryItems = [
            ("q", query),
            ("limit", "\(finalLimit)")
        ]

        if let cursor {
            queryItems.append(("cursor", cursor))
        }

        let queryURL: URL

        do {
            queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
            )

            let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .get,
                                                         acceptValue: "application/json",
                                                         authorizationValue: authorizationValue)
            let response = try await APIClientService.sendRequest(request,
                                                                  decodeTo: ActorSearchActorsOutput.self)

            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
