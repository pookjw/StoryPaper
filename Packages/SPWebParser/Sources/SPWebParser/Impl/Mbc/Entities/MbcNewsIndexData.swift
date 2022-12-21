import Foundation

struct MbcNewsIndexData: Sendable {
    struct Data: Sendable {
        enum CodingKeys: CodingKey {
            case List
        }
        
        let list: [MbcNewsArticleData]
    }
    
    enum CodingKeys: CodingKey {
        case Data
    }
    
    let data: [Self.Data]
}

extension MbcNewsIndexData: Decodable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(Array<Self.Data>.self, forKey: .Data)
    }
}

extension MbcNewsIndexData.Data: Decodable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        list = try container.decode(Array<MbcNewsArticleData>.self, forKey: .List)
    }
}
