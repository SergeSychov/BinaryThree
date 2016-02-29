//
//  ViewController.swift
//  TSystemsTask
//
//  Created by Serge Sychov on 26.02.16.
//  Copyright © 2016 Sergey Sychov. All rights reserved.
//

import UIKit

class Circle {
    var value: NSInteger?
    var leftCircle:Circle?
    var rightCircle:Circle?
    
    init(){
        value = nil
        leftCircle = nil
        rightCircle = nil
    }

    init(deepCount:NSInteger){
        let quantity = NSInteger(pow(Double(deepCount),2)-1)  //total qauntity of cells
        for(var i = 0 ; i<quantity ; i++ ){
            addCircle(i);
        }
    }


    func addCircle(nextValue: NSInteger){
        if (value == nil){ value = nextValue; return}
        else {
            //var tempCircle = self
            var circles:[Circle] = [self]
            var counter = 0
            while true {
                let tempCircle = circles[counter]
                if(tempCircle.leftCircle == nil){ tempCircle.leftCircle = Circle(); tempCircle.leftCircle?.value = nextValue; break}
                else { circles.append(tempCircle.leftCircle!) }
                
                if(tempCircle.rightCircle == nil){ tempCircle.rightCircle = Circle(); tempCircle.rightCircle?.value = nextValue; break}
                else { circles.append(tempCircle.rightCircle!) }
                
                counter++
                
            }
            return
        }
        
    }
    
    //----------------------------------------------------------------------------------------
    //MARK: -first describe function
    
    func makeOrderedStringArrayFromCirle(inputStringArray:[String]?, deep:NSInteger)->[String]
    {
        //start from zero
        var orderedArray:[String] = []
        //if its just start
        if(inputStringArray == nil){
            //if initial construction
            orderedArray = [String(value!)]
        } else {
            
            orderedArray = inputStringArray!
            var stringForLevel:String
            if(inputStringArray!.count >= deep+1){
                stringForLevel = orderedArray[deep];
                stringForLevel+=" "
                stringForLevel+=String(value!)
                orderedArray[deep] = stringForLevel
                
            } else {
                stringForLevel = String(value!)
                orderedArray.append(stringForLevel)
            }
            
        }
        
        if((leftCircle) != nil){
            orderedArray = (leftCircle?.makeOrderedStringArrayFromCirle(orderedArray, deep: deep+1))!
        }
        if(rightCircle != nil){
            orderedArray = rightCircle!.makeOrderedStringArrayFromCirle(orderedArray, deep: deep+1)
        }
        
        return orderedArray
    }
    
    
    
    func describeCirle ()->String {
        var returnString = ""
        for str in self.makeOrderedStringArrayFromCirle(nil, deep: 0){
            returnString+=str
            returnString+="\n"
            print(str)
        }
        
        return returnString
        
    }
    //----------------------------------------------
    
    
}


//MARK: -Viewcontroller
class ViewController: UIViewController {
    
    @IBOutlet weak var buttonTSystemTree: UIButton!
    
    @IBOutlet weak var buttonMyTree: UIButton!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    
    var circle:Circle? = nil // = Circle()
    let arrayForCircles = [1,3,7,8,9,10,11]; //initial array from T-System
    
    var circleSecond:Circle? = nil// = Circle(deepCount: 4)
    
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelDescription.textColor = UIColor.grayColor();
        labelDescription.text = "В  приложеннии создаются два бинарных дерева. Первое согласно задачи T-System из массива:1,3,7,8,9,10,11. Второе бинарное дерево с начальным значением 0 и глубиной ссылок - 4 \n. После инициации упорядоченные по уровням деревья можно посмотреть нажав кнопки. Для вывода строк в ширину реализованы две рекрусивные функциию"
        
        buttonTSystemTree.titleLabel!.textAlignment = NSTextAlignment.Center
        buttonTSystemTree.titleLabel!.numberOfLines=0;
        buttonTSystemTree.titleLabel!.baselineAdjustment = UIBaselineAdjustment.AlignBaselines
        buttonTSystemTree.titleLabel!.adjustsFontSizeToFitWidth = true
        buttonTSystemTree.enabled = false
        
        buttonMyTree.titleLabel!.textAlignment = NSTextAlignment.Center
        buttonMyTree.titleLabel!.numberOfLines=0;
        buttonMyTree.titleLabel!.baselineAdjustment = UIBaselineAdjustment.AlignBaselines
        buttonMyTree.titleLabel!.adjustsFontSizeToFitWidth = true
        buttonMyTree.enabled = false

        
        let queue = NSOperationQueue()
        
        queue.addOperationWithBlock { () -> Void in
            
            self.circle = Circle()
            for item in self.arrayForCircles{
                self.circle?.addCircle(item)
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.buttonTSystemTree.enabled = true
            })
        }
        
        queue.addOperationWithBlock { () -> Void in
            
            self.circleSecond = Circle(deepCount: 4)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.buttonMyTree.enabled = true
            })
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func printSecondCircleButtonTTapped(sender: AnyObject) {
        
        let queue = NSOperationQueue()
        
        queue.addOperationWithBlock { () -> Void in
            let str = self.circleSecond!.describeCirle()
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.labelDescription.textColor = UIColor.blackColor()
                self.labelDescription.text = str;
            })
        }

    }

    @IBAction func printCirleButtonTapped(sender: UIButton) {
        self.labelDescription.text = ""
        printCirclecOrderedByLevel(circle!)
    }
    
    //----------------------------------------------------------------------------------------
    //MARK: -second describe function
    func printCirclecOrderedByLevel(circle: Circle, var circles:[Circle]?=nil){
        if(circles == nil){
            circles = [circle]
        }

        if(circles!.isEmpty || circles![0].value==nil){
            return
        } else {
            var nextLevelOfCircles:[Circle] = []
            var stringOfCurrentLevel:String = ""
            for circle in circles! {
                stringOfCurrentLevel+=String(circle.value!)
                stringOfCurrentLevel+=" "
                if(circle.leftCircle != nil) {nextLevelOfCircles.append(circle.leftCircle!)}
                if(circle.rightCircle != nil){nextLevelOfCircles.append(circle.rightCircle!)}
                
            }
            self.labelDescription.textColor = UIColor.blackColor()
            stringOfCurrentLevel+="\n"
            self.labelDescription.text! += stringOfCurrentLevel;
            print(stringOfCurrentLevel);
            printCirclecOrderedByLevel(circle, circles: nextLevelOfCircles)
            return
        }
       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

