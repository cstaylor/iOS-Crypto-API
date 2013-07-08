iOS-Crypto-API
==============

I am not a cryptography expert, but I do have several years of experience using cryptographic APIs like the
Java Cryptography Extension.

From my personal experience, I've found the iOS native cryptography options to be more of a moving target.

So, to insulate my apps from the underlying implementations, I've borrowed from the JCE and implemented several
Objective-C protocols:
- KeyGenerator: creates new SecretKey objects
- SecretKey: represents a symmetric key
- KeySpec: represents pre-existing key material for generating SecretKey objects using a SecretKeyFactory
- SecretKeyFactory: generates a SecretKey from pre-existing key material
- Cipher: represents an engine for either encrypting plaintext or decrypting ciphertext with a symmetric algorithm
          and an existing SecretKey
- RSAKey: I didn't do much to abstract this.  This should really be called "AsymmetricKey".

Note: the following examples are also included as Unit tests.

Here's some examples of what you can do:

// Generate a new AES 128-bit key using random data
NSError * error = nil;  
id<KeyGenerator> keyGen = [[AESKeyGenerator alloc] init];  
id<SecretKey> key = [keyGen generate:128 onError:&error];  

// Encrypt a NSData blob using AES CBC encryption  
NSData * plaintext = ...;  
NSError * error = nil;  
id<KeyGenerator> keyGen = [[AESKeyGenerator alloc] init];  
id<SecretKey> key = [keyGen generate:128 onError:&error];  
id<Cipher> cipher = [[AESCipher alloc] init:ENCRYPT withKey:key];  
NSMutableData * ciphertext = [NSMutableData data];  
[ciphertext appendData:[cipher update:plaintext onError:&error]];  
[ciphertext appendData:[cipher final:&error]];  
// Make sure to save the IV for later  
NSData * iv = cipher.iv;  
  


// Decrypt a NSData blob using AES CBC encryption  
NSData * ciphertext = ...;  
NSError * error = nil;  
NSData * iv = ...;  
id<KeyGenerator> keyGen = [[AESKeyGenerator alloc] init];  
id<SecretKey> key = [keyGen generate:128 onError:&error];  
id<Cipher> cipher = [[AESCipher alloc] init:DECRYPT withKey:key iv:iv];  
NSMutableData * plaintext = [NSMutableData data];  
[plaintext appendData:[cipher update:ciphertext onError:&error]];  
[plaintext appendData:[cipher final:&error]];

// Generate an AES key from a password using PBKDF2  
NSError * error = nil;  
id<KeySpec> keyspec = [[PBKDFKeySpec alloc] init:@"MyPassword"];  
id<SecretKeyFactory> factory = [[PBKDFSecretKeyFactory alloc] init];  
id<SecretKey> key = [factory generate:keyspec onError:&error];

// Retrieve RSA public key material from the application keychain and generate a new key if the existing one
// wasn't found, then encrypt an AESKey for transmission  
NSString * pub_key_in_pem_format = ...;  
NSError * error = nil;  
RSAPublicKey * rsa = [RSAPublicKey findByName:@"mykey" onError:&error];  
if ( !rsa ) {  
  error = nil;  
  rsa = [[RSAPublicKey alloc] initWithBase64:pub_key_in_pem_format name:@"mykey" onError:&error ];  
}  
id<KeyGenerator> keyGen = [[AESKeyGenerator alloc] init];  
id<SecretKey> key = [keyGen generate:128 onError:&error];  
NSData * encrypted_key = [rsa encrypt:[key key] onError:&error];
