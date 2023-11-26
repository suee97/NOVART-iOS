import Foundation

final class ExhibitionInteractor {
    func fetchExhibitions() async throws -> [Exhibition] {
        let exhibitions = try await APIClient.fetchExhibitions()
        return exhibitions
    }
}
