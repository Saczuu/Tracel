//
//  Interactor.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/28/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Combine
import Foundation

class Interactor {
    
    
    // MARK: - INPOST status list request
    func fetchInpostStatuses(result: @escaping (Result<StatusesInpost, NetworkError>) -> Void ){
        let url = URL(string: "https://api-shipx-pl.easypack24.net/v1/statuses")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            let json = JSONDecoder()
            do {
                let statuses = try! json.decode(StatusesInpost.self, from: data!)
                result(.success(statuses))
            } catch {
                result(.failure(NetworkError.unableToFetch))
            }
        }.resume()
    }
}
