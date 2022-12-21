import Foundation
import SPError

struct MbcNewsCalData: Sendable {
    struct Date: Sendable {
        enum CodingKeys: CodingKey {
            case Day, CurrentID
        }
        
        let day: String
        let currentId: String
    }
    
    enum CodingKeys: CodingKey {
        case DataId, DateList
    }
    
    let dataId: String
    let dateList: [Self.Date]
}

extension MbcNewsCalData: Decodable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        dataId = try container.decode(String.self, forKey: .DataId)
        dateList = try container.decode(Array<Self.Date>.self, forKey: .DateList)
    }
}

extension MbcNewsCalData.Date: Decodable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        day = try container.decode(String.self, forKey: .Day)
        currentId = try container.decode(String.self, forKey: .CurrentID)
    }
}
