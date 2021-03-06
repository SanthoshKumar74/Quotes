//
//  NewQuoteViewController.swift
//  Quotes
//
//  Created by Santhosh on 21/03/22.
//

import UIKit
import Vision
import CoreData

class NewQuoteViewController:UIViewController
{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories:[Category] = []
    let notion = NotionAPI()
    var selectedCategory: Category?
    var quoteString = ""
  var new:Bool = true

  @IBOutlet var deleteButton: UIButton!
  @IBOutlet var quoteImage: UIImageView!
    @IBOutlet var quoteText: UITextView?
    @IBOutlet var categoryPicker: UIPickerView!
    @IBOutlet var authorText: UITextField!{
        didSet{
            if authorText == nil{
                print("Set to nil")
            }
        }
    }
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Author", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Delete only author", style: .default, handler: { _ in
            self.authorText.text! = " "
        }))

        alert.addAction(UIAlertAction(title: "Delete all Quotes Associated with the author", style: .default, handler: { _ in
            self.notion.deleteAuthor(author: self.authorText.text!)
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
//        let alert = UIAlertController(title: "Delete Author", message: nil, preferredStyle: .actionSheet)
//
//
//
//               alert.addAction(UIAlertAction(title: "Delete all Quotes Associated with the author", style: .default, handler: { _ in
//                   self.notion.deleteAuthor(author: self.authorText.text!)
//                   self.navigationController?.popViewController(animated: true)
//               }))
//               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//               present(alert, animated: true, completion: nil)
        
    }
    @IBAction func saveQuote(_ sender: UIButton) {
        
      let compact = categories.unique(){$0.name}
      saveNewQuote(oldQuote:quoteString,newquote: quoteText!.text!, author: authorText.text!, category: compact[categoryPicker.selectedRow(inComponent: 0)].name!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(quoteString)
      if new {
        deleteButton.isHidden = true
      }
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        quoteText!.clipsToBounds = true
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        categories = try! context.fetch(fetchRequest) as! [Category]
        print("New Category")
        print(categories.count)
        let index = indexOf(selectedCategory: selectedCategory!)
        categoryPicker.selectRow( index , inComponent: 0, animated: true)
        let tap = UITapGestureRecognizer(target: self, action:#selector(cancelEdititing))
        self.view.addGestureRecognizer(tap)
        
    }
    @IBAction func cameraClicked(_ sender: UIBarButtonItem) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        
        let alert = UIAlertController(title: "Add Photos", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            imagePickerVC.sourceType = .camera
            imagePickerVC.allowsEditing = true
            self.present(imagePickerVC, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in
            imagePickerVC.sourceType = .photoLibrary
            imagePickerVC.allowsEditing = true
            self.present(imagePickerVC, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: VisionText Recognition

extension NewQuoteViewController
{
    func readText(image:UIImage)
    {
        guard let cgImage = image.cgImage else { return  }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let recquest = VNRecognizeTextRequest { recquest, error in
            guard let observations = recquest.results as? [VNRecognizedTextObservation], error == nil else{return}
            
            
            var minHeight:CGFloat
            var height:[CGFloat] = []
            for observation in observations {
                print(observation.boundingBox.width)
                print(observation.topCandidates(5))
                height.append(observation.boundingBox.width)
            }
            minHeight = height.min()!
            for observation in observations {
                if observation.boundingBox.width == minHeight{
                    let text = observation.topCandidates(1).first?.string
                    self.authorText.text = text
                }
            }
            let text =  observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: " ")
            DispatchQueue.main.async {
                print(text)
                self.quoteText!.text = text
            }
    
            
        }
        //recquest.minimumTextHeight = 0.05
        recquest.recognitionLevel = .accurate
        
        do
        {
            try handler.perform([recquest])
        }catch{
            
        }
    }
    }

//MARK: ImagerPickerDelegate

extension NewQuoteViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            print(info)
            DispatchQueue.main.async {
                self.quoteImage.image = image
            }
           
           readText(image: image)
            
        }
    }
}

//MARK: CatergoryPicker Delegate
extension NewQuoteViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let compact = categories.unique(){$0.name}
       return compact.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let compact = categories.unique(){$0.name}
        return compact[row].name
    }
}

//MARK: AuthorSelect
extension NewQuoteViewController
{
    func configure(quote:Quotes)
    {
      quoteString = quote.quote!
    new = false
        DispatchQueue.main.async {
            self.authorText.text = quote.authorCategory?.name
            self.quoteText!.text = quote.quote
        }
          
}
    func configureAuthortext(author:String)
    {
        DispatchQueue.main.async {
            print(author)
            self.authorText.text = author ?? ""
        }
    }
}
                     

//MARK: Adding New Quote
extension NewQuoteViewController
{
  func saveNewQuote(oldQuote:String, newquote:String,author:String,category:String)
    {
        print(category)
               //notion.addPage(quote: quote, author: author, category: category)
      notion.updateData(author: author, oldQuote: oldQuote, newQuote: newquote, Category: category)
        navigationController?.popViewController(animated: true)
        
        
        
    }
    
}

//MARK: Finding the index of selected Category
extension NewQuoteViewController
{
    func indexOf(selectedCategory: Category)-> Int
    { var index = 0
      let compact = self.categories.unique(){$0.name}
      for category in compact
        {
            if category.name == selectedCategory.name{
              print("index of Selected item\(index)")
                return index
            }
            index += 1
        }
      print("fullindex")
        return index
    }
}


//MARK: Tap Gesture
extension NewQuoteViewController
{
    @objc func cancelEdititing(){
        self.view.endEditing(true)
    }
}
