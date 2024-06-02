import UIKit
import Combine

final class ExhibitionGuideViewModel {
    
    private let exhibitionId: Int64
    private let backgroundColor: UIColor
    private let coordinator: ExhibitionCoordinator
    private let downloadInteractor: ExhibitionInteractor
    @Published private(set) var exhibitionInfo: ExhibitionInfoModel?
    
    init(exhibitionId: Int64, backgroundColor: UIColor, coordinator: ExhibitionCoordinator, downloadInteractor: ExhibitionInteractor) {
        self.exhibitionId = exhibitionId
        self.backgroundColor = backgroundColor
        self.coordinator = coordinator
        self.downloadInteractor = downloadInteractor
        self.fetchExhibitionInfo()
    }
    
}


// MARK: - Functions
extension ExhibitionGuideViewModel {
    
    func getBackgroundColor() -> UIColor {
        return self.backgroundColor
    }
    
    func getArtistCount() -> Int {
        guard let exhibitionInfo = self.exhibitionInfo, let artists = exhibitionInfo.artists else { return 0 }
        return artists.count
    }
    
    func getArtist(index: Int) -> ExhibitionParticipantModelTmp? {
        guard let exhibitionInfo = self.exhibitionInfo, let artists = exhibitionInfo.artists else { return nil }
        if artists.count < index + 1 {
            return nil
        }
        return artists[index]
    }
    
}


// MARK: - API
extension ExhibitionGuideViewModel {
    
    func fetchExhibitionInfo() {
        Task {
            do {
                self.exhibitionInfo = try await downloadInteractor.fetchExhibitionInfo(id: exhibitionId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}


// MARK: - Navigation
extension ExhibitionGuideViewModel {
    
    @MainActor
    func showExhibitionDetail() {
        coordinator.navigate(to: .exhibitionDetail(id: exhibitionId))
    }
    
}
