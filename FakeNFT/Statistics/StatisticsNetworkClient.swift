//
//  StatisticsNetworkClientProtocol.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 20.12.23.
//

import Foundation

protocol StatisticsNetworkClientProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func sendRequest(to url: URL, body: Data?, completion: @escaping (Result<Data, Error>) -> Void)
}

final class StatisticsNetworkClient: StatisticsNetworkClientProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            
            if let data = data {
                completion(.success(data))
            } else {
                let noDataError = NSError(domain: "NoData", code: 0, userInfo: nil)
                completion(.failure(noDataError))
            }
        }
        task.resume()
    }
    
    func sendRequest(to url: URL, body: Data?, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let bodyData = body {
            let bodyString = String(data: bodyData, encoding: .utf8)
            urlRequest.httpBody = bodyString?.data(using: .utf8)
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            let httpResponse = response as? HTTPURLResponse

            if let data = data {
                completion(.success(data))
            } else {
                let noDataError = NSError(domain: "NoData", code: 0, userInfo: nil)
                completion(.failure(noDataError))
            }
        }
        task.resume()
    }
}
