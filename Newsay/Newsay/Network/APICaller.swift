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
}

