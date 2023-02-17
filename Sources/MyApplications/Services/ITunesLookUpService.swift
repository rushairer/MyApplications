//
//  ITunesLookUpService.swift
//  
//
//  Created by Abenx on 2023/2/15.
//

import Foundation

public struct ITunesLookUpService {
    let iTunesAPIURLString: String!
    public init(iTunesAPIURLString: String = "https://itunes.apple.com/lookup") {
        self.iTunesAPIURLString = iTunesAPIURLString
    }
    
    public func request(id: String, language: String = "en_US") async -> LookUpResponseResult? {
        guard var urlComponents = URLComponents(string: iTunesAPIURLString) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: id),
            URLQueryItem(name: "entity", value: "software"),
            URLQueryItem(name: "l", value: language)
        ]
        guard let url = urlComponents.url else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print(String(data: data, encoding: .utf8) as Any)
                print(url.relativeString, Locale.current)
                return nil
            }
            let decoder = JSONDecoder()
            return try decoder.decode(LookUpResponseResult.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
