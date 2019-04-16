//
//  SearchCell.swift
//  MapStuff
//
//  Created by mitsuyoshi matsuo on 2019/04/14.
//  Copyright © 2019 mitsuyoshi matsuo. All rights reserved.
//

import UIKit
import MapKit

protocol SearchCellDelegate {
    func distanceFromUser(location: CLLocation) -> CLLocationDistance?
    func getDirections(forMapItem mapItem: MKMapItem)
}


class SearchCell: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: SearchCellDelegate?
    
    var mapItem: MKMapItem? {
        didSet {
            configureCell()
        }
    }
    
    lazy var directionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Go", for: .normal)
        button.backgroundColor = .directionsGreen()
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleGetDirections), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.alpha = 0
        return button
    }()
    
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
        return label
    }()
    
    let locationDistanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
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
        
        addSubview(directionsButton)
        let buttonDimension: CGFloat = 50
        directionsButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: buttonDimension, height: buttonDimension)
        directionsButton.centerY(inView: self)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors

    // 径路取得
    @objc func handleGetDirections() {
        guard let mapItem = self.mapItem else { return }
        delegate?.getDirections(forMapItem: mapItem)
    }

    // MARK: - Helper Functions
    
    // アニメーションボタン
    func animateButtonIn() {
        directionsButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.directionsButton.alpha = 1
            self.directionsButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.directionsButton.transform = .identity
        }
    }
    
    // セルの構成
    func configureCell() {
        locationTitleLabel.text = mapItem?.name
        
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.unitStyle = .abbreviated
        
        guard let mapItemLocation = mapItem?.placemark.location else { return }
        guard let distanceFromUser = delegate?.distanceFromUser(location: mapItemLocation) else { return }
        let distanceAsString = distanceFormatter.string(fromDistance: distanceFromUser)
        locationDistanceLabel.text = distanceAsString
    }

}
