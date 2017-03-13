//
//  ResponseBuilder.swift
//  Smoke
//
//  Created by Ondrej Rafaj on 27/11/2016.
//  Copyright © 2016 manGoweb UK Ltd. All rights reserved.
//

import Vapor
import HTTP
import Fluent


struct ResponseBuilder {
    
    
    // MARK: Response builders
    
    static func build<M: Model>(model: M, statusCode: StatusCodes = .success) -> ResponseRepresentable {
        do {
            let status: Status = .other(statusCode: statusCode.rawValue, reasonPhrase: Lang.get("Success"))
            let response: Response = try Response.init(status: status, json: JSON(model.makeNode()))
            response.headers["Content-Type"] = "application/json"
            response.headers["Access-Control-Allow-Origin"] = "*"
            return response
        }
        catch {
            return self.internalServerError
        }
    }
    
    static func build(json: JSON, statusCode: StatusCodes = .success) -> ResponseRepresentable {
        do {
            let status: Status = .other(statusCode: statusCode.rawValue, reasonPhrase: Lang.get("Success"))
            let response: Response = try Response.init(status: status, json: json)
            response.headers["Content-Type"] = "application/json"
            response.headers["Access-Control-Allow-Origin"] = "*"
            return response
        }
        catch {
            return self.internalServerError
        }
    }
    
    static func build(node: Node, statusCode: StatusCodes = .success) -> ResponseRepresentable {
        do {
            let status: Status = .other(statusCode: statusCode.rawValue, reasonPhrase: Lang.get("Success"))
            let response: Response = try Response.init(status: status, json: JSON(node))
            response.headers["Content-Type"] = "application/json"
            response.headers["Access-Control-Allow-Origin"] = "*"
            return response
        }
        catch {
            return self.internalServerError
        }
    }
    
    // MARK: Validation responses
    
    static func validationErrorResponse(errors: [ValidationError]) -> ResponseRepresentable {
        do {
            let status: Status = .other(statusCode: StatusCodes.preconditionNotMet.rawValue, reasonPhrase: Lang.get("Validation error"))
            var formattedErrors: [Node] = []
            for e: ValidationError in errors {
                let errorDetailNode = try ["type": e.validationType.rawValue, "localized": e.errorMessage].makeNode()
                let errorNode = try [e.name: errorDetailNode].makeNode()
                formattedErrors.append(errorNode)
            }
            let response: Response = try Response.init(status: status, json: JSON(formattedErrors.makeNode()))
            response.headers["Content-Type"] = "application/json"
            response.headers["Access-Control-Allow-Origin"] = "*"
            return response
        }
        catch {
            return self.internalServerError
        }
    }
    
    // MARK: Default responses
    
    static func customErrorResponse(statusCode code: StatusCodes, message: String, bodyMessage: String? = nil) -> ResponseRepresentable {
        let response = Response(status: .other(statusCode: code.rawValue, reasonPhrase: message))
        response.headers["Content-Type"] = "application/json"
        response.body = try! Body(JSON(["error": (bodyMessage != nil ? bodyMessage! : message).makeNode()]))
        response.headers["Access-Control-Allow-Origin"] = "*"
        return response
    }
    
    static var ping: ResponseRepresentable {
        get {
            let response = Response(status: .other(statusCode: StatusCodes.successNoData.rawValue, reasonPhrase: Lang.get("Johnny 5 is Alive")))
            response.headers["Content-Type"] = "application/json"
            response.headers["Access-Control-Allow-Origin"] = "*"
            return response
        }
    }
    
    static var okNoContent: ResponseRepresentable {
        get {
            let response = Response(status: .other(statusCode: StatusCodes.successNoData.rawValue, reasonPhrase: Lang.get("Success")))
            response.headers["Content-Type"] = "application/json"
            response.headers["Access-Control-Allow-Origin"] = "*"
            return response
        }
    }
    
    static func cors(_ request: Request) -> ResponseRepresentable {
        let response = Response(status: .other(statusCode: StatusCodes.success.rawValue, reasonPhrase: Lang.get("CORS success")))
        response.headers["Content-Type"] = "application/json"
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
        var headers: [String] = []
        var isContentType: Bool = false
        for headerKey in request.headers.keys {
            if (headerKey.key.lowercased() == "content-type") {
                isContentType = true
            }
            headers.append(headerKey.key)
        }
        if !isContentType {
            headers.append("Content-Type")
        }
        headers.append("*")
        if !headers.contains("X-AuthToken") {
            headers.append("X-AuthToken")
        }
        response.headers["Access-Control-Allow-Headers"] = headers.joined(separator: ",")
        response.headers["Access-Control-Max-Age"] = "400"
        return response
    }
    
    static var notFound: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .notFound, message: Lang.get("Not found"))
        }
    }
    
    static var appNotFound: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .notFound, message: Lang.get("Application not found"))
        }
    }
    
    static var emailExists: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .notAuthorised, message: Lang.get("Email already registered"))
        }
    }
    
    static var notAuthorised: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .notAuthorised, message: Lang.get("Not authorised"))
        }
    }
    
    static var awsNotAuthorised: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .notAuthorised, message: Lang.get("Not authorised to access AWS"))
        }
    }
    
    static var actionFailed: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .forbidden, message: Lang.get("Action failed"))
        }
    }
    
    static var incompleteData: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .preconditionNotMet, message: Lang.get("Incomplete data"))
        }
    }
    
    static var teapot: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .teapot, message: Lang.get("I'm a teapot"))
        }
    }
    
    static var internalServerError: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .internalServerError, message: Lang.get("Fuck!"), bodyMessage: Lang.get("Internal server error"))
        }
    }
    
    static var notImplemented: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .notFound, message: Lang.get("Stumbling?"), bodyMessage: Lang.get("Not implemented"))
        }
    }
    
    static var selfHarm: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .forbidden, message: Lang.get("Self harming?!"), bodyMessage: Lang.get("Don't do this to yourself!"))
        }
    }
    
    static var setupLocked: ResponseRepresentable {
        get {
            return self.customErrorResponse(statusCode: .forbidden, message: Lang.get("Go away!"), bodyMessage: Lang.get("Setup has been locked"))
        }
    }
    
}
