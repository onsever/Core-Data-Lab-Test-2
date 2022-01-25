//
//  Game.swift
//  Lab2_OnurcanSever_C0830345_iOS
//
//  Created by Onurcan Sever on 2022-01-24.
//

import Foundation

struct Game {
    
    var turnCounter: Int = 0
    var player1Score: Int = 0
    var player2Score: Int = 0
    
    var currentPlayer: Player = .player1
    var turn: Turn = .cross
    var winner: Winner = .none
    
    enum Player {
        case player1
        case player2
        case none
    }
    
    enum Turn: String {
        case cross = "cross"
        case nought = "nought"
    }
    
    enum Winner {
        case player1
        case player2
        case draw
        case none
    }
    
    private func checkTurn() -> Turn {
        
        if turnCounter % 2 != 0 {
            return .cross
        }
        
        return .nought
    }
    
    mutating func start() {
        
        if checkTurn() == .cross {
            turnCounter += 1
            currentPlayer = .player1
            turn = .nought
        }
        else {
            turnCounter += 1
            currentPlayer = .player2
            turn = .cross
        }
        
                
    }
    
    mutating func end(){
        
        if turnCounter == 9 {
            winner = .draw
            turnCounter = 0
        }
        
    }
    
    mutating func reset() {
        turnCounter = 0
        currentPlayer = .player1
    }
    
    mutating func incrementScore() {
        if winner == .player1 {
            player1Score += 1
        }
        
        if winner == .player2 {
            player2Score += 1
        }
    }
    
        
    func determineTheWinner(cellTitles: [String], turn: Turn) -> Bool {
        
        if cellTitles[0] == turn.rawValue && cellTitles[1] == turn.rawValue && cellTitles[2] == turn.rawValue {
            return true
        }
        
        if cellTitles[3] == turn.rawValue && cellTitles[4] == turn.rawValue && cellTitles[5] == turn.rawValue {
            return true
        }
        
        if cellTitles[6] == turn.rawValue && cellTitles[7] == turn.rawValue && cellTitles[8] == turn.rawValue {
            return true
        }
        
        if cellTitles[0] == turn.rawValue && cellTitles[3] == turn.rawValue && cellTitles[6] == turn.rawValue {
            return true
        }
        
        if cellTitles[1] == turn.rawValue && cellTitles[4] == turn.rawValue && cellTitles[7] == turn.rawValue {
            return true
        }
        
        if cellTitles[2] == turn.rawValue && cellTitles[5] == turn.rawValue && cellTitles[8] == turn.rawValue {
            return true
        }
        
        if cellTitles[0] == turn.rawValue && cellTitles[4] == turn.rawValue && cellTitles[8] == turn.rawValue {
            return true
        }
        
        if cellTitles[2] == turn.rawValue && cellTitles[4] == turn.rawValue && cellTitles[6] == turn.rawValue {
            return true
        }
        
        return false
    }
    
    
    
}
