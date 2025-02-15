struct FeedStoryModel {
    let title: String
}

extension FeedStoryModel {
    static var mock: [Self] {
        (0...50).map { Self(title: "Это сторис \($0)") }
    }
}
