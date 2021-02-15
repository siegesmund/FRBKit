import Foundation

extension Fred  {
    
    public struct Series: Codable {
        public let id: String
        public let realtimeStart: String
        public let realtimeEnd: String
        public let title: String
        public let observationStart: String
        public let observationEnd: String
        public let frequency: String
        public let frequencyShort: String
        public let units: String
        public let unitsShort: String
        public let seasonalAdjustment: String
        public let seasonalAdjustmentShort: String
        public let lastUpdated: String
        public let popularity: Int
        public let notes: String?
        
        public enum CodingKeys: String, CodingKey {
            case id
            case realtimeStart = "realtime_start"
            case realtimeEnd = "realtime_end"
            case title
            case observationStart = "observation_start"
            case observationEnd = "observation_end"
            case frequency
            case frequencyShort = "frequency_short"
            case units = "units"
            case unitsShort = "units_short"
            case seasonalAdjustment = "seasonal_adjustment"
            case seasonalAdjustmentShort = "seasonal_adjustment_short"
            case lastUpdated = "last_updated"
            case popularity
            case notes
        }
    }
}
