import Foundation

final class ExhibitionInteractor {
    func fetchExhibitions() async throws -> [ExhibitionModel] {
        let exhibitions = try await APIClient.fetchExhibitions()
        return exhibitions
    }
    
    func fetchExhibitionDetail(exhibitionId: Int64) async throws -> ExhibitionDetailModel {
        try await APIClient.fetchExhibitionDetail(exhibitionId: exhibitionId)
    }
}
