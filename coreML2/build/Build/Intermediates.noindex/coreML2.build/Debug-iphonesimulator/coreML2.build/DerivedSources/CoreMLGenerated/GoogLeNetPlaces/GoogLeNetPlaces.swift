//
// GoogLeNetPlaces.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GoogLeNetPlacesInput : MLFeatureProvider {

    /// Input image of scene to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
    var sceneImage: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["sceneImage"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "sceneImage") {
            return MLFeatureValue(pixelBuffer: sceneImage)
        }
        return nil
    }
    
    init(sceneImage: CVPixelBuffer) {
        self.sceneImage = sceneImage
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GoogLeNetPlacesOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// Probability of each scene as dictionary of strings to doubles
    lazy var sceneLabelProbs: [String : Double] = {
        [unowned self] in return self.provider.featureValue(for: "sceneLabelProbs")!.dictionaryValue as! [String : Double]
    }()

    /// Most likely scene label as string value
    lazy var sceneLabel: String = {
        [unowned self] in return self.provider.featureValue(for: "sceneLabel")!.stringValue
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(sceneLabelProbs: [String : Double], sceneLabel: String) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["sceneLabelProbs" : MLFeatureValue(dictionary: sceneLabelProbs as [AnyHashable : NSNumber]), "sceneLabel" : MLFeatureValue(string: sceneLabel)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class GoogLeNetPlaces {
    var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: GoogLeNetPlaces.self)
        return bundle.url(forResource: "GoogLeNetPlaces", withExtension:"mlmodelc")!
    }

    /**
        Construct a model with explicit path to mlmodelc file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration
        - parameters:
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct a model with explicit path to mlmodelc file and configuration
        - parameters:
           - url: the file url of the model
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
        self.model = try MLModel(contentsOf: url, configuration: configuration)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as GoogLeNetPlacesInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as GoogLeNetPlacesOutput
    */
    func prediction(input: GoogLeNetPlacesInput) throws -> GoogLeNetPlacesOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as GoogLeNetPlacesInput
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as GoogLeNetPlacesOutput
    */
    func prediction(input: GoogLeNetPlacesInput, options: MLPredictionOptions) throws -> GoogLeNetPlacesOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return GoogLeNetPlacesOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - sceneImage: Input image of scene to be classified as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as GoogLeNetPlacesOutput
    */
    func prediction(sceneImage: CVPixelBuffer) throws -> GoogLeNetPlacesOutput {
        let input_ = GoogLeNetPlacesInput(sceneImage: sceneImage)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface
        - parameters:
           - inputs: the inputs to the prediction as [GoogLeNetPlacesInput]
           - options: prediction options 
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as [GoogLeNetPlacesOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [GoogLeNetPlacesInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [GoogLeNetPlacesOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [GoogLeNetPlacesOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  GoogLeNetPlacesOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
