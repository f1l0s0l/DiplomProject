typealias PostId = String

struct Post {
    let id: PostId
    let authorId: UserId
    let text: String
    let imageURL: String
    let likeIds: [UserId]
    let commentsCount: Int
    let timestamp: UnixTimestamp
}
