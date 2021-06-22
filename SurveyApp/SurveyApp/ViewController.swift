//
//  ViewController.swift
//  SurveyApp
//
//  Created by Ramesh Guddala on 14/06/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var questions = [Question]()
    var indexVal = 0
    var isSkipPressed = false
    var isNextPressed = false
    let cellId = "AnswersCell"
    var selectedIndex:IndexPath?
    var resultDict = [String: String]()
    var questionCount = 0
    var answer = ""
    let containerView = UIView()
    var select_Height_constraint: NSLayoutConstraint!
    let greenColor =  UIColor(red: 0, green: 60/255, blue: 16/255, alpha: 1.0)
    let cellHeight: CGFloat = 50.0
    // UI Eleements
    lazy var headerLabel : UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Verify Identity"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    lazy var qaTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AnswersCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
   
    // Buttons declartions
    lazy var skipButton : UIButton = {
        let skip = UIButton()
        skip.backgroundColor = greenColor
        skip.translatesAutoresizingMaskIntoConstraints = false
        return skip
    }()
    
    lazy var submitButton : UIButton = {
        let submit = UIButton()
        submit.translatesAutoresizingMaskIntoConstraints = false
        return submit
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        readJsonFile()
        addViews()
        qaTableView.rowHeight = UITableView.automaticDimension
        qaTableView.estimatedRowHeight = cellHeight
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.removeConstraints()
        qaTableView.removeConstraints()
        setUpView()
        qaTableView.reloadData()
    }
    
    
    func addViews()  {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
         containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 0.5
        self.qaTableView.layer.cornerRadius = 5
        self.qaTableView.layer.masksToBounds = true
  
        containerView.addSubview(headerLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(qaTableView)
        self.view.addSubview(containerView)
    }
    
    func setUpView()  {
    
     
          let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 40),
            containerView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
           
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            headerLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            headerLabel.heightAnchor.constraint(equalToConstant: 30),
            
            lineView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            lineView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            lineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            qaTableView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10),
            qaTableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            qaTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            qaTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
       let tableHeight = qaTableView.contentSize.height
        if UIDevice.current.orientation.isLandscape {
            
            //containerView.heightAnchor.constraint(equalToConstant: tableHeight + 100).isActive = true
            containerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10).isActive = true
        }else{
            containerView.heightAnchor.constraint(equalToConstant: tableHeight + 90).isActive = true

          //  containerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -200).isActive = true
        }

        self.loadViewIfNeeded()
        
    }
    
    func readJsonFile(){
        if let path = Bundle.main.path(forResource: "formFillJson", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.parse(json: data)
            } catch {
                // handle error
            }
        }
    }
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(FormFill.self, from: json) {
            print(jsonPetitions)
            questions = jsonPetitions.questions
        }
    }
    
    func updateDictAndTableView(){
        
        guard selectedIndex != nil  else {
            return
        }
            resultDict[questions[indexVal].question] = "\(questions[indexVal].answers[selectedIndex!.row])"
            questionCount += 1
            indexVal += 1
       
    }

    @objc func skipAction(){
        print("Skipped")
        isSkipPressed = true
        indexVal += 1
        selectedIndex = nil
        qaTableView.reloadData()

    }
    @objc func submitAction(){
        print("submitAction")
   
        if questionCount < questions.count - 1{ // upto 4 Questions
            if questionCount < questions.count - 2 {
                self.updateDictAndTableView()
                qaTableView.reloadData()
            }
            if questionCount == questions.count - 2 {
                guard selectedIndex != nil  else {
                    return
                }
                resultDict[questions[indexVal].question] = "\(questions[indexVal].answers[selectedIndex!.row])"
                self.skipButton.isHidden = true
                self.submitButton.isUserInteractionEnabled = false
            }
        }
        selectedIndex = nil
        print(resultDict)
    }
    
    
    //MARK:- Make UI
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions[self.indexVal].answers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath) as! AnswersCell
        cell.answerLabel.text = "\(questions[self.indexVal].answers[indexPath.row])"
        
        cell.selectionStyle = .none
        if (selectedIndex == indexPath) {
            cell.radioImage.image = UIImage.init(systemName: "circle.fill")
        } else {
            cell.radioImage.image = UIImage.init(systemName: "circle")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        answer = questions[indexVal].answers[selectedIndex!.row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(questions[self.indexVal].question)"
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 40)) //set these values as necessary
        returnedView.backgroundColor = .white
        
        let label = UILabel.init(frame: CGRect(x: 5, y: 0, width: returnedView.frame.size.width, height: returnedView.frame.size.height))
        label.text = "\(questions[self.indexVal].question)"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        returnedView.addSubview(label)
        return returnedView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 10, width: tableView.frame.size.width, height: cellHeight)) //set these values as necessary
        footerView.backgroundColor = .white
        
        
        skipButton = UIButton.init(frame: CGRect(x: footerView.frame.size.width - 200, y: 10, width: 50, height: 30))
        skipButton.layer.cornerRadius = 5
        skipButton.setTitle("SKIP", for: .normal)
        skipButton.backgroundColor = greenColor
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton = UIButton.init(frame: CGRect(x: footerView.frame.size.width - 140, y: 10, width: 135, height: 30))
        submitButton.layer.cornerRadius = 5
        submitButton.backgroundColor = .gray
        submitButton.isUserInteractionEnabled = false
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        if selectedIndex != nil {
            submitButton.backgroundColor = greenColor
            submitButton.isUserInteractionEnabled = true
        }
        if questionCount == questions.count - 2 || (isSkipPressed && indexVal == questions.count - 1){
            
            submitButton.setTitle("Submit Answers", for: .normal)
        }else{
            submitButton.setTitle("Next", for: .normal)
        }
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        
        footerView.addSubview(skipButton)
        footerView.addSubview(submitButton)
  
        if isSkipPressed {
            skipButton.isHidden = true
            skipButton.isUserInteractionEnabled = false
        }
        return footerView
        
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellHeight
    }
    
   
}
extension UIView {

    /**
     Removes all constrains for this view
     */
    func removeConstraints() {

        let constraints = self.superview?.constraints.filter{
            $0.firstItem as? UIView == self || $0.secondItem as? UIView == self
        } ?? []

        self.superview?.removeConstraints(constraints)
        self.removeConstraints(self.constraints)
    }
}
