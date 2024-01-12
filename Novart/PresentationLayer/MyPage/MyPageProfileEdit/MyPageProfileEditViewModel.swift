import UIKit
import Combine
import Alamofire

final class MyPageProfileEditViewModel {
    // MARK: - Properties
    private let coordinator: MyPageCoordinator
    private var interactor = MyPageDownloadInteractor()
    
    @Published var categoryTagItemSelectCount: Int = 0
    var categoryTagItems = [TagItem(tag: "제품 디자이너", isSelected: false), TagItem(tag: "시각 디자이너", isSelected: false),TagItem(tag: "UX 디자이너", isSelected: false), TagItem(tag: "패션 디자이너", isSelected: false), TagItem(tag: "3D 아티스트", isSelected: false), TagItem(tag: "크리에이터", isSelected: false), TagItem(tag: "일러스트레이터", isSelected: false), TagItem(tag: "공예가", isSelected: false), TagItem(tag: "화가", isSelected: false)]
    
    @Published var recommendTagItemSelectCount: Int = 0
    @Published var tagFieldString: String = ""
    var recommendTagItems = [TagItem(tag: "제품", isSelected: false), TagItem(tag: "공예", isSelected: false), TagItem(tag: "그래픽", isSelected: false), TagItem(tag: "회화", isSelected: false), TagItem(tag: "UX", isSelected: false), TagItem(tag: "UI", isSelected: false), TagItem(tag: "모던", isSelected: false), TagItem(tag: "클래식", isSelected: false), TagItem(tag: "오브제", isSelected: false), TagItem(tag: "감성적인", isSelected: false), TagItem(tag: "심플", isSelected: false), TagItem(tag: "귀여운", isSelected: false), TagItem(tag: "키치한", isSelected: false), TagItem(tag: "힙한", isSelected: false), TagItem(tag: "레트로", isSelected: false), TagItem(tag: "트렌디", isSelected: false), TagItem(tag: "부드러운", isSelected: false), TagItem(tag: "몽환적인", isSelected: false), TagItem(tag: "실용적인", isSelected: false), TagItem(tag: "빈티지", isSelected: false), TagItem(tag: "화려한", isSelected: false), TagItem(tag: "재활용", isSelected: false), TagItem(tag: "친환경", isSelected: false), TagItem(tag: "지속가능한", isSelected: false), TagItem(tag: "밝은", isSelected: false), TagItem(tag: "어두운", isSelected: false), TagItem(tag: "차가운", isSelected: false), TagItem(tag: "따뜻한", isSelected: false)]


    // 원본 유저 데이터
    let user: PlainUser
    
    @Published var isLoading: Bool = false
    
    init(coordinator: MyPageCoordinator, user: PlainUser) {
        self.coordinator = coordinator
        self.user = user
        initCategoryTags()
        initRecommendTags()
    }
    
    
    // MARK: - Functions
    private func initCategoryTags() {
        for i in 0..<categoryTagItems.count {
            guard let tag = categoryTagItems[i].tag else { return }
            if user.jobs.contains(tag) {
                categoryTagItems[i].isSelected = true
            }
        }
        updateCategoryTagItemSelectCount()
    }
    
    private func initRecommendTags() {
        for i in 0..<recommendTagItems.count {
            guard let tag = recommendTagItems[i].tag else { return }
            if user.tags.contains(tag) {
                recommendTagItems[i].isSelected = true
            }
        }
        
        for e in user.tags {
            if e != user.tags.last {
                tagFieldString += "\(e), "
            } else {
                tagFieldString += "\(e)"
            }
        }
        
        updateRecommendTagItemSelectCount()
    }
    
    func updateCategoryTagSelection(indexPath: IndexPath, isSelected: Bool) {
        categoryTagItems[indexPath.row].isSelected = isSelected
        updateCategoryTagItemSelectCount()
    }
    
    func updateRecommendTagSelection(indexPath: IndexPath, isSelected: Bool) {
        recommendTagItems[indexPath.row].isSelected = isSelected
        
        // 선택된 추천태그 문자열
        let tagString = recommendTagItems[indexPath.row].tag ?? ""
        
        if isSelected {
            tagFieldString += tagFieldString.isEmpty ? tagString : ", \(tagString)" // 추천태그 추가
        } else {
            // 추천태그 제거
            if let range = tagFieldString.range(of: tagString) {
                var lb = range.lowerBound
                var ub = range.upperBound
                
                // 추천태그가 중간, 마지막 위치일 때 좌측 ","를 만나는 범위까지 문자열 삭제
                if lb != tagFieldString.startIndex {
                    while true {
                        if lb == tagFieldString.startIndex {
                            break
                        }
                        if tagFieldString[lb] != "," {
                            lb = tagFieldString.index(lb, offsetBy: -1)
                        } else {
                            break
                        }
                    }
                    tagFieldString.replaceSubrange(lb..<range.upperBound, with: "")
                } else {
                    // 추천태그가 첫번째 위치일 때 우측 "," & 공백을 제외한 문제열을 만날 때까지 삭제
                    while true {
                        if ub == tagFieldString.endIndex {
                            break
                        }
                        if tagFieldString[ub] == "," || tagFieldString[ub] == " " {
                            ub = tagFieldString.index(ub, offsetBy: +1)
                        } else {
                            break
                        }
                    }
                    tagFieldString.replaceSubrange(tagFieldString.startIndex..<ub, with: "")
                }
            }
        }
        updateRecommendTagItemSelectCount() // 추천태그 선택 변경으로 인한 count update
    }
    
