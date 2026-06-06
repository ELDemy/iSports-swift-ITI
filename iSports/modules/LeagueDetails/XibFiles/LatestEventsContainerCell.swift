import UIKit

class LatestEventsContainerCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LatestEventsContainerCell"
    
    private var innerCollectionView: UICollectionView!
    private var events: [LatestEvent] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInnerCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInnerCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 120)
        layout.minimumLineSpacing = 14
        
        innerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        innerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        innerCollectionView.isScrollEnabled = true
        innerCollectionView.backgroundColor = .clear
        innerCollectionView.showsVerticalScrollIndicator = true
        
        // Register your existing xib
        innerCollectionView.register(
            UINib(nibName: "LatestEventCell", bundle: nil),
            forCellWithReuseIdentifier: "LatestEventCell"
        )
        
        innerCollectionView.dataSource = self
        contentView.addSubview(innerCollectionView)
        
        NSLayoutConstraint.activate([
            innerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            innerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            innerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            innerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with events: [LatestEvent]) {
        self.events = events
        innerCollectionView.reloadData()
    }
}

extension LatestEventsContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "LatestEventCell",
            for: indexPath
        ) as! LatestEventCell
        cell.configure(with: events[indexPath.row])
        return cell
    }
}
