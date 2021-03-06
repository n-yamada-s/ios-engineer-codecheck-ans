//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    // MARK: IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: Public Properties
    var repo: Repositories?
    var idx: Int = 0

    // MARK: Private Properties
    private var task: URLSessionTask?
    private var word: String?
    private let urlStr: String = "https://api.github.com/search/repositories?q="

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let dtl = segue.destination as? ViewController2
            dtl?.vc1 = self
        }
    }

    // MARK: Private Methods
    private func request(url: URL) {
        task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                if let obj = try? JSONDecoder().decode(Repositories.self, from: data) {
                    self?.repo = obj
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        // これ呼ばなきゃリストが更新されません
        task?.resume()
    }

    // MARK: UISearchBarDelegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let word = searchBar.text, word.count != 0 {
            if let url = URL(string: urlStr + word) {
                request(url: url)
            }
        }
    }

    // MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        if let item = repo?.items[indexPath.row] {
            cell.textLabel?.text = item.fullName
            cell.detailTextLabel?.text = item.language
            cell.tag = indexPath.row
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        idx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }

}
