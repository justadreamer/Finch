//
//  ColorDefs.h
//  Finch
//
//  Created by Eugene Dorfman on 3/10/13.
//
//

#ifndef Finch_ColorDefs_h
#define Finch_ColorDefs_h
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


#define COLOR_NAV_BACKGROUND RGB(190,223,253)
#define COLOR_TABLE_BACKGROUND RGB(217.0,233.0,238.0)
#define COLOR_FINCH_TITLE RGB(14.0,149.0,181.0)
#define COLOR_SECTION_HEADER_TITLE RGB(76,86,110)
#define NAV_TEXT_ATTRIBUTES @{UITextAttributeTextColor:COLOR_FINCH_TITLE,UITextAttributeTextShadowOffset:[NSValue valueWithCGPoint:CGPointMake(0,0)]}
#endif
