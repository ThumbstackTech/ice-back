//
//  DocumentManager.swift
//  HOP
//
//  Created by Himesh Soni on 09/06/20.
//  Copyright © 2020 CMarix. All rights reserved.
//

import Foundation
import UIKit

class DocumentManager {

  static let shared = DocumentManager()

  private init(){}

  // get directory path
  func getDirectoryPath() -> URL? {

    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("HopImages")

    if let url = URL(string: path){
      return url
    }
    dPrint("PATH>>>>>>>>>>>>> \(path)")
    return nil
  }

  //save image into document directory
  func saveImageDocumentDirectory(image: UIImage? = nil, video: Data? = nil, imageName: String) {

    let fileManager = FileManager.default

    if let path = getDirectoryPath()?.absoluteString{

      if !fileManager.fileExists(atPath: path) {
        try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
      }

      let url = URL(string: path)
      let imagePath = url!.appendingPathComponent(imageName)
      let urlString: String = imagePath.absoluteString

      if video != nil {
        fileManager.createFile(atPath: urlString as String, contents: video, attributes: nil)

      } else {

        let imageData = image?.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
      }
    }
  }

  // get image into document Directiry
  func getImageFromDocumentDirectory(imageName: String) -> UIImage?{

    let fileManager = FileManager.default

    if let Path = getDirectoryPath(){

      let imagePath = Path.appendingPathComponent(imageName)
      let urlString: String = imagePath.absoluteString

      if fileManager.fileExists(atPath: urlString) {
        let image = UIImage(contentsOfFile: urlString)
        return image!

      } else {
        return nil
      }
    }
    return nil
  }


  func getImagePathFromName(imageName: String) -> String {

    if let Path = getDirectoryPath(){

      let imagePath = Path.appendingPathComponent(imageName)
      return imagePath.path
    }
    return ""
  }

  // Delete image from the document directory
  func deleteImageFromDocumentDirectory(imageName: String) {

    let fileManager = FileManager.default

    if let Path = getDirectoryPath(){

      let imagePath = Path.appendingPathComponent(imageName)
      let urlString: String = imagePath.absoluteString

      if fileManager.fileExists(atPath: urlString) {
        do {
          try fileManager.removeItem(atPath: urlString)
        } catch {
          dPrint("Couldn't delete Image directory")
        }
      }
    }
  }

  // Get video URL
  func getVideoFromDocumentDirectory(videoName: String) -> URL {

    let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString)
    let strDocumentsUrl = documentsDirectory.appendingPathComponent(videoName)
    return URL(fileURLWithPath: strDocumentsUrl)
  }

  // Delete All files
  func deleteAllFiles() {
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    do {
      let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                 includingPropertiesForKeys: nil,
                                                                 options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
      for fileURL in fileURLs {
        try FileManager.default.removeItem(at: fileURL)
      }
    } catch  {dPrint(error) }
  }
}
