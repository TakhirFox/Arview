//
//  NetworkService.swift
//  Arview
//
//  Created by Zakirov Tahir on 25.04.2021.
//

import Foundation

class NetworkService {
    private let baseUrl = "https://api.twitch.tv"
    
    func getTopGames<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        
        guard let url = URL(string: "\(urlString)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("sd4grh0omdj9a31exnpikhrmsu3v46", forHTTPHeaderField: "Client-ID")
        request.addValue("application/vnd.twitchtv.v5+json", forHTTPHeaderField: "Accept")
        
        
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            
            if error != nil {
                return
            }
            
            guard let data = data else { return }

            do {
                let topGames = try JSONDecoder().decode(T.self, from: data)
                completion(topGames, nil)
                
            } catch {
                completion(nil, error)
                print("Ошибка:", error.localizedDescription)
            }
            

            
            
        }.resume()
        
    }

    
}
