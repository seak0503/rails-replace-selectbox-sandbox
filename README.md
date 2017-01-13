# Replace selectbox sandbox

[Ajaxでセレクトボックスの中身が動的に変わるRailsアプリの作り方](http://qiita.com/jnchito/items/59a5f6bea3d7be84b839)で紹介されているサンプルを自身の学習のためにコピーしたものです。

Sample app for replacing selectbox options by ajax.

![Image](http://cdn-ak.f.st-hatena.com/images/fotolife/s/seak0503/20170113/20170113183317.gif?1484300286)

## How to setup

### 要件
* ruby 2.2.6

### 1. Install PhantomJS

Poltergeist requires PhantomJS. See https://github.com/teampoltergeist/poltergeist#installing-phantomjs

```
brew install phantomjs
```

### 2. install

```
rbenv gemset create 2.2.5 replace-selectbox-sandbox

gem install bundler

bundle install --path vendor/bundle
```

### 3. Set up initial data

```
bin/rake db:create

bin/rake db:migrate db:seed
```

### 4. Run Rails server

```
rails s
```

### 5. Open browser

```
open http://localhost:3000
```

## How to run test

```
bin/rspec
```

## License

MIT license.

# Ajaxでセレクトボックスの中身が動的に変わるRailsアプリの作り方の説明

## はじめに

親のカテゴリを変更すると、子のカテゴリの中身が動的に変わるセレクトボックスってよくありますよね。

たとえばこんなやつです↓

![Image](http://cdn-ak.f.st-hatena.com/images/fotolife/s/seak0503/20170113/20170113183317.gif?1484300286)


この動きを実現するごく簡単なサンプルアプリを作ってみたので、今回はそれを紹介します。

### 対象となるRubyとRailsのバージョン

今回のサンプルアプリは以下の環境で動作します。

- Rails 4.2.1
- Ruby 2.2.1

## ざっくりとした処理の流れ

この動きを実現するためにはこういう処理の流れになります。

1. ユーザーが親カテゴリが変更する
2. JavaScriptのchangeイベントが呼ばれる
3. JavaScriptがサーバーに子カテゴリの一覧を問い合わせる
4. サーバーが子カテゴリの一覧をJSONで返す
5. JavaScriptがサーバーから子カテゴリの一覧を受け取る
6. 子カテゴリセレクトボックスの中身をサーバーから受け取った子カテゴリの一覧で置き換える

いわゆるAjaxってやつですね。
言葉にすると簡単ですが、技術的にはいろいろな要素が絡んでくるので初心者の方にとっては結構大変かもしれません。

そこで、今から動作に必要な各コードを順番に説明していきます。

## モデル

モデルはItem, Category, SubCategoryの3種類です。

```ruby
class Item < ActiveRecord::Base
  belongs_to :category
  belongs_to :sub_category
end

class Category < ActiveRecord::Base
  has_many :sub_categories, ->{ order(:id) }
end

class SubCategory < ActiveRecord::Base
  belongs_to :category
end
```

モデル図で表すとこんな感じになります。

![Screen Shot 2015-04-09 at 10.47.55.png](https://qiita-image-store.s3.amazonaws.com/0/7465/386fb41d-32b9-356f-bde4-fd89b694ff1f.png "Screen Shot 2015-04-09 at 10.47.55.png")


## ルーティング

routes.rbは以下のようになっています。

```ruby
Rails.application.routes.draw do
  resources :items
  resources :categories, only: [] do
    resources :sub_categories, only: :index
  end
  root 'items#index'
end
```

`sub_categories#index` がAjaxで呼ばれて子カテゴリの一覧を返すアクションです。

## View

Viewはslimを使って書きました。
また、Bootstrap向けのHTMLをレンダリングするために[Rails Bootstrap Forms](https://github.com/bootstrap-ruby/rails-bootstrap-forms)というgemの`bootstrap_form_for`メソッドを使っています。

```slim
= bootstrap_form_for @item do |f|
  = f.text_field :name

  - category_options = Category.order(:id).map { |c| [c.name, c.id, data: { children_path: category_sub_categories_path(c) }] }
  = f.select :category_id, category_options, { include_blank: true }, class: 'select-parent'

  - sub_categories = @item.category.try(:sub_categories) || []
  - sub_category_options = sub_categories.map { |c| [c.name, c.id] }
  = f.select :sub_category_id, sub_category_options, { include_blank: true }, class: 'select-children'

  = f.submit 'Save', class: 'btn btn-primary'
```

注目してほしいのは以下の部分です。

```slim
category_options = Category.order(:id).map { |c| 
  [c.name, c.id, data: { children_path: category_sub_categories_path(c) }] 
}
```

セレクトボックスの中身を作る際にdata属性をオプションで渡しています。
この配列を`f.select`に渡すと以下のようなHTMLが出力されます。

```html
<select class="form-control select-parent" name="item[category_id]" id="item_category_id">
  <option value=""></option>
  <option data-children-path="/categories/1/sub_categories" value="1">本</option>
  <option data-children-path="/categories/2/sub_categories" value="2">家電・カメラ・AV機器</option>
  <option data-children-path="/categories/3/sub_categories" value="3">ホーム・キッチン</option>
</select>
```

`data-children-path`に子カテゴリを取得する際のpathが入るのがポイントです。
このあとのJavaScriptにてこのpathを使います。

## CoffeeScript (JavaScript)

JavaScriptの処理はCoffeeScriptで書いています。

```coffee
$ ->
  do ->
    replaceSelectOptions = ($select, results) ->
      $select.html $('<option>')
      $.each results, ->
        option = $('<option>').val(this.id).text(this.name)
        $select.append(option)

    replaceChildrenOptions = ->
      childrenPath = $(@).find('option:selected').data().childrenPath
      $selectChildren = $(@).closest('form').find('.select-children')
      if childrenPath?
        $.ajax
          url: childrenPath
          dataType: "json"
          success: (results) ->
            replaceSelectOptions($selectChildren, results)
          error: (XMLHttpRequest, textStatus, errorThrown) ->
            console.error("Error occurred in replaceChildrenOptions")
            console.log("XMLHttpRequest: #{XMLHttpRequest.status}")
            console.log("textStatus: #{textStatus}")
            console.log("errorThrown: #{errorThrown}")
      else
        replaceSelectOptions($selectChildren, [])

    $('.select-parent').on
      'change': replaceChildrenOptions
```

このコードは大きく分けて3つの処理にわかれています。

まず、以下のコードで親カテゴリ変更時のイベントを設定しています。

```coffee
$('.select-parent').on
  'change': replaceChildrenOptions
```

次に、`replaceChildrenOptions`がchangeイベントで呼ばれるメソッドです。
何をやっているのかわかりやすくするためにコメントを入れてみます。

```coffee
replaceChildrenOptions = ->
  # 選択された親カテゴリのオプションから、data-children-pathの値を読み取る
  childrenPath = $(@).find('option:selected').data().childrenPath
  # 子カテゴリのセレクトボックスを取得する
  $selectChildren = $(@).closest('form').find('.select-children')
  if childrenPath?
    # childrenPathが存在する = 親カテゴリが選択されている場合、
    # ajaxでサーバーに子カテゴリの一覧を問い合わせる
    $.ajax
      url: childrenPath
      dataType: "json"
      success: (results) ->
        # サーバーから受け取った子カテゴリの一覧でセレクトボックスを置き換える
        replaceSelectOptions($selectChildren, results)
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        # 何らかのエラーが発生した場合
        console.error("Error occurred in replaceChildrenOptions")
        console.log("XMLHttpRequest: #{XMLHttpRequest.status}")
        console.log("textStatus: #{textStatus}")
        console.log("errorThrown: #{errorThrown}")
  else
    # 親カテゴリが未選択だったので、子カテゴリの選択肢をクリアする
    replaceSelectOptions($selectChildren, [])
```

最後に、`replaceSelectOptions`は子カテゴリのセレクトボックスの中身を置き換えるためのメソッドです。
いったん空の選択肢を追加したあと、サーバーから受け取った値を順番に詰め込んでいます。

```coffee
replaceSelectOptions = ($select, results) ->
  $select.html $('<option>')
  $.each results, ->
    option = $('<option>').val(this.id).text(this.name)
    $select.append(option)
```

## コントローラー

こちらはAjaxのリクエストを受け取り、JSONを返すサーバーサイドの処理です。

コントローラーはこんな感じになっています。

```ruby
class SubCategoriesController < ApplicationController
  def index
    category = Category.find(params[:category_id])
    render json: category.sub_categories.select(:id, :name)
  end
end
```

セキュリティ面を考慮してidとname以外は返却しないようにしています。

http://localhost:3000/categories/1/sub_categories のようなURLにアクセスすると子カテゴリの一覧がJSONとして返ってきます。

```javascript
[
  {
    id: 1,
    name: "和書"
  },
  {
    id: 2,
    name: "洋書"
  },
  {
    id: 3,
    name: "コミック"
  },
  {
    id: 4,
    name: "雑誌"
  }
]
```

ちなみに親カテゴリを変更したときのログはこんなふうに出力されます。

```text  
Started GET "/categories/1/sub_categories" for ::1 at 2015-04-10 08:29:23 +0900
Processing by SubCategoriesController#index as JSON
  Parameters: {"category_id"=>"1"}
  Category Load (0.1ms)  SELECT  "categories".* FROM "categories" WHERE "categories"."id" = ? LIMIT 1  [["id", 1]]
  SubCategory Load (0.6ms)  SELECT "sub_categories"."id", "sub_categories"."name" FROM "sub_categories" WHERE "sub_categories"."category_id" = ?  ORDER BY "sub_categories"."id" ASC  [["category_id", 1]]
Completed 200 OK in 15ms (Views: 1.1ms | ActiveRecord: 0.7ms)
```

自分の作ったアプリがうまく動かないときはログを見て、正しくリクエストとレスポンスが処理されているか確認してください。

アプリケーション側の主要なコードはこんな感じです。
いまいちピンと来ていない人は冒頭で説明した「ざっくりとした処理の流れ」をもう一度見直して、処理とコードの対応関係を確認してみてください。

## テストコード (RSpec)

最後にRSpecで書いたテストコードの一部を載せておきます。

```ruby
require 'rails_helper'

feature 'Items' do
  background do
    {'本' => %w(和書 洋書), '家電・カメラ・AV機器' => %w(家電 カメラ)}.each do |category_name, sub_category_names|
      category = Category.create(name: category_name)
      sub_category_names.each do |sub_category_name|
        category.sub_categories.create(name: sub_category_name)
      end
    end
  end
  scenario 'Manage items', js: true do
    # 新規作成画面を開く
    visit root_path
    click_on 'New Item'

    # セレクトボックスのデフォルト値を検証する
    expect(page).to have_select 'Category', options: ['', '本', '家電・カメラ・AV機器']
    expect(page).to have_select 'Sub category', options: ['']

    # カテゴリを変更するとサブカテゴリの項目が変わることを検証する
    select '本', from: 'Category'
    expect(page).to have_select 'Sub category', options: ['', '和書', '洋書']
    select '家電・カメラ・AV機器', from: 'Category'
    expect(page).to have_select 'Sub category', options: ['', '家電', 'カメラ']
    select '', from: 'Category'
    expect(page).to have_select 'Sub category', options: ['']

    # 以下省略
  end
end
```

今回はUI側の動作確認がメインなので、フィーチャスペックを使います。
また、JavaScriptが必要不可欠なので、`scenario 'Manage items', js: true do`の部分で`js: true`のオプションを付けました。

`background`ではテスト用のデータを作っています。

`scenario`以下がメインのテストです。
コメントで書いているとおり、カテゴリを変更するとサブカテゴリの項目が変わることを検証しています。

テストコードの全体はGitHub上のコードを見てください。

- https://github.com/JunichiIto/replace-selectbox-sandbox/blob/master/spec/feature/items_spec.rb

またRSpecやフィーチャスペックの読み方、書き方については以前書いたこちらの記事を参考にしてください。

- [使えるRSpec入門・その1「RSpecの基本的な構文や便利な機能を理解する」](http://qiita.com/jnchito/items/42193d066bd61c740612)
- [使えるRSpec入門・その4「どんなブラウザ操作も自由自在！逆引きCapybara大辞典」](http://qiita.com/jnchito/items/607f956263c38a5fec24)

## まとめ

というわけで今回はセレクトボックスの中身がAjaxで動的に変わるサンプルアプリを紹介してみました。

「こういうの、やってみたいんだけどやり方がわからなかった」という人の参考になれば幸いです！


### 【PR】「Everyday Rails - RSpecによるRailsテスト入門」を読んでテストが書けるRailsプログラマになろう！

UIの処理を変更のたびに毎回手作業で確認するのは非常に面倒です。
しかし、テストを書いておけば何度でも自動的にUIが壊れていないことを検証できます。

今回のサンプルアプリを開発する際も、テストコードを書いていたおかげで積極的にリファクタリングすることができました。

「テストコードが大事なのはわかるけど、何をどうしたらいいか全然わからないんだよな～」という人は僕が翻訳した電子書籍、「[Everyday Rails - RSpecによるRailsテスト入門](https://leanpub.com/everydayrailsrspec-jp)」をぜひ読んでみてください。

この本は初心者向けにやさしくテストコードの書き方を説明しているので、「テストって全然わからないんだけど」という人でも大丈夫です！

対応している電子書籍のフォーマットは、PDF、EPUB、Kindleの3種類です。
興味のある方はこちらのページからご購入ください。よろしくお願いします！

[Everyday Rails - RSpecによるRailsテスト入門](https://leanpub.com/everydayrailsrspec-jp)

![Everyday Rails - RSpecによるRailsテスト入門](https://s3.amazonaws.com/titlepages.leanpub.com/everydayrailsrspec-jp/large?1393556181)
