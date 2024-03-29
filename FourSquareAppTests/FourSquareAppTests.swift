

import XCTest
@testable import FourSquareApp

class FourSquareAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    private func getMap() -> Data? {
                 let bundle = Bundle(for: type(of: self))
                 guard let pathToData = bundle.path(forResource: "testFourSquareAPI", ofType: ".json")  else {
                     XCTFail("couldn't find Json")
                     return nil
                 }
                 let url = URL(fileURLWithPath: pathToData)
                 do {
                     let data = try Data(contentsOf: url)
                     return data
                 } catch let error {
                     fatalError("couldn't find data \(error)")
                 }
             }

     func testMap() {
          
                 let data = getMap() ?? Data()
        let mapData = Foursquare.getTestData(from: data) ?? []
              print(mapData)
                XCTAssertTrue(mapData.count > 0, "No map data was loaded")
         }
    
    
    private func getPicData() -> Data? {
                   let bundle = Bundle(for: type(of: self))
                   guard let pathToData = bundle.path(forResource: "testPicture", ofType: ".json")  else {
                       XCTFail("couldn't find Json")
                       return nil
                   }
                   let url = URL(fileURLWithPath: pathToData)
                   do {
                       let data = try Data(contentsOf: url)
                       return data
                   } catch let error {
                       fatalError("couldn't find data \(error)")
                   }
               }
    func testPicture() {
             
                    let data = getPicData() ?? Data()
        let picData = Picture.getPictureTestData(from: data) ?? []
                 print(picData)
                   XCTAssertTrue(picData.count > 0, "No picture data was loaded")
            }
       
}
