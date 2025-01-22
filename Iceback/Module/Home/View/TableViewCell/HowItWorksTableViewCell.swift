//
//  HowItWorksTableViewCell.swift
//  Counos
//
//  Created by Admin on 09/01/24.
//

import UIKit

class HowItWorksTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var constTableViewStepsHeight: NSLayoutConstraint!
    @IBOutlet weak var tblHowItWorksSteps: UITableView!
    
    //MARK: - Constant & Variables
    var arrHowItWorks : [HowItWorksItem] = []
    var tableViewReloadDelegate: TableViewReloadDelegate!
    var navigateToStoreDelegate: NavigateToStoreDelegate!
    var navigateToProjectDetailsDelegate: NavigateToProjectDetailsDelegate!
    var navigateToCashbackDelegate: NavigateToCashbackDelegate!
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        xibRegister()
        tblHowItWorksSteps.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        tblHowItWorksSteps.delegate = self
        tblHowItWorksSteps.dataSource = self
        tblHowItWorksSteps.registerCell(ofType: HowItWorksStepsTableViewCell.self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
    }
    
    //MARK: - Setup Data
    override func setup<T>(_ object: T) {
        
    }
    
    //MARK: - Observe Value TableView Content Size
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if object is UITableView{
                if let newValue = change?[.newKey]{
                    let newSize = newValue as! CGSize
                    constTableViewStepsHeight.constant = newSize.height
                   dPrint("CONTENT SIZE Height: \(newSize.height)")
                    tableViewReloadDelegate.reloadTableView()
                }
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension HowItWorksTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHowItWorks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: HowItWorksStepsTableViewCell.self)
        cell.tag = indexPath.row
        cell.setup(arrHowItWorks[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate
extension HowItWorksTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigateToStoreDelegate.navigateToStore()
        case 1:
            navigateToCashbackDelegate.navigateToCashback()
        case 2:
            navigateToProjectDetailsDelegate.navigateToProjectDetails()
        default:
            break
        }
    }
}
