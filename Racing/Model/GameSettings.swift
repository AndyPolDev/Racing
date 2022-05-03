import Foundation
import UIKit

class GameSettings: Codable {
    
    var carIndex: Int
    var carSpeed: Int
    var userName: String
    
    init(carIndex: Int, carSpeed: Int, userName: String) {
        self.carIndex = carIndex
        self.carSpeed = carSpeed
        self.userName = userName
    }
    
    public enum CodingKeys: String, CodingKey {
        case carIndex, carSpeed, userName
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.carIndex = try container.decode(Int.self, forKey: .carIndex)
        self.carSpeed = try container.decode(Int.self, forKey: .carSpeed)
        self.userName = try container.decode(String.self, forKey: .userName)
    
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.carIndex, forKey: .carIndex)
        try container.encode(self.carSpeed, forKey: .carSpeed)
        try container.encode(self.userName, forKey: .userName)
    }
    
    
 
}
