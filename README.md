# embulk-plugin-input-roo-excel

[Japanese Page](README.ja.md)

This is a input plugin for [Embulk](https://github.com/embulk/embulk) to read xlsx documents.

## Installation

```
java -jar embulk.jar gem intall embulk-plugin-input-roo-excel
```

You also need roo gem for read xlsx documents. If those package not install automatically, install too.

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

You can check package list.

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

## configuration

data example.

configuration

| key      | description   | default     |
|----------|---------------|-------------|
| data_pos | data position | 1           |
| sheet    | sheet name    | first sheet |
| paths    | file path     | []          |
| colums   | column names  |             |

column name

| key    | description |
|--------|-------------|
| name   | colum name  |
| type   | type        |

Type is one of the following value.

* booealn
* long
* double
* string
* timestamp

## Usage

Example data. The sheet name is "The Beatles".

| No | first_name  | first_name | nickname | birthday   |
|----|-------------|------------|----------|------------|
| 1  | John        | Lennon     | John    | 1940/10/09 |
| 2  | Paul        | McCartney  | Paul     | 1942/06/18 |
| 3  | George      | Harrison   | George   | 1943/02/25 |
| 4  | Ringo       | Starr      | Ringo    | 1940/07/07 |

configuration file

```
in:
  type: roo_excel
  sheet: "The Beatles"
  data_pos: 2
  paths: ["/path/to/beatles"]
  columns:
    - { name: no, type: long }
    - { name: first_name, type: string }
    - { name: last_name,  type: string }
    - { name: nick_name,  type: string }
    - { name: birthday,   type:timestamp, format:"%Y/%m/%d" }
out:
  type: stdout
```

## execution

```
java -jar embulk.jar preview config.yml
java -jar embulk.jar run config.yml
```

## Contributing

1. Fork it ( https://github.com/hiroyuki-sato/embulk-plugin-input-roo-excel/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
