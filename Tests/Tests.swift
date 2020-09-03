// https://github.com/Quick/Quick

import Quick
import Nimble
import ImageKitIO
import Alamofire

let apiVersion: String = API_VERSION;

class URLGenerationSpec: QuickSpec {
    
    override func spec() {
        
        beforeSuite {
            _ = ImageKit.init(clientPublicKey: "Dummy public key", imageKitEndpoint: "https://ik.imagekit.io/demo", transformationPosition: TransformationPosition.PATH)
        }
        
        it("Overriding urlEndpoint Parameter"){
            let actual = ImageKit.shared
                .url(urlEndpoint: "https://ik.imagekit.io/modified_imagekitid", path: "medium_cafe_B1iTdD0C.jpg")
                .create()
            expect(actual).to(equal(String(format:"https://ik.imagekit.io/modified_imagekitid/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
        }
        
        it("Removal of double slashes in urlEndpoint"){
            let actual = ImageKit.shared
                .url(urlEndpoint: "https://ik.imagekit.io/demo/", path: "medium_cafe_B1iTdD0C.jpg")
                .create()
            expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
        }
        
        it("Removal of double slashes in path"){
            let actual = ImageKit.shared
                .url(urlEndpoint: "https://ik.imagekit.io/demo/", path: "/medium_cafe_B1iTdD0C.jpg")
                .create()
            expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
        }
        
        it("New transformation parameter"){
            let actual = ImageKit.shared
                .url(urlEndpoint: "https://ik.imagekit.io/demo", path: "medium_cafe_B1iTdD0C.jpg")
                .addCustomTransformation(key: "test", value: "test")
                .create()
            expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:test-test/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
        }
        
        it("SDK Version as Query Parameter"){
            let actual = ImageKit.shared
                .url(urlEndpoint: "https://ik.imagekit.io/demo", path: "medium_cafe_B1iTdD0C.jpg")
                .create()
            expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
        }
        
        it("Query Transformations") {
            let actual = ImageKit.shared
                .url(path: "medium_cafe_B1iTdD0C.jpg", transformationPosition: TransformationPosition.QUERY)
                .width(width: 300)
                .height(height: 300)
                .create()
            expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@&tr=w-300,h-300", apiVersion)))
        }
        
        it("Chained Transformation"){
            let actual = ImageKit.shared
                .url(urlEndpoint: "https://ik.imagekit.io/demo", path: "medium_cafe_B1iTdD0C.jpg")
                .height(height: 300)
                .chainTransformation()
                .rotation(rotation: Rotation.VALUE_90)
                .create()
            expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:h-300:rt-90/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
        }
        
        it("Source URL"){
            let actual = ImageKit.shared
                .url(src: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg")
                .create()
            expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
        }
        
        it("Custom Query Parameter"){
            let actual = ImageKit.shared
                .url(src: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg")
                .addCustomQueryParameter(key: "x-test-header", value: "Test")
                .create()
            expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@&x-test-header=Test", apiVersion)))
        }
        
        it("Source URL with Path Transforms") {
            let actual = ImageKit.shared
                .url(src: "https://ik.imagekit.io/demo/tr:h-300.00,w-300.00:rt-90/medium_cafe_B1iTdD0C.jpg")
                .height(height: 300)
                .width(width: 300)
                .chainTransformation()
                .rotation(rotation: Rotation.VALUE_90)
                .create()
            expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@&tr=h-300,w-300:rt-90", apiVersion)))
        }
        
        it("Custom Query Parameter with Transforms") {
            let actual = ImageKit.shared
                .url(src: "https://ik.imagekit.io/demo/tr:h-300.00,w-300.00:rt-90/medium_cafe_B1iTdD0C.jpg")
                .height(height: 300)
                .width(width: 300)
                .chainTransformation()
                .rotation(rotation: Rotation.VALUE_90)
                .addCustomQueryParameters(params: ["x-test-header": "Test"])
                .create()
            expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@&tr=h-300,w-300:rt-90&x-test-header=Test", apiVersion)))
        }
}

class UnitTestSpec : QuickSpec{
    override func spec(){
        describe("Basic URL Generation"){
                   it("Path") {
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Url Endpoint and Path") {
                       let actual = ImageKit.shared
                           .url(urlEndpoint: "https://ik.imagekit.io/demo", path: "medium_cafe_B1iTdD0C.jpg")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Source"){
                       let actual = ImageKit.shared
                           .url(src: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg")
                           .create()
                       expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
               }

               describe("Transformations") {
                   it("Width: 300"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .width(width: 300)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:w-300/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Height: 300"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .height(height: 300)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:h-300/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Aspect Ratio: 2 by 3"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .aspectRatio(width: 2, height: 3)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ar-2-3/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Crop: maintain_ratio"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .crop(cropType: CropType.MAINTAIN_RATIO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:c-maintain_ratio/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Crop: force"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .crop(cropType: CropType.FORCE)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:c-force/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Crop: at_least"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .crop(cropType: CropType.AT_LEAST)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:c-at_least/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Crop: at_max"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .crop(cropType: CropType.AT_MAX)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:c-at_max/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Crop Mode: resize"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .cropMode(cropMode: .RESIZE)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:cm-resize/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Crop Mode: extract"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .cropMode(cropMode: .EXTRACT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:cm-extract/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Crop Mode: pad_extract"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .cropMode(cropMode: .PAD_EXTRACT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:cm-pad_extract/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Crop Mode: pad_resize"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .cropMode(cropMode: .PAD_RESIZE)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:cm-pad_resize/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: center"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .CENTER)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-center/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: top"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .TOP)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-top/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: left"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .LEFT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-left/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: bottom"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .BOTTOM)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-bottom/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: right"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .RIGHT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-right/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: top_left"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .TOP_LEFT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-top_left/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: top_right"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .TOP_RIGHT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-top_right/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: bottom_left"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .BOTTOM_LEFT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-bottom_left/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: bottom_right"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .BOTTOM_RIGHT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-bottom_right/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Focus Type: auto"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .focus(focusType: .AUTO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:fo-auto/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Quality: 50"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .quality(quality: 50)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:q-50/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Format: auto"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .format(format: .AUTO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:f-auto/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Format: webp"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .format(format: .WEBP)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:f-webp/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Format: jpg"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .format(format: .JPG)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:f-jpg/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Format: jpeg"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .format(format: .JPEG)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:f-jpeg/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Format: png"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .format(format: .PNG)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:f-png/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Blur: 50"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .blur(blur: 50)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:bl-50/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Grayscale"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .effectGray(flag: true)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:e-grayscale/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("DPR: 2.5"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .dpr(dpr: 2.5)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:dpr-2.50/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Named Transform: test"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .named(namedTransformation: "test")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:n-test/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Default Image: medium_cafe_B1iTdD0C.jpg"){
                       let actual = ImageKit.shared
                           .url(path: "non_existent_image.jpg")
                           .defaultImage(defaultImage: "medium_cafe_B1iTdD0C.jpg")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:di-medium_cafe_B1iTdD0C.jpg/non_existent_image.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Progressive"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .progressive(flag: true)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:pr-true/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Lossless"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .lossless(flag: true)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:l-true/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Trim"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .trim(flag: true)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:t-true/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Trim: 50"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .trim(value: 50)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:t-50/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Image: logo-white_SJwqB4Nfe.png"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: center"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .CENTER)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-center/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: top"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .TOP)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-top/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: left"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .LEFT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-left/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: bottom"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .BOTTOM)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-bottom/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: right"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .RIGHT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-right/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: top_left"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .TOP_LEFT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-top_left/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: top_right"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .TOP_RIGHT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-top_right/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: bottom_left"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .BOTTOM_LEFT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-bottom_left/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Focus: bottom_right"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayFocus(overlayFocus: .BOTTOM_RIGHT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ofo-bottom_right/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay X: 50"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayX(overlayX: 50)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ox-50/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Y: 50"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayY(overlayY: 50)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,oy-50/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Width: 50"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayWidth(overlayWidth: 50)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,ow-50/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Height: 50"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayImage(overlayImage: "logo-white_SJwqB4Nfe.png")
                           .overlayHeight(overlayHeight: 50)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:oi-logo-white_SJwqB4Nfe.png,oh-50/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Text: overlay made easy"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Text Color: 00AAFF55"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextColor(overlayTextColor: "00AAFF55")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otc-00AAFF55/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: AbrilFatFace"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .ABRIL_FAT_FACE)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-AbrilFatFace/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Amarnath"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .AMARANTH)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Amarnath/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Arvo"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .ARVO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Arvo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Audiowide"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .AUDIOWIDE)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Audiowide/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: exo"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .EXO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-exo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: FredokaOne"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .FREDOKA_ONE)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-FredokaOne/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Kanit"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .KANIT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Kanit/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Lato"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .LATO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Lato/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Lobster"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .LOBSTER)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Lobster/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Lora"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .LORA)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Lora/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Monoton"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .MONOTON)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Monoton/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Montserrat"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .MONTSERRAT)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Montserrat/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: PT_Mono"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .PT_MONO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-PT_Mono/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: PT_Serif"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .PT_SERIF)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-PT_Serif/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: OpenSans"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .OPEN_SANS)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-OpenSans/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Roboto"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .ROBOTO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Roboto/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: stagOldStandard"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .STAG_OLD_STANDARD)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-stagOldStandard/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Ubuntu"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .UBUNTU)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Ubuntu/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Family: Vollkorn"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontFamily(overlayTextFontFamily: .VOLLKORN)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,otf-Vollkorn/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Font Size: 45"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextFontSize(overlayTextSize: 45)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,ots-45/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Text Typography: Bold"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextTypography(overlayTextTypography: .BOLD)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,ott-b/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Text Typography: Italics"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextTypography(overlayTextTypography: .ITALICS)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,ott-i/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Text Typography: Bold Italics"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayTextTypography(overlayTextTypography: .BOLD_ITALICS)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,ott-bi/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Text Alpha: 5"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayText(overlayText: "overlay made easy")
                           .overlayAlpha(overlayAlpha: 5)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:ot-overlay%%20made%%20easy,oa-5/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Overlay Background: 00AAFF55"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .overlayBackground(overlayBackground: "00AAFF55")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:obg-00AAFF55/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Color Profile"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .colorProfile(flag: true)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:cp-true/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Metadata"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .metadata(flag: true)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:md-true/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Rotation: auto"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .rotation(rotation: .AUTO)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:rt-auto/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Rotation: 0"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .rotation(rotation: .VALUE_0)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:rt-0/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Rotation: 90"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .rotation(rotation: .VALUE_90)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:rt-90/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Rotation: 180"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .rotation(rotation: .VALUE_180)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:rt-180/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Rotation: 270"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .rotation(rotation: .VALUE_270)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:rt-270/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Rotation: 360"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .rotation(rotation: .VALUE_360)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:rt-360/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Radius: 5"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .radius(radius: 5)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:r-5/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Round"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .round()
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:r-max/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Background: 00AAFF55"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .background(backgroundColor: "00AAFF55")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:bg-00AAFF55/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Border: 5, 00AAFF55"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .border(borderWidth: 5, borderColor: "00AAFF55")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:b-5_00AAFF55/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Contrast"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .effectContrast(flag: true)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:e-contrast/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Sharpen: 5"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .effectSharpen(value: 5)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:e-sharpen-5/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("USM"){
                       let actual = ImageKit.shared
                           .url(path: "medium_cafe_B1iTdD0C.jpg")
                           .effectUSM(radius: 5, sigma: 5, amount: 5, threshold: 5)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:e-usm-5.00-5.00-5.00-5.00/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Chain Transformation"){
                       let actual = ImageKit.shared
                           .url(urlEndpoint: "https://ik.imagekit.io/demo", path: "medium_cafe_B1iTdD0C.jpg")
                           .height(height: 300)
                           .chainTransformation()
                           .rotation(rotation: Rotation.VALUE_90)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:h-300:rt-90/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Custom Transfomation: w 300"){
                       let actual = ImageKit.shared
                           .url(urlEndpoint: "https://ik.imagekit.io/demo", path: "medium_cafe_B1iTdD0C.jpg")
                           .addCustomTransformation(key: "w", value: "300")
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:w-300/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
               }

               describe("Image Path with Transformations height: 300, width: 300 and rotate: 90"){
                   it("Path Transformations") {
                       let actual = ImageKit.shared
                           .url(urlEndpoint: "https://ik.imagekit.io/demo", path: "medium_cafe_B1iTdD0C.jpg")
                           .height(height: 300)
                           .width(width: 300)
                           .chainTransformation()
                           .rotation(rotation: Rotation.VALUE_90)
                           .create()
                       expect(actual).to(equal(String(format:"https://ik.imagekit.io/demo/tr:h-300,w-300:rt-90/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@", apiVersion)))
                   }
                   it("Query Transformations") {
                       let actual = ImageKit.shared
                           .url(urlEndpoint: "https://ik.imagekit.io/demo", path: "medium_cafe_B1iTdD0C.jpg", transformationPosition: TransformationPosition.QUERY)
                           .height(height: 300)
                           .width(width: 300)
                           .chainTransformation()
                           .rotation(rotation: Rotation.VALUE_90)
                           .create()
                       expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@&tr=h-300,w-300:rt-90", apiVersion)))
                   }
               }
               describe("Src with Transformations height: 300, width: 300 and rotate: 90"){
                   it("Without Transforms") {
                       let actual = ImageKit.shared
                           .url(src: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg")
                           .height(height: 300)
                           .width(width: 300)
                           .chainTransformation()
                           .rotation(rotation: Rotation.VALUE_90)
                           .create()
                       expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@&tr=h-300,w-300:rt-90", apiVersion)))
                   }
                   it("With Path Transforms") {
                       let actual = ImageKit.shared
                           .url(src: "https://ik.imagekit.io/demo/tr:h-300.00,w-300.00:rt-90/medium_cafe_B1iTdD0C.jpg")
                           .height(height: 300)
                           .width(width: 300)
                           .chainTransformation()
                           .rotation(rotation: Rotation.VALUE_90)
                           .create()
                       expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@&tr=h-300,w-300:rt-90", apiVersion)))
                   }
                   it("With Query Transforms") {
                       let actual = ImageKit.shared
                           .url(src: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?tr=h-300.00,w-300.00:rt-90")
                           .height(height: 300)
                           .width(width: 300)
                           .chainTransformation()
                           .rotation(rotation: Rotation.VALUE_90)
                           .create()
                       expect(actual).to(equal(String(format: "https://ik.imagekit.io/demo/medium_cafe_B1iTdD0C.jpg?ik-sdk-version=ios-%@&tr=h-300,w-300:rt-90", apiVersion)))
                   }
               }
           }
    }
}

class MimeDetectorSpec : QuickSpec{
    override func spec(){
        describe(".readBytes()") {
          context("when we want to read 4 bytes of string data") {
            let str = "hello"
            let data = str.data(using: .utf8)!
            let mimeDetector = MimeDetector(data: data)
            let bytes = mimeDetector.readBytes(count: 4)

            it("should return 4 bytes") {
              expect(bytes.count) == 4
            }

            it("should return correct bytes") {
              let endIndex = str.index(str.startIndex, offsetBy: 4)
              let substr = str[..<endIndex]
              let expectation = [UInt8](substr.utf8)

              expect(bytes) == expectation
            }
          }
        }

        describe("MimeDetector.mimeType(data:)") {
          let extensions = [
            "7z",
            "amr",
            "ar",
            "avi",
            "bmp",
            "bz2",
            "cab",
            "cr2",
            "crx",
            "deb",
            "dmg",
            "eot",
            "epub",
            "exe",
            "flac",
            "flif",
            "flv",
            "gif",
            "ico",
            "jpg",
            "jxr",
            "m4a",
            "m4v",
            "mid",
            "mkv",
            "mov",
            "mp3",
            "mp4",
            "mpg",
            "msi",
            "mxf",
            "nes",
            "ogg",
            "opus",
            "otf",
            "pdf",
            "png",
            "ps",
            "psd",
            "rar",
            "rpm",
            "rtf",
            "sqlite",
            "swf",
            "tar",
            "tar.Z",
            "tar.gz",
            "tar.lz",
            "tar.xz",
            "ttf",
            "wav",
            "webm",
            "webp",
            "wmv",
            "woff",
            "woff2",
            "xpi",
            "zip"
          ]

          let mimeTypeByExtension = [
            "tar.Z": "application/x-compress",
            "tar.gz": "application/gzip",
            "tar.lz": "application/x-lzip",
            "tar.xz": "application/x-xz"
          ]

          for ext in extensions {
            context("when extension is \(ext)") {
              it("shoud guess the correct mime type") {
                let data = loadFileData(path: "/Tests/fixtures/fixture.\(ext)")
                let mimeType = MimeDetector.mimeType(data: data)

                if let mime = mimeTypeByExtension[ext] {
                  expect(mimeType?.mime) == mime
                } else {
                  expect(mimeType?.ext) == ext
                }
              }
            }
          }
        }

        describe("MimeDetector.mimeType(bytes:)") {
          context("when given jpeg bytes") {
            it("should return image/jpeg mime type") {
              let bytes: [UInt8] = [255, 216, 255]
              let mimeType = MimeDetector.mimeType(bytes: bytes)

              expect(mimeType?.mime) == "image/jpeg"
            }
          }

          context("when given 7z bytes") {
            it("should return application/x-7z-compressed") {
              let bytes: [UInt8] = [55, 122, 188, 175, 39, 28]
              let mimeType = MimeDetector.mimeType(bytes: bytes)

              expect(mimeType?.mime) == "application/x-7z-compressed"
            }
          }
        }

        describe("MimeDetector.mimeType(bytes:).type") {
          context("when file type is image/jpeg") {
            it("should return true") {
              let data: Data = loadFileData(path: "/Tests/fixtures/fixture.jpg")
              let mimeType = MimeDetector.mimeType(data: data)

              expect(mimeType?.type) == .jpg
            }
          }

          context("when file type is application/pdf") {
            it("should return true") {
              let data: Data = loadFileData(path: "/Tests/fixtures/fixture.pdf")
              let mimeType = MimeDetector.mimeType(data: data)

              expect(mimeType?.type) == .pdf
            }
          }

          context("when file type is not image/jpeg") {
            it("should return true") {
              let data: Data = loadFileData(path: "/Tests/fixtures/fixture.png")
              let mimeType = MimeDetector.mimeType(data: data)

              expect(mimeType?.type) != .jpg
            }
          }
        }
    }
}

func loadFileData(path: String) -> Data {
    let projectDir = URL(fileURLWithPath: #file).pathComponents.prefix(while: { $0 != "Tests" }).joined(separator: "/").dropFirst()
    print(projectDir)
    let absolutePath = "\(projectDir)\(path)"
    print(absolutePath)
    let url = URL(fileURLWithPath: absolutePath, isDirectory: false)
    return try! Data(contentsOf: url)
}