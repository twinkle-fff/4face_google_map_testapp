# google_map_testapp

これはflutterでgoogleMap連携appを作成するテストアップです。

jsonを読み取り、地図上に表示します。

location.dart内のjsonURLを変更することでテストデータを変更できます。

対応json形式
{places:[{name:(地名),lat:(緯度),lng(経度),num:(match数)},{name:(地名),lat:(緯度),lng(経度),num:(match数)},...,{name:(地名),lat:(緯度),lng(経度),num:(match数)}]}

未済事項：
アイコン選択時の挙動,遷移,詳細表示,場所選択など
zoom制限,
分割読み取り,
zoom時の挙動
アイコンサイズなど,デザイン,
mapAPI上の表示作成
他


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




