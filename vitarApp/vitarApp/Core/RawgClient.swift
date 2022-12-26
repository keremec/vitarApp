//
//  RawgClient.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 9.12.2022.
//

import Foundation
import Alamofire

final class RawgClient {
    static let BASE_URL = "https://rawg.io/api/games"
    static let API_URL = "https://api.rawg.io/api/games"
    
    static func getPopularGames(completion: @escaping ([RawgModel]?, Error?) -> Void) {
        let urlString = BASE_URL + "/lists/main?discover=true&ordering=-relevance&page_size=40&page=1" + "&key=" + Secrets.RAWG_API_KEY
        handleResponse(urlString: urlString, responseType: GetRawgResponseModel.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
    
    static func searchGames(gameName:String, completion: @escaping ([RawgModel]?, Error?) -> Void) {
        let encodedString = gameName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "*"
        let urlString = API_URL + "?search_precise=true" + "&search=" + encodedString + "&key=" + Secrets.RAWG_API_KEY
        handleResponse(urlString: urlString, responseType: GetRawgResponseModel.self) { responseModel, error in
            completion(responseModel?.results, error)
        }
    }
    
    
    static func getGameDetail(gameId: Int, completion: @escaping (RawgDetailModel?, Error?) -> Void) {
        let urlString = API_URL + "/" + String(gameId) + "?key=" + Secrets.RAWG_API_KEY
        handleResponse(urlString: urlString, responseType: RawgDetailModel.self, completion: completion)
    }
    
    static private func handleResponse<T: Decodable>(urlString: String, responseType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        AF.request(urlString).response { response in
            guard let data = response.value else {
                DispatchQueue.main.async {
                    completion(nil, response.error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(T.self, from: data!)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
