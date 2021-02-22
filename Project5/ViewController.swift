//
//  ViewController.swift
//  Project5
//
//  Created by Frank Solleveld on 22/02/2021.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: Custom Variables
    var allWords = [String]()
    var usedWords = [String]()

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["bench"]
        }
        startGame()
    }
    
    // MARK: Custom Methods
    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    // MARK: Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}

