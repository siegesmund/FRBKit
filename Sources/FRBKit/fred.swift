import Foundation
import Combine

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

public let fredAPIKey = "34186410dc2edcfe3e4622accdc1c923"

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
    }
    
}
