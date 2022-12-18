import Foundation
import SPError
import SPLogger

struct MbcNewsArticleData: Sendable {
    enum CodingKeys: CodingKey {
        case Section, Image, Title, Desc, Link, Author, StartDate
    }
    
    let section: String?
    let imageURL: URL?
    let title: String?
    let description: String?
    let linkURL: URL?
    let author: String?
    let startDate: Date?
}

extension MbcNewsArticleData: Decodable {
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        section = try container.decodeIfPresent(String.self, forKey: .Section)
        
        //
        
        if let imageURLString: String = try container.decodeIfPresent(String.self, forKey: .Image) {
            imageURL = .init(string: "https:\(imageURLString)")
        } else {
            imageURL = nil
        }
        
        //
        
        title = try container.decodeIfPresent(String.self, forKey: .Title)
        description = try container.decodeIfPresent(String.self, forKey: .Desc)
        
        //
        
        if let linkURLString: String = try container.decodeIfPresent(String.self, forKey: .Link) {
            linkURL = .init(string: linkURLString)
        } else {
            linkURL = nil
        }
        
        //
        
        author = try container.decodeIfPresent(String.self, forKey: .Author)
        
        //
        
        if let startDateString: String = try container.decodeIfPresent(String.self, forKey: .StartDate) {
            let dateFormatter: DateFormatter = .init()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = .init(identifier: "ko_KR")
            
            if let startDate: Date = dateFormatter.date(from: startDateString) {
                self.startDate = startDate
            } else {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                if let startDate: Date = dateFormatter.date(from: startDateString) {
                    self.startDate = startDate
                } else {
                    self.startDate = nil
                }
            }
        } else {
            startDate = nil
        }
    }
}
