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

    // MARK: Private Properties
    private let repoModel = RepositoryModel()
    private let parPage = 30
    private var items = [Item]()
    private var totalCount = 0

    private var qWord = ""
    private var page = 1
    private var isLoading = false

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
   }

    // MARK: Private Methods
    private func initView() {
        repoModel.delegate = self

        indicatorView.isHidden = true
        setSearchBar("")
        totalCountLabel.text = "-"

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
     }

    private func setSearchBar(_ text: String) {
        searchBar.text = text
        searchWidthConstraint.isActive = (searchBar.text != "")
        searchWidthFullConstraint.isActive = (searchBar.text == "")
    }

    private func requestRepository(word: String) {
        indicatorView.isHidden = false
        indicator.startAnimating()
        totalCountLabel.text = "-"
        qWord = word
        page = 1
        repoModel.request(word: qWord, parPage: parPage)
    }

    private func addRepository() {
        tableView.reloadData()
        if totalCount > page * parPage {
            page += 1
            repoModel.request(word: qWord, parPage: parPage, page: page)
        }
    }

    private func pushDetailView(item: Item) {
        if let detail = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detail.item = item
            navigationController?.pushViewController(detail, animated: true)
        }
    }

    private func pushHistoryView() {
        if let history = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController {
            history.word = searchBar.text
            history.delegate = self
            navigationController?.pushViewController(history, animated: true)
        }
    }

    // MARK: IBAction
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        pushHistoryView()
    }
}

extension ListViewController: RepositoryModelDelegate {

    func repositoryDidSuccess(result: Repository) {
        isLoading = false
        if page == 1 {
            totalCount = result.totalCount
            items = result.items

            DispatchQueue.main.async {
                self.totalCountLabel.text = "\(self.totalCount)"
                // スクロール位置を戻す
                self.tableView.setContentOffset(.zero, animated: false)
                self.tableView.layoutIfNeeded()
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
            }
        } else {
            items.append(contentsOf: result.items)

            DispatchQueue.main.async {
                self.totalCountLabel.text = "\(self.totalCount)"
                self.tableView.reloadData()
            }
        }
    }

    func repositoryDidError() {
        isLoading = false
        page -= 1
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.indicatorView.isHidden = true
        }
    }
}

extension ListViewController: HistoryViewControllerDelegate {

    func didSelected(word: String) {
        if word != searchBar.text {
            requestRepository(word: word)
            setSearchBar(word)
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading && totalCount > items.count {
            return items.count + 1
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > items.count - 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell {
                cell.start()
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell {
            let item = items[indexPath.row]
            cell.configure(item)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 画面遷移
        pushDetailView(item: items[indexPath.row])
    }
}

extension ListViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            setSearchBar("")
            items = [Item]()
            totalCount = 0
            totalCountLabel.text = "\(totalCount)"
            tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}

extension ListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = tableView.contentOffset.y
        let frameH = tableView.frame.size.height
        let contentH = tableView.contentSize.height
        // 一番下までスクロール（バッファは要調整）
        if offset + frameH > contentH - 100.0 && !isLoading {
            isLoading = true
            print("addRepository")
            addRepository()
        }
    }
}
