import Foundation

class RaceResult: Codable {
    var userName: String
    var score: Int
    var gameDateAndTime: String
    
    
    init(userName: String, score: Int, gameDateAndTime: String) {
        self.userName = userName
        self.score = score
        self.gameDateAndTime = gameDateAndTime
    }
    
    public enum CodingKeys: String, CodingKey {
        case userName, score, gameDateAndTime
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
         
        self.userName = try container.decode(String.self, forKey: .userName)
        self.score = try container.decode(Int.self, forKey: .score)
        self.gameDateAndTime = try container.decode(String.self, forKey: .gameDateAndTime)
    
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
         
        try container.encode(self.userName, forKey: .userName)
        try container.encode(self.score, forKey: .score)
        try container.encode(self.gameDateAndTime, forKey: .gameDateAndTime)
    }
    
    
}
