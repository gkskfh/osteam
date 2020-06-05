//
//  ViewController.swift
//  ScrollViewCode
//
//  Created by youngjun choi on 2020/06/03.
//  Copyright © 2020 youngjun choi. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    let scrollView = UIScrollView() // Create the scrollView

    struct TmpData: Codable {
        var images : String
        var type : String
    }
    var tmpData = [TmpData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        
        let url = "http://127.0.0.1/json_parse.php"
        let params = ["":""]
        let headers: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded; charset=UTF-8"]
        
        let alamo = AF.request(url, method: .get, parameters: params, headers: headers).validate(statusCode: 200..<300)
        //결과값으로 JSON을 받을 때 사용
        alamo.responseJSON() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                
                if let jsonObj = value as? [Dictionary<String, Any>]
                {
                    
                    self.tmpData.removeAll()
                    for item in jsonObj {
                        let images = item["images"]! as? String ?? ""
                        let type = item["type"]! as? String ?? ""
                        self.tmpData.append(TmpData(images: images, type: type))
                        
                    }
                    //self.MyTableView.reloadData()
                    //self.scrollToBottom()
                }
                
                
                self.changeFrame()
                
            //통신실패
            case .failure(let error):
                
                print("error: \(String(describing: error.errorDescription))")
            }
        }
    }
    
    func changeFrame () {
        let guide = self.view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
        
        
        //스크롤뷰 생성 후 메인뷰에 addSubView 해준다.
        //        var rectF = self.view.frame
        //        rectF.origin.y = 0
        scrollView.frame = guide.layoutFrame
        self.scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        

        //UI뷰에 컬러값 세팅.
        let x : [UIColor] = [UIColor.blue,UIColor.red,UIColor.yellow]
        
        let scrollViewCount = tmpData.count
        
        
        //For each UIColor add a view that is 100px larger then the height of the scrollView
        for index in 0...scrollViewCount-1{
            
            let yPosition = scrollView.frame.size.height * CGFloat(index)
            //추가되는 뷰의 위치값 y를 설정해줘야 아래로 붙는다..
            //let subView = UIView( frame: CGRect(x: 0, y: yPosition, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            let pre_path = "http://localhost/images/"
            
            // subView.backgroundColor = x[index]
            // scrollView.addSubview(subView)
            
            
            //            let storyboard = UIStoryboard(name: "Other", bundle: nil)
            // class 파일을 호출하면 안되고 스토리보드에 있는 dentifier값으로 호출 뒤에 as! 파일명으로 맵핑?처리 해야줘야함.
            let addViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubView") as! SubViewController
            
            self.addChild(addViewController)
            //            self.view.addSubview(addViewController.view)
            
            addViewController.view.frame  = CGRect(x: 0, y: yPosition, width: self.scrollView.frame.width  , height: self.scrollView.frame.height)
            
            self.scrollView.addSubview(addViewController.view)
//            addViewController.FirstButton.addTarget(self, action: #FirstBtnAction, for: .tou)
//            addViewController.FirstButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            
        
            if tmpData[index].type == "Second" {
                addViewController.FirstButton.isHidden = true
            } else if tmpData[index].type == "Third" {
                addViewController.SecondButton.isHidden = true
                addViewController.FirstButton.isHidden = true
            } else {
                
            }
            
            //뷰를 가져올때 위치값 설정해서 하나씩 붙여준다. to : scrollView
//            addViewController.view.frame  = CGRect(x: 0, y: yPosition, width: self.scrollView.frame.width  , height: self.scrollView.frame.height)
//            self.scrollView.addSubview(addViewController.view)
            
            //컨트롤러만 불러오고 UI는 못불러옴.
            //            let subController = SubViewController()
            //            let subImageView = addViewController.MainImage
            //            let subMainView = addViewController.MainView
            //
            guard let imageURL = URL(string: "\(pre_path)\(tmpData[index].images)") else { return }
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    //                    subImageView?.image = image
                    addViewController.MainImage.image = image
                }
            }
            
            //  scrollView.addSubview(subMainView!)
        }
  
        let c = (self.scrollView.frame.size.height) * CGFloat(x.count)
        self.scrollView.contentSize = CGSize(self.scrollView.frame.width, c)
        //Background Color
        self.view.backgroundColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //safe Area 설정값 해당함수에서 확인.  //viewdidApear 함수에서 처리.
    override func viewSafeAreaInsetsDidChange() {
     // ... your layout code here
//        self.changeFrame()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //self.changeFrame()
    }
    
    @objc func buttonAction(_ sender:UIButton!) {
        print("Button tapped")
    }
    
    
}

extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}


extension UIApplication {

   var statusBarView: UIView? {
      return value(forKey: "statusBar") as? UIView
    }

}


func setImage(from url: String) {
    guard let imageURL = URL(string: url) else { return }

        // just not to cause a deadlock in UI!
    DispatchQueue.global().async {
        guard let imageData = try? Data(contentsOf: imageURL) else { return }

        let image = UIImage(data: imageData)
        DispatchQueue.main.async {
            //self.imageView.image = image
        }
    }
}
