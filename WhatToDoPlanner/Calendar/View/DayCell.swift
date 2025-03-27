import UIKit

final class DayCell: UICollectionViewCell {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        static let reuseId = "DayCell"
    }
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Constants.fontName, size: 14)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
        
        contentView.layer.cornerRadius = 28
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with day: CalendarModels.CalendarDay) {
        label.text = day.dayNumber
        
        if day.isSelected {
            contentView.backgroundColor = UIColor(hex: "85B7CA", alpha: 0.56)
            label.textColor = .white
        } else if day.isToday {
            contentView.backgroundColor = UIColor(hex: "D9D9D9")
            label.textColor = .black
        } else {
            contentView.backgroundColor = UIColor(hex: "D9D9D9", alpha: 0.3)
            label.textColor = .black
        }
    }
    
    private func configureLabel() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.pinCenterX(to: contentView.centerXAnchor)
        label.pinCenterY(to: contentView.centerYAnchor)
    }
}
