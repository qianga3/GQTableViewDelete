//
//  ViewController.swift
//  GQTableViewDelete
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 GQ. All rights reserved.
//

import UIKit
import SnapKit

let sW = UIScreen.main.bounds.size.width
let sH = UIScreen.main.bounds.size.height
let sHH = UIScreen.main.bounds.size.height-64
let sHHH = UIScreen.main.bounds.size.height-64-44
extension UIColor {
    class func rgbColorFromHex(rgb:Int) -> UIColor {
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
}

class ViewController: UIViewController {

    
    @IBOutlet weak var leftBtnSet: UIBarButtonItem!
    
    @IBOutlet weak var rightBtnSet: UIBarButtonItem!
    
    @IBAction func rightBtnAction(_ sender: Any) {
        isBianji = !isBianji
        if isBianji {
            rightBtnSet.image = UIImage(named: "取消")
            leftBtnSet.image = UIImage(named: "全选")
            self.tableView.allowsMultipleSelectionDuringEditing = true
            self.tableView.isEditing = !self.tableView.isEditing
            UIView.animate(withDuration: 0.5, animations: {
                
                self.deleteView.frame = CGRect(x: 0, y: sHH+4, width: sW, height: 60)
                
            })
            
            
        }else{
            self.tableView.isEditing = !self.tableView.isEditing
            rightBtnSet.image = UIImage(named: "shoucang_xuanze")
            leftBtnSet.image = UIImage(named: "back")
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.deleteView.frame = CGRect(x: 0, y: sHH+4+60, width: sW, height: 60)
            }, completion: { (true) in
                //弹下去的时候删除为0
                self.deleteBtn.setTitle("删除(\(self.deleteArr.count))", for: .normal)
            })
            
            //取消之后 不是全选  删除数组 清0
            self.isQuanxuan = false
            self.deleteArr.removeAllObjects()
        }

    }
    
       @IBAction func leftBtnAction(_ sender: Any) {
        if isBianji {
            self.quanxuan()
            
        }else{
            back()
        }

    }

    
    var tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: sW, height: sHH), style: .plain)
    
    var dataArr = NSMutableArray()
    
    var isBianji = false  //是否是编辑状态
    
    var isQuanxuan = false // 是否全选
    
    var deleteArr = NSMutableArray()  //删除数组  用于多选
    
    var deleteView = UIView()  //删除View
    
    let deleteBtn = UIButton()  //删除按钮

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        createUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isBianji = false
        isQuanxuan = false
    }
    
    func getData(){
        dataArr = ["强哥最帅第一次","强哥最帅第二次","强哥最帅第三次","强哥最帅第四次","强哥最帅第五次"]
    }

    func createUI(){
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.isEditing = false
        tableView.rowHeight = 44
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        deleteView.frame = CGRect(x: 0, y: sHH+60, width: sW, height: 60)
        deleteView.backgroundColor = UIColor.rgbColorFromHex(rgb: 0x444444)
        deleteView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.deleteView.snp.left).offset(15)
            make.top.equalTo(self.deleteView.snp.top).offset(10)
            make.right.equalTo(self.deleteView.snp.right).offset(-15)
            make.bottom.equalTo(self.deleteView.snp.bottom).offset(-10)
        }
        deleteBtn.setTitle("删除(\(self.deleteArr.count))", for: .normal)
        deleteBtn.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xf54040)
        deleteBtn.setTitleColor(UIColor.white, for: .normal)
        deleteBtn.layer.masksToBounds = true
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.addTarget(self, action: #selector(ViewController.duoxuanDelete), for: .touchUpInside)
        
        self.view.addSubview(deleteView)
    }
    
    
    func duoxuanDelete(){
        if (self.tableView.isEditing){
            self.dataArr.removeObjects(in: self.deleteArr as! [Any])
            self.tableView.reloadData()
            //更新删除的title,清除一次之后要清楚删除按钮
            deleteArr.removeAllObjects()
            deleteBtn.setTitle("删除(\(self.deleteArr.count))", for: .normal)
            
        }else {
            return
        }
    }
    
    func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func quanxuan(){
        isQuanxuan = !isQuanxuan
        if isQuanxuan {
            for (i, _) in dataArr.enumerated(){
                let index = NSIndexPath(item: i, section: 0)
                self.tableView.selectRow(at: index as IndexPath, animated: true, scrollPosition: .top)
                deleteArr.removeAllObjects()
                for item in dataArr {
                    self.deleteArr.add(item)
                }
                self.deleteBtn.setTitle("删除(\(self.deleteArr.count))", for: .normal)
                
            }
        }else{
            for (i,_) in dataArr.enumerated() {
                let index = NSIndexPath(item: i, section: 0)
                self.tableView.deselectRow(at: index as IndexPath, animated: true)
                self.deleteArr.removeAllObjects()
                self.deleteBtn.setTitle("删除(\(self.deleteArr.count))", for: .normal)
            }
        }
    }
    
    

}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row] as! String
        //去掉选中后的 效果
        cell.selectedBackgroundView = UIView(frame: CGRect.zero)
        //改变勾选的颜色
//        cell.tintColor = UIColor.rgbColorFromHex(rgb: 0x11c08e)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isBianji {
            deleteArr.add(self.dataArr[indexPath.row])
            self.deleteBtn.setTitle("删除(\(self.deleteArr.count))", for: .normal)
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isBianji {
            deleteArr.remove(dataArr[indexPath.row])
            self.deleteBtn.setTitle("删除(\(self.deleteArr.count))", for: .normal)
        }
        
    }
}

