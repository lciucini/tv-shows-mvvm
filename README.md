# Tv Show App - MVVM + RxSwift

This app is created for learning and job interviews purposes.

Overview

The main approach was use MVVM pattern and Reactive interactions, this first think in mi mind was SwiftUI and Combine o similar technologies. But this approach have one problem, the compatibility for this case I decide use the next technologies stack:

- UIKit  + AutoLayout + Xibs (this approach is very help-full in teams whit many people).
- RxSwift + RxCocoa.
- SQLite + GRDB.
- Repositories for isolate third party libs and features of the Business Logic.

Get Started

1: Install cocoa pods in your mac os

2: in the main folder run 

```json
pod install
```

3: open the .xcworkspace and build project

### NetworkManager

This layer is a wrapper of  URLSession made for implement RxSwift observables , for this particular case it should be more than appropriate. For escalation this app should be considerate implement Real or Core Data. 

### AppDataBase

This class use GRDB pod for store an list of Tv Shows than users was subscribed inside this app.

### Extensions

This folder group some util extensions for simplify some properties manipulations for example:

- Set font and color of UILabel
- Add aditional static properties for UIColor whit our custom pallete
- Set gradient for a UIView
- and other extension features

### Commons

Common folder groups all components or classes that are frequently used for one or more components.

For Example: a BaseViewController, CustomButtons and one SchedulerProvider 

### Model

In this folder are the main components of our app, such as: NetworkManager,  AppDataBase, ApiServices, Repositories, Repositories Implementations, DataModels, etc.

### List, Search, Detail

This folders have the same scaffolding

```json
---- List
------ ViewModel
------ View
------ ...
```

This approach is focused on scaling the functions of our application, this in the future will help to scale our logic in modules. But this approach, as it happens in this case, we will notice that we have a lot of duplicate code. This is not typical of the design pattern, if it is not the responsibility of the developer it is my fault. In the next iterations shloud be refactor some viewModels for use better.