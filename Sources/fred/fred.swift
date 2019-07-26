import Foundation

/**
// Example
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
                public case Category = "fred/category"                 // Get a category.
                public case Children = "fred/category/children"        // Get the child categories for a specified parent category.
                public case Related = "fred/category/related"          // Get the related categories for a category.
                public case Series = "fred/category/series"            // Get the series in a category.
                public case Tags = "fred/category/tags"                // Get the tags for a category.
                public case RelatedTags = "fred/category/related_tags" // Get the related tags for a category.
            }
            
            public enum Releases: String {
                public case Releases = "fred/releases"                 // Get all releases of economic data.
                public case AllReleasesDates = "fred/releases/dates"   // Get release dates for all releases of economic data.
                public case Release = "fred/release"                   // Get a release of economic data.
                public case ReleaseDates = "fred/release/dates"        // Get release dates for a release of economic data.
                public case ReleaseSeries = "fred/release/series"      // Get the series on a release of economic data.
                public case ReleaseSources = "fred/release/sources"    // Get the sources for a release of economic data.
                public case ReleaseTags = "fred/release/tags"          // Get the tags for a release.
                public case RelatedTags = "fred/release/related_tags"  // Get the related tags for a release.
                public case ReleaseTables = "fred/release/tables"      // Get the release tables for a given release.
            }
            
            public enum Series: String {
                public case Series = "fred/series"                         // Get an economic data series.
                public case Categories = "fred/series/categories"          // Get the categories for an economic data series.
                public case Observations = "fred/series/observations"      // Get the observations or data values for an economic data series.
                public case Release = "fred/series/release"                // Get the release for an economic data series.
                public case Search = "fred/series/search"                  // Get economic data series that match keywords.
                public case SearchTags = "fred/series/search/tags"         // Get the tags for a series search.
                public case SearchRelatedTags = "fred/series/search/related_tags" // Get the related tags for a series search.
                public case Tags = "fred/series/tags"                      // Get the tags for an economic data series.
                public case Updates = "fred/series/updates"                // Get economic data series sorted by when observations were updated on the FRED® server.
                public case VintageDates = "fred/series/vintagedates"           // Get the dates in history when a series' data values were revised or new data values were released.
            }
            
            public enum Sources: String {
                public case Sources = "fred/sources"   // Get all sources of economic data.
                public case Source = "fred/source"     // Get a source of economic data.
                public case Releases = "fred/source/releases"  // Get the releases for a source.
            }
            
            public enum Tags: String {
                public case Tags = "fred/tags"     // Get all tags, search for tags, or get tags by name.
                public case RelatedTags = "fred/related_tags" // Get the related tags for one or more tags.
                public case Series = "fred/tags/series"    // Get the series matching tags.
            }
        }
        
        // FRED request arguments
        public enum Argument: String {
            public case APIKey = "api_key"
            // case FileType = "file_type" // Only support JSON
            public case CategoryId = "category_id"
            public case RealTimeStart = "realtime_start"
            public case RealTimeEnd = "realtime_end"
            public case Limit = "limit"
            public case Offset = "offset"
            public case OrderBy = "order_by"
            public case SortOrder = "sort_order"
            public case FilterVariable = "filter_variable"
            public case FilterValue = "filter_value"
            public case TagNames = "tag_names"
            public case ExcludeTagNames = "exclude_tag_names"
            public case TagGroupId = "tag_group_id"
            public case SearchText = "search_text"
            public case IncludeReleaseDatesWithNoData = "include_release_dates_with_no_data"
            public case ReleaseId = "release_id"
            public case ElementId = "element_id"
            public case IncludeObservationValues = "include_observation_values"
            public case ObservationDate = "observation_date"
            public case SeriesId = "series_id"
            public case ObservationStart = "observation_start"
            public case ObservationEnd = "observation_end"
            public case Units = "units"
            public case Frequency = "frequency"
            public case AggregationMethod = "aggregation_method"
            public case OutputType = "output_type"
            public case VintageDates = "vintage_dates"
            public case TagSearchText = "tag_search_text"
            public case SeriesSearchText = "series_search_text"
            public case SourceId = "source_id"
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
            public case start = "realtime_start"
            public case end = "realtime_end"
            public case observationStart = "observation_start"
            public case observationEnd = "observation_end"
            public case units
            public case outputType = "output_type"
            public case fileType = "file_type"
            public case orderBy = "order_by"
            public case sortOrder = "sort_order"
            public case count
            public case offset
            public case limit
            public case observations
            public case categories
        }
        
        func splitObservations() -> (dates: [Date], values: [Double]) {
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
            public case date
            public case realtimeStart = "realtime_start"
            public case realtimeEnd = "realtime_end"
            public case value
        }
        
    }
    
    public struct Category: Codable {
        public let id: Int
        public let name: String
        public let parentId: Int
        
        public enum CodingKeys: String, CodingKey {
            public case id
            public case name
            public case parentId = "parent_id"
        }
    }
    
}
