//
//  ViewController.swift
//  MemoryGameHW1
//
//  Created by Seiran (317101541) and Vladimir (327149621) on 25/03/2016.
//  Copyright © 2016 Seiran and Vladimir. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var unflippedLabel = "X"
    var charArray = ["A","A","B","B","C","C","D","D","E","E","F","F","G","G","H","H"]
    var charMatrix = [["a","b","c","d"],["x","y","z","w"],["a","b","c","d"],["x","y","z","w"]]
    var clickCount = 0
    var firstCell = [0,0]
    var elapsedSeconds = 0
    var score = 1000
    var timer: NSTimer!
    var isPaused = false
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var collectionViewRef: UICollectionView!
    
    let preferences = NSUserDefaults.standardUserDefaults()
    
    let currentUserKey = "currentUser"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTimer.text = "00:00"
        lblScore.text = "\(score)"
        
        prepareCells()
        timer = NSTimer.scheduledTimerWithTimeInterval( 1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
    }
    
    
    func updateTimer() {
        elapsedSeconds++;
        let minutes = elapsedSeconds/60
        let seconds = elapsedSeconds % 60
        
        lblTimer.text=String(format: "%02d:%02d", minutes, seconds)
        
        if elapsedSeconds%5==0{
            score--
            lblScore.text = "\(score)"
        }
    }
    
    func prepareCells(){
        var arrayCounter = 0

        charArray = charArray.shuffle()
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++){
                charMatrix[i][j] = charArray[arrayCounter]
                arrayCounter++
                }
            
        }
    }
    
    func checkGameEnded(collectionView: UICollectionView)->Bool{
       
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++){
                let  cell=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                if !cell.isFaceUp{
                    return false
                }
                
            }
            
        }
        return true;

    }
    
    func setNewGame(collectionView: UICollectionView){
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++){
                let  cell=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                cell.isFaceUp=false;
                cell.hidden=false
                cell.lblCelltext.text = unflippedLabel
            }
        }
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellID", forIndexPath: indexPath) as! CollectionViewCell
        //here we setting the initial text
        if(!cell.isFaceUp){
            cell.lblCelltext.text = unflippedLabel}
        else{
            cell.lblCelltext.text=charMatrix[indexPath.section][indexPath.row]}
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Row \(indexPath.row), section: \(indexPath.section)")
        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        clickCount++
        currentCell.lblCelltext.text=charMatrix[indexPath.section][indexPath.row]
        
        if(clickCount==1){
            firstCell[0]=indexPath.section
            firstCell[1]=indexPath.row
        }
            
        else if(clickCount==2){
            clickCount=0
            if(checkFlipedCells(charMatrix[indexPath.section][indexPath.row],cell2: charMatrix[firstCell[0]][firstCell[1]]) && !(indexPath.section == firstCell[0] &&  firstCell[1] == indexPath.row)){
                currentCell.isFaceUp=true
                
                let  savedCell=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: firstCell[1], inSection: firstCell[0])) as! CollectionViewCell
                savedCell.isFaceUp=true
                
            }
            setCellsEnabled(collectionView, enabled: false)
            
            //wait 1 sec
            let time=dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1*Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()){
                self.setFaceDownWrongCell(collectionView)
                self.setCellsEnabled(collectionView, enabled: true)
                
                if self.checkGameEnded(collectionView){
                    self.finishGame()
                }
            }
            
            
        }
        
        
        //NSiindexpath is an index object
    }
    
    func finishGame(){
        timer.invalidate()
        
        alertWin()
        
    }
    
    func checkFlipedCells(cell1:String, cell2:String )->Bool{
        
        return cell1 == cell2
    }
    
    func setCellsEnabled(collectionView: UICollectionView, enabled: Bool){
        
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++){
                let  c=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                c.userInteractionEnabled=enabled;
            }
        }
    }

    
    func setFaceDownWrongCell(collectionView: UICollectionView){
        
        for(var i=0;i<4;i++){
            for (var j=0;j<4;j++)
            {
                let  cell=collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: j)) as! CollectionViewCell
                if(cell.isFaceUp)
                {
                    cell.hidden=true
                }
                else{
                    cell.lblCelltext.text = unflippedLabel
                }
                
            }
            
        }
        
        
        
        
    }
    
    func alertWin(){
        let alertController = UIAlertController(title: "!!! You Have Won !!!", message:
            "Your score: \(score)", preferredStyle: UIAlertControllerStyle.Alert)
        
        //save current user score
        preferences.setInteger(score, forKey: currentUserKey)
        preferences.synchronize()
        
        alertController.addAction(UIAlertAction(title: "I'm the one who knocks!", style: UIAlertActionStyle.Default){
            action -> Void in
            self.restartGame()
            self.timer = NSTimer.scheduledTimerWithTimeInterval( 1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
            })
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    @IBAction func onPauseTap(sender: UIButton) {
        if isPaused{
            timer = NSTimer.scheduledTimerWithTimeInterval( 1.0, target: self, selector:"updateTimer", userInfo: nil, repeats: true)
            setCellsEnabled(collectionViewRef, enabled: true)
            isPaused=false
            sender.setTitle("Pause", forState: .Normal)
        
            
        }else{
            timer.invalidate()
            setCellsEnabled(collectionViewRef, enabled: false)
            isPaused=true
            sender.setTitle("Resume", forState: .Normal)
        }
    }
    
    @IBAction func onRestartTap(sender: AnyObject) {
        restartGame()
    }
    
    func restartGame(){
        elapsedSeconds = 0
        score = 1000
        lblTimer.text = "00:00"
        
       
        prepareCells()
        setCellsEnabled(collectionViewRef, enabled: true)
        setNewGame(collectionViewRef)
        
        
    }
    
    
}



// MARK: extention methods

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}


