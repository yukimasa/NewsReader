//
//  ListViewController.swift
//  NewsReader
//
//  Created by yukimasa ikeda on 2019/07/28.
//  Copyright © 2019 yukimasa. All rights reserved.
//

import UIKit

// ListViewControllerクラスをデリゲートに指定
// XMLParserDelegateがXMLParserのデリゲートになるためのプロトコル名
class ListViewController: UITableViewController, XMLParserDelegate {
    
    // RSSデータを解析するためのXMLParserクラスのインスタンスを格納
    var parser:XMLParser!
    // 複数の記事を格納するための配列
    var items  = [Item]()
    // Itemクラス型のプロパティで「タイトル（title）」と「本文のURL（link）」の2つのプロパティを持つ
    var item:Item?
    // データ解析で抽出した文字列を一時的に格納するためのプロパティ
    var currentString = ""
    
    // セルの数を設定する
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // セルの内容を設定する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを再利用する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startDownload()
    }
    
    // RSSデータをダウンロード
    func startDownload() {
        // 古いデータが入ったままでダウンロードすると、重複する記事が生成されてしまうので、items配列を初期化している
        self.items = []
        
        // ニュース記事がある「WIRED」というサイトのRSSフィードのURLを指定
        if let url = URL(string: "https://wired.jp/rssfeeder/") {
            // 引数にRSSフィードのURLを指定して、XMLParserのインスタンスを作成
            // 不正なURLが指定された時に「nil」を返すことがあるため「XMLParser(contentsOf: url)」の戻り値の型はオプショナル型となっている
            if let parser = XMLParser(contentsOf: url) {
                // parserのデリゲートに「self」(ListViewController)を指定し、最後にparse()メソッドを呼び出すことでデータの解析を開始している
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
        }
    }
    
    // XMLParserDelegateで宣言されているメソッドで、要素名の開始タグが出現するたびに、デリゲートとして指定したインスタンスの中で自動的に呼び出される
    // ニュース記事の要素名から必要なデータ(item)のみを取り出す処理
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {
        // 古い文字列が入ったままの状態で処理が進まないように、変数を初期化する
        self.currentString = ""
        // 引数elementNameには、ダウンロードしたRSS形式のデータの要素名が入っているので、文字列"item"と比較することで、要素名が"item"のデータのみを取得する
        if elementName == "item" {
            self.item = Item()
        }
    }
    
    // タグで囲まれた内容（要素）を取り出す
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // 引数stringには見つかった記事の内容が格納されている。この引数の中身を変数に追加していく
        self.currentString += string
    }
    
    // itemに1つの記事（item）を追加する
    // ある要素名が終わると（</item>などの終了タグが見つかる）と自動的に呼ばれる
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // 引数のelementNameに要素名が格納されているので、switch文の条件に指定することで要素ごとの処理を行う
        switch elementName {
        case "title": self.item?.title = currentString
        case "link": self.item?.link = currentString
        case "item": self.items.append(self.item!)
        default: break
        }
    }
    
    // 全てのデータの解析が終了すると自動的に呼ばれる
    func parserDidEndDocument(_ parser: XMLParser) {
        // テーブルビューの内容を更新する（UITableViewクラスのreloadData()メソッドを呼び出す）ことで取得したニュースの記事を画面に表示している。
        self.tableView.reloadData()
    }
    
    // 記事のデータを次の画面に渡す処理
    // 画面推移のタイミングで何らかのデータを受け渡したい場合は、セグエの設定に加えてprepare(for:sender:)メソッドを書く必要がある
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // UITableViewクラスのindexPathForSelectedRowプロパティを使ってユーザーがタップしたセルのindexPathを取得し、その値を用いてitems配列から該当する記事（item）を取得
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let item = items[indexPath.row]
            // 推移先のビューコントローラーを格納
            // 引数のsegueはUIStoryboardSegueクラス（ストーリーボード上の矢印）のインスタンスで、destinationプロパティ(推移先のビューコントローラー)を持つ
            let controller = segue.destination as! DetailViewController
            // 推移先のtitleとlinkに記事のタイトルとURLを格納している
            controller.title = item.title
            controller.link = item.link
        }
    }
}
