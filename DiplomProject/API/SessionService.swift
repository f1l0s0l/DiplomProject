protocol SessionService: AnyObject {
    var sessionDidChande: (() -> Void)? { get set }
    func signOut()
}
