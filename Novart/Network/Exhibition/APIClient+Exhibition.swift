import Alamofire
import Foundation

extension APIClient {
    static func fetchExhibitions() async throws -> [ExhibitionModel] {
        try await APIClient.request(target: ExhibitionTarget.fetchExhibitions, type: [ExhibitionModel].self)
    }
    
    static func fetchExhibitionDetail(exhibitionId: Int64) async throws -> ExhibitionDetailModel {
        try await APIClient.request(target: ExhibitionTarget.fetchExhibitionDetail(id: exhibitionId), type: ExhibitionDetailModel.self)
    }
    
    static func fetchArtistsExhibition(id: Int64) async throws -> [ExhibitionModel] {
        try await APIClient.request(target: ExhibitionTarget.fetchArtistExhibition(artistId: id), type: [ExhibitionModel].self)
    }
}
