import Foundation

final class ExhibitionInteractor {
    func fetchExhibitions() async throws -> [ExhibitionModel] {
        let exhibitions = try await APIClient.fetchExhibitions()
        return exhibitions
    }
}
