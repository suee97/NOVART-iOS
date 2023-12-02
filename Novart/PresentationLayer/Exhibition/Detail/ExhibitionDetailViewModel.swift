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
        let infoItem = ExhibitionDetailInfoModel(posterImageUrl: nil, title: "서울대학교 공예과 졸업 전시회", subtitle: "Seoul. Univ. Craft", description: "본 전시는 지난 120년동안 한국의 기대수명에 대한 '데이터'를 '디자인'과 접목하여 긍정적인 사회적 변화상을 시각적으로 표현한 공공디자인 전시입니다.공공디자인 전시입니다.공공디자인 전시입니다.공공디자인 전시입니다.공공디자인 전시입니다.", category: [.product, .graphic, .painting], count: 12, duration: 30, participants: [ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil), ParticipantModel(nickname: "Jonathan", role: "제품 디자이너", profileImageUrl: nil)])
        
        let endItem = ExhibitionEndItem(likeCount: 9999, commentCount: 9999)
        detailInfoItemSubject.send([.info: [infoItem], .art: [ExhibitionArtItem(titleImageUrls: ["https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_thumbnail_1.png", "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_thumbnail_2.png"], title: "Chair", artistName: "방태림", description: "‘판재의 특징을 살린 오브젝트 디자인’ 프로제트에 맞춰 진행한 사무용품 카비넷’입니다. 효율성과 실용성에 치중하여 다소 복잡한 외관을 지닌 서류정리함을 심플한 형태를 가진 판재를 이용하여 단순하고 간결하게 리디자인하였습니다.", detailImages: [ExhibitionDetailImage(url: "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_detail_1.png", width: 400, height: 300), ExhibitionDetailImage(url: "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_detail_2.png", width: 300, height: 200)]), ExhibitionArtItem(titleImageUrls: ["https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_thumbnail_1.png", "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_thumbnail_2.png"], title: "Chair", artistName: "방태림", description: "‘판재의 특징을 살린 오브젝트 디자인’ 프로제트에 맞춰 진행한 사무용품 카비넷’입니다. 효율성과 실용성에 치중하여 다소 복잡한 외관을 지닌 서류정리함을 심플한 형태를 가진 판재를 이용하여 단순하고 간결하게 리디자인하였습니다.", detailImages: [ExhibitionDetailImage(url: "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_detail_1.png", width: 400, height: 300), ExhibitionDetailImage(url: "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_detail_2.png", width: 300, height: 200)]), ExhibitionArtItem(titleImageUrls: ["https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_thumbnail_1.png", "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_thumbnail_2.png"], title: "Chair", artistName: "방태림", description: "‘판재의 특징을 살린 오브젝트 디자인’ 프로제트에 맞춰 진행한 사무용품 카비넷’입니다. 효율성과 실용성에 치중하여 다소 복잡한 외관을 지닌 서류정리함을 심플한 형태를 가진 판재를 이용하여 단순하고 간결하게 리디자인하였습니다.", detailImages: [ExhibitionDetailImage(url: "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_detail_1.png", width: 400, height: 300), ExhibitionDetailImage(url: "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_detail_2.png", width: 300, height: 200)]), ExhibitionArtItem(titleImageUrls: ["https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_thumbnail_1.png", "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_thumbnail_2.png"], title: "Chair", artistName: "방태림", description: "‘판재의 특징을 살린 오브젝트 디자인’ 프로제트에 맞춰 진행한 사무용품 카비넷’입니다. 효율성과 실용성에 치중하여 다소 복잡한 외관을 지닌 서류정리함을 심플한 형태를 가진 판재를 이용하여 단순하고 간결하게 리디자인하였습니다.", detailImages: [ExhibitionDetailImage(url: "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_detail_1.png", width: 400, height: 300), ExhibitionDetailImage(url: "https://novart-bucket.s3.ap-northeast-2.amazonaws.com/plain/filling_cabinet_detail_2.png", width: 300, height: 200)])], .end: [endItem]])
    }
}
