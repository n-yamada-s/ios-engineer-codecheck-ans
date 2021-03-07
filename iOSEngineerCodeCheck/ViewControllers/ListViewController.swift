//
//  ListViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: Public Properties
    var word: String?

    // MARK: Private Properties
    private let repoModel = RepositoryModel()
    private var repo = Repository()
    private var task: URLSessionTask?
    private var idx: Int = 0

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repoModel.delegate = self
        searchBar.delegate = self

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = word
        if let word = word {
            repoModel.request(word: word)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let detail = segue.destination as? DetailViewController
            detail?.item = repo.items[self.idx]
        } else if segue.identifier == "History" {
            let history = segue.destination as? HistoryViewController
            history?.word = word
        }
    }

    // MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell {
            let item = repo.items[indexPath.row]
            cell.configure(item)
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        // 画面遷移
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

extension ListViewController: RepositoryModelDelegate {

    func repositoryDidChange(result: Repository) {
        repo = result
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ListViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" && word != nil {
            // searchBarの×ボタン押下時
            word = nil
            repo = Repository()
            self.tableView.reloadData()
        } else {
            // 画面遷移
            performSegue(withIdentifier: "History", sender: self)
        }
        searchBar.resignFirstResponder()
    }
}
