import Foundation

// Example
/*
 Fred.Query(categories: .Category)
    .with(.APIKey, value: fredAPIKey)
    .with(.CategoryId, value: "125")
    .fetch { response in
 
         print("Request: \(String(describing: response.request))")   // original url request
         print("Response: \(String(describing: response.response))") // http url response
         print("Result: \(response.result)")                         // response serialization result
 
         if let json = response.result.value {
            print("JSON: \(json)") // serialized json response
         }
 
         if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)") // original server data as UTF8 string
         }
    }
*/

let fredAPIKey = ""

// Reference: https://research.stlouisfed.org/docs/api/fred/

public class Fred {
    
    public class Query {
        
        // FRED request paths
        public enum Request {
            
            public enum Categories: String {
                case Category = "fred/category"                 // Get a category.
                case Children = "fred/category/children"        // Get the child categories for a specified parent category.
                case Related = "fred/category/related"          // Get the related categories for a category.
                case Series = "fred/category/series"            // Get the series in a category.
                case Tags = "fred/category/tags"                // Get the tags for a category.
                case RelatedTags = "fred/category/related_tags" // Get the related tags for a category.
            }
            
            public enum Releases: String {
                case Releases = "fred/releases"                 // Get all releases of economic data.
                case AllReleasesDates = "fred/releases/dates"   // Get release dates for all releases of economic data.
                case Release = "fred/release"                   // Get a release of economic data.
                case ReleaseDates = "fred/release/dates"        // Get release dates for a release of economic data.
                case ReleaseSeries = "fred/release/series"      // Get the series on a release of economic data.
                case ReleaseSources = "fred/release/sources"    // Get the sources for a release of economic data.
                case ReleaseTags = "fred/release/tags"          // Get the tags for a release.
                case RelatedTags = "fred/release/related_tags"  // Get the related tags for a release.
                case ReleaseTables = "fred/release/tables"      // Get the release tables for a given release.
            }
            
            public enum Series: String {
                case Series = "fred/series"                         // Get an economic data series.
                case Categories = "fred/series/categories"          // Get the categories for an economic data series.
                case Observations = "fred/series/observations"      // Get the observations or data values for an economic data series.
                case Release = "fred/series/release"                // Get the release for an economic data series.
                case Search = "fred/series/search"                  // Get economic data series that match keywords.
                case SearchTags = "fred/series/search/tags"         // Get the tags for a series search.
                case SearchRelatedTags = "fred/series/search/related_tags" // Get the related tags for a series search.
                case Tags = "fred/series/tags"                      // Get the tags for an economic data series.
                case Updates = "fred/series/updates"                // Get economic data series sorted by when observations were updated on the FRED® server.
                case VintageDates = "fred/series/vintagedates"           // Get the dates in history when a series' data values were revised or new data values were released.
            }
            
            public enum Sources: String {
                case Sources = "fred/sources"   // Get all sources of economic data.
                case Source = "fred/source"     // Get a source of economic data.
                case Releases = "fred/source/releases"  // Get the releases for a source.
            }
            
            public enum Tags: String {
                case Tags = "fred/tags"     // Get all tags, search for tags, or get tags by name.
                case RelatedTags = "fred/related_tags" // Get the related tags for one or more tags.
                case Series = "fred/tags/series"    // Get the series matching tags.
            }
        }
        
        // FRED request arguments
        public enum Argument: String {
            case APIKey = "api_key"
            // case FileType = "file_type" // Only support JSON
            case CategoryId = "category_id"
            case RealTimeStart = "realtime_start"
            case RealTimeEnd = "realtime_end"
            case Limit = "limit"
            case Offset = "offset"
            case OrderBy = "order_by"
            case SortOrder = "sort_order"
            case FilterVariable = "filter_variable"
            case FilterValue = "filter_value"
            case TagNames = "tag_names"
            case ExcludeTagNames = "exclude_tag_names"
            case TagGroupId = "tag_group_id"
            case SearchText = "search_text"
            case IncludeReleaseDatesWithNoData = "include_release_dates_with_no_data"
            case ReleaseId = "release_id"
            case ElementId = "element_id"
            case IncludeObservationValues = "include_observation_values"
            case ObservationDate = "observation_date"
            case SeriesId = "series_id"
            case ObservationStart = "observation_start"
            case ObservationEnd = "observation_end"
            case Units = "units"
            case Frequency = "frequency"
            case AggregationMethod = "aggregation_method"
            case OutputType = "output_type"
            case VintageDates = "vintage_dates"
            case TagSearchText = "tag_search_text"
            case SeriesSearchText = "series_search_text"
            case SourceId = "source_id"
        }
        
        var first: Bool = true
        // var url = URL(string: "https://api.stlouisfed.org/")
        var url = "https://api.stlouisfed.org/"
        
        // Initialize with API key
        public init(apiKey: String) {
            _ = self.with(.APIKey, value: apiKey)
        }
        
        //
        // Initialize with request path
        //
        public init(categories: Request.Categories) {
            url = "\(url)\(categories.rawValue)"
        }
        
        public init(releases: Request.Releases) {
            url = "\(url)\(releases.rawValue)"
        }
        
