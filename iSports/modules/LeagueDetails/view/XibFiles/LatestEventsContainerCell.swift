import UIKit

class LatestEventsContainerCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LatestEventsContainerCell"
    
    private var innerCollectionView: UICollectionView!
    private var events: [Event] = []
    
    var onEventTapped: ((Event) -> Void)?
    
    private let emptyView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()
    private let emptyIconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor(named: "accentColor")?.withAlphaComponent(0.4) ?? .systemGray3
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "flag.checkered",
                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .thin))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No results yet"
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = UIColor(named: "SecondaryText") ?? .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInnerCollectionView()
        setupEmptyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmptyView() {
        contentView.backgroundColor    = UIColor(named: "CardBackground")?.withAlphaComponent(0.55)
            ?? UIColor.secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth  = 1
        contentView.layer.borderColor  = UIColor(named: "accentColor")?.withAlphaComponent(0.15).cgColor

        contentView.addSubview(emptyView)
        emptyView.addSubview(emptyIconView)
        emptyView.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            emptyIconView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyIconView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -14),
            emptyIconView.widthAnchor.constraint(equalToConstant: 46),
            emptyIconView.heightAnchor.constraint(equalToConstant: 46),

            emptyLabel.topAnchor.constraint(equalTo: emptyIconView.bottomAnchor, constant: 10),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
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
        
        innerCollectionView.register(
            UINib(nibName: "LatestEventCell", bundle: nil),
            forCellWithReuseIdentifier: "LatestEventCell"
        )
        
        innerCollectionView.dataSource = self
        innerCollectionView.delegate = self
        contentView.addSubview(innerCollectionView)
        
        NSLayoutConstraint.activate([
            innerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            innerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            innerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            innerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with events: [Event]) {
        self.events = events
        emptyView.isHidden      = !events.isEmpty
        innerCollectionView.isHidden = events.isEmpty
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

extension LatestEventsContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        onEventTapped?(event)
    }
}
