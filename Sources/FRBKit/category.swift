import Foundation

extension Fred {
    
    public struct Category: Codable {
        public let id: String
        public let name: String
        public let parentId: String
        
        public enum CodingKeys: String, CodingKey {
            case id
            case name
            case parentId = "parent_id"
        }
    }
}
