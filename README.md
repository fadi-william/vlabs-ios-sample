# VLabs iOS Sample

The goal of this project is to develop a sample iOS application using swift's most commonly used libraries. The iOS application connects to a mocked backend provided by the [Jsonplaceholder](https://jsonplaceholder.typicode.com/) service. The libraries that I'm going to discuss here cover the most common tasks from networking to custom layout implementation. In this sample project, I will use some of the libraries discussed here.

## Libraries

The libraries can be categorized into three sections. First, the libraries that are purely related to [ReactiveX](http://reactivex.io/) ; you may want to check the link for more information about the API and its [operators](http://reactivex.io/documentation/operators.html) that handle asynchronous data streams through functional programming. Then, the libraries used for performing asynchronous http requests, downloading and caching, managing a local data store and building forms. Finally, the libraries related to custom layout implementation.

### ReactiveX

#### RxSwift

[RxSwift](https://github.com/ReactiveX/RxSwift) is the implementation of ReactiveX for the swift programming language.

#### RxCocoa

RxCocoa is part of RxSwift. It provides a reactive API extensions to the user interface components of the Cocoa API.

#### RxDataSources

It's true that you could bind your Rx observables to your table and collection views using RxCocoa. However, you will need [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) for the collection and table views that use sections by conforming your data objects to the `SectionModelType` protocol.

#### RxGesture

[RxGestures](https://github.com/RxSwiftCommunity/RxGesture) provides an API to the user interface's view object to respond to the user's gestures reactively.

### Network  

#### Moya

One of the common tasks involved in implementing iOS applications is to perform http requests to some provided web services. [Moya](https://github.com/Moya/Moya) helps you write your http requests in an abstract and a concise way. So, you won't need to keep on writing boilerplate code. For more information, check the library's documentation.

#### Moya-ObjectMapper

[Moya-ObjectMapper](https://github.com/ivanbruel/Moya-ObjectMapper) is used to serialize your Moya's API JSON responses to actual objects. So, you won't need to serialize your object from a JSON dictionary.

### Form Implementation

#### Eureka

[Eureka](https://github.com/xmartlabs/Eureka) is a library that helps you implement forms using a tableview under the hood. It provides custom operators to help you build your form and also provides a built-in validation API.

### Image Caching

#### Kingfisher

[Kingfisher](https://github.com/onevcat/Kingfisher) is a library used to fetch and cache your downloaded images. In case you are an Android developer, it is similar to [Picasso](http://square.github.io/picasso/).

### Layout Implementation

#### LayoutKit

[LayoutKit](http://layoutkit.org) is an alternative to auto-layout that was implemented by LinkedIn for performance reasons. 

#### SnapKit

[SnapKit](https://github.com/SnapKit/SnapKit) is an API that helps you declare auto-layout constraints programmatically.

### Local Data Store

### Realm Mobile Database

[Realm mobile database](https://realm.io/products/realm-mobile-database/) is a very fast local database and it is an alternative to SQLite and Core Data.

### Theming

#### Chameleon

[Chameleon](https://github.com/ViccAlexander/Chameleon) is a flat color framework that helps you theme your iOS application easily.

## Conclusion

So, I hope that I was able to present the libraries in a concise and in an appropriate way. I encourage you to check the sample app to see an example of how some of these libraries work together. For more information, I suggest that you check the libraries' official documentation that I provided here.

Note: I believe that this is not the most appropriate architecture to build iOS applications. So, using an MVVM design pattern will be more appropriate.

## LICENSE

Copyright © 2017 LEVIOZA

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
