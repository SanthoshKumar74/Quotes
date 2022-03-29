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
    var selectedCategory: Category?
    static var authorText  : String = ""
    @IBOutlet var quoteImage: UIImageView!
    @IBOutlet var quoteText: UITextView!
    @IBOutlet var authorText: UITextField!
    @IBOutlet var categoryPicker: UIPickerView!
    
    @IBAction func saveQuote(_ sender: UIButton) {
        saveNewQuote(quote: quoteText.text!, author: authorText.text!, category: categories[categoryPicker.selectedRow(inComponent: 0)].name!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        quoteText.clipsToBounds = true
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        categories = try! context.fetch(fetchRequest) as! [Category]
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
                self.quoteText.text = text
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
       print(categories.count)
       return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(row)
        print(categories[row].name)
        return categories[row].name
    }
}
                     
//MARK: Author TextField
extension NewQuoteViewController:UITextFieldDelegate
{

}

//MARK: Adding New Quote
extension NewQuoteViewController
{
    func saveNewQuote(quote:String,author:String,category:String)
    {
       let newQuote = Quotes(context: context)
        let Author = Author(context: context)
        selectedCategory?.name = category
        Author.name = author
        newQuote.quote = quote
        newQuote.parentCategory = selectedCategory
        newQuote.authorCategory = Author
        try! context.save()
        dismiss(animated: true, completion: nil)
        
        
    }
    
}

