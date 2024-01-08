//
//  StatisticsNetworkClientProtocol.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 20.12.23.
//

import Foundation

protocol StatisticsNetworkClientProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask?
    func sendRequest(to url: URL, body: Data?, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask?
}

final class StatisticsNetworkClient: StatisticsNetworkClientProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask? {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                let noDataError = NSError(domain: "NoData", code: 0, userInfo: nil)
                completion(.failure(noDataError))
            }
        }
        task.resume()
        return task
    }
    
    func sendRequest(to url: URL, body: Data?, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask? {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let bodyData = body {
            let bodyString = String(data: bodyData, encoding: .utf8)
            urlRequest.httpBody = bodyString?.data(using: .utf8)
            print("Request Body: \(bodyString ?? "")")
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }

            if let data = data {
                completion(.success(data))
            } else {
                let noDataError = NSError(domain: "NoData", code: 0, userInfo: nil)
                completion(.failure(noDataError))
            }
        }
        task.resume()
        return task
    }
}
