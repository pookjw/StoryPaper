import Foundation

public protocol SPWebParser {
    associatedtype NewsSection: SPNewsSection
    associatedtype NewsCategory: SPNewsCatetory
    
    func newsSectionsForHome() async throws -> [NewsSection]
    func newsSections(for newsCategory: NewsCategory) async throws -> [NewsSection]
}
