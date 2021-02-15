import Foundation
import Combine

public extension Fred.Query  {
    
    // TODO: Improve error handling
    @available(OSX 10.15, *)
    func fetch() -> AnyPublisher<Fred.Result, Error> {
        url = "\(url)&file_type=json" // Set file_type to JSON (default is XML)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60
        let session = URLSession(configuration: sessionConfig)
        
        print(url)
        
        return session
            .dataTaskPublisher(for: URL(string: url)!)
            .map { $0.data }
            .decode(type: Fred.Result.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    // MARK: - Alias for completion handler for http request
    typealias CompletionHandler = (Fred.Result?) -> Void
    
    // MARK: - fetch: makes an API request asynchronously
    func fetch(onCompletion: @escaping CompletionHandler) {
        
        url = "\(url)&file_type=json" // Set file_type to JSON (default is XML)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            var fredResult: Fred.Result?
            
            guard let data = data else { return }
            
            // let jsonData = try! JSONSerialization.data(withJSONObject: data)
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            fredResult = try? decoder.decode(Fred.Result.self, from: data)
            onCompletion(fredResult)
        }
        
        task.resume()
    }
    
    // Makes a synchronous request to the API
    func fetchSync() throws -> Fred.Result {
        
        url = "\(url)&file_type=json" // Set file_type to JSON (default is XML)
        
        print(url)
        
        let data = try Data(contentsOf: URL(string: url)!)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(Fred.Result.self, from: data)
    }
}
