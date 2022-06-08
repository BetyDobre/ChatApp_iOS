import Foundation
import FirebaseStorage

///Allows to get, fetch and upload files to Firebase Storage
final class StorageManager{
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    private init(){}
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    public typealias UploadVideoCompletion = (Result<String, Error>) -> Void
    
    /// Uploads picture to firebase storage and return completion with url string to download
    public func uploadProfilePicture(with data:Data, fileName: String, completion: @escaping UploadPictureCompletion ){
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download URL returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    ///Downloads the url from a specified path
    public func downloadURL(for path: String, completion: @escaping (Result<String, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            completion(.success(url.absoluteString))
        })
    }
    
    /// Upload image that will be sent in a conversation message
    public func uploadPhotoMessage(with data:Data, fileName: String, completion: @escaping UploadPictureCompletion ){
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download URL returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    ///Upload video that will be sent in a conversation message
    public func uploadVideoMessage(with fileUrl: URL, fileName: String, completion: @escaping UploadVideoCompletion ){
        if let videoData = NSData(contentsOf: fileUrl) as Data? {
        storage.child("message_videos/\(fileName)").putData(videoData, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                print("Failed to upload video file")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            
            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download URL returned: \(urlString)")
                completion(.success(urlString))
            })
        })
        }
    }
    
    public enum StorageErrors: Error{
        case failedToUpload
        case failedToGetDownloadURL
    }}
