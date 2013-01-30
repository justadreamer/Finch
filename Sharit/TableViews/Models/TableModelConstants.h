//
//  TableModelConstants.h
//  Finch
//
//  Created by Eugene Dorfman on 12/1/12.
//
//

#ifndef Finch_TableModelConstants_h
#define Finch_TableModelConstants_h

//the constant values are corresponding to the class properties - to enable serialization/deserialization

//both sections and cells:
extern NSString* const kTag;

//cells:
extern NSString* const kCellModel;
extern NSString* const kCellIdentifier;
extern NSString* const kCellStyle;
extern NSString* const kCellNibName;
extern NSString* const kCellClassName;
extern NSString* const kCellAdapter;
extern NSString* const kCellAccessoryType;
//sections:
extern NSString* const kSectionTitleForHeader;
extern NSString* const kSectionTitleForFooter;
extern NSString* const kSectionCellModels;
#endif
