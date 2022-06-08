import UIKit

class SingleCommentViewController: UIViewController {
    
    private let emailLabel: UILabel = {
        let field = UILabel()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.font = .italicSystemFont(ofSize: 20)
        return field
    }()
    private let nameLabel: UILabel = {
        let field = UILabel()
        field.font = .boldSystemFont(ofSize: 25)
        return field
    }()
    private let commentLabel: UILabel = {
        let field = UILabel()
        return field
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "comment")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var id : Int!
    var comment: [Comment] = []
    
    init(with id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(commentLabel)
        view.addSubview(imageView)
        getComment(id: id)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.frame = view.bounds
        nameLabel.frame = CGRect(x: (view.width/2) - 70, y: 200, width: view.width, height: 30)
        emailLabel.frame = CGRect(x: (view.width)/2 - 75, y: nameLabel.bottom+10, width: view.width, height: 30)
        imageView.frame = CGRect(x: (view.width - view.width/3)/2, y: emailLabel.bottom+10, width: view.width/3, height: view.width/3)
        commentLabel.frame = CGRect(x: 20, y: imageView.bottom + 10, width: view.width-20, height: view.width/3)
    }
    
    func getComment(id: Int) {
        let urlSession = URLSession(configuration: .default)
        
        let urlComponents = URLComponents(string: "https://mocki.io/v1/00fde7c1-3fe3-4844-949a-ee34856436d6")
        //let urlComponents?.query = "id=\(id)"
        let url = urlComponents?.url
        
        let dataTask = urlSession.dataTask(with: url!, completionHandler: {(data, response, error) in
            let decoder = JSONDecoder()
            self.comment = try! decoder.decode([Comment].self, from: data!)
            DispatchQueue.main.async {
                var pos = 0
                for c in self.comment {
                    if c.id == self.id {
                        self.nameLabel.text = self.comment[pos].name
                        self.emailLabel.text = self.comment[pos].email
                        self.commentLabel.text = "\"\(self.comment[pos].body)\""
                        break
                    }
                    pos+=1
                }
            }
        })
        
        dataTask.resume()
    }
}
