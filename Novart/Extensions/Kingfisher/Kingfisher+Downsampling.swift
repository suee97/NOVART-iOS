import UIKit
import Kingfisher

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    func setImageWithDownsampling(
        with resource: Resource?,
        size: CGSize,
        options: KingfisherOptionsInfo? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
            var mergedOptions: KingfisherOptionsInfo = [
                .processor(DownsamplingImageProcessor(size: size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
            if let options {
                mergedOptions.append(contentsOf: options)
            }
            self.setImage(with: resource, options: mergedOptions, completionHandler: completionHandler)
    }
}
