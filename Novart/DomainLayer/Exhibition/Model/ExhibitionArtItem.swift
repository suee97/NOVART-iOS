//
//  ExhibitionArtItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/11/05.
//

import UIKit
import Combine
import Kingfisher

final class ExhibitionArtItem: ExhibitionDetailItem {
    let artId: Int64
    let description: String
    let title: String
    let subtitle: String
    let thumbnailImageUrls: [String]
    let detailImages: [ExhibitionDetailImageInfoModel]
    let artistInfo: ExhibitionArtistFollowInfoModel
    let exhibitionImages: CurrentValueSubject<[UIImage], Never> = .init([])
    
    var isContactEnabled: Bool {
        artistInfo.email != nil || artistInfo.openChatUrl != nil 
    }
    
    init(artId: Int64, description: String, title: String, subtitle: String, thumbnailImageUrls: [String], detailImages: [ExhibitionDetailImageInfoModel], artistInfo: ExhibitionArtistFollowInfoModel) {
        self.artId = artId
        self.description = description
        self.title = title
        self.subtitle = subtitle
        self.thumbnailImageUrls = thumbnailImageUrls
        self.detailImages = detailImages
        self.artistInfo = artistInfo
    }
    
    init(item: ExhibitionDetailArtItem) {
        self.artId = item.id
        self.description = item.description
        self.thumbnailImageUrls = item.thumbnailImageUrls
        self.title = "Temp"
        self.subtitle = "Subtitle"
        self.detailImages = item.detailImageInfo
        self.artistInfo = item.artistFollow
        super.init()
        loadImages()
    }
    
    func loadImages() {
        Task {
            do {
                let images = try await downloadImages(from: detailImages.map { $0.url }).compactMap { $0 }
                exhibitionImages.send(images)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func downloadImage(from urlString: String) async throws -> UIImage? {
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
    
    func downloadImages(from urlStrings: [String]) async throws -> [UIImage?] {
        var images: [UIImage?] = []

        try await withThrowingTaskGroup(of: UIImage?.self) { [weak self] group in
            guard let self else { return }
            for urlString in urlStrings {
                group.addTask {
                    try await self.downloadImage(from: urlString)
                }
            }

            for try await image in group {
                images.append(image)
            }
        }

        return images
    }
}
