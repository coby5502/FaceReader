//
//  FaceManager.swift
//  FaceReader
//
//  Created by COBY_PRO on 2022/08/23.
//

import UIKit

import Foundation

final class FaceManager {
    
    static let shared = FaceManager()
    
    static var leftEye: [CGPoint]? = nil
    static var rightEye: [CGPoint]? = nil
    static var leftEyebrow: [CGPoint]? = nil
    static var rightEyebrow: [CGPoint]? = nil
    static var nose: [CGPoint]? = nil
    static var outerLips: [CGPoint]? = nil
    static var innerLips: [CGPoint]? = nil
    static var faceContour: [CGPoint]? = nil
    
    static var faceImage: UIImage? = nil
    
    static var eyeDistance: CGFloat? = nil
    static var eyeWidth: CGFloat? = nil
    static var eyeHeight: CGFloat? = nil
    
    static var noseWidth: CGFloat? = nil
    static var noseHeight: CGFloat? = nil
    
    static var lipsWidth: CGFloat? = nil
    static var lipsHeight: CGFloat? = nil
    
    static var faceWidth: CGFloat? = nil
    static var faceHeight: CGFloat? = nil
    
    static var score: Int = 0
    static var grade: Int = 0
    
    func setValues() {
        // eye
        FaceManager.eyeDistance = FaceManager.rightEye![3].x - FaceManager.leftEye![3].x
        FaceManager.eyeWidth = FaceManager.leftEye![3].x - FaceManager.leftEye![0].x
        FaceManager.eyeHeight = FaceManager.leftEye![5].y - FaceManager.leftEye![1].y
        
        // nose
        FaceManager.noseWidth = FaceManager.nose![5].x - FaceManager.nose![3].x
        FaceManager.noseHeight = FaceManager.nose![4].y - FaceManager.nose![0].y
        
        // Lips
        FaceManager.lipsWidth = FaceManager.outerLips![7].x - FaceManager.outerLips![13].x
        FaceManager.lipsHeight = FaceManager.outerLips![10].y - FaceManager.outerLips![4].y
        
        // face
        FaceManager.faceWidth = FaceManager.faceContour![0].x - FaceManager.faceContour![16].x
        FaceManager.faceHeight = FaceManager.faceContour![8].y - FaceManager.faceContour![0].y
    }
    
    private init() { }
}

let gradeData: [[String: String]] = [
    [
        "grade": "낭(狼)",
        "info": "위험인자가 될 집단의 출현"
    ],
    [
        "grade": "호(虎)",
        "info": "불특정 다수의 생명의 위기"
    ],
    [
        "grade": "귀(鬼)",
        "info": "도시 전체의 기능정지 및 괴멸 위기"
    ],
    [
        "grade": "용(龍)",
        "info": "도시 여러개가 괴멸 당할 위기"
    ],
    [
        "grade": "신(神)",
        "info": "인류멸망의 위기"
    ],
]
