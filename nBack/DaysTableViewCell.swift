
import UIKit

class DaysTableViewCell: UITableViewCell {
    
    let dateLabel: Label
    let countLabel: Label
    
    let stackView: StackView
    
    init() {
        dateLabel = Label()
        countLabel = Label()
        countLabel.textAlignment = .right
        
        stackView = StackView(arrangedSubviews: [dateLabel,countLabel], axis: .horizontal, spacing: 5, distribution: .fillEqually)
        
        super.init(style: .default, reuseIdentifier: "cell")
        
        contentView.addSubview(stackView)
        setupConstraints()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        dateLabel = Label()
        countLabel = Label()
        countLabel.textAlignment = .right
        
        stackView = StackView(arrangedSubviews: [dateLabel,countLabel], axis: .horizontal, spacing: 5, distribution: .fillEqually)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor))
        constraints.append(stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor))
        constraints.append(stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DaysTableViewCell: ConfigurableCell {
    func configure(for object: Day) {
        dateLabel.text = Lets.cellLabelDateFormatter.string(from: object.date)
        countLabel.text = "\(object.results.count)"
    }
}


class Label: UILabel {
    init() {
        super.init(frame: CGRect())
        font = Theme.Fonts.label.font
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
