//
//  DetailTableViewController.swift
//  DcardAPP
//
//  Created by 陳秉軒 on 2022/4/29.
//

import UIKit
import Kingfisher
import Alamofire

class DetailTableViewController: UITableViewController {
    

    
    @IBOutlet var detailView: headerView!
    

    var post:Post!
    var postDetail:PostDetail?
    var comments = [Comments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDetailApi()
        fetchCommentsApi()
        
        title = post.title
        if post.gender == "F"{
        detailView.genderImage.image = UIImage(named: "woman")
            
            detailView.genderLabel.text = "女同學"
        }else{
            detailView.genderImage.image = UIImage(named: "man")
            detailView.genderLabel.text = "男同學"
        }
        if post.school == nil{
            detailView.schoolLabel.text = "匿名"
        }else{
            detailView.schoolLabel.text = post.school
        }
        
        if post.likeCount != 0{
            detailView.likeCountImage.tintColor = UIColor.systemRed
        }else{
            detailView.likeCountImage.tintColor = UIColor.systemGray
        }
        
        if post.commentCount != 0{
            detailView.commentCountImage.tintColor = .blue
        }else{
            detailView.commentCountImage.tintColor = .gray
        }
        
        detailView.forumNameLabel.text = post.forumName
        detailView.titleLabel.text = post.title
        detailView.likeCountLabel.text = "\(post.likeCount)"
        detailView.commentCountLabel.text = "\(post.commentCount)"
        
    }
    
    
    func fetchDetailApi(){
        
        if let url = URL(string: "https://dcard.tw/_api/posts/\(post.id)"){
//            let decoder = JSONDecoder()
//                            let dateFormatter = ISO8601DateFormatter()
//                            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//                            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
//                                let container = try decoder.singleValueContainer()
//                                let dateString = try container.decode(String.self)
//                                return dateFormatter.date(from: dateString) ?? Date()
//
//                            })
//            AF.request(url).responseDecodable(of: PostDetail.self, decoder: decoder) { response in
//                switch response.result {
//                case .success(let postDetail):
//                    let contentSplit = postDetail?.content.split(separator: "\n").map(String.init)
//                    print("contentSplit = \(contentSplit)")
//                    let mutableAttributedString = NSMutableAttributedString()
//                    contentSplit?.forEach({ row in
//                        if row.contains("https") {
//                            mutableAttributedString.append(imageSource: row, labelText: self.detailView.contentLabel)
//                        } else {
//                            mutableAttributedString.append(string: row)
//                        }
//                    })
//                    DispatchQueue.main.async {
//                        print("show detail \(mutableAttributedString)")
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yyyy/MM/dd hh:mm"
//                        let timeText = formatter.string(from: postDetail.createdAt!)
//                        self.detailView.createdAtLabel.text = timeText
//                        self.detailView.contentLabel.attributedText = mutableAttributedString
//                        self.tableView.reloadData()
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//                let postDetail = response.result
//
//            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
                    }
                })
                if let data = data {

                    do{
                        let postDetail = try decoder.decode(PostDetail.self, from: data)
                        self.postDetail = postDetail

                        let contentSplit = self.postDetail?.content.split(separator: "\n").map(String.init)
                        let mutableAttributedString = NSMutableAttributedString()
                        contentSplit?.forEach({ row in
                            if row.contains("https") {
                                mutableAttributedString.append(imageSource: row, labelText: self.detailView.contentLabel)
                            } else {
                                mutableAttributedString.append(string: row)
                            }
                        })

                        DispatchQueue.main.async {
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy/MM/dd hh:mm"
                            let timeText = formatter.string(from: postDetail.createdAt)
                            self.detailView.createdAtLabel.text = timeText
//                            self.detailView.contentLabel.attributedText = mutableAttributedString
                            self.tableView.reloadData()
                        }
                    }catch{
                        print("catch = \(error)")
                    }
                }
            }.resume()
        }
    }
    
    func fetchCommentsApi(){
        let urlStr = "https://dcard.tw/_api/posts/\(post.id)/comments"
        if let url = URL(string: urlStr){
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    if let date = dateFormatter.date(from: dateString) {
                        return date
                    } else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
                    }
                })
                if let data = data {
                    do{
                        let comments = try decoder.decode([Comments].self, from: data)
                        self.comments = comments
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }catch{
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    
    
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return detailView
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else{return DetailTableViewCell()}
        let index = comments[indexPath.row]
        if index.gender == "F"{
            cell.genderImage.image = UIImage(named: "woman")
        }else{
            cell.genderImage.image = UIImage(named: "man")
        }
        
        if index.school == nil{
            cell.schoolLabel.text = "匿名"
        }else{
            cell.schoolLabel.text = index.school
        }
        cell.contentLabel.text = index.content
        cell.floorLabel.text = "B\(index.floor)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/mm/dd hh:mm"
        let timeText = formatter.string(from: index.createdAt)
        cell.createdAtLabel.text = timeText
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
