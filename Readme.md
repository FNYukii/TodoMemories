## Todo Memories
## 概要
iOS向けのTodo管理アプリです。
Realmを使用しており、データはデバイス内に保存されます。
Apple純正アプリのような、シンプルなインターフェースを実装しています。


## 特徴
アプリに登録したTodoはいつでも内容を確認したり、優先順位を変更したりできます。
またTodoを達成済みとして保存することができ、過去に達成したTodoを閲覧ことができます。
日々の生活で達成したTodoを振り返ることで、達成感や充実感を獲得することにつながります。

## 思い出
2021年6月にMacBookを購入して以来、少しずつiOSアプリ開発をを学んでいた私は、「**私生活で使えるくらい実用的なTodoアプリを作りたい!**」と考えていました。
モバイルデータベースである[Realm](https://github.com/realm/realm-swift)の使い方に慣れてきた私は、2021年10月、この**Todo Memories**の開発に取り掛かりました。

私生活で使えるアプリ制作が目標なので、実際にアプリを日常で使いながら生活し、**感じた課題をもとに改良を重ねながら開発しました**。
[Todo Diaries](https://github.com/Yu357/TodoDiaries)の開発を始める2022年2月までの4ヶ月間、このTodo Memoriesを私生活で使いながら改良を重ねる、そんな日々を送っていました。

2022年6月現在、Todo Diariesの開発で得たノウハウをもとに、このTodo Memoriesの改修を行なっています。
放置されていたバグを修正し、UIの刷新を行い、英語と日本語へのローカライズにも対応しました。
今も私生活でこのアプリを使用しているので、課題が見つかるたびにブラッシュアップを重ねたいと思っています。

## フレームワーク・ライブラリ
- [Realm](https://github.com/realm/realm-swift)
- [Charts](https://github.com/danielgindi/Charts)
- [Introspect](https://github.com/siteline/SwiftUI-Introspect)

## スクリーンショット
<div style="display: flex; justify-content: space-between;">
  <img style="display: block; width: 30%;" src="https://user-images.githubusercontent.com/65577595/174990185-d91a826c-3e04-41be-9df7-da0beb690c98.png"/>
  <img style="display: block; width: 30%;" src="https://user-images.githubusercontent.com/65577595/174990200-7a9f9d23-85b2-457b-80a8-629410d06ed7.png"/>
  <img style="display: block; width: 30%;" src="https://user-images.githubusercontent.com/65577595/174990215-fd7cba42-5019-4abe-a4ec-17337ee44800.png"/>
</div>
