import UIKit
import Combine
import Alamofire
import Kingfisher

final class MyPageProfileEditViewModel {
    weak var coordinator: MyPageCoordinator?
    private var interactor = MyPageDownloadInteractor()
    private let imageUploadInteractor = ProductUploadInteractor()
    let user: PlainUser
    @Published var isLoading: Bool = false
    @Published var categoryTagItemSelectCount: Int = 0
    @Published var recommendTagItemSelectCount: Int = 0
    @Published var tagFieldString: String = ""
    var categoryTagItems: [TagItem]
    var recommendTagItems: [TagItem]
    var originalProfileImage: UIImage?
    var originalBackgroundImage: UIImage?
    let shouldUpdateImageView: PassthroughSubject<Void, Never> = .init()
    var isProfileCropEnabled: Bool {
        user.profileImageUrl != nil
    }
    var isBackgroundCropEnabled: Bool {
        user.backgroundImageUrl != nil
    }
    
    init(user: PlainUser) {
        self.user = user
        let jobTagList = JobTags.tagList
        let RecommendTagList = RecommendTags.tagList
        self.categoryTagItems = TagItemConverter(tagList: jobTagList).getTagItems()
        self.recommendTagItems = TagItemConverter(tagList: RecommendTagList).getTagItems()
        setUpCategoryTagItems()
        setUpRecommendTagItems()
        downloadProfileImage()
        downloadBackgroundImage()
    }
    
    private func setUpCategoryTagItems() {
        for i in 0..<categoryTagItems.count {
            guard let tag = categoryTagItems[i].tag, user.jobs.contains(tag) else { continue }
            categoryTagItems[i].isSelected = true
        }
        updateCategoryTagItemSelectCount()
    }
    
    private func setUpRecommendTagItems() {
        for i in 0..<recommendTagItems.count {
            guard let tag = recommendTagItems[i].tag, user.tags.contains(tag) else { continue }
            recommendTagItems[i].isSelected = true
        }
        setUpTagFieldText()
        updateRecommendTagItemSelectCount()
    }
    
    private func setUpTagFieldText() {
        var tagFieldString = ""
        for e in user.tags {
            tagFieldString += (e == user.tags.last) ? "\(e)" : "\(e), "
        }
        self.tagFieldString = tagFieldString
    }
    
    func updateCategoryTagSelection(indexPath: IndexPath, isSelected: Bool) {
        categoryTagItems[indexPath.row].isSelected = isSelected
        updateCategoryTagItemSelectCount()
    }
    
    func shouldAddRecommendTagItem() -> Bool {
        let maxRecommendTagCount = 3
        return recommendTagItemSelectCount < maxRecommendTagCount
    }
    
    func shouldAddCategoryTagItem() -> Bool {
        let maxCategoryTagCount = 2
        return categoryTagItemSelectCount < maxCategoryTagCount
    }
    
    func updateRecommendTagSelection(indexPath: IndexPath, isSelected: Bool) {
        recommendTagItems[indexPath.row].isSelected = isSelected
        let tagString = recommendTagItems[indexPath.row].tag ?? ""
        if isSelected {
            addTagToTagFieldString(with: tagString)
        } else {
            removeTagFromTagFieldString(target: tagString)
        }
        updateRecommendTagItemSelectCount()
    }
    
    private func addTagToTagFieldString(with tagString: String) {
        if tagFieldString.isEmpty {
            tagFieldString += tagString
        } else {
            tagFieldString += ", \(tagString)"
        }
    }
    
