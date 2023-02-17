//
//  ApplicationInfo.swift
//  
//
//  Created by Abenx on 2023/2/15.
//

import Foundation

public struct LookUpResponseResult: Codable {
    public enum WrapperType: String, Codable {
        case artist
        case software
    }

    public struct Result: Codable {
        public var wrapperType: WrapperType
        public var artistName: String
        public var artistId: Int64
        
        public var artistLinkUrl: String?
        public var artistType: String?
        
        public var bundleId: String?
        public var trackName: String?
        public var trackId: Int64?
        public var description: String?
        public var artworkUrl60: String?
        public var artworkUrl100: String?
        public var artworkUrl512: String?
        public var trackViewUrl: String?
        public var screenshotUrls: [String]?
    }
    
    public var resultCount: Int
    public var results: [Result]
}
