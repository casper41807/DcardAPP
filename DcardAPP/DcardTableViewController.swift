//
//  DcardTableViewController.swift
//  DcardAPP
//
//  Created by 陳秉軒 on 2022/4/27.
//

import UIKit
import Kingfisher

class DcardTableViewController: UITableViewController {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchApi()
        refreshView()
        
    }

  
  
//    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailTableViewController? {
//        let controller = DetailTableViewController(coder: coder)
//        if let row = tableView.indexPathForSelectedRow?.row{
//            controller?.post = posts[row]
//        }
//        return controller
//    }
    
    
  
    
    //利用prepare傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailTableViewController,let row = tableView.indexPathForSelectedRow?.row {
            controller.post = posts[row]
        }
    }
    
    
    
    
    @objc func fetchApi(){
        let urlStr = "https://dcard.tw/_api/posts"
        if let url = URL(string: urlStr){
            URLSession.shared.dataTask(with: url) { data, response, error in
                let decoder = JSONDecoder()
                if let data = data {
                    do{
                        let posts = try decoder.decode([Post].self, from: data)
                        self.posts = posts
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    }catch{
                        print(error)
                    }
                }
            }.resume()
        }
    }
    //上拉更新tableView
    func refreshView(){
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.white] //文字顏色
        refreshControl?.attributedTitle = NSAttributedString(string: "更新中", attributes: attributes) //顯示文字
        refreshControl?.tintColor = .white //元件顏色
        refreshControl?.backgroundColor = .gray //下拉背景顏色
        refreshControl?.addTarget(self, action: #selector(fetchApi), for: UIControl.Event.valueChanged) //下拉後執行的動作
        tableView.refreshControl = refreshControl
        //下面這種方式加入也可以
        //tableView.addSubview(refreshControl!)
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DcardTableViewCell", for: indexPath) as? DcardTableViewCell else{return DcardTableViewCell()}
        let index = posts[indexPath.row]
        
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
        
        if index.likeCount != 0{
            cell.likeCountImage.tintColor = UIColor.systemRed
        }else{
            cell.likeCountImage.tintColor = UIColor.systemGray
        }
        
        if index.mediaMeta.count != 0{
            let urlStr = index.mediaMeta[0].url
//            URLSession.shared.dataTask(with: urlStr) { data, response, error in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        cell.postImage.image = UIImage(data: data)
//                    }
//                }
//            }.resume()
            //利用套件抓圖
            cell.postImage.kf.setImage(with: urlStr)
            cell.postImage.isHidden = false
        }else{
            cell.postImage.isHidden = true
        }
        cell.forumNameLabel.text = index.forumName
        cell.titleLabel.text = index.title
        cell.excerptLabel.text = index.excerpt
        cell.likeCountLabel.text = "\(index.likeCount)"
        cell.commentCountLabel.text = "\(index.commentCount)"
        
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
    //                let dateFormatter = ISO8601DateFormatter()
    //                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    //                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
    //                    let container = try decoder.singleValueContainer()
    //                    let dateString = try container.decode(String.self)
    //                    if let date = dateFormatter.date(from: dateString) {
    //                        return date
    //                    } else {
    //                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
    //                    }
    //                })
}
