//
//  DataStructure.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 12/27/16.
//  Copyright © 2016 Nguyen Nguyen. All rights reserved.
//

import Foundation

struct DataStructure {
    
    /* Have keys as constants to prevent spelling errors
     * and avoid confusion. eg. "title" can be found in
     * ViewControllers too, so places can exist where the
     * particular string is used for something else.
     */
    static let kTaskTitleKey = "title"
    static let kTaskCompletedKey = "completed"
    static let kTaskUserKey = "user"
    
    let title: String
    let user: String
    // let firebaseReference: FIRDatabaseReference?
    var completed: Bool
    
    /* Initializer for instantiating a new object in code.
     */
    init(title: String, user: String, completed: Bool, id: String = "") {
        self.title = title
        self.user = user
        self.completed = completed
        // self.firebaseReference = nil
    }
    
    /* Method to help updating values of an existing object.
     */
    func toDictionary() -> Dictionary<String, Any> {
        return [
            DataStructure.kTaskTitleKey: self.title,
            DataStructure.kTaskUserKey: self.user,
            DataStructure.kTaskCompletedKey: self.completed
        ]
    }
    
    func toJSON2() -> Any {
        return toDictionary().toJSON()
    }
    
    
}
