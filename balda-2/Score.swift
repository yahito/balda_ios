//
//  Score.swift
//  balda-2
//
//  Created by Andrey on 28/04/2024.
//

import UIKit
import SwiftUI

class Score: UIView, UITableViewDelegate, UITableViewDataSource {

    
    // Assuming you have defined Info and OpponentInfo classes somewhere in your project
    var info: Info?
    
    private let playerOneImageView = UIImageView()
    private let playerTwoImageView = UIImageView()
    private let playerOneLabel = UILabel()
    private let playerTwoLabel = UILabel()
    private let playerOneScoreLabel = UILabel()
    private let playerTwoScoreLabel = UILabel()
    private let playerOneWordsTableView = UITableView()
    private let playerTwoWordsTableView = UITableView()
    private let divider = UIView()
    private let horizontalLine = UIView()
    private let verticalLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        playerTwoWordsTableView.allowsSelection = false
        playerOneWordsTableView.allowsSelection = false
        playerTwoWordsTableView.backgroundColor = .clear
        playerTwoWordsTableView.backgroundView = nil
        playerTwoWordsTableView.isScrollEnabled = true
        playerTwoWordsTableView.bounces = true
        isUserInteractionEnabled = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setInfo(_ newInfo: Info) {
        playerTwoWordsTableView.backgroundColor = .clear
        playerTwoWordsTableView.backgroundView = nil
        
        self.info = newInfo
        // Update the UI elements with new info
        playerOneLabel.text = newInfo.opponentInfo1.name
        
        playerOneScoreLabel.text = "\(newInfo.opponentInfo1.score)"
        playerOneScoreLabel.font = .systemFont(ofSize: 32)
        
        playerTwoLabel.text = newInfo.opponentInfo2.name
        
        playerTwoScoreLabel.text = "\(newInfo.opponentInfo2.score)"
        playerTwoScoreLabel.font = .systemFont(ofSize: 32)
        playerOneWordsTableView.reloadData()
        playerTwoWordsTableView.reloadData()
    }
    
    private func setupViews() {
        // Configure image views, labels, divider
        
        playerOneWordsTableView.backgroundColor = .clear
        playerTwoWordsTableView.backgroundColor = .clear
        
        horizontalLine.backgroundColor = .darkGray
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false

        verticalLine.backgroundColor = .darkGray
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the table views
        playerOneWordsTableView.delegate = self
        playerOneWordsTableView.dataSource = self
        playerTwoWordsTableView.delegate = self
        playerTwoWordsTableView.dataSource = self
        
        // Register cells
        playerOneWordsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "wordCell")
        playerTwoWordsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "wordCell")
        
        
        
        // Add subviews
        addSubviews(playerOneImageView, playerTwoImageView, playerOneLabel, playerTwoLabel, playerOneScoreLabel, playerTwoScoreLabel, playerOneWordsTableView, playerTwoWordsTableView, divider, horizontalLine, verticalLine)
        
        // Layout
        layoutViews()
    }
    
    private func layoutViews() {

        playerOneImageView.image = UIImage(named: "av_man")
        playerTwoImageView.image = UIImage(named: "av_woman")
        
        
        NSLayoutConstraint.activate([
                    // First view constraints
            playerOneImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            playerOneImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            playerOneImageView.widthAnchor.constraint(equalToConstant: 60),
            playerOneImageView.heightAnchor.constraint(equalToConstant: 60),
            
            playerOneLabel.topAnchor.constraint(equalTo: playerOneImageView.bottomAnchor),
            playerOneLabel.centerXAnchor.constraint(equalTo: playerOneImageView.centerXAnchor),
            
            playerOneScoreLabel.topAnchor.constraint(equalTo: playerOneLabel.bottomAnchor),
            playerOneScoreLabel.centerXAnchor.constraint(equalTo: playerOneImageView.centerXAnchor),
            
            playerOneWordsTableView.leftAnchor.constraint(equalTo: playerOneImageView.rightAnchor),
            playerOneWordsTableView.trailingAnchor.constraint(equalTo: centerXAnchor),
            playerOneWordsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            playerOneWordsTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            
            playerTwoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            playerTwoImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            playerTwoImageView.widthAnchor.constraint(equalToConstant: 60),
            playerTwoImageView.heightAnchor.constraint(equalToConstant: 60),
                    
           
            playerTwoLabel.topAnchor.constraint(equalTo: playerTwoImageView.bottomAnchor),
            playerTwoLabel.centerXAnchor.constraint(equalTo: playerTwoImageView.centerXAnchor),
            
            playerTwoScoreLabel.topAnchor.constraint(equalTo: playerTwoLabel.bottomAnchor),
            playerTwoScoreLabel.centerXAnchor.constraint(equalTo: playerTwoImageView.centerXAnchor),
               
            
            playerTwoWordsTableView.trailingAnchor.constraint(equalTo: playerTwoImageView.leadingAnchor),
            playerTwoWordsTableView.leadingAnchor.constraint(equalTo: playerOneWordsTableView.trailingAnchor),
            playerTwoWordsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            playerTwoWordsTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            
            horizontalLine.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0), // Position it 100 points from the top
            horizontalLine.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            horizontalLine.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            horizontalLine.heightAnchor.constraint(equalToConstant: 3),
            
            
            verticalLine.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor), // Position it 100 points from the top
            verticalLine.widthAnchor.constraint(equalToConstant: 3),
            verticalLine.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            verticalLine.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            

        ])
    }
    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == playerOneWordsTableView {
            return info?.opponentInfo1.words.count ?? 0
        } else if tableView == playerTwoWordsTableView {
            return info?.opponentInfo2.words.count ?? 0
        }
        return 0
    }
    
    private func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        cell.backgroundColor = .clear
        
        let s: String
        if tableView == playerOneWordsTableView {
            s = info!.opponentInfo1.words[indexPath.row]
        } else  {
            s = info!.opponentInfo2.words[indexPath.row]
        }
    
        print(cell)
        cell.textLabel?.text = s
        cell.layer.borderWidth = 0
        cell.textLabel?.textColor = .white
        
        
        
        return cell
    }
    
    func setCurrentTwo() {
        setCurrent(playerTwoImageView, playerTwoLabel, playerTwoScoreLabel)
        setOther(playerOneImageView, playerOneLabel, playerOneScoreLabel)
    }
    
    func setCurrentOne() {
        setOther(playerTwoImageView, playerTwoLabel, playerTwoScoreLabel)
        setCurrent(playerOneImageView, playerOneLabel, playerOneScoreLabel)
    }
    
    private func setCurrent(_ image: UIImageView, _ title: UILabel, _ score: UILabel) {
        
        let color = UIColor(hex: "#DF5386")
        
        image.layer.borderWidth = 5
        image.layer.cornerRadius = playerTwoImageView.image!.size.width / 4.0
        image.layer.masksToBounds = true
        image.layer.borderColor = color!.cgColor
        
        title.textColor = color
        score.textColor = color
        
        
        
    }
    
    private func setOther(_ image: UIImageView, _ title: UILabel, _ score: UILabel) {
        let color = UIColor(hex: "#DF5386")
        
        image.layer.borderWidth = 0
        image.layer.masksToBounds = false
        image.layer.borderColor = .none
        
        title.textColor = .white
        score.textColor = .white
                    
    }
    
    // UITableViewDelegate methods
    // Implement any delegate methods you may need
}



