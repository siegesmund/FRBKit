import Foundation


extension Fred {
    
    public struct Release: Codable {
        public let id: String
        public let realtimeStart: String
        public let realtimeEnd: String
        public let name: String
        public let pressRelease: String
        public let link: String?

        public enum CodingKeys: String,CodingKey {
            case id
            case realtimeStart = "realtime_start"
            case realtimeEnd = "realtime_end"
            case name
            case pressRelease = "press_release"
            case link
        }
    }
}
