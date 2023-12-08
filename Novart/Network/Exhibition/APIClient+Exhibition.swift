import Alamofire
import Foundation

extension APIClient {
    static func fetchExhibitions() async throws -> [ExhibitionModel] {
        try await APIClient.request(target: ExhibitionTarget.fetchExhibitions, type: [ExhibitionModel].self)
    }
}
