//
//  ListViewController.swift
//  NewsReader
//
//  Created by yukimasa ikeda on 2019/07/28.
//  Copyright © 2019 yukimasa. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
}
