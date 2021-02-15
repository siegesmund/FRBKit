import Foundation


extension Fred {
    
    // Fred API Result struct
    public struct Result: Codable {
        
        public let start: String?
        public let end: String?
        public let filterVariable: String?
        public let filterValue: String?
        public let observationStart: String?
        public let observationEnd: String?
        public let units: String?
        public let outputType: Int?
        public let fileType: String?
        public let orderBy: String?
        public let sortOrder: String?
        public let count: Int?
        public let offset: Int?
        public let limit: Int?
        public let series: [Series]?
        public let observations: [Observation]?
        public let releases: [Release]?
        public let categories: [Category]?
        
        public enum CodingKeys: String, CodingKey {
            case start = "realtime_start"
            case end = "realtime_end"
            case filterVariable = "filter_variable"
            case filterValue = "filter_value"
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
            case series = "seriess"
            case observations
            case releases
            case categories
        }
        /*
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
        }*/
    }
}
