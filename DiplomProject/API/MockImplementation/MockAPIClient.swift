import FirebaseFirestore
import FirebaseAuth

fileprivate enum EmptyError: Error {
    case empty
}

fileprivate let dataBase = Firestore.firestore()

final class MockAPIClient: APIClient {
    func perform<T: APIRequest>(request: T, completion: @escaping (Result<T.ResultValue, any Error>) -> Void) {
        let method = Method(request: request)
        switch method {
        case .getFriends(let getFriendsRequest):
            getFriends(
                request: getFriendsRequest,
                completion: completion as! (Result<API.getFriends.ResultValue, any Error>) -> Void
            )
        case .getPosts(let getPostsRequest):
            getPosts(
                request: getPostsRequest,
                completion: completion as! (Result<API.getPosts.ResultValue, any Error>) -> Void
            )
        case .login(let loginRequest):
            login(
                email: loginRequest.email,
                password: loginRequest.password,
                completion: completion as! (Result<API.login.ResultValue, any Error>) -> Void
            )
        case .checkAuth(_):
            checkAuth(completion: completion as! (Result<API.login.ResultValue, any Error>) -> Void)
        }
    }
    
    // MARK: - Private methodы
    
    private func getUser(userId: UserId, completion: @escaping (Result<User, Error>) -> Void) {
        dataBase.collection("users").document(userId).getDocument {
            documentSnapshot,
            error in
            guard error == nil else {
                print("ОШИБКА 1")
                print(error!)
                completion(.failure(error!))
                return
            }
            
            guard let data = documentSnapshot?.data() else {
                print("ОШИБКА 2")
                print("НЕТ ДОКУМЕНТА")
                completion(.failure(EmptyError.empty))
                return
            }
            
            let avatarURLString = data["avatarURL"] as? String
            let user = User(
                id: userId,
                name: data["name"] as? String ?? "Без имени",
                friendIds: data["friendIds"] as? [UserId] ?? [],
                postIds: data["postIds"] as? [String] ?? [],
                storyIds: data["storyIds"] as? [String] ?? [],
                avatarURL: URL(string: avatarURLString ?? "")
            )
            print("user приходит: \(user)")
            completion(.success(user))
        }
    }
    
    private func getFriends(request: API.getFriends, completion: @escaping (Result<API.getFriends.ResultValue, any Error>) -> Void) {
        getUser(userId: request.userId) { result in
            switch result {
            case .success(let user):
                getFriends(for: user.friendIds, completion: completion)
            case .failure(let error):
                print("ОШИБКА 3")
                DispatchQueue.main.async {
                    completion(.failure(EmptyError.empty))
                }
            }
        }
        
        func getFriends(for friendIds: [UserId], completion: @escaping (Result<API.getFriends.ResultValue, any Error>) -> Void) {
            let group = DispatchGroup()
            var isCancelled = false
            var resultUsers: [User] = []
            
            for friendId in friendIds {
                group.enter()
                getUser(userId: friendId) { result in
                    switch result {
                    case .success(let user):
                        resultUsers.append(user)
                    case .failure(let error):
                        isCancelled = true
                        DispatchQueue.main.async {
                            completion(.failure(EmptyError.empty))
                        }
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                guard !isCancelled else { return }
                completion(.success(resultUsers))
            }
        }
    }
    
    // MARK: - Posts
    
    private func getPost(for postId: PostId, completion: @escaping (Result<Post, Error>) -> Void) {
        print(" Запросили документ \(postId)")
        dataBase.collection("posts").document(postId).getDocument { documentSnapshot, error in
            guard error == nil else {
                print("ОШИБКА 1")
                print(error!)
                completion(.failure(error!))
                return
            }
            
            guard let data = documentSnapshot?.data() else {
                print("ОШИБКА 2")
                print("НЕТ ДОКУМЕНТА \(postId)")
                completion(.failure(EmptyError.empty))
                return
            }
            
            let post = Post(
                id: postId,
                authorId: data["authorId"] as! UserId,
                text: data["text"] as! String,
                imageURL: data["imageURL"] as! String,
                likeIds: data["likeIds"] as? [UserId] ?? [],
                commentsCount: data["commentsCount"] as! Int,
                timestamp: data["timestamp"] as! UnixTimestamp
            )
            print("post приходит: \(post)")
            completion(.success(post))
        }
    }
    
    private func getPosts(request: API.getPosts, completion: @escaping (Result<API.getPosts.ResultValue, any Error>) -> Void) {
        getUser(userId: request.userId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let user):
                let getFriendsRequest = API.getFriends(parameters: [:], userId: user.id)
                getFriends(request: getFriendsRequest) { result in
                    switch result {
                    case .success(let friends):
                        let postIds = friends.flatMap(\.postIds) + user.postIds
                        getPosts(users: friends + [user], postIds: postIds, completion: completion)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        
        func getPosts(users: [User], postIds: [PostId], completion: @escaping (Result<API.getPosts.ResultValue, any Error>) -> Void) {
            let group = DispatchGroup()
            var isCancelled = false
            var resultPosts: [Post] = []
            
            for postId in postIds {
                group.enter()
                getPost(for: postId) { result in
                    switch result {
                    case .success(let post):
                        resultPosts.append(post)
                    case .failure(let error):
                        isCancelled = true
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                guard !isCancelled else { return }
                let sortedPostIds = resultPosts.sorted { $0.timestamp < $1.timestamp }
                completion(.success((sortedPostIds, users)))
            }
        }
    }
    
    private func login(email: String, password: String, completion: @escaping (Result<User, any Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let result else {
                completion(.failure(EmptyError.empty))
                return
            }
            
            let fireBaseUser = result.user
            
            getUser(userId: fireBaseUser.uid) { result in
                completion(result)
            }
        }
    }
    
    private func checkAuth(completion: @escaping (Result<User, any Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(EmptyError.empty))
            return
        }
        getUser(userId: user.uid) { result in
            completion(result)
        }
    }
}





fileprivate enum Method {
    case getFriends(API.getFriends)
    case getPosts(API.getPosts)
    case login(API.login)
    case checkAuth(API.checkAuth)
}

extension Method {
    init(request: any APIRequest) {
        switch request.method {
        case "getFriends":
            self = .getFriends(request as! API.getFriends)
        case "getPosts":
            self = .getPosts(request as! API.getPosts)
        case "login":
            self = .login(request as! API.login)
        case "checkAuth":
            self = .checkAuth(request as! API.checkAuth)
        default:
            fatalError()
        }
    }
}
