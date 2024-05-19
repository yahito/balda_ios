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
    
    private func getLabelFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return  UIFont.preferredFont(forTextStyle: .title3);
        } else {
            return UIFont.preferredFont(forTextStyle: .largeTitle);
        }
    }
    
    private func getScoreFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return  UIFont.preferredFont(forTextStyle: .title3);
        } else {
            return UIFont.preferredFont(forTextStyle: .largeTitle);
        }
    }
    
    private func getWordsFont() -> UIFont {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return  UIFont.preferredFont(forTextStyle: .body);
        } else {
            return UIFont.preferredFont(forTextStyle: .title1);
        }
    }
    
    func setInfo(_ newInfo: Info) {
        playerTwoWordsTableView.backgroundColor = .clear
        playerTwoWordsTableView.backgroundView = nil
        
        self.info = newInfo
        // Update the UI elements with new info
        playerOneLabel.text = newInfo.opponentInfo1.name
        playerOneLabel.font = getLabelFont()
        
        playerOneScoreLabel.text = "\(newInfo.opponentInfo1.score)"
        playerOneScoreLabel.font = getScoreFont()
        
        playerTwoLabel.text = newInfo.opponentInfo2.name
        playerTwoLabel.font = getLabelFont()
        
        playerTwoScoreLabel.text = "\(newInfo.opponentInfo2.score)"
        playerTwoScoreLabel.font = getScoreFont()
        
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
        
        let imageLeft = playerOneImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: (UIScreen.main.bounds.width * 0.1));
        imageLeft.priority = .defaultLow
        
        let imageRight = playerTwoImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -(UIScreen.main.bounds.width * 0.1))
        imageRight.priority = .defaultLow
        
        let xxx = playerOneWordsTableView.leftAnchor.constraint(equalTo: playerOneImageView.rightAnchor, constant: 0)
        xxx.priority = .defaultLow
            
        
        let xxx2 = playerTwoWordsTableView.rightAnchor.constraint(equalTo: playerTwoImageView.leftAnchor, constant: 0)
        xxx2.priority = .defaultLow
        
        
        NSLayoutConstraint.activate([
                    // First view constraints
            playerOneImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            imageLeft,
            
            playerOneImageView.widthAnchor.constraint(equalToConstant: 60),
            playerOneImageView.heightAnchor.constraint(equalToConstant: 60),
            
            playerOneLabel.topAnchor.constraint(equalTo: playerOneImageView.bottomAnchor),
            playerOneLabel.centerXAnchor.constraint(equalTo: playerOneImageView.centerXAnchor),
            playerOneLabel.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
            
            playerOneScoreLabel.topAnchor.constraint(equalTo: playerOneLabel.bottomAnchor),
            playerOneScoreLabel.centerXAnchor.constraint(equalTo: playerOneImageView.centerXAnchor),
                        
            xxx,
            playerOneWordsTableView.leftAnchor.constraint(greaterThanOrEqualTo: playerOneImageView.rightAnchor, constant: 10),
            playerOneWordsTableView.leftAnchor.constraint(greaterThanOrEqualTo: playerOneLabel.rightAnchor, constant: 10),
            
            playerOneWordsTableView.trailingAnchor.constraint(equalTo: centerXAnchor),
            playerOneWordsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            playerOneWordsTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            
            
            playerTwoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            imageRight,
            playerTwoImageView.widthAnchor.constraint(equalToConstant: 60),
            playerTwoImageView.heightAnchor.constraint(equalToConstant: 60),
                    
           
            playerTwoLabel.topAnchor.constraint(equalTo: playerTwoImageView.bottomAnchor),
            playerTwoLabel.centerXAnchor.constraint(equalTo: playerTwoImageView.centerXAnchor),
            playerTwoLabel.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            playerTwoScoreLabel.topAnchor.constraint(equalTo: playerTwoLabel.bottomAnchor),
            playerTwoScoreLabel.centerXAnchor.constraint(equalTo: playerTwoImageView.centerXAnchor),
               
            
            xxx2,
            playerTwoWordsTableView.rightAnchor.constraint(lessThanOrEqualTo: playerTwoImageView.rightAnchor, constant: 10),
            playerTwoWordsTableView.rightAnchor.constraint(lessThanOrEqualTo: playerTwoLabel.rightAnchor, constant: 10),
            
            playerTwoWordsTableView.trailingAnchor.constraint(equalTo: playerTwoImageView.leadingAnchor),
            playerTwoWordsTableView.leadingAnchor.constraint(equalTo: playerOneWordsTableView.trailingAnchor),
            playerTwoWordsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            playerTwoWordsTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            playerTwoWordsTableView.widthAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
            
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        cell.backgroundColor = .clear
        
        let s: String
        if tableView == playerOneWordsTableView {
            s = info!.opponentInfo1.words[indexPath.row]
        } else  {
            s = info!.opponentInfo2.words[indexPath.row]
        }
            
        cell.textLabel?.text = s
        cell.layer.borderWidth = 0
        //cell.textLabel?.textColor = .white
        
        if (tableView == sel && selId == indexPath.row) {
            cell = UITableViewCell()
            cell.textLabel?.text = s
            cell.layer.borderWidth = 0
            cell.backgroundColor = .clear
            let color = UIColor(hex: "#DF5386")
            cell.textLabel?.textColor = color
            
            let preferredFont =  getWordsFont()
            let fontDescriptor = preferredFont.fontDescriptor.withSymbolicTraits(.traitBold)
            
            cell.textLabel?.font = UIFont(descriptor: fontDescriptor!, size: preferredFont.pointSize)
            
            UIView.animate(withDuration: 0.5,
                                  delay: 0,
                                  options: [.repeat, .autoreverse, .allowUserInteraction],
                                  animations: { [weak cell] in
                cell!.textLabel?.alpha = 0
                                  }, completion: nil)
               
            
        } else {
            cell.textLabel?.textColor = .white
            cell.textLabel?.font =  getWordsFont()
            cell.textLabel?.alpha = 100
        }
        
    
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
    
    func highlightWord(_ word: String) {
        highlightWord(word, info!.opponentInfo1, playerOneWordsTableView)
        highlightWord(word, info!.opponentInfo2, playerTwoWordsTableView)
    }
    
    var sel: UITableView? = nil
    var selId: Int = -1
    
    func highlightWord(_ word: String, _ info : OpponentInfo, _ v: UITableView) {
        var w1 = info.words.firstIndex { $0 == word }
        if (w1 != nil) {
            v.scrollToRow(at: IndexPath.SubSequence(row: w1!, section: 0), at: UITableView.ScrollPosition.middle, animated: true)
            sel = v
            selId = w1!
            v.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.sel = nil
                self.selId = 1
                v.reloadData()
            }
        }
        
       
    }
    
 
    // UITableViewDelegate methods
    // Implement any delegate methods you may need
}



