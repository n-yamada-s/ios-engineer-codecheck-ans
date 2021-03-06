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
    let repoModel = RepositoryModel()

    var repo: Repository?
    var idx: Int = 0

    // MARK: Private Properties
    private var task: URLSessionTask?

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repoModel.delegate = self
        searchBar.delegate = self

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let dtl = segue.destination as? DetailViewController
            dtl?.item = self.repo?.items[self.idx]
        }
    }

    // MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell {
            if let item = repo?.items[indexPath.row] {
                cell.configure(item)
            }
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
    func repositoryDidChange(repo: Repository) {
        self.repo = repo
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let word = searchBar.text, word.count != 0 {
            repoModel.request(word: word)
        }
    }
}
