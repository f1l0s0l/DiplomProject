import UIKit

final class FeedViewModel {
    
    // MARK: - Public properties
    
    var stateChanged: ((State) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }
    
    private(set) var stories: [FeedStoryModel] = []
    private(set) var items: [FeedItem] = []
    private(set) var posts: [PostId: Post] = [:]
    private(set) var users: [UserId: User] = [:]
    
    // MARK: - Private properties
    
    private let client: APIClient
    
    // MARK: - Lifecycles
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK: - Public methods
    
    func loadPosts() {
        state = .loading
        
        let userId = "UHwc5gRdVObEFnb66qymee9Exim1"
        client.perform(request: API.getPosts(parameters: [:], userId: userId)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success((let posts, let users)):
                for post in posts {
                    self.posts[post.id] = post
                    if let lastItem = items.last {
                        if dateFor(item: lastItem).isEqualDay(to: post.timestamp.date) {
                            items.append(.post(post.id))
                        } else {
                            items.append(contentsOf: [.date(post.timestamp.date), .post(post.id)])
                        }
                    } else {
                        items = [.date(post.timestamp.date), .post(post.id)]
                    }
                }
                
                for user in users {
                    self.users[user.id] = user
                }
                
                state = .loaded
            case .failure(let failure):
                state = .wrong
            }
        }
    }
    
    // MARK: - Private properties
    
    private func dateFor(item: FeedItem) -> Date {
        switch item {
        case .post(let postId):
            posts[postId]!.timestamp.date
        case .date(let date):
            date
        }
    }
}

extension FeedViewModel {
    enum State {
        case initial
        case loading
        case loaded
        case wrong
    }
}



extension FeedViewModel {
    enum FeedItem {
        case post(PostId)
        case date(Date)
    }
}
