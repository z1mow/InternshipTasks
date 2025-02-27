//
//  YouTubeVideo.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 25.02.2025.
//

import Foundation


struct YouTubeVideo: Codable {
    let videoId: String
    let title: String
    let channelTitle: String
    let thumbnailURL: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case videoId
        case title
        case channelTitle
        case thumbnailURL
        case description
    }
}

struct YouTubeSearchResponse: Codable {
    let items: [YouTubeVideoItem]
}

struct YouTubeVideoItem: Codable {
    let id: VideoID
    let snippet: VideoSnippet
}

struct VideoID: Codable {
    let videoId: String?
}

struct VideoSnippet: Codable {
    let title: String
    let channelTitle: String
    let description: String
    let thumbnails: Thumbnails
}

struct Thumbnails: Codable {
    let medium: Thumbnail
}

struct Thumbnail: Codable {
    let url: String
}
