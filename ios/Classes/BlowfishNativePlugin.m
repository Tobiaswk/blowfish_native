#import "BlowfishNativePlugin.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation BlowfishNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"blowfish_native"
            binaryMessenger:[registrar messenger]];
  BlowfishNativePlugin* instance = [[BlowfishNativePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray *arguments = [call arguments];
    if ([@"encrypt" isEqualToString:call.method]) {
        NSData *encrypted = [self doBlowfish:arguments[1] context:kCCEncrypt key:arguments[0] options:kCCOptionPKCS7Padding | kCCOptionECBMode iv:nil error:nil];
        result([encrypted base64EncodedStringWithOptions:0]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}
//https://stackoverflow.com/questions/30860101/how-to-implement-blowfish-ecb-algorithm-pkcs5-padding-in-ios
- (NSData *)doBlowfish:(NSData *)dataIn
               context:(CCOperation)kCCEncrypt_or_kCCDecrypt
                   key:(NSData *)key
               options:(CCOptions)options
                    iv:(NSData *)iv
                 error:(NSError **)error
{
    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeBlowfish];

    ccStatus = CCCrypt( kCCEncrypt_or_kCCDecrypt,
                       kCCAlgorithmBlowfish,
                       options,
                       key.bytes,
                       key.length,
                       (iv)?nil:iv.bytes,
                       dataIn.bytes,
                       dataIn.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);

    if (ccStatus == kCCSuccess) {
        dataOut.length = cryptBytes;
    }
    else {
        if (error) {
            *error = [NSError errorWithDomain:@"kEncryptionError"
                                         code:ccStatus
                                     userInfo:nil];
        }
        dataOut = nil;
    }

    return dataOut;
}

@end
