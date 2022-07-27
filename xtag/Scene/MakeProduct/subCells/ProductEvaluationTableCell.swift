//
//  ProductEvaluationTableCell.swift
//  xtag
//
//  Created by Yoon on 2022/07/11.
//

import UIKit

enum EvaluateState {
    case LIKED
    case DIFFICULT
    case NOTLIKED
}

class ProductEvaluationTableCell: UITableViewCell {

    public static let IDENTIFIER = "ProductEvaluationTableCell"
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var difficultButton: UIButton!
    @IBOutlet weak var notLikedButton: UIButton!
    
    public var selectEvaluation: ((EvaluateState)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likedBtnPressed(_ sender: Any) {
        if selectEvaluation != nil {
            selectEvaluation!(EvaluateState.LIKED)
        }
        
        handleEvaluateButton(state: EvaluateState.LIKED)
        
        
    }
    
    @IBAction func diffiicultBtnPressed(_ sender: Any) {
        if selectEvaluation != nil {
            selectEvaluation!(EvaluateState.DIFFICULT)
        }
        handleEvaluateButton(state: EvaluateState.DIFFICULT)
    }
    
    @IBAction func notLikedBtnPressed(_ sender: Any) {
        if selectEvaluation != nil {
            selectEvaluation!(EvaluateState.NOTLIKED)
        }
        handleEvaluateButton(state: EvaluateState.NOTLIKED)
    }
    
    private func handleEvaluateButton(state: EvaluateState) {
        switch state {
        case .LIKED:
            likeButton.isSelected = true
            difficultButton.isSelected = false
            notLikedButton.isSelected = false
        case .DIFFICULT:
            likeButton.isSelected = false
            difficultButton.isSelected = true
            notLikedButton.isSelected = false
        case .NOTLIKED:
            likeButton.isSelected = false
            difficultButton.isSelected = false
            notLikedButton.isSelected = true
        }
    }
}