    // 텍스트 필드 ',' 기준으로 태그 개수 카운트
    private func updateRecommendTagItemSelectCount() {
        if tagFieldString.isEmpty {
            recommendTagItemSelectCount = 0
            return
        }
        recommendTagItemSelectCount = tagFieldString.components(separatedBy: ",").count
    }
    
    private func updateCategoryTagItemSelectCount() {
        categoryTagItemSelectCount = categoryTagItems.filter{$0.isSelected}.count
    }
    
    // 유저의 텍스트필드 입력에 따른 뷰모델 및 UI 동기화
    func tagFieldChangedFromUser() {
        if !tagFieldString.isEmpty {
            let tags = tagFieldString.components(separatedBy: ",").map{$0.trimmingCharacters(in: .whitespaces)}
            
            for i in 0..<recommendTagItems.count {
                let idx = tags.firstIndex(of: recommendTagItems[i].tag ?? "") ?? -1
                recommendTagItems[i].isSelected = (idx != -1)
            }
        }
        updateRecommendTagItemSelectCount()
    }
}


// MARK: - API
extension MyPageProfileEditViewModel {
    
    // true: 중복, false: 사용가능
    func checkDuplicateNickname(nickname: String) async throws -> Bool {
        try await interactor.checkDuplicateNickname(nickname: nickname)
    }
    
    func applyChanges(userData: ProfileEditUserDataModel) {
        Task {
            do {
                isLoading = true
                var userData = userData
                
                if let profileFileName = userData.profileFileName {
                    // presigned url + image url 요청
                    let response = try await interactor.requestPresignedUrl(filename: profileFileName, category: "profile")
                    userData.profileImageUrl = response.imageUrl
                    
                    // S3 업로드
                    guard let file = userData.profileImage?.jpegData(compressionQuality: 0.5) else { return }
                    guard let presignedUrl = URL(string: response.presignedUrl) else { return }
                    var request = URLRequest(url: presignedUrl)
                    request.httpMethod = "PUT"
                    request.setValue("image/jpeg", forHTTPHeaderField: "Content-type")
                    request.httpBody = file

                    AF.request(request).response { _ in }
                }
                
                if let backgroundFileName = userData.backgroundFileName {
                    // presigned url + image url 요청
                    let response = try await interactor.requestPresignedUrl(filename: backgroundFileName, category: "background")
                    userData.backgroundImageUrl = response.imageUrl
                    
                    // S3 업로드
                    guard let file = userData.backgroundImage?.jpegData(compressionQuality: 0.5) else { return }
                    guard let presignedUrl = URL(string: response.presignedUrl) else { return }
                    var request = URLRequest(url: presignedUrl)
                    request.httpMethod = "PUT"
                    request.setValue("image/jpeg", forHTTPHeaderField: "Content-type")
                    request.httpBody = file

                    AF.request(request).response { _ in }
                }
                
                let categoryTags: [String] = categoryTagItems.filter{$0.isSelected}.compactMap{$0.tag}
                let recommendTags: [String] = tagFieldString.components(separatedBy: ",").map{$0.trimmingCharacters(in: .whitespaces)}.filter{!$0.isEmpty}
                
                let _ = try await interactor.profileEdit(profileEditRequestBodyModel: ProfileEditRequestBodyModel(nickname: userData.nickname, profileImageUrl: userData.profileImageUrl, backgroundImageUrl: userData.backgroundImageUrl, tags: recommendTags, jobs: categoryTags, email: userData.email, openChatUrl: userData.link))
            
                // 유저 정보 갱신
                Authentication.shared.user = try await interactor.getUser()
                isLoading = false
                await showMain()
            } catch {
                print(error.localizedDescription)
                isLoading = false
            }
        }
    }
}


// MARK: - Navigation
extension MyPageProfileEditViewModel {
    
    @MainActor
    func showMain() {
        coordinator.navigate(to: .MyPageMain)
    }
    
}
