import UIKit
import Combine
import ColorThiefSwift
import Kingfisher

final class ExhibitionViewModel {
    
    private let coordinator: ExhibitionCoordinator
    
    @Published var processedExhibitions = [ProcessedExhibition]() // 후처리 된 전시 객체 배열
    @Published var cellIndex: Int = 0 // 전시 인덱스
    
    init(coordinator: ExhibitionCoordinator) {
        self.coordinator = coordinator
    }
    
    func getExhibitions() {
        
        // 서버 데이터
        let exhibitions = [
            Exhibition(id: 0, imageUrl: "https://www.syu.ac.kr/wp-content/uploads/2020/06/%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%A0%84%EC%8B%9C-%ED%8F%AC%EC%8A%A4%ED%84%B0_.jpg", desc: "[1] 본 전시는 지난 120년동안 한국의 기대수명에 대한 '데이터'를 '디자인'과 접목하여 긍정적인 사회적 변화상을 시각적으로 표현한 공공디자인 전시입니다.", likeCount: 0, commentCount: 999, isLike: true),
            Exhibition(id: 1, imageUrl: "https://file.newswire.co.kr/data/datafile2/thumb_640/2023/06/1846260943_20230622105758_2248298315.jpg", desc: "[2] 본 전시는 지난 120년동안 한국의 기대수명에 대한 '데이터'를 '디자인'과 접목하여 긍정적인 사회적 변화상을 시각적으로 표현한 공공디자인 전시입니다.", likeCount: 1557, commentCount: 5458, isLike: true),
            Exhibition(id: 2, imageUrl: "https://museumnews.kr/wp-content/uploads/2018/01/%EB%91%90%EB%B2%88%EC%A7%B8%ED%92%8D%EA%B2%BD-%EC%A0%84%EC%8B%9C-%ED%8F%AC%EC%8A%A4%ED%84%B0.jpg", desc: "[3] 본 전시는 지난 120년동안 한국의 기대수명에 대한 '데이터'를 '디자인'과 접목하여 긍정적인 사회적 변화상을 시각적으로 표현한 공공디자인 전시입니다아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아", likeCount: 10000, commentCount: 1000, isLike: false),
            Exhibition(id: 3, imageUrl: "https://www.fcbarcelona.com/fcbarcelona/photo/2022/08/02/ae5252d1-b79b-4950-9e34-6e67fac09bb0/LeoMessi20092010_pic_fcb-arsenal62.jpg", desc: "[4] 본 전시는 지난 120년동안 한국의 기대수명에 대한 '데이터'를 '디자인'과 접목하여 긍정적인 사회적 변화상을 시각적으로 표현한 공공디자인 전시입니다.", likeCount: 99999, commentCount: 99999, isLike: true),
            Exhibition(id: 4, imageUrl: "https://museumnews.kr/wp-content/uploads/2018/01/%EB%91%90%EB%B2%88%EC%A7%B8%ED%92%8D%EA%B2%BD-%EC%A0%84%EC%8B%9C-%ED%8F%AC%EC%8A%A4%ED%84%B0.jpg", desc: "[3] 본 전시는 지난 120년동안 한국의 기대수명에 대한 '데이터'를 '디자인'과 접목하여 긍정적인 사회적 변화상을 시각적으로 표현한 공공디자인 전시입니다아아아아아아아아아아아아아아아아아아아아아아아아아아아아아아", likeCount: 123456, commentCount: 0, isLike: false)
        ]

        for e in exhibitions {
            guard let url = URL(string: e.imageUrl) else { return }
            
            let imageView = UIImageView()
            imageView.kf.setImage(with: url, completionHandler: { _ in
                if let dominant = ColorThief.getColor(from: imageView.image ?? UIImage())?.makeUIColor() {
                    let hueValue = dominant.getHsb().0
                    let hsbColor = UIColor(hue: hueValue / 360, saturation: 0.08, brightness: 0.95, alpha: 1.0)
                    
                    // 처리 후 데이터
                    self.processedExhibitions.append(ProcessedExhibition(id: e.id, imageView: imageView, desc: e.desc, likeCount: e.likeCount, commentCount: e.commentCount, isLike: e.isLike, backgroundColor: hsbColor))
                }
            })
        }
    }
}
