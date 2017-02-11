import Foundation

struct Score {
   var falseFalse = 0
   var falseTrue = 0
   var trueFalse = 0
   var trueTrue = 0
   
   var correct: Int { return falseFalse + trueTrue }
   var incorrect: Int { return falseTrue + trueFalse }
   var matches: Int { return falseTrue + trueTrue }
   
   static func tally(correctAnswers: [Bool], playerAnswers: [Bool]) -> Score {
      var s = Score()
      zip(playerAnswers, correctAnswers).forEach { player,correct in
         switch (player,correct) {
         case (false,false): s.falseFalse += 1
         case (false,true): s.falseTrue += 1
         case (true,false): s.trueFalse += 1
         case (true,true): s.trueTrue += 1
         }
      }
      return s
   }
}
