import Foundation
import AVFoundation

class SpeechSynthesizer {
    static private var synth = AVSpeechSynthesizer()
    static func speak(number: Int) {
        let utterance = AVSpeechUtterance(string: "\(number)")
        synth.speak(utterance)
    }
}
