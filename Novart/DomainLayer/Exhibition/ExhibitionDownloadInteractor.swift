import Foundation

final class ExhibitionInteractor {
    func fetchExhibitions() async throws -> [ExhibitionModel] {
        let exhibitions = try await APIClient.fetchExhibitions()
        return exhibitions
    }
    
    func fetchExhibitionInfo(id: Int64) async throws -> ExhibitionInfoModel {
        try await APIClient.fetchExhibitionInfo(id: id)
    }
    
    func fetchExhibitionDetail(exhibitionId: Int64) async throws -> ExhibitionDetailModel {
        try await APIClient.fetchExhibitionDetail(exhibitionId: exhibitionId)
    }
    
    func makeLikeRequest(id: Int64) async throws {
        _ = try await APIClient.makeLikeRequest(id: id)
    }
    
    func makeUnlikeRequest(id: Int64) async throws {
        _ = try await APIClient.makeUnlikeRequest(id: id)
    }
}
