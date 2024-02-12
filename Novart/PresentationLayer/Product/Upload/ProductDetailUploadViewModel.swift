//
//  ProductDetailUploadViewModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/24.
//

import Foundation
import Combine

final class ProductDetailUploadViewModel {
    private weak var coordinator: ProductUploadCoordinator?
    
    var maxTitleCount: Int = 30
    var maxCategoryCount: Int = 1
    var maxDescriptionCount: Int = 200
    var maxTagCount: Int = 5
    
    var selectedCoverImages: [UploadMediaItem]
    var selectedDetailImages: [UploadMediaItem]
    var categories: [TagItem]
    var priceTags: [TagItem] = [TagItem(tag: "전시", isSelected: false), TagItem(tag: "전시+거래", isSelected: false)]
    var recommendTags: [TagItem] = [
        TagItem(tag: "제품", isSelected: false), TagItem(tag: "공예", isSelected: false), TagItem(tag: "그래픽", isSelected: false), TagItem(tag: "회화", isSelected: false), TagItem(tag: "UX", isSelected: false), TagItem(tag: "UI", isSelected: false), TagItem(tag: "모던", isSelected: false), TagItem(tag: "클래식", isSelected: false), TagItem(tag: "오브제", isSelected: false), TagItem(tag: "감성적인", isSelected: false), TagItem(tag: "심플", isSelected: false), TagItem(tag: "귀여운", isSelected: false), TagItem(tag: "키치한", isSelected: false), TagItem(tag: "힙한", isSelected: false), TagItem(tag: "레트로", isSelected: false), TagItem(tag: "트렌디", isSelected: false), TagItem(tag: "부드러운", isSelected: false), TagItem(tag: "몽환적인", isSelected: false), TagItem(tag: "실용적인", isSelected: false), TagItem(tag: "빈티지", isSelected: false), TagItem(tag: "화려한", isSelected: false), TagItem(tag: "재활용", isSelected: false), TagItem(tag: "친환경", isSelected: false), TagItem(tag: "지속가능한", isSelected: false), TagItem(tag: "밝은", isSelected: false), TagItem(tag: "어두운", isSelected: false), TagItem(tag: "차가운", isSelected: false), TagItem(tag: "따뜻한", isSelected: false)
    ]
    
    var recommendationExpanded = true
    @Published var recommendTagFieldString: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    var forSale: Bool = false
    var price: Int = 0
    var selectedCategory: CategoryType? {
        if let selectedTag = categories.first(where: { $0.isSelected }) {
            return CategoryType(rawValue: selectedTag.tag ?? "")
        }
        return nil
    }

    var selectedTags: [String] {
        let selectedTags = recommendTags.filter({ $0.isSelected })
        return selectedTags.compactMap { $0.tag }
    }
    
    init(coordinator: ProductUploadCoordinator?, selectedCoverImages: [UploadMediaItem], selectedDetailImages: [UploadMediaItem]) {
        self.coordinator = coordinator
        self.selectedCoverImages = selectedCoverImages
        self.selectedDetailImages = selectedDetailImages
        let categories: [CategoryType] = [.craft, .fashion, .product, .graphic, .painting]
        self.categories = categories.map { TagItem(tag: $0.rawValue) }
    }
    
    func selectCategory(index: Int) {
        var updatedCategories: [TagItem] = []
        for (idx, category) in categories.enumerated() {
            if idx == index {
                let updated = TagItem(id: category.id, tag: category.tag, isSelected: true)
                updatedCategories.append(updated)
            } else {
                let updated = TagItem(id: category.id, tag: category.tag, isSelected: false)
                updatedCategories.append(updated)
            }
        }
        categories = updatedCategories
    }
    
    func selectPriceTag(index: Int) {
        var updatedTags: [TagItem] = []
        for (idx, tag) in priceTags.enumerated() {
            if idx == index {
                let updated = TagItem(id: tag.id, tag: tag.tag, isSelected: true)
                updatedTags.append(updated)
            } else {
                let updated = TagItem(id: tag.id, tag: tag.tag, isSelected: false)
                updatedTags.append(updated)
            }
        }
        priceTags = updatedTags
    }
    
    func selectTag(index: Int, isSelected: Bool) {
        let tag = recommendTags.remove(at: index)
        let newTag = TagItem(id: tag.id, tag: tag.tag, isSelected: isSelected)
        recommendTags.insert(newTag, at: index)
        updateRecommendTagSelection(index: index, isSelected: isSelected)

    }
    
    func updateRecommendTagSelection(index: Int, isSelected: Bool) {
        recommendTags[index].isSelected = isSelected
        
        // 선택된 추천태그 문자열
        let tagString = recommendTags[index].tag ?? ""
        
        if isSelected {
            recommendTagFieldString += recommendTagFieldString.isEmpty ? tagString : ", \(tagString)" // 추천태그 추가
        } else {
            // 추천태그 제거
            if let range = recommendTagFieldString.range(of: tagString) {
                var lb = range.lowerBound
                var ub = range.upperBound
                
                // 추천태그가 중간, 마지막 위치일 때 좌측 ","를 만나는 범위까지 문자열 삭제
                if lb != recommendTagFieldString.startIndex {
                    while true {
                        if lb == recommendTagFieldString.startIndex {
                            break
                        }
                        if recommendTagFieldString[lb] != "," {
                            lb = recommendTagFieldString.index(lb, offsetBy: -1)
                        } else {
                            break
                        }
                    }
                    recommendTagFieldString.replaceSubrange(lb..<range.upperBound, with: "")
                } else {
                    // 추천태그가 첫번째 위치일 때 우측 "," & 공백을 제외한 문제열을 만날 때까지 삭제
                    while true {
                        if ub == recommendTagFieldString.endIndex {
                            break
                        }
                        if recommendTagFieldString[ub] == "," || recommendTagFieldString[ub] == " " {
                            ub = recommendTagFieldString.index(ub, offsetBy: +1)
                        } else {
                            break
                        }
                    }
                    recommendTagFieldString.replaceSubrange(recommendTagFieldString.startIndex..<ub, with: "")
                }
            }
        }
    }
    
    @MainActor
    func showPreview() {
        guard let previewData = createPreviewData() else { return }
        coordinator?.navigate(to: .preview(data: previewData))
    }
}

extension ProductDetailUploadViewModel {
    func createPreviewData() -> ProductPreviewModel? {
        guard let selectedCategory else { return nil }
        let coverImages = selectedCoverImages.map { $0.image }
        let detailImages = selectedDetailImages.map { $0.image }
        
        return ProductPreviewModel(name: title, description: description, price: price, coverImages: coverImages, detailImages: detailImages, artTagList: selectedTags, selectedCategory: selectedCategory, forSale: forSale)
    }
}
