//
//  SearchCell.swift
//  MapStuff
//
//  Created by mitsuyoshi matsuo on 2019/04/14.
//  Copyright © 2019 mitsuyoshi matsuo. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPink()
        view.addSubview(locationImageView)
        locationImageView.center(inView: view)
        locationImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locationImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }()
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .mainPink()
        iv.image = #imageLiteral(resourceName: "baseline_location_on_white_24pt_3x")
        return iv
    }()
    
    let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Coffee Shop"
        return label
    }()
    
    let locationDistanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "0.2 ml"
        return label
    }()


    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(imageContainerView)
        let dimension: CGFloat = 40
        imageContainerView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: dimension, height: dimension)
        imageContainerView.layer.cornerRadius = dimension / 2
        imageContainerView.centerY(inView: self)
        
        addSubview(locationTitleLabel)
        locationTitleLabel.anchor(top: imageContainerView.topAnchor, left: imageContainerView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(locationDistanceLabel)
        locationDistanceLabel.anchor(top: nil, left: imageContainerView.rightAnchor, bottom: imageContainerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper Functions



    // MARK: -

}
