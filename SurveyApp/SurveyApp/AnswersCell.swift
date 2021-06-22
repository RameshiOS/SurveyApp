//
//  AnswersCell.swift
//  SurveyApp
//
//  Created by Ramesh Guddala on 15/06/21.
//

import UIKit

class AnswersCell: UITableViewCell {

    let radioImage = UIImageView()
    let answerLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
   
        
        
    }

    func setUpView(){
        radioImage.image = UIImage.init(systemName: "circle")
        radioImage.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(radioImage)
        contentView.addSubview(answerLabel)
        
        NSLayoutConstraint.activate([
        
        
            radioImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            radioImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            radioImage.widthAnchor.constraint(equalToConstant: 30),
            radioImage.heightAnchor.constraint(equalToConstant: 30),
            
            answerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            answerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50),
            answerLabel.heightAnchor.constraint(equalToConstant: 30)
        
        
        ])

        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setUpView()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
