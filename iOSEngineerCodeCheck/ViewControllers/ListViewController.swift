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
    @IBOutlet private weak var totalCountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var searchWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchWidthFullConstraint: NSLayoutConstraint!

    // MARK: Public Properties
    var word: String?

    // MARK: Private Properties
    private let repoModel = RepositoryModel()
    private var repo = Repository()
    private var task: URLSessionTask?

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
        if word != searchBar.text {
            searchBar.text = word
            updateSearchConstraints()
            requestRepository()
        }
    }

    // MARK: Private Methods
    private func requestRepository() {
        if let word = word {
            repoModel.request(word: word)
            indicatorView.isHidden = false
            indicator.startAnimating()
        }
    }

    private func updateSearchConstraints() {
        searchWidthConstraint.isActive = (word != nil)
        searchWidthFullConstraint.isActive = (word == nil)
    }

    private func pushDetailView(item: Item) {
        if let detail = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detail.item = item
            navigationController?.pushViewController(detail, animated: true)
        }
    }

    private func pushHistoryView() {
        if let history = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController {
            history.word = word
            navigationController?.pushViewController(history, animated: true)
        }
    }

    // MARK: IBAction
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        pushHistoryView()
    }
}

extension ListViewController: RepositoryModelDelegate {

    func repositoryDidChange(result: Repository) {
        repo = result
        DispatchQueue.main.async {
            self.totalCountLabel.text = "\(result.totalCount)"
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
        tableView.deselectRow(at: indexPath, animated: true)
        // 画面遷移
        pushDetailView(item: repo.items[indexPath.row])
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
            updateSearchConstraints()
            repo = Repository()
            self.tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}
