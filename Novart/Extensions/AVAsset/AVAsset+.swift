//
//  AVAsset+.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/12/10.
//

import UIKit
import AVFoundation

public extension AVAsset {
    var thumbnailImage: UIImage? {
        get async throws {
            var time = try await load(.duration)
            let imageGenerator = AVAssetImageGenerator(asset: self)
            imageGenerator.appliesPreferredTrackTransform = true
            
            time.value = CMTimeValue(0)
            
            guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: nil) else {
                return nil
            }
            
            return UIImage(cgImage: cgImage)
        }
    }
    
    var videoDuration: Double? {
        get async throws {
            let durationTime = try await load(.duration)
            return CMTimeGetSeconds(durationTime)
        }
    }
}
