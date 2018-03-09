
import Foundation


public class BACCalculator
{
    private var weight  = Double()
    private var sex = Bool()
    private var state = String()
    
    private var startTime:NSDate? = nil
    private var drinkHistory = [(Double,NSDate)]()
    private var bacHistory = [(Double,NSDate)]()
    
    private var tempDrinks = [Double]()
    
    struct Constants {
        static let AlcoholDistributionRatioMen = 0.73
        static let AlcoholDistributionRatioWomen = 0.66
        static let BloodVolume = 5.14
        static let DecayRatio = 0.015
    }
    
    init(weight: Double, sex: Bool, state: String) {
        self.weight = weight
        self.sex = sex
        self.state = state
    }
    
    public func addDrink(onces: Double) {
        tempDrinks.append(onces)
    }
    
    public func drink(time: NSDate) {
        let currTime = time
        if startTime == nil {
            startTime = currTime
        }
        
        var totalOnces = Double()
        for onces in tempDrinks {
            totalOnces += onces
        }
        
        tempDrinks = [Double]()
        
        drinkHistory.append((totalOnces, currTime))
    }
    
    func getBAC(time: NSDate) -> Double {
        if(drinkHistory.count == 0) {
            return 0.0
        }
        
        let pastDrinkingHistory = getPastDrinkingHistory(time: time)
        
        if pastDrinkingHistory.count == 0 {
            return 0.0
        }
        
        let pastOunce = getTotalOnces(history: pastDrinkingHistory)
        
        let (_, lastTime) = pastDrinkingHistory.last!
        
        let bac = computeBAC(ounces: pastOunce, fromTime: lastTime, toTime: time)
        return bac
    }
    
    
    
    func getPastDrinkingHistory(time: NSDate) -> [(Double, NSDate)] { //returns pasthistory, trucated before the passed NSDate
        var tmpDrinkHistory = [(Double, NSDate)]()
        
        for i in 0..<drinkHistory.count {
            let (ounce, date) = drinkHistory[i]
            if date.compare(time as Date) != ComparisonResult.orderedDescending {
                tmpDrinkHistory.append((ounce, date))
            } else {
                break
            }
        }
        
        return tmpDrinkHistory
    }
    
    func getTotalOnces(history: [(Double, NSDate)] ) -> Double { //returns the total number of onces of alc in system, based on drink history
        var (prevOunce, prevTime)  = history[0]
        
        for i in 1..<history.count {
            let (thisOunce, thisTime)  = history[i]
            
            let extraOunce = computeOunce(prevOunce: prevOunce, fromTime: prevTime, toTime: thisTime)
            
            (prevOunce, prevTime) = (extraOunce + thisOunce, thisTime)
        }
        
        
        return prevOunce
    }
    
    func computeBAC(ounces: Double, fromTime: NSDate, toTime: NSDate) -> Double {
        let elapsedTime = toTime.timeIntervalSince(fromTime as Date)
        let hours = abs(elapsedTime / 3600)
        let ratio = (self.sex) ? Constants.AlcoholDistributionRatioMen : Constants.AlcoholDistributionRatioWomen
        
        let bac = (ounces * Constants.BloodVolume / self.weight * ratio) - Constants.DecayRatio * hours
        
        return bac
    }
    
    func computeOunce(prevOunce: Double, fromTime: NSDate, toTime: NSDate) -> Double {
        let bac = computeBAC(ounces: prevOunce, fromTime: fromTime, toTime: toTime)
        let ratio = (self.sex) ? Constants.AlcoholDistributionRatioMen : Constants.AlcoholDistributionRatioWomen
        
        let result = (bac * self.weight) / (Constants.BloodVolume * ratio)
        
        return result
    }
    
}
