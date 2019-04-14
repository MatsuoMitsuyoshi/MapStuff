//
//  SearchInputView.swift
//  MapStuff
//
//  Created by mitsuyoshi matsuo on 2019/04/14.
//  Copyright © 2019 mitsuyoshi matsuo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchInputView: UIView {
    
    
    // MARK: - Properties
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.alpha = 0.8
        return view
    }()



    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
            configureViewComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    // Viewの構成要素
    func configureViewComponents() {
        backgroundColor = .white
        
        addSubview(indicatorView)
        indicatorView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 8)
        indicatorView.centerX(inView: self)
        
        configureSearchBar()
        configureTableView()
    }
    
    // SearchBarの構成
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for a place or address"
//        searchBar.delegate = self
        searchBar.barStyle = .black
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        addSubview(searchBar)
        searchBar.anchor(top: indicatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 50)
    }
    
    // TableViewの構成
    func configureTableView() {
        tableView = UITableView()
        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdentifier)

        addSubview(tableView)
        tableView.anchor(top: searchBar.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
    }
    
}

// MARK: - UITableViewDataSource/Delegate

extension SearchInputView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        return cell
    }
    
}
