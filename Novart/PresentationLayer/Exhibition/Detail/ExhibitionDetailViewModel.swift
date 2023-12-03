//
//  ExhibitionDetailViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/03.
//

import Foundation
import Combine

final class ExhibitionDetailViewModel {
    
    private weak var coordinator: ExhibitionDetailCoordinator?
    var detailInfoItemSubject: PassthroughSubject<[ExhibitionDetailViewController.Section: [ExhibitionDetailItem]], Never> = .init()
    
    let exhibitionId: Int64
    
    private let exhibitionInteractor: ExhibitionInteractor = .init()
    
    init(coordinator: ExhibitionDetailCoordinator?, exhibitionId: Int64) {
        self.coordinator = coordinator
        self.exhibitionId = exhibitionId
    }
    
    @MainActor
    func closeCoordinator() {
        coordinator?.close()
    }
}

extension ExhibitionDetailViewModel {
    func loadData() {
        
        Task {
            do {
                let exhibitionData = try await exhibitionInteractor.fetchExhibitionDetail(exhibitionId: exhibitionId)
                let artItems = exhibitionData.arts.map { ExhibitionArtItem(item: $0) }
                let infoItem = ExhibitionDetailInfoModel(posterImageUrl: nil, title: "서울대학교 공예과 졸업 전시회", subtitle: "Seoul. Univ. Craft", description: "본 전시는 지난 120년동안 한국의 기대수명에 대한 '데이터'를 '디자인'과 접목하여 긍정적인 사회적 변화상을 시각적으로 표현한 공공디자인 전시입니다.공공디자인 전시입니다.공공디자인 전시입니다.공공디자인 전시입니다.공공디자인 전시입니다.", category: [.product, .graphic, .painting], count: 12, duration: 30, participants: [ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil)])
                
                let endItem = ExhibitionEndItem(likeCount: 9999, commentCount: 9999)
                detailInfoItemSubject.send([.info: [infoItem], .art: artItems, .end: [endItem]])
            } catch {
                print(error.localizedDescription)

            }
        }
    }
    
    func test() {
        Task {
            do {
                try await exhibitionInteractor.fetchExhibitionDetail(exhibitionId: exhibitionId)
            } catch {
                print("heheheh")
                print(error.localizedDescription)
            }
        }
    }
}
