import UIKit

protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionView {
    func dequeueReusableCell<Cell: ReusableCell>(for indexPath: IndexPath) -> Cell? {
        return self.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell
    }
    
    func registerCellClass<Cell: ReusableCell>(_ cellType: Cell.Type) {
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}
