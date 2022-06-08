import UIKit

class CommentsViewController: UIViewController {

    var comments: [Comment] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        getComments()
    }
    
    func getComments() {
        let urlSession = URLSession(configuration: .default)
        
        let urlComponents = URLComponents(string: "https://mocki.io/v1/00fde7c1-3fe3-4844-949a-ee34856436d6")
        let url = urlComponents?.url
        
        let dataTask = urlSession.dataTask(with: url!, completionHandler: {(data, response, error) in
            let decoder = JSONDecoder()
            self.comments = try! decoder.decode([Comment].self, from: data!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        dataTask.resume()
    }
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedComment = comments[indexPath.row]
        let vc = SingleCommentViewController(with: selectedComment.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
