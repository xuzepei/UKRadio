//
//  RCEncryption.h


#import <Foundation/Foundation.h>

@interface RCEncryption : NSObject

+ (NSString*)decryptUseDES:(NSString*)cipherText key:(NSString*)key;
+ (NSString*)encryptUseDES:(NSString*)clearText key:(NSString *)key;

@end
