import Foundation

extension Fred {
    
    public struct Observation: Codable {
        
        public let date: String
        public let realtimeStart: String
        public let realtimeEnd: String
        public var value: String
        
        public enum CodingKeys: String, CodingKey {
            case date
            case realtimeStart = "realtime_start"
            case realtimeEnd = "realtime_end"
            case value
        }
    }
}
