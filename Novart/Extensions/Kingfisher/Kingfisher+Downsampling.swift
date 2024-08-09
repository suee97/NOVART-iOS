import UIKit
import Kingfisher

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    func setImageWithDownsampling(
        with source: URL,
        size: CGSize,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
            self.setImage(with: source, options: [
                .processor(DownsamplingImageProcessor(size: size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ],
            completionHandler: completionHandler
        )
    }
}
