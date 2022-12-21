import Foundation

struct MbcNewsResult: SPNewsResult {
    let hasMorePage: Bool
    let sections: [MbcNewsSection]
}
