//
//  ViewController.swift
//  WhaleApp
//
//  Created by Horacio Alexandro Sanchez on 2/6/21.
//

import UIKit

class WhaleCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate var hasCellExpanded : Bool = false
    fileprivate var keyboardDidAppear = false
    fileprivate var cellSize : CGSize = .zero
    fileprivate var selectedCell_index : Int = 0
    fileprivate var offsetBeforeReload : CGPoint = .zero
    fileprivate let cell_ID : String = "whale_ID"
    fileprivate var dataSourceModels = [Whale]()
    fileprivate let allWhalesURLs = WhaleURLs.allCases.compactMap({$0.rawValue})
    fileprivate let colorpalette : [UIColor] = [.systemGreen, .systemOrange, .systemRed, .systemPurple, .systemGreen, .systemOrange, .systemRed, .systemPurple]
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask{
            return .all
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setUpCollectionView()
        fetchSomeWhales()
        
    }//End of viewDidLoad()
    
    
    fileprivate func fetchSomeWhales(){
        
        
        //Iterate through the array of URL strings ...
        for whaleURL_string in allWhalesURLs{
            
            //Fetch whale image w/ current URL via the manager singleton ....
            NetworkManager.shared.fetchWhales(urlString: whaleURL_string, completion: { [weak self] (whaleImage, name) in
                
                //Unwrap self ...
                guard self == self else {return}
                
                //Whale model objec ...
                let whale = Whale(name: name, image: whaleImage)
                
                //Append to array of models & reload ...
                self?.dataSourceModels.append(whale)
                self?.collectionView.reloadData()
                
            })//End of fetchWales()
            
        }//End of loop
        
    }//End od fetchSomeWhales()
    
    
    
    fileprivate func setUpCollectionView(){
        
        //Let's override the collectionview's constarints ...
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //Customize the collectionview ...
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(WhaleCell.self, forCellWithReuseIdentifier: cell_ID)
        self.collectionView.layer.borderWidth = 4
        self.collectionView.layer.borderColor = UIColor.clear.cgColor
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        
        //Set new constraints to include a safe layout guide constraint on top ...
        self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        

        
    }//End of setUpCollectionView()
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if hasCellExpanded{
            return 1
        }else{
            return dataSourceModels.count
        }

    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_ID, for: indexPath) as! WhaleCell
        
        if hasCellExpanded{
            
            //Set up full screen cell for the selected whale ...
            cell.isExpanded = hasCellExpanded
            cell.setUpWhaleViews()
            self.view.backgroundColor = colorpalette[selectedCell_index]
            cell.backgroundColor = colorpalette[selectedCell_index]
            cell.whaleImageView.image = dataSourceModels[selectedCell_index].image
            cell.whalenameLabel.text = dataSourceModels[selectedCell_index].name
            cell.whalenameLabel.backgroundColor = colorpalette[selectedCell_index]
            cell.whaleNameString = dataSourceModels[selectedCell_index].name
            
        }else{
            
            //Set up all whales ...
            cell.isExpanded = hasCellExpanded
            cell.backgroundColor = colorpalette[indexPath.item]
            self.view.backgroundColor = .white
            cell.whaleImageView.image = dataSourceModels[indexPath.item].image
            cell.whalenameLabel.text = dataSourceModels[indexPath.item].name
            cell.whalenameLabel.backgroundColor = colorpalette[indexPath.item]
            
        }
        
        return cell
        
        
    }//End of cellForItemAt()
    
    func calculateCellSize() -> CGSize{
        
        //Calculate initial cell size ...
        let cellsPerRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumLineSpacing * CGFloat(cellsPerRow - 1))
        let w = Int((collectionView.bounds.width - spacing + 10) / CGFloat(cellsPerRow))
        let h = Int((collectionView.bounds.height - spacing) / CGFloat(cellsPerRow))
        
        return CGSize(width: w, height: h)
        
    }//End of calculateCellSize()
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if hasCellExpanded{
            
            //Calculate cell size when on full screen ...
            let h : CGFloat = self.collectionView.bounds.size.height
            let w : CGFloat = self.collectionView.bounds.size.width
            
            cellSize = CGSize(width: w, height: h)
            return cellSize
                        
        }else{
            
            //Calculate initial cell size ...
            cellSize = calculateCellSize()
            return cellSize

        }
        
        
    }//End of sizeForItemAt()
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if hasCellExpanded{
            
            if keyboardDidAppear{
                
                if let cell = collectionView.cellForItem(at: indexPath) as? WhaleCell{
                    cell.nameTextField.resignFirstResponder()
                    self.keyboardDidAppear = false
                    return
                }
                
            }
            
            
            //Contract the cell back to its place & reload...
            hasCellExpanded = false
            collectionView.reloadData()
            collectionView.performBatchUpdates({

            }, completion: { _ in
                self.collectionView.setContentOffset(self.offsetBeforeReload, animated: false)
                self.collectionView.isScrollEnabled = true
            })
            
        }else{
            
            //Expand the cell to full screen & reload...

            let expandedSize = CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
            selectedCell_index = indexPath.item
            hasCellExpanded = true
            cellSize = expandedSize
            offsetBeforeReload = collectionView.contentOffset
            collectionView.isScrollEnabled = false

            collectionView.reloadData()
            
        }
        
        
    }//End of didSelectItemAt()
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Have the collection view re-layout its cells.
        coordinator.animate(
            alongsideTransition: { _ in
                
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
                
            },
            completion: { _ in }
        )
        
    }//End of viewWillTransition()
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if !keyboardDidAppear{
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                let keyboard_height : CGFloat = keyboardSize.height
                let scrollPoint = CGPoint(x: 0, y: keyboard_height)
                self.collectionView.setContentOffset(scrollPoint, animated: true)
                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboard_height, right: 0)
                
                
            }
            
            keyboardDidAppear = true
            
        }
        
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        if keyboardDidAppear {
            
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            keyboardDidAppear = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    

}

