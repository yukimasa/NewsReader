//
//  ListViewController.swift
//  NewsReader
//
//  Created by yukimasa ikeda on 2019/07/28.
//  Copyright © 2019 yukimasa. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    // セルの数を設定する
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // セルの内容を設定する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを再利用する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
}
