//
//  Extension+AVAsset.swift
//  hnstails
//
//  Created by Yoon on 2021/10/23.
//
import AVKit

extension AVAsset {

    func generateThumbnail(completion: @escaping ([UIImage]?) -> Void) {
        DispatchQueue.global().async {
            var i = 0
            var images : [UIImage] = []
            
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let duration = self.duration
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time),
                         NSValue(time: CMTime(seconds: duration.seconds / 5 * 1, preferredTimescale: 600)),
                         NSValue(time: CMTime(seconds: duration.seconds / 5 * 2, preferredTimescale: 600)),
                         NSValue(time: CMTime(seconds: duration.seconds / 5 * 3, preferredTimescale: 600)),
                         NSValue(time: CMTime(seconds: duration.seconds / 5 * 4, preferredTimescale: 600))]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    if i == 4 {
                        images.append(UIImage(cgImage: image))
                        completion(images)
                    } else {
                        images.append(UIImage(cgImage: image))
                        i = i + 1
                    }
                    
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    func generate5Thumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