        public init(series: Request.Series) {
            url = "\(url)\(series.rawValue)"
        }
        
        public init(sources: Request.Sources) {
            url = "\(url)\(sources.rawValue)"
        }
        
        public init(tags: Request.Tags) {
            url = "\(url)\(tags.rawValue)"
        }
        
        public func with(_ argument: Argument, value: String) -> Query {
            
            if first {
                url = "\(url)?\(argument.rawValue)=\(value)"
                first = false
            } else {
                url = "\(url)&\(argument.rawValue)=\(value)"
            }
            
            return self
        }
        
        // MARK: - Alias for completion handler for http request
        public typealias CompletionHandler = (Fred.Result?) -> Void
        
        // MARK: - fetch: makes an API request asynchronously
        public func fetch(onCompletion: @escaping CompletionHandler) {
            
            url = "\(url)&file_type=json" // Set file_type to JSON (default is XML)
            
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
                
                var fredResult: Fred.Result?
                
                guard let data = data else { return }
                
                // let jsonData = try! JSONSerialization.data(withJSONObject: data)
                
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                fredResult = try! decoder.decode(Fred.Result.self, from: data)
                onCompletion(fredResult)
            }
            
            task.resume()
        }
        
        // Makes a synchronous request to the API
        public func fetchSync() -> Fred.Result? {
            
            url = "\(url)&file_type=json" // Set file_type to JSON (default is XML)
            
            if let data = try? Data(contentsOf: URL(string: url)!)
            {
                var fredResult: Fred.Result?
                
                // let jsonData = try! JSONSerialization.data(withJSONObject: data)
                
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                
                
                fredResult = try! decoder.decode(Fred.Result.self, from: data)
                
                return fredResult
            }
            
            return nil
        }
        
        /*
        * Common queries
        */
        
        // Requires a global variable 'fredAPIKey' with the api key
        public static func series(seriesId: String, start: String, end: String, onCompletion: @escaping CompletionHandler) {
            Fred.Query(series: .Observations)
                .with(.APIKey, value: fredAPIKey)
                .with(.SeriesId, value: seriesId)
                .with(.RealTimeStart, value: start)
                .with(.RealTimeEnd, value: end)
                .fetch { response in
                    if let r = response {
                        onCompletion(r)
                    }
            }
        }
        
        // Requires a global variable 'fredAPIKey' with the api key
        public static func seriesSync(seriesId: String, start: String, end: String) -> Fred.Result? {
            return Fred.Query(series: .Observations)
                .with(.APIKey, value: fredAPIKey)
                .with(.SeriesId, value: seriesId)
                .with(.RealTimeStart, value: start)
                .with(.RealTimeEnd, value: end)
                .fetchSync()
        }
        
        /*
        // Fetches data, saves to SQLite and does something with it in a callback
        static func fetchAndSaveToSQL(seriesId: String, start: String, end: String, db: Database, onCompletion: CompletionHandler?) {
            
            let result = seriesSync(seriesId: seriesId, start: start, end: end)
            try! result?.observations?.forEach { row in
                try db.execute("""
                    INSERT INTO fred_data_series
                        (series_id, date, start, end, value)
                    VALUES
                        (?, ?, ?, ?, ?)
                    """, arguments: [])
            }
        }
        
        // Convenience method with no callback
        static func fetchAndSaveToSQL(seriesId: String, start: String, end: String, db: Database) {
            fetchAndSaveToSQL(seriesId: seriesId, start: start, end: end, db: db)
        }
        */
    }
    
    // Fred API Result struct
    public struct Result: Codable {
        
        public let start: Date?
        public let end: Date?
        public let observationStart: Date?
        public let observationEnd: Date?
        public let units: String?
        public let outputType: Int?
        public let fileType: String?
        public let orderBy: String?
        public let sortOrder: String?
        public let count: Int?
        public let offset: Int?
        public let limit: Int?
        public let observations: [Observation]?
        public let categories: [Category]?
        
        public enum CodingKeys: String, CodingKey {
            case start = "realtime_start"
            case end = "realtime_end"
            case observationStart = "observation_start"
            case observationEnd = "observation_end"
            case units
            case outputType = "output_type"
            case fileType = "file_type"
            case orderBy = "order_by"
            case sortOrder = "sort_order"
            case count
            case offset
            case limit
            case observations
            case categories
        }
        
        public func splitObservations() -> (dates: [Date], values: [Double]) {
            var dates = [Date]()
            var values = [Double]()
            
            observations?.forEach { obs in
                if let doubleValue = Double(obs.value) {
                    dates.append(obs.date)
                    values.append(doubleValue)
                }
            }
            
            return (dates: dates, values: values)
        }
    }
    
    public struct Observation: Codable {
        
        public let date: Date
        public let start: Date
        public let end: Date
        public var value: String
        
        public enum CodingKeys: String, CodingKey {
            case date
            case start = "realtime_start"
            case end = "realtime_end"
            case value
        }
        
    }
    
    public struct Category: Codable {
        let id: Int
        let name: String
        let parentId: Int
        
        public enum CodingKeys: String, CodingKey {
            case id
            case name
            case parentId = "parent_id"
        }
    }
    
}
