
#import <Foundation/Foundation.h>


@interface ValidationManager : NSObject {

}

////////***************** VALIDATE INPUT STRINGS Methods *************** //////////////

// Validate email id URL's
+ (BOOL) validateEmailID:(NSString *)emailId;

// Validate Name Strings
+ (BOOL) validateNameStrings:(NSString *)nameString;

// Validate Phone Number Strings
+ (BOOL) validatePhoneNumber:(NSString *)phoneNumber ;

// Validate Note Strings
+ (BOOL) validateNoteStrings:(NSString *)noteString;

// Validate ZIP Strings
+ (BOOL) validateZipCode:(NSString *)zipCode ;

// Validate Number Strings
+ (BOOL) validateNumber:(NSString *)numString ;

// Validate password Strings
+ (BOOL) validatePassword:(NSString *)password ;

// Validate username Strings
+ (BOOL) validateUsername:(NSString *)username;

// Validate US SSN number
+ (BOOL) validateSSNNumber:(NSString *)ssnNumberString;

// Validate Web URL
+ (BOOL) validateWebURL:(NSString *)webURL;

// Validate Credit card numbers
+ (BOOL) validateCreditCardNumberString:(NSString *)creditCardNumber;

@end
