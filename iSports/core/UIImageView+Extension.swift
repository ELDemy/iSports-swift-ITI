import UIKit

extension UIImageView {
    func loadImage(from urlString: String?, placeholder: UIImage? = nil) {
        self.image = placeholder
        self.startShimmering()
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.stopShimmering()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.stopShimmering()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                self.stopShimmering()
            }
        }.resume()
    }
}
