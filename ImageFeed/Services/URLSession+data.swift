//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 21.04.2025.
//
import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let completeOnMain: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = dataTask(with: request) { data, response, error in
            if let error = error {
                print("[URLSession.data]: 🚫 Request error — \(error.localizedDescription)")
                completeOnMain(.failure(NetworkError.urlRequestError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("[URLSession.data]: 🚫 Invalid response object")
                completeOnMain(.failure(NetworkError.urlSessionError))
                return
            }

            let statusCode = httpResponse.statusCode
            if !(200..<300).contains(statusCode) {
                print("[URLSession.data]: ❗️HTTP Error \(statusCode) — \(request.url?.absoluteString ?? "no URL")")
                completeOnMain(.failure(NetworkError.httpStatusCode(statusCode)))
                return
            }

            guard let data = data else {
                print("[URLSession.data]: 🚫 Empty data despite success status code")
                completeOnMain(.failure(NetworkError.urlSessionError))
                return
            }

            completeOnMain(.success(data))
        }

        return task
    }
}
