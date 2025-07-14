//
//  URLSession+objectTask.swift
//  ImageFeed
//
//  Created by   Дмитрий Кривенко on 27.05.2025.
//
import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let jsonData):
                do {
                    let response = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(Result.success(response))
                } catch let error {
                    print("[Ошибка декодирования]: \(error.localizedDescription), Данные: \(String(data: jsonData, encoding: .utf8) ?? "")")
                    completion(Result.failure(error))
                }
            case .failure(let error):
                print("[objectTask]: \(error.localizedDescription)")
                completion(Result.failure(error))
            }
        }
        return task
    }
}
