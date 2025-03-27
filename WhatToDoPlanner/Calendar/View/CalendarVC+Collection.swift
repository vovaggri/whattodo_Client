import UIKit

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeks.count * 7
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.Constants.reuseId, for: indexPath) as? DayCell else {
            return UICollectionViewCell()
        }
        
        // Which week
        let weekIndex = indexPath.item / 7
        // Which day in a week (0..6)
        let dayIndex = indexPath.item % 7
        
        let day = weeks[weekIndex][dayIndex]
        cell.configure(with: day)
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Каждый «экран» (страница) содержит ровно 7 ячеек по горизонтали
        // Ширина = ширина collectionView / 7
        // Высота = высота collectionView (например, 80)
        let width = collectionView.frame.width / 7
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weekIndex = indexPath.item / 7
        let dayIndex = indexPath.item % 7
        let day = weeks[weekIndex][dayIndex]
        interactor?.didSelectDay(day.date)
    }
}
