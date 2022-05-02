//
//  DcardResponse.swift
//  DcardAPP
//
//  Created by 陳秉軒 on 2022/4/27.
//

import Foundation
import UIKit

struct Post:Codable{
    let id:Int //文章id
    let title:String //標題
    let excerpt:String //內文
    let commentCount:Int
    let likeCount:Int
    let forumName: String //類別
    let gender: String //性別
    let school: String? //學校
    let mediaMeta: [MediaMeta]
    struct MediaMeta:Codable{
        let url: URL
    }
}

struct PostDetail:Codable{
    let content:String
    let createdAt:Date
    let commentCount:Int
    let likeCount:Int
    let media:[Media]
    struct Media:Codable{
        let url:URL
    }
}

struct Comments:Codable{
    let createdAt:Date
    let floor:Int
    let content:String
    let gender:String
    let school:String?
}



extension NSMutableAttributedString {
    func append(string: String) {
        self.append(NSAttributedString(string: string + "\n"))
    }
    func append(imageSource: String, labelText: UILabel) {
        guard let url = URL(string: imageSource) else { return }
        UIImage.image(from: url) { image in
            guard let image = image else { return }
            let scaledImage = image.scaled(with: UIScreen.main.bounds.width / image.size.width * 1)
            let attachment = NSTextAttachment()
            attachment.image = scaledImage
            self.append(NSAttributedString(attachment: attachment))
            self.append(NSAttributedString(string: "\n"))
        }
    }
}




extension UIImage {
    static func image(from url: URL, handel: @escaping (UIImage?) -> ()) {
        guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            handel(nil)
            return
        }
        handel(image)
    }
    
    func scaled(with scale: CGFloat) -> UIImage? {
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}








//extension NSMutableAttributedString {
//    func append(string: String) {
////        調整textView上字體大小
//        self.append(NSAttributedString(string: string + "\n", attributes: [.font: UIFont.systemFont(ofSize: 16)]))
//    }
//
//    func append(imageFrom: String, textView: UITextView) {
//        guard let url = URL(string: imageFrom) else { return }
//             UIImage.image(from: url) { (image) in
//            guard let image = image else { return }
//
////            設定螢幕寬度的0.8 長寬比不變
//            let scaledImg = image.scaled(with: UIScreen.main.bounds.width / image.size.width * 0.8)
//            let attachment = NSTextAttachment()
//            attachment.image = scaledImg
//            self.append(NSAttributedString(attachment: attachment))
//            self.append(NSAttributedString(string: "\n"))
//        }
//
//    }
//}
