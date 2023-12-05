import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case httpError(_ statusCode: Int)
    case requestError(_ error: Error)
}

protocol NetworkClient {
    func fetchPhotos(with tags: String, completion: @escaping (Result<FlickrResponse, NetworkError>) -> Void)
}

class NetworkClientImp: NetworkClient {
    
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    private let session = URLSession(configuration: .default)
    
    func fetchPhotos(with tags: String, completion: @escaping (Result<FlickrResponse, NetworkError>) -> Void) {
        guard var components = URLComponents(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        components.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: tags)
        ]

        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.requestError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.httpError(httpResponse.statusCode)))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(FlickrResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(NetworkError.requestError(error)))
                }
            } else {
                completion(.failure(NetworkError.noData))
            }
        }
        task.resume()
    }
}


