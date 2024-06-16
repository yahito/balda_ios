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
    
    private var stackOne: UIStackView?
    private var stackTwo: UIStackView?
    
    var onUserPicChange: () -> Void = {}
    
    @objc private func userViewTapped() {
        onUserPicChange()
    }

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
        
        setupViews()
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
        
        stackOne = UIStackView(arrangedSubviews: [playerOneImageView, playerOneLabel, playerOneScoreLabel])
        stackOne!.axis = .vertical
        stackOne!.alignment = .center
        
        stackTwo = UIStackView(arrangedSubviews: [playerTwoImageView, playerTwoLabel, playerTwoScoreLabel])
        stackTwo!.axis = .vertical
        stackTwo!.alignment = .center
        
        // Add subviews
        addSubviews(playerOneWordsTableView, playerTwoWordsTableView, divider, horizontalLine, verticalLine, stackTwo!, stackOne!)
                
                     
        if playerOneImageView.gestureRecognizers?.count ?? 0 == 0 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userViewTapped))
            tapGesture.numberOfTapsRequired = 2
            playerOneImageView.addGestureRecognizer(tapGesture)
            playerOneImageView.isUserInteractionEnabled = true
        }
        
        // Layout
        layoutViews()
    }
    
    
    private func layoutViews() {
                
        let iconSize = UIScreen.main.bounds.width*0.15
        
        if info != nil {
            var resW = iconSize
            var resH = iconSize
            
            if playerTwoImageView.image != nil {
                resW = playerTwoImageView.image!.size.width
                resH = playerTwoImageView.image!.size.height
            }
            
            playerTwoImageView.image = UIImage(named: info!.opponentInfo2.userPic.rawValue.lowercased())?.resized(to: CGSize(width: resW, height: resH))
            
            playerOneImageView.image = UIImage(named: info!.opponentInfo1.userPic.rawValue.lowercased())?.resized(to: CGSize(width: resW, height: resH))
            
            playerTwoImageView.layer.cornerRadius = playerTwoImageView.image!.size.width / 2.0
            playerOneImageView.layer.cornerRadius = playerOneImageView.image!.size.width / 2.0
        }
        
        NSLayoutConstraint.activate([
                    // First view constraints
            stackOne!.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            stackOne!.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10),
            stackOne!.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
                        
            playerOneWordsTableView.leftAnchor.constraint(equalTo: stackOne!.rightAnchor, constant: 0),
            
            playerOneWordsTableView.trailingAnchor.constraint(equalTo: centerXAnchor),
            playerOneWordsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            playerOneWordsTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            
                        
            stackTwo!.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            stackTwo!.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10),
            stackTwo!.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.2),
                                
            playerTwoWordsTableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            playerTwoWordsTableView.rightAnchor.constraint(equalTo: stackTwo!.leftAnchor, constant: 0),
            playerTwoWordsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            playerTwoWordsTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            
            
            horizontalLine.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0), // Position it 100 points from the top
            horizontalLine.leftAnchor.constraint(equalTo: playerOneWordsTableView.leftAnchor),
            horizontalLine.rightAnchor.constraint(equalTo: playerTwoWordsTableView.rightAnchor),
            horizontalLine.heightAnchor.constraint(equalToConstant: 3),
            
            
            verticalLine.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor), // Position it 100 points from the top
            verticalLine.widthAnchor.constraint(equalToConstant: 3),
            verticalLine.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            verticalLine.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        ])
        
        if (info != nil) {
            if (info?.opponentInfo1.words.count ?? 0 > 0) {
                playerOneWordsTableView.scrollToRow(at: IndexPath.SubSequence(row: info!.opponentInfo1.words.count - 1, section: 0), at: UITableView.ScrollPosition.middle, animated: true)
            }
            
            if (info?.opponentInfo2.words.count ?? 0 > 0) {
                playerTwoWordsTableView.scrollToRow(at: IndexPath.SubSequence(row: info!.opponentInfo2.words.count - 1, section: 0), at: UITableView.ScrollPosition.middle, animated: true)
            }
        }
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
        
        image.layer.borderWidth = 4
        if playerTwoImageView.image != nil {
            image.layer.cornerRadius = playerTwoImageView.image!.size.width / 2.0
        }
        image.layer.masksToBounds = true
        image.layer.borderColor = color!.cgColor
        
        title.textColor = color
        score.textColor = color
    }
    
    private func setOther(_ image: UIImageView, _ title: UILabel, _ score: UILabel) {
                
        image.layer.borderWidth = 3
        image.layer.masksToBounds = true
        if playerTwoImageView.image != nil {
            image.layer.cornerRadius = playerTwoImageView.image!.size.width / 2.0
        }
        image.layer.borderColor = UIColor.clear.cgColor
        
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