    private func removeTagFromTagFieldString(target tagString: String) {
        let currentTags = tagFieldString
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: [" "]) }
        let newTags = currentTags.filter { $0 != tagString }
        var newTagFieldString = ""
        for tag in newTags {
            if tag == newTags.last {
                newTagFieldString += tag
            } else {
                newTagFieldString += "\(tag), "
            }
        }
        tagFieldString = newTagFieldString
    }
    
    private func updateRecommendTagItemSelectCount() {
        if tagFieldString.isEmpty {
            recommendTagItemSelectCount = 0
            return
        }
        recommendTagItemSelectCount = tagFieldString.components(separatedBy: ",").count
    }
    
    private func updateCategoryTagItemSelectCount() {
        categoryTagItemSelectCount = categoryTagItems
            .filter { $0.isSelected }
            .count
    }
    
    func updateRecommendTagSelectionFromUserTagFieldEditing() {
        if !tagFieldString.isEmpty {
            let tags = tagFieldString
                .components(separatedBy: ",")
                .map{ $0.trimmingCharacters(in: .whitespaces) }
            for i in 0..<recommendTagItems.count {
                guard let recommendTag = recommendTagItems[i].tag else { continue }
                recommendTagItems[i].isSelected = tags.contains(recommendTag)
            }
        }
        updateRecommendTagItemSelectCount()
    }
    
    func checkEmailValidation(email: String) -> Bool {
        if email.isEmpty { return true }
        let pattern = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"
        if let _ = email.range(of: pattern, options: .regularExpression) {
            return true
        } else {
            return false
        }
    }
    
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
                    
                    let nsString = profileFileName as NSString
                    let fileNameWithoutExtension = nsString.deletingPathExtension
                    let fileExtension = nsString.pathExtension

                    let response = try await interactor.requestPresignedUrls(filenames: [profileFileName, "\(fileNameWithoutExtension)_compressed.\(fileExtension)"], category: .profile)
                    let originalPresignedUrlModel = response[0]
                    let compressedPresignedUrlModel = response[1]
                    userData.originalProfileImageUrl = originalPresignedUrlModel.imageUrl
                    userData.compressedProfileImageUrl = compressedPresignedUrlModel.imageUrl
                    
                    // S3 업로드
                    guard let originalFile = userData.profileImage?.jpegData(compressionQuality: 1) else { return }
                    guard let originalPresignedUrl = URL(string: originalPresignedUrlModel.presignedUrl) else { return }
                    var originalFilerequest = URLRequest(url: originalPresignedUrl)
                    originalFilerequest.httpMethod = "PUT"
                    originalFilerequest.setValue("image/jpeg", forHTTPHeaderField: "Content-type")
                    originalFilerequest.httpBody = originalFile

                    AF.request(originalFilerequest).response { _ in }
                    
                    guard let compressedFile = userData.profileImage?.jpegData(compressionQuality: 0.2) else { return }
                    guard let presignedUrl = URL(string: compressedPresignedUrlModel.presignedUrl) else { return }
                    var compressedFilerequest = URLRequest(url: presignedUrl)
                    compressedFilerequest.httpMethod = "PUT"
                    compressedFilerequest.setValue("image/jpeg", forHTTPHeaderField: "Content-type")
                    compressedFilerequest.httpBody = compressedFile

                    AF.request(compressedFilerequest).response { _ in }
                }
                
                if let backgroundFileName = userData.backgroundFileName {
                    // presigned url + image url 요청
                    let nsString = backgroundFileName as NSString
                    let fileNameWithoutExtension = nsString.deletingPathExtension
                    let fileExtension = nsString.pathExtension

                    let response = try await interactor.requestPresignedUrls(filenames: [backgroundFileName, "\(fileNameWithoutExtension)_compressed.\(fileExtension)"], category: .background)
                    let originalPresignedUrlModel = response[0]
                    let compressedPresignedUrlModel = response[1]
                    userData.originalBackgroundImageUrl = originalPresignedUrlModel.imageUrl
                    userData.compressedBackgroundImageUrl = compressedPresignedUrlModel.imageUrl
                    
                    // S3 업로드
                    guard let originalFile = userData.backgroundImage?.jpegData(compressionQuality: 1) else { return }
                    guard let originalPresignedUrl = URL(string: originalPresignedUrlModel.presignedUrl) else { return }
                    var originalFilerequest = URLRequest(url: originalPresignedUrl)
                    originalFilerequest.httpMethod = "PUT"
                    originalFilerequest.setValue("image/jpeg", forHTTPHeaderField: "Content-type")
                    originalFilerequest.httpBody = originalFile

                    AF.request(originalFilerequest).response { _ in }
                    
                    guard let compressedFile = userData.backgroundImage?.jpegData(compressionQuality: 0.5) else { return }
                    guard let presignedUrl = URL(string: compressedPresignedUrlModel.presignedUrl) else { return }
                    var compressedFilerequest = URLRequest(url: presignedUrl)
                    compressedFilerequest.httpMethod = "PUT"
                    compressedFilerequest.setValue("image/jpeg", forHTTPHeaderField: "Content-type")
                    compressedFilerequest.httpBody = compressedFile

                    AF.request(compressedFilerequest).response { _ in }
                }
                
                let categoryTags: [String] = categoryTagItems.filter{$0.isSelected}.compactMap{$0.tag}
                let recommendTags: [String] = tagFieldString.components(separatedBy: ",").map{$0.trimmingCharacters(in: .whitespaces)}.filter{!$0.isEmpty}
                
                let _ = try await interactor.profileEdit(profileEditRequestBodyModel: ProfileEditRequestBodyModel(nickname: userData.nickname, profileImageUrl: userData.compressedProfileImageUrl, backgroundImageUrl: userData.compressedBackgroundImageUrl, originProfileImageUrl: userData.originalProfileImageUrl, originBackgroundImageUrl: userData.originalBackgroundImageUrl, tags: recommendTags, jobs: categoryTags, email: userData.email, openChatUrl: userData.link))
            
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
    
    @MainActor
    func showMain() {
        coordinator?.navigate(to: .MyPageMain)
    }
    
    private func downloadImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    continuation.resume(returning: imageResult.image)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func downloadProfileImage() {
        Task {
            do {
                guard let profileImageUrl = user.profileImageUrl else { return }
                let profileImage = try await downloadImage(from: profileImageUrl)
                self.originalProfileImage = profileImage
                self.shouldUpdateImageView.send()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func downloadBackgroundImage() {
        Task {
            do {
                guard let backgroundImageUrl = user.backgroundImageUrl else { return }
                let backgroundImage = try await downloadImage(from: backgroundImageUrl)
                self.originalBackgroundImage = backgroundImage
                self.shouldUpdateImageView.send()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
