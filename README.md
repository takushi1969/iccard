# carLicenseCardReader #

## 概要 ##

ICCardタイプの免許書に格納された住所情報を標準出力に出力する。

## 使用方法 ##
`$ carLicenseCardReader datafile`

## 詳細 ##
ICCardタイプの免許書の住所ファイルは、制御コード無しのJISで記録されている。
このコマンドは、住所ファイルの内容をUTF-8にエンコードして、標準出力に出力する。

## 拡張性 ##

### ハッシュ変数`tags` ###

現在は、0x41をタグに持つTLV形式のバイナリファイルのみを認識する。
`ICCard::CarLicenseCard`のハッシュ変数`tags`を拡張することで、他のタグにも対応可能である。

#### 定義 ####

##### 定義例 #####

> my %tags = (
>     0x41	=> \&rawJIS2UTF,
> );

###### 意味 ######

キー | タクの値
値 | TLVのVを第一引数に取る関数へのリファレンス

## 参照 ##

1. [ICCard免許書仕様](http://www.npa.go.jp/pdc/notification/koutuu/menkyo/menkyo20110328.pdf)




