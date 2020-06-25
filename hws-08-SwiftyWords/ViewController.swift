//
//  ViewController.swift
//  hws-08-SwiftyWords
//
//  Created by Philip Hayes on 6/25/20.
//  Copyright © 2020 PhilipHayes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var level = 1
    
    override func loadView() {
        // Create empty main view with parent class of all UIKit view types: labels, buttons, progress views, etc
        view = UIView()
        view.backgroundColor = .white
        
        // Create "score label"
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        // Create "clues label"
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        // Create "answers label"
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        // Create "current answer" text field
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // Create "submit" button
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        
        // Connect the "submit" button to code
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        // Create "clear" button
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        
        // Connect "clear" button to code
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        // Create a container for letter buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // Add a thin gray border around the letter button container
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Activate array of multiple constraints simultaneously
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // Pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            // Pin the leading edge of the clues label to the leading edge of the layout margins plue 100 points.
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            
            // Make the clues label 60% of the width of the layout margins minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            // Pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            // Pin the answers label to the trailing edge of the layout margins minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            
            // Fit the answers label to 40% of available space minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            // Make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            // Center the current answer text field below the clues label
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            // Position the current answer and clear buttons
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            // Position the letter buttons container
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])
        
        // Set width and height for letter buttons
        let width = 150
        let height = 80
        
        // Create 20 buttons in a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // Create a button and set the font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                // Display temporary text in button to make it visible
                letterButton.setTitle("WWW", for: .normal)
                
                // Calculate the button frame based on row and column
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // Add button to buttons view
                buttonsView.addSubview(letterButton)
                
                // Add button to letterButtons array
                letterButtons.append(letterButton)
                
                // Connect letter buttons to code
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
        
        
//        cluesLabel.backgroundColor = .gray
//        answersLabel.backgroundColor = .lightGray
//        buttonsView.backgroundColor = .yellow
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadLevel()
    }
    
    // MARK: Data Load Method
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        // Configure buttons and labels
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        // Add 1 to level
        level += 1
        
        // Remove all items from the solutions array
        solutions.removeAll(keepingCapacity: true)
        
        // Call loadLevel to load and show the new level
        loadLevel()
        
        // Ensure all letter buttons are visible
        for btn in letterButtons { btn.isHidden = false }
    }
    
    // MARK: - Button Methods
    
    @objc func letterTapped(_ sender: UIButton) {
        // Safety check
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        // Append button title to player's current answer
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        
        // Append button to activated buttons array
        activatedButtons.append(sender)
        
        // Hide button that was tapped
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        // Unwrap the current answer text
        guard let answerText = currentAnswer.text else { return }
        
        // Search for a clue string that matches the submitted answer
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            // Split answer label text up with line breaks
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            
            // Replace the line at the solution position with the solution
            splitAnswers?[solutionPosition] = answerText
            
            // Join answer label back together
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            // If score divides evenly by 7, all seven words have been found
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well Done", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
        else {
            // Notify user if no match is found
            let ac = UIAlertController(title: "Doh!!!", message: "That hurt...", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        // Remove text from the current answer text field
        currentAnswer.text = ""
        
        // Unhide activated buttons
        for btn in activatedButtons {
            btn.isHidden = false
        }
        
        // Clear activated buttons array
        activatedButtons.removeAll()
    }
    


}

