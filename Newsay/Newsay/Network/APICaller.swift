import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=\(APISecrets.API_KEY)&pageSize=10"
    }
    
    enum APIError : Error {
        case failedToGetData
    }
    
    public func getNews(with page: Int, completion: @escaping (Result<NewsResponse, Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseAPIURL)&page=\(page)") else {
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
    
    public func getNewsByCategory(categoryKey: String, page: Int ,completion: @escaping (Result<NewsResponse, Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseAPIURL)&category=\(categoryKey)&page=\(page)" ) else {
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
    
    public func getNewsBySearch(with searchText: String, completion: @escaping (Result<NewsResponse, Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseAPIURL)&q=\(searchText)" ) else {
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

