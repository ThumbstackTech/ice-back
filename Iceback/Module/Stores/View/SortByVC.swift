//
//  SortByVC.swift
//  Iceback
//
//  Created by Admin on 12/01/24.
//

import UIKit

class SortByVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tblSortBy: UITableView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblSortByTitle: UILabel!
    
    //MARK: - Constant & Variables
    var arrSortBy = ARRAY.SORTBY
    var previousIndex = Int()
    var sortByDelegate: SortByDelegate!
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        xibRegister()
    }
    
    override func viewDidLayoutSubviews() {
        GCDMainThread.async { [self] in
            viewBackground.roundCorners(corners: [.topLeft, .topRight], radius: 40)
            btnClose.circleCorner = true
        }
    }
    
    //MARK: - Setup Controller
    func setupController() {
        navigationItem.hidesBackButton = true
        
        arrSortBy[previousIndex].isSelect = true
        lblSortByTitle.text = lblSortByTitle.text?.localized()
    }
    
    //MARK: - XIB Register
    func xibRegister() {
        tblSortBy.delegate = self
        tblSortBy.dataSource = self
        tblSortBy.registerCell(ofType: SortByTableViewCell.self)
    }
    
}

//MARK: - Button Extension
extension SortByVC {
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}

//MARK: - UITableViewDataSource
extension SortByVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSortBy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: SortByTableViewCell.self)
        cell.setup(arrSortBy[indexPath.row])
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension SortByVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false) { [self] in
            sortByDelegate.sortBy(sort: arrSortBy[indexPath.row].title.localized(), intPrevius: indexPath.row)
        }
    }
}
