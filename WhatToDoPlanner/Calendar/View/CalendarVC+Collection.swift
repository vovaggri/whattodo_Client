import UIKit

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tasksCollectionView {
            return tasks.count
        } else {
            return weeks.count * 7
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tasksCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.Constants.identifier, for: indexPath) as? TaskCell else {
                return UICollectionViewCell()
            }
            let task = tasks[indexPath.item]
            cell.configure(with: task)
            cell.delegate = self
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.Constants.reuseId, for: indexPath) as? DayCell else {
            return UICollectionViewCell()
        }
        let weekIndex = indexPath.item / 7
        let dayIndex = indexPath.item % 7
        let day = weeks[weekIndex][dayIndex]
        cell.configure(with: day)
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Cells for tasks
        if collectionView == tasksCollectionView {
            let width: CGFloat = 351
            let height: CGFloat = 104
           
            return CGSize(width: width, height: height)
        }
        
        // Cells for calendar
        let spacing: CGFloat = 1.2
        let daysCount: CGFloat = 7
        // общее пространство занятое отступами между ячейками
        let totalSpacing = spacing * (daysCount - 1)
        // доступная ширина под все ячейки
        let usableWidth = collectionView.bounds.width - totalSpacing
        // ширина одной ячейки
        let cellWidth = floor(usableWidth / daysCount)
        // высота = высота коллекции (например, 68)
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weekIndex = indexPath.item / 7
        let dayIndex = indexPath.item % 7
        let day = weeks[weekIndex][dayIndex]
            
        // Обновляем выбранную дату
        selectedDate = day.date
        collectionView.reloadData()
            
        // Сообщаем интеректору выбранную дату
        interactor?.didSelectDay(day.date)
        interactor?.filterTasks(for: selectedDate, allItems: allTasks, selectedItems: &tasks)
        tasksCollectionView.reloadData()
    }
}
