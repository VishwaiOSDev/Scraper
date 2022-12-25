@main
public struct Scraper {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(Scraper().text)
    }
}
