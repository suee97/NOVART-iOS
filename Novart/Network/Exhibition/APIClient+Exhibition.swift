import Alamofire
import Foundation

extension APIClient {
    static func fetchExhibitions() async throws -> [Exhibition] {
        try await APIClient.request(target: ExhibitionTarget.fetchExhibitions, type: [Exhibition].self)
    }
}
