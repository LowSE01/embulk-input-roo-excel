# embulk-plugin-input-roo-excel

[embulk-plugin-input-roo-excel](https://github.com/hiroyuki-sato/embulk-plugin-input-roo-excel)は、[Embulk](https://github.com/embulk/embulk)で、xlsxファイルを読込みするための入力プラグインです。

## インストール方法

Embulkのgemインストール方法にならって次のようにしてパッケージを導入します。


```
java -jar embulk.jar gem intall embulk-plugin-input-roo-excel
```

また本プラグインは、xlsxファイルの読込みにrooを利用しているので、自動的にrooが導入されない場合は次のようにしてrooもインストールしてください。

```
java -jar ~/embulk.jar gem install roo
Fetching: ruby-ole-1.2.11.8.gem (100%)
Successfully installed ruby-ole-1.2.11.8
Fetching: spreadsheet-1.0.1.gem (100%)
Successfully installed spreadsheet-1.0.1
Fetching: nokogiri-1.6.6.2-java.gem (100%)
Successfully installed nokogiri-1.6.6.2-java
Fetching: rubyzip-1.1.7.gem (100%)
Successfully installed rubyzip-1.1.7
Fetching: roo-1.13.2.gem (100%)
Successfully installed roo-1.13.2
5 gems installed
```


導入したパッケージは次のコマンドで確認をすることができます。(~/.embulk以下に導入されます。)

```
java -jar ~/embulk.jar gem list

*** LOCAL GEMS ***

ffi (1.9.3 java)
jar-dependencies (0.1.2)
jruby-openssl (0.9.5 java)
json (1.8.0 java)
krypt (0.0.2)
krypt-core (0.0.2 universal-java)
krypt-provider-jdk (0.0.2)
nokogiri (1.6.6.2 java)
rake (10.1.0)
rdoc (4.0.1)
roo (1.13.2)
ruby-ole (1.2.11.8)
rubyzip (1.1.7)
spreadsheet (1.0.1)
```

設定ファイル


## 設定

設定

| 項目名   | 説明                         | 未指定時    |
|----------|------------------------------|-------------|
| data_pos | データが何行目から開始するか | 1           |
| sheet    | 読み込みたいシート名         | 最初のシート|
| paths    | xlsxを保存したディレクトリ   |             |
| colums   | Embulkに取り込むカラム名     |             |


カラム名は次のようなパラメータがあります。


| 項目名   | 設定                         |
|----------|------------------------------|
| name     | カラムの名前                 |
| type     | 型                           |

型は、Embulkの型にあわせてください

* booealn (未テスト)
* long: 整数
* double: 浮動小数点
* string: 文字列
* timestamp: 日時

## 設定例

シート名: "The Beatles"に次のようなデータが格納されている場合

| id | first_name  | first_name | nickname | birthday   |
|----|-------------|------------|----------|------------|
| 1  | John        | Lennon     | John     | 1940/10/09 |
| 2  | Paul        | McCartney  | Paul     | 1942/06/18 |
| 3  | George      | Harrison   | George   | 1943/02/25 |
| 4  | Ringo       | Starr      | Ringo    | 1940/07/07 |


設定は次のように記述します。

```
in:
  type: roo_excel
  sheet: "The Beatles"
  data_pos: 2
  paths: ["/path/to/beatles"]
  columns:
    - { name: id, type: long }
    - { name: first_name, type: string }
    - { name: last_name,  type: string }
    - { name: nick_name,  type: string }
    - { name: birthday,   type: timestamp }
out:
  type: stdout
```

## 実行例

```
java -jar embulk.jar preview config.yml
java -jar embulk.jar run config.yml
```

## 既存の問題点

* doneはまだ動きません。
* '1:00'など時刻を記載するとExcel上はTimeになりますが良い変換方法が思いつかないので型をdoubleにして、3600.0と秒に変換してください。

## Contributing

1. Fork it ( https://github.com/hiroyuki-sato/embulk-plugin-input-roo-excel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
