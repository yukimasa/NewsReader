//
//  DetailViewController.swift
//  NewsReader
//
//  Created by yukimasa ikeda on 2019/07/28.
//  Copyright © 2019 yukimasa. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ニュース記事の本文を表示する処理
        
        // 変数linkに格納されている値を使用して、urlインスタンスを作成
        // URLクラスのインスタンスを作成することでURLが不正なものかを検証する
        if let url = URL(string: self.link) {
            // データの保存方法を設定し、requestインスタンスを作成
            let request = URLRequest(url: url)
            // load(_:)メソッドで、ユーザーがタップした記事の内容をネットからダウンロードして、ウェブビューにWebサイトを表示させる
            self.webView.load(request)
        }
    }
    
}
