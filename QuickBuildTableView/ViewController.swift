//
//  ViewController.swift
//  QuickBuildTableView
//
//  Created by 张尉 on 2017/10/20.
//  Copyright © 2017年 Wayne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let builder = TableBuilder.init(configuration: {
        var config = TableBuilerConfiguration()
        config.useFixedRowHeight = false
        return config
    }())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = builder
        tableView.dataSource = builder
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        build()
    }
    
    
    func build() {
        builder.groups.removeAll()
        
        let groups = Array((0..<Int(arc4random()) % 100 + 10))
        groups.forEach({ (groupIdx) in
            
            builder.groups.append(TableBuilder.Group.generate(block: { (group) in
                
                let rows = Array(0..<Int(arc4random()) % 8 + 1)
                rows.forEach({ (rowIdx) in
                    group.rows.append(TableBuilder.Row.generate(block: { (row) in
                        let height = CGFloat(arc4random() % 100) + 20
                        row.height = { _, _ in return height }
                        row.rendering = { tableView, indexPath in
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                            cell.textLabel?.text = "Section\(groupIdx),Row\(rowIdx)"
                            return cell
                        }
                        
                        row.canEdit = { _,_ in return true }
                        row.editActions = { tableView, IndexPath in
                            let action = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "DEL", handler: { [weak self] (action, indexPath) in
                                
                                if let group = self?.builder.group(at: indexPath.section) {
                                    if group.rows.count == 1 {
                                        self?.builder.groups.remove(at: indexPath.section)
                                        tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .fade)
                                    }
                                    else {
                                        group.rows.remove(at: IndexPath.row)
                                        tableView.deleteRows(at: [IndexPath], with: .fade)
                                    }
                                }
                            })
                            action.backgroundColor = UIColor.blue
                            
                            return [action]
                        }
                    }))
                })
                
                
            }))
            
        })
        
        tableView.reloadData()
    }

}

