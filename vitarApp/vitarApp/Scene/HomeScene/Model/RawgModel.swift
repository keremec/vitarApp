//
//  RawgModel.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 12.12.2022.
//

import Foundation

struct RawgModel: Decodable {
    let id: Int?
    let tba: Bool?
    let name: String?
    let released: String?
    let metacritic: Int?
    let rating: EsrbRating?
    let parentPlatforms: [ParentPlatform]?
    let genres: [Genre]?
    let imageWide: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case tba
        case name
        case released
        case metacritic
        case genres
        case rating = "esrb_rating"
        case parentPlatforms = "parent_platforms"
        case imageWide = "background_image"
    }
}
