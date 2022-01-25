//
//  ViewController.swift
//  Lab2_OnurcanSever_C0830345_iOS
//
//  Created by Onurcan Sever on 2022-01-24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    
    @IBOutlet weak var cell1: UIButton!
    @IBOutlet weak var cell2: UIButton!
    @IBOutlet weak var cell3: UIButton!
    @IBOutlet weak var cell4: UIButton!
    @IBOutlet weak var cell5: UIButton!
    @IBOutlet weak var cell6: UIButton!
    @IBOutlet weak var cell7: UIButton!
    @IBOutlet weak var cell8: UIButton!
    @IBOutlet weak var cell9: UIButton!

    private var game = Game()
    private lazy var cells: [UIButton] = [cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9]
    private var selectedCell: UIButton?
    private var selectedCellArray = [Cell]()
    private var board = [Board]()
    
    private var images = [Image]()

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeToReset()
        
        loadData()
        
        //loadImages()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if event?.subtype == .motionShake {
            selectedCell?.setImage(nil, for: .normal)
            selectedCell?.setTitle("", for: .normal)
            selectedCell?.isEnabled = true
            game.start()
            
            
            if game.currentPlayer == .player1 {
                playerLabel.text = "Player 1's Turn"
                playerLabel.textColor = .systemGreen
            }
            else {
                playerLabel.text = "Player 2's Turn"
                playerLabel.textColor = .systemRed
            }
            
        }
    }
    
    @IBAction func gameBoardPressed(_ sender: UIButton) {
        
        selectedCell = sender
              
        let newImage = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as! Image
        
        let newCell = Cell(context: context)
        newCell.button = Int64(sender.tag)
        selectedCellArray.append(newCell)
                
        if game.winner == .none {
            game.start()
            if (sender.image(for: .normal) == nil) {
                if (game.currentPlayer == .player1) {
                    playerLabel.text = "Player 1's Turn"
                    playerLabel.textColor = .systemGreen
                    
                    sender.setTitle(game.turn.rawValue, for: .normal)
                    sender.imageView?.alpha = 0
        
                                        
                    UIView.animate(withDuration: 1.2) {
                        sender.imageView?.alpha = 1
                        sender.setImage(UIImage(named: self.game.turn.rawValue), for: .normal)
                                                
                    }
                    
                                        
                }
                else if (sender.image(for: .normal)) == nil {
                    if (game.currentPlayer == .player2) {
                        playerLabel.text = "Player 2's Turn"
                        playerLabel.textColor = .systemRed
                        
                        let x = sender.frame.origin.x
                        let y = sender.frame.origin.y
                        
                        let height = sender.frame.size.height
                        let width = sender.frame.size.width
                        
                        sender.setTitle(game.turn.rawValue, for: .normal)
                        sender.imageView?.frame = CGRect(x: x, y: y, width: 0, height: 0)
                        
                            UIView.animate(withDuration: 1.2) {
                            sender.setImage(UIImage(named: self.game.turn.rawValue), for: .normal)
                            sender.imageView?.frame = CGRect(x: x, y: y, width: width, height: height)
                        }
                        
                    }
                }
                sender.isEnabled = false
            }
        }
        
        let png = sender.image(for: .normal)?.pngData()
        newImage.image = png
        
        saveData()
        
        if isDraw() {
            game.end()
            playerLabel.text = "Draw!"
            return
        }
        
        if game.determineTheWinner(cellTitles: getCellTitles(), turn: Game.Turn.cross) {
            game.winner = .player1
            
            if !sender.isEnabled {
                game.incrementScore()
            }

            player1ScoreLabel.text = "Player 1: \(game.player1Score)"
            playerLabel.text = "Player 1 (Cross) has won!"
            playerLabel.textColor = .systemGreen
        
        }
                
        if game.determineTheWinner(cellTitles: getCellTitles(), turn: Game.Turn.nought) {
            game.winner = .player2
            
            if !sender.isEnabled {
                game.incrementScore()
                
            }
            
            player2ScoreLabel.text = "Player 2: \(game.player2Score)"
            playerLabel.text = "Player 2 (Nought) has won!"
            playerLabel.textColor = .systemRed
        
        }
  
    }
    
    private func getCellTitles() -> [String] {
        var cellTitles: [String] = [String]()
        
        for cell in cells {
            cellTitles.append(cell.title(for: .normal)!)
        }
        
        return cellTitles
    }
    
    
    private func swipeToReset() {
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRecognized(_:)))
        gesture.direction = .left
        view.isUserInteractionEnabled = true
        
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc private func swipeRecognized(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            for cell in cells {
                cell.setImage(nil, for: .normal)
                cell.setTitle("", for: .normal)
                cell.isEnabled = true
            }
            game.reset()
            game.winner = .none
            playerLabel.text = ""
            
            for image in images {
                context.delete(image)
            }
            
            images.removeAll()
        }
        
    }
    
    private func isDraw() -> Bool {
        for cell in cells {
            if cell.image(for: .normal) == nil {
                return false
            }
        }
        
        return true
    }
    
    private func saveData() {
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func loadData() {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        
        do {
            self.images = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    private func loadCells() {
        let request: NSFetchRequest<Cell> = Cell.fetchRequest()
        
        do {
            self.selectedCellArray = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadImages() {
        
        loadData()
        loadCells()
        
        for i in 0..<cells.count {
            if cells[i].tag == selectedCellArray[i].button {
                cells[i].setImage(UIImage(data: images[i].image!), for: .normal)
            }
            else {
                cells[i].setImage(nil, for: .normal)
            }
        }
        
        
        
    }
    
    
}
