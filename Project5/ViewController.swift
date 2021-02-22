//
//  ViewController.swift
//  Project5
//
//  Created by Frank Solleveld on 22/02/2021.
//

/*
 BONUS: Fix the uppercase and lowercase bug.
 */

import UIKit

class ViewController: UITableViewController {
    
    // MARK: Custom Variables
    var allWords = [String]()
    var usedWords = [String]()

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
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
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    if lowerAnswer.count <= 3 {
                        showErrorMessage("short")
                    } else {
                        showErrorMessage("isReal")
                    }
                }
            } else {
                if lowerAnswer == title?.lowercased() {
                    showErrorMessage("title")
                } else {
                    showErrorMessage("isOriginal")
                }
            }
        } else {
            showErrorMessage("isPossible")
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        guard word != title?.lowercased() else { return false }
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        guard word.count > 3 else { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(_ type: String){
        let errorTitle: String
        let errorMessage: String
        guard let title = title else { return }
        switch type {
        case "isReal":
            errorTitle = "Word not recognized."
            errorMessage = "You cannot just create a word."
        case "isOriginal":
            errorTitle = "Word already used."
            errorMessage = "Be more original."
        case "isPossible":
            errorTitle = "Word not possible."
            errorMessage = "You can't spell that word from \(title.lowercased())."
        case "short":
            errorTitle = "Word too short."
            errorMessage = "Your word must be more than three characters long."
        case "title":
            errorTitle = "Title word."
            errorMessage = "Entering the title word is not accepted."
        default:
            errorTitle = "Unknown error occurred."
            errorMessage = "An unknown error has occured."
        }
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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

