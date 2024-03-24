//
//  ProductDetailEditModel.swift
//  Novart
//
//  Created by Jinwook Huh on 2/24/24.
//

import UIKit
import Combine

class ProductUploadModel: ObservableObject {
    let id: Int64?
    @Published var name: String?
    @Published var description: String?
    @Published var price: Int64?
    @Published var coverImages: [UploadMediaItem]
    @Published var detailImages: [UploadMediaItem]
    @Published var artTagList: [String]
    @Published var forSale: Bool
    @Published var category: CategoryType
    
    init() {
        self.id = nil
        self.name = nil
        self.description = nil
        self.price = nil
        self.coverImages = []
        self.detailImages = []
        self.artTagList = []
        self.forSale = false
        self.category = .all
    }
    
    init(id: Int64, name: String, description: String, price: Int64, coverImages: [UploadMediaItem], detailImages: [UploadMediaItem], artTagList: [String], forSale: Bool, category: CategoryType) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.coverImages = coverImages
        self.detailImages = detailImages
        self.artTagList = artTagList
        self.forSale = forSale
        self.category = category
    }
    
    func addImages(step: UploadStep, images: [UploadMediaItem]) {
        switch step {
        case .coverImage:
            self.coverImages.append(contentsOf: images)
        case .detailImage:
            self.detailImages.append(contentsOf: images)
        }
    }
    

    func removeImage(step: UploadStep, identifier: String) {
        var images: [UploadMediaItem] = (step == .coverImage) ? coverImages : detailImages
        
        guard let idx = images.firstIndex(where: { $0.identifier == identifier }) else {
            return
        }
                
        images.remove(at: idx)
        
        switch step {
        case .coverImage:
            coverImages = images
        case .detailImage:
            detailImages = images
        }
    }
    
    func updateImage(step: UploadStep, identifier: String, item: UploadMediaItem) {
        var images: [UploadMediaItem] = (step == .coverImage) ? coverImages : detailImages
        
        guard let idx = images.firstIndex(where: { $0.identifier == identifier }) else {
            return
        }
                
        images.remove(at: idx)
        images.insert(item, at: idx)
        
        switch step {
        case .coverImage:
            coverImages = images
        case .detailImage:
            detailImages = images
        }
    }

    func getImage(step: UploadStep, identifier: String) -> UploadMediaItem? {
        var images: [UploadMediaItem] = (step == .coverImage) ? coverImages : detailImages
        return images.first(where: { $0.identifier == identifier })
    }
    
}
