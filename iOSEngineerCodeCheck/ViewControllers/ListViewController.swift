//
//  ListViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var indicatorView: UIView!

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
        indicatorView.isHidden = true
        searchBar.text = word
        if let word = word {
            repoModel.request(word: word)
            indicatorView.isHidden = false
            indicator.startAnimating()
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
}

extension ListViewController: RepositoryModelDelegate {

    func repositoryDidChange(result: Repository) {
        repo = result
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.indicatorView.isHidden = true
            self.indicator.stopAnimating()
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell {
            let item = repo.items[indexPath.row]
            cell.configure(item)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        // 画面遷移
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

extension ListViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text == "" && word != nil {
            // searchBarの×ボタン押下時
            word = nil
            repo = Repository()
            self.tableView.reloadData()
        } else {
            // 画面遷移
            performSegue(withIdentifier: "History", sender: self)
        }
        return true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
