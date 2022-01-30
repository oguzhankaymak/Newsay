import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=\(APISecrets.API_KEY)"
    }
    
    enum APIError : Error {
        case failedToGetData
    }
    
    public func getNews(completion: @escaping (Result<NewsResponse, Error>) -> Void){
        guard let url = URL(string: Constants.baseAPIURL) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(result))
            }
            
            catch {
                print("error.localizedDescription : \(error.localizedDescription)")
                print("error : \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

