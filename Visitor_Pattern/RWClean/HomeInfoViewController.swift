/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public protocol HomeInfoDataSourceProtocol {
  var imageName: String? { get }
  var hideNextButton: Bool { get }
}
extension HomeInfoDataSourceProtocol {
  public var hideNextButton: Bool { return false }
  public var image: UIImage? {
    guard let imageName = imageName else { return nil }
    return UIImage(named: imageName)!
  }
}

public protocol HomeInfoBuilderDelegate: class {
  func homeInfoBuilderCompleted(_ homeInfo: HomeInfo)
}

public class HomeInfoViewController: UIViewController {
  
  // MARK: - Injections
  public var delegate: HomeInfoBuilderDelegate!
  public var homeInfo: MutableHomeInfo!
  
  public var homeInfoDataSource: HomeInfoDataSourceProtocol? {
    didSet {
      configureView()
    }
  }
  
  internal func configureView() {
    guard let dataSource = homeInfoDataSource else { return }
    if let imageView = imageView,
      let image = dataSource.image {
      imageView.image = image
    }
    nextButton?.isHidden = dataSource.hideNextButton
  }
  
  public var visitor: StoryboardVisitor = DefaultStoryboardVisitor()
  
  // MARK: - Outlets
  @IBOutlet public var imageView: UIImageView?
  @IBOutlet public var nextButton: UIButton?
  
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    performVisitation()
    setupBackBarButtonItem()
  }
  
  private func performVisitation() {
    guard let vc = self as? StoryboardVisitable else { return }
    vc.accept(visitor)
  }
  
  private func setupBackBarButtonItem() {
    let back = NSLocalizedString("Back", comment: "")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: back, style: .plain,
                                                         target: nil, action: nil)
  }
  
  // MARK: - Segues
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let HomeInfoViewController = segue.destination as? HomeInfoViewController else { return }
    HomeInfoViewController.delegate = delegate
    HomeInfoViewController.homeInfo = homeInfo
  }
}