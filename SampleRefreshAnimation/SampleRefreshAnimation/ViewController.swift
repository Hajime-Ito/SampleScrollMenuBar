//
//  ViewController.swift
//  SampleRefreshAnimation
//
//  Created by hajime ito on 2020/02/10.
//  Copyright © 2020 hajime_poi. All rights reserved.
//
import UIKit
import SwiftGifOrigin

typealias TableViewDD = UITableViewDelegate & UITableViewDataSource

class ViewController: UIViewController, TableViewDD, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var scrollViewBar: UIView!
    var myHeaderView: UIView!
    var lastContentOffset: CGFloat = 0
    var lastContentOffsetX: CGFloat = 0
    var scrollViewLabelArray: [UILabel] = []
    
    struct data {
        let TitleMenu = ["アニメ","ドラマ","映画","ニュース","漫画","生放送"]
        var index = 0
        
        mutating func setIndex(v: Int) {
            index = v
        }
        
        func getTitle() -> String {
            return TitleMenu[index]
        }
    }
    
    var Data = data()
    
    @IBOutlet weak var myTableView: UITableView!
    
    fileprivate let refreshCtl = UIRefreshControl()
    
    var bilibili = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createHeaderView()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.contentInset.top = 30 //ヘッダーの高さ分下げる
        myTableView.refreshControl = refreshCtl
        refreshCtl.tintColor = .clear // ゲージを透明にする
        refreshCtl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: .valueChanged)
        scrollView.delegate = self
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.addHeaderViewGif()
        if bilibili {
            bilibili = false
        } else {
            bilibili = true
        }
        myTableView.contentInset.top = 130 //ヘッダーの分下げる
        sender.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [],animations: {
                self.myTableView.contentInset.top = 30
            }, completion: nil)
            self.updateHeaderView()
            self.myTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEST",for: indexPath as IndexPath) as! tableViewCell
        
        if bilibili {
            if indexPath.section == 0 {
                cell.myImageView?.image = UIImage.gif(name: "bili")
            } else {
                cell.myImageView?.image = nil
            }
        } else {
            if indexPath.section == 0 {
                cell.myImageView?.image = nil
            } else {
                cell.myImageView?.image = UIImage.gif(name: "bili2")
            }
        }
        cell.myTextLabel?.text = Data.getTitle()
        cell.myImageView?.clipsToBounds = true
        return cell
    }
    
}

extension ViewController {
    private func createHeaderView() {
        let displayWidth: CGFloat! = self.view.frame.width
        // 上に余裕を持たせている（後々アニメーションなど追加するため）
        myHeaderView = UIView(frame: CGRect(x: 0, y: -230, width: displayWidth, height: 230))
        myHeaderView.alpha = 1
        myHeaderView.backgroundColor = UIColor(red: 142/255, green: 237/255, blue: 220/255, alpha: 1)
        myTableView.addSubview(myHeaderView)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 200, width: displayWidth, height: 30))
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor(red: 238/255, green: 142/255, blue: 160/255, alpha: 1)
        makeScrollMenu(scrollView: &scrollView)
        myHeaderView.addSubview(scrollView)
        scrollViewBar = UIView(frame: CGRect(x: 0, y: 225, width: 70, height: 5))
        scrollViewBar.backgroundColor = UIColor(red: 142/255, green: 237/255, blue: 220/255, alpha: 0.8)
        myHeaderView.addSubview(scrollViewBar)
        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
        if bilibili {
            image.image = UIImage(named: "bili2")
        } else {
            image.image = UIImage(named: "bili")
        }
        myHeaderView.addSubview(image)
    }
    
    private func updateHeaderView() {
        let displayWidth: CGFloat! = self.view.frame.width
        self.myHeaderView.subviews[2].removeFromSuperview()
        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
        if bilibili {
            image.image = UIImage(named: "bili2")
        } else {
            image.image = UIImage(named: "bili")
        }
        myHeaderView.addSubview(image)
    }
    
    func addHeaderViewGif() {
        let displayWidth: CGFloat! = self.view.frame.width
        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
        if bilibili {
            image.loadGif(name: "bili2")
        } else {
            image.loadGif(name: "bili")
        }
        myHeaderView.addSubview(image)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.myHeaderView.subviews[2].removeFromSuperview()
        }
    }
    
    func makeScrollMenu(scrollView: inout(UIScrollView)) {
        let menuLabelWidth:CGFloat = 70
        let titles = Data.TitleMenu
        let menuLabelHeight:CGFloat = scrollView.frame.height
        var X: CGFloat = 0
        var count = 1
        for title in titles {
            let scrollViewLabel = UILabel()
            scrollViewLabel.textAlignment = .center
            scrollViewLabel.frame = CGRect(x:X, y:0, width:menuLabelWidth, height:menuLabelHeight)
            scrollViewLabel.text = title
            scrollViewLabel.isUserInteractionEnabled = true
            scrollViewLabel.tag = count
            scrollView.addSubview(scrollViewLabel)
            X += menuLabelWidth
            count += 1
            scrollViewLabelArray.append(scrollViewLabel)
        }
        
        changeColorScrollViewLabel(tag: 1)
        
        scrollView.contentSize = CGSize(width:X, height:menuLabelHeight)
    }
    
    private func changeColorScrollViewLabel(tag: Int) {
        for label in scrollViewLabelArray {
            if label.tag == tag {
                label.textColor = UIColor(red: 142/255, green: 237/255, blue: 220/255, alpha: 1)
            } else {
                label.textColor = .white
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        print("touch")
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            guard t.view is UILabel else {
                return
            }
            switch t.view!.tag {
            case 1:
                print(1)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)

                changeColorScrollViewLabel(tag: 1)
                
                Data.setIndex(v: 0)
                myTableView.reloadData()
            case 2:
                print(2)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                
                changeColorScrollViewLabel(tag: 2)
                
                Data.setIndex(v: 1)
                myTableView.reloadData()
            case 3:
                print(3)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                
                changeColorScrollViewLabel(tag: 3)
                
                Data.setIndex(v: 2)
                myTableView.reloadData()
            case 4:
                print(4)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)

                changeColorScrollViewLabel(tag: 4)
                
                Data.setIndex(v: 3)
                myTableView.reloadData()
            case 5:
                print(5)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                
                changeColorScrollViewLabel(tag: 5)
                
                Data.setIndex(v: 4)
                myTableView.reloadData()
            case 6:
                print(6)
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [],animations: {
                    self.scrollViewBar.frame.origin.x = t.view!.frame.origin.x - self.scrollView.contentOffset.x
                }, completion: nil)
                
                changeColorScrollViewLabel(tag: 6)
                
                Data.setIndex(v: 5)
                myTableView.reloadData()
            default:
                break
            }
        }
    }
    
}

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}


class tableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextLabel: UILabel!
    @IBOutlet weak var syosaiButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
