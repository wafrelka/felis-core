## 概要

完動。

## 仕様

- マルチサイクル (パイプライン・スーパースカラなし, 分岐予測なし)
- インオーダー発行・インオーダー実行
- プログラムローダー方式
- メインメモリ: 655360 words
- インストラクションメモリ: 65536 words
- クロック: 120 MHz

`CVT.W.S` は最近接偶数丸めとして実装してある

アーキテクチャの仕様については [wafrelka/felis/wiki](https://github.com/wafrelka/felis/wiki) に記載

## 実行方法

1. リセットボタンを押下する
1. UART 経由でユーザープログラムを送信する
1. 受信完了直後からプログラムの実行が開始される

ユーザープログラムのデータフォーマットは以下の通り

- 先頭4バイトはプログラムのサイズを表す
- 残りはプログラム本体を表す
- リトルエンディアンである

## 必要となる IP

- Divider Generator
  - AXI-4, Non-Blocking
- Floating-point
  - Add/Sub, Div, Mul, Sqrt, Float-to-Fixed, Fixed-to-Float
  - AXI-4, Non-Blocking
- Block Memory Generator
  - Native Interface
  - Single Port RAM
  - Latency: 1 Clock
