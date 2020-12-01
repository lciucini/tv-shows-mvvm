//
//  NetworkManager.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 22/11/2020.
//

import Foundation
import RxSwift

class NetworkManager {
    let apiKey = "208ca80d1e219453796a7f9792d16776"
    let baseApiUrl = "https://api.themoviedb.org/3"
    let urlSession = URLSession.shared
    
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return jsonDecoder
    }()
    
    
    
    
    func fetch<T: Codable>(url: String, params: [String: String]? = nil) -> Single<T> {
        
        return Single<T>.create { single in
            guard var urlComponents = URLComponents(string: "\(self.baseApiUrl)\(url)") else {
                single(.error(NetworkManagerError.invalidURL))
                return Disposables.create()
            }
            
            var queryItems = [URLQueryItem(name: "api_key", value: self.apiKey)]
            
            if let params = params {
                queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
            }
            
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                single(.error(NetworkManagerError.invalidURL))
                return Disposables.create()
            }
            
            let task = self.urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    single(.error(NetworkManagerError.apiError))
                }
                
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    single(.error(NetworkManagerError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    single(.error(NetworkManagerError.emptyData))
                    return
                }
                
                do {
                    let response = try self.jsonDecoder.decode(T.self, from: data)
                    single(.success(response))
                } catch let error {
                    print(error)
                    single(.error(NetworkManagerError.serializationError))
                }
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}

public enum NetworkManagerError: Error {
    case apiError
    case invalidResponse
    case invalidURL
    case emptyData
    case serializationError
}
