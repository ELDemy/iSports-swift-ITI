import UIKit
final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    private var activeTasks: [String: URLSessionDataTask] = [:]
    private let queue = DispatchQueue(label: "com.iSports.imageLoader", attributes: .concurrent)
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
      func loadImage(
        from urlString: String?,
        into imageView: UIImageView,
        placeholder: UIImage? = UIImage(systemName: "sportscourt.fill"),
        completion: ((Bool) -> Void)? = nil
    ) {
        let tag = imageView.hash
        
        imageView.image = placeholder
        imageView.tintColor = UIColor(red: 1/255, green: 71/255, blue: 81/255, alpha: 0.3)
        
        guard let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) else {
            completion?(false)
            return
        }
        
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            imageView.image = cachedImage
            completion?(true)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self, weak imageView] data, response, error in
            guard let self = self, let imageView = imageView else { return }
            
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion?(false)
                }
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                UIView.transition(with: imageView, duration: 0.25, options: .transitionCrossDissolve) {
                    imageView.image = image
                }
                completion?(true)
            }
        }
        task.resume()
    }
}
