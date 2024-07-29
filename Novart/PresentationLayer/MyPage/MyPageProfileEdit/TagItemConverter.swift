import Foundation

final class TagItemConverter {
    private var tagList: [String]
    
    init(tagList: [String]) {
        self.tagList = tagList
    }
    
    init() {
        self.tagList = []
    }
    
    func setTagList(tagList: [String]) {
        self.tagList = tagList
    }
    
    func getTagItems() -> [TagItem] {
        return convertTagItems()
    }
    
    private func convertTagItems() -> [TagItem] {
        return tagList.map { TagItem(tag: $0, isSelected: false) }
    }
}
