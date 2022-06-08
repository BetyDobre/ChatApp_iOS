import UIKit

class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()

    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userNameLabel.frame = CGRect(x: 20,
                                     y: 10,
                                     width: 150,
                                     height: (contentView.heigth-20)/2)

        userMessageLabel.frame = CGRect(x: 20,
                                        y: userNameLabel.bottom + 10,
                                        width: contentView.width,
                                        height: (contentView.heigth-20)/2)

    }

    public func configure(with model: Comment) {
        userMessageLabel.text = model.body
        userNameLabel.text = model.name
    }

}
