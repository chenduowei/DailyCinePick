//
//  Movie.swift
//  MovieRecommender
//
//  Created by chenduowei on 2023/4/7.
//

import Foundation

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String?
    let name: String?
    let poster_path: String?
    let overview: String?
    let vote_average: Double
    let media_type: String

    var displayTitle: String {
        return title ?? name ?? "N/A"
    }

    var posterURL: String {
        return "https://image.tmdb.org/t/p/w500\(poster_path ?? "")"
    }

    var watchLink: String {
        if media_type == "movie" {
            return "https://www.themoviedb.org/movie/\(id)"
        } else {
            return "https://www.themoviedb.org/tv/\(id)"
        }
    }

    var review: String {
        return overview ?? "N/A"
    }

    var rating: Double {
        return vote_average
    }

    enum CodingKeys: String, CodingKey {
        case id, title, name, overview, poster_path, vote_average, media_type
    }
}
