import Foundation

struct MbcNewsHomeData: Sendable {
    enum CodingKeys: CodingKey {
        case Data
    }
    
    let data: [MbcNewsArticleData]
}

extension MbcNewsHomeData: Decodable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(Array<MbcNewsArticleData>.self, forKey: .Data)
    }
}
