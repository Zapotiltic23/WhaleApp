//
//  WhaleCell.swift
//  WhaleApp
//
//  Created by Horacio Alexandro Sanchez on 2/6/21.
//

import UIKit

class WhaleCell: UICollectionViewCell, UITextFieldDelegate {
    
    
    let whaleImageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.contentMode = .scaleAspectFit
        
        return imageView
                
    }()
    
    let whalenameLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .yellow
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.clear.cgColor
        label.text = "Placeholder"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.alpha = 1
        return label
                
    }()
    
    lazy var nameTextField : UITextField = {
        
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.delegate = self
        field.placeholder = "Guess whale name??"
        field.textAlignment = .center
        field.returnKeyType = .go
        
        
        
        return field
        
        
    }()
    
    var imageViewHeightAnchor : NSLayoutConstraint?
    var nameLabelHeightAnchor : NSLayoutConstraint?
    var isExpanded : Bool = false

    var whaleNameString : String = ""
    fileprivate var nameLabelHeightAnchor_multiplier : CGFloat = 0.1
    fileprivate var nameLabelFontSize : CGFloat = 18



    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpWhaleViews() //Set up UI....

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Prepare our UI elements when dequeuing a new cell ...
        self.nameTextField.text = nil
        self.whaleImageView.image = nil

    }
    
    func setUpWhaleViews() {
        
        //This method lays-out the views and their constraints everytime there's
        //a device rotation. Views are laid out depending on the state of the
        //app i.e. Cell Expanded (textfield front) || Cell Grid (name label front)
        
        
        //Remove all constraints...
        self.removeConstraints(whalenameLabel.constraints)
        self.removeConstraints(whaleImageView.constraints)
        self.removeConstraints(nameTextField.constraints)

        //Remove views ...
        whalenameLabel.removeFromSuperview()
        whaleImageView.removeFromSuperview()
        nameTextField.removeFromSuperview()
        
        self.backgroundColor = .yellow
        
        //Add views ...
        self.addSubview(whalenameLabel)
        self.addSubview(whaleImageView)
        self.addSubview(nameTextField)

        
        if isExpanded{
            
            //Switch label & textfield positions ...
            self.bringSubviewToFront(nameTextField)
            self.sendSubviewToBack(whalenameLabel)
            nameTextField.alpha = 1
            whalenameLabel.alpha = 0
            
            //Adjust constraints multipliers for device orientation ...
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                nameLabelHeightAnchor_multiplier = 0.15
                nameLabelFontSize = 25
                
            } else {
                print("Portrait")
                nameLabelHeightAnchor_multiplier = 0.1
                nameLabelFontSize = 18

            }
            
        }else{
            
            //Cell Grid ...
            nameTextField.alpha = 0
            whalenameLabel.alpha = 1
            self.bringSubviewToFront(whalenameLabel)
            self.sendSubviewToBack(nameTextField)
            nameLabelHeightAnchor_multiplier = 0.1
            nameLabelFontSize = 18


        }

        //Lay out constraints ...
        whalenameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        whalenameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        whalenameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        whalenameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: nameLabelHeightAnchor_multiplier).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: nameLabelHeightAnchor_multiplier).isActive = true
        
        
        whaleImageView.bottomAnchor.constraint(equalTo: whalenameLabel.topAnchor).isActive = true
        whaleImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        whaleImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        whaleImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: (0.9-nameLabelHeightAnchor_multiplier)).isActive = true
        
        
        self.layoutIfNeeded()
        whaleImageView.layer.cornerRadius = whaleImageView.frame.width / 24
        whalenameLabel.font = UIFont.systemFont(ofSize: nameLabelFontSize)
        



    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //Switch positions again when tapping on textfield to
        //begging editing...
        whalenameLabel.text = whaleNameString
        textField.placeholder = "Guess whale name??"
        self.sendSubviewToBack(whalenameLabel)
        self.bringSubviewToFront(nameTextField)
        nameTextField.alpha = 1
        whalenameLabel.alpha = 0

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        //This method performs a string compare on the name label and the
        //textfield input and shows success || failure...
        
        let inputText = textField.text ?? ""
        
        if inputText == ""{
            
            //Case I: No guess ...
            textField.placeholder = "You did not enter a whale name. Try again!"
            
        }else if inputText == whalenameLabel.text{
            
            //Case II: Correct guess ...
            whalenameLabel.text = "\(inputText) is the correct name! 🥳"
            textField.text = ""
            self.sendSubviewToBack(nameTextField)
            self.bringSubviewToFront(whalenameLabel)
            nameTextField.alpha = 0
            whalenameLabel.alpha = 1

        }else{
            
            //Case III: Incorrect guess ...
            textField.placeholder = "\(inputText) is incorrect! 😳"
            textField.text = ""
            
        }
        
        //Hide keyboard on 'Go' button tap ...
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}//End of WhaleCell()
