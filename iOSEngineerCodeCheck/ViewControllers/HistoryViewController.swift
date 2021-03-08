//
//  HistoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田奈津代 on 2021/03/07.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol HistoryViewControllerDelegate: class {
    func didSelected(word: String)
}

class HistoryViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Public Properties
    var word: String?
    weak var delegate: HistoryViewControllerDelegate?

    // MARK: Private Properties
    private var words = [String]()
    private var userDefaults = UserDefaults.standard
    private let key = "words"

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadWords()
        searchBar.becomeFirstResponder()
        searchBar.text = word
    }

    // MARK: Private Methods
    private func loadWords() {
        // userDefaultsに保存された値の取得
        words = userDefaults.array(forKey: key) as? [String] ?? [String]()
    }

    private func removeWords() {
        userDefaults.removeObject(forKey: key)
        loadWords()
    }

    private func saveWords() {
        userDefaults.set(words, forKey: key)
    }

    private func dismiss(word: String?) {
        if let word = word {
            delegate?.didSelected(word: word)
        }
        navigationController?.popViewController(animated: true)
    }

    // MARK: IBAction
    @IBAction func didTapClearButton(_ sender: UIButton) {
        removeWords()
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell {
            let word = words[indexPath.row]
            cell.configure(word)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(word: words[indexPath.row])
    }
}

extension HistoryViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let word = searchBar.text, word.count != 0 {
            if word != words.first {
                // 1番めに追加
                words.insert(word, at: 0)
                saveWords()
            }
            dismiss(word: word)
        }
    }
}
