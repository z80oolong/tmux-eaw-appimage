# tmux-eaw-appimage -- EAW 対応 tmux を起動する AppImage ファイル作成用の Dockerfile

## 概要

[tmux 2.5][TMUX] 以降において、 Unicode の規格における東アジア圏の各種文字のうち、いわゆる "◎" や "★" 等の記号文字及び罫線文字等、 [East_Asian_Width 特性の値が A (Ambiguous) となる文字][EAWA] (以下、 [East Asian Ambiguous Character][EAWA]) が、日本語環境で文字幅を適切に扱うことが出来ずに表示が乱れる問題が発生しています。

このリポジトリは、端末多重化ソフトウェアである [tmux][TMUX] において、Unicode の規格における東アジア圏の各種文字のうち、いわゆる "◎" や "★" 等の記号文字及び罫線文字等、 [East_Asian_Width 特性の値が A (Ambiguous) となる文字][EAWA] (以下、 [East Asian Ambiguous Character][EAWA]) が、日本語環境で文字幅を適切に扱うことが出来ずに表示が乱れる問題を修正するための差分ファイルを適用した [tmux][TMUX] を起動する [AppImage ファイル][APPI]を生成するための Docker コンテナを構築する Dockerfile 等を含むリポジトリです。

即ち、本リポジトリに含まれる Dockerfile によって構築される Docker コンテナは、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用した端末多重化ソフトウェアである [tmux][TMUX] を起動するための [AppImage ファイル][APPI]を生成する為の Docker コンテナです。

なお、本リポジトリのオリジナルとなった [Nelson Enzo 氏][NELS]による [Dockerfile][TAPP] とは、 [tmux][TMUX] に依存するライブラリである ```libevent``` 及び ```ncurses``` を始め、これらのビルドに必要となる ```m4, autoconf, automake, libtool``` をソースコードからビルドする点で異なっています。

## 使用法

まず最初に、 Docker コンテナの公式のドキュメントである "[Docker のインストール — Docker-docs-ja 17.06.Beta ドキュメント][DCK1]" のページ等を参考にして、 [tmux][TMUX] の [AppImage ファイル][APPI]を生成するための端末に Docker コンテナ環境を構築します。

そして、本リポジトリ内のシェルスクリプト ```build-appimage.sh``` を以下の通りに起動します。

```
  $ sudo ./build-appimage.sh
```

シェルスクリプト ```build-appimage.sh``` の起動により、[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]を適用した [tmux][TMUX] をビルドするための Docker コンテナが構築され、 Docker コンテナ内にて、 [tmux][TMUX] 及び [tmux][TMUX] に依存するライブラリ群等がビルドされ、 [tmux][TMUX] を起動するための [AppImage ファイル][APPI]が生成されます。

そして、シェルスクリプトが正常に終了すると、ディレクトリ ```./opt/release``` 以下に [AppImage ファイル][APPI] ```tmux-eaw-3.0a-x86_64.AppImage``` が生成されます。

なお、シェルスクリプト ```build-appimage.sh``` は、デフォルトでは最新の安定版である [tmux 3.0a][TMUX] の [AppImage ファイル][APPI]を生成しますが、以下のようにオプション ```-r, --release``` で安定版のバージョン番号を指定することにより、指定されたバージョンの [tmux][TMUX] の [AppImage ファイル][APPI]を生成することが出来ます。

```
  $ sudo ./build-appimage.sh -r 2.9a        (旧安定版 tmux 2.9a をビルド。)
  $ sudo ./build-appimage.sh --release 2.7  (旧安定版 tmux 2.7  をビルド。)
```

## AppImage ファイルの使用法

前述で生成した [AppImage ファイル][APPI] ```tmux-eaw-3.0a-x86_64.AppImage``` を用いて [tmux][TMUX] を起動するには、以下の通りにして  [AppImage ファイル][APPI] ```tmux-eaw-3.0a-x86_64.AppImage``` にファイルの実行権限を付与して環境変数 ```PATH``` が示すディレクトリに配置します。

そして、以下のようにして ```tmux-eaw-3.0a-x86_64.AppImage``` から ```tmux``` へシンボリックリンクを張ると、コマンドラインから ```tmux``` と入力することで、 [East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]を適用した [tmux][TMUX] が起動します。

```
  $ cd opt/release
  $ sudo chmod u+x ./tmux-eaw-3.0a-x86_64.AppImage
  $ sudo cp -pRv ./tmux-eaw-3.0a-x86_64.AppImage /usr/local/bin    # (一例として /usr/local/bin 以下に導入する場合を示す。)
  $ cd /usr/local/bin
  $ sudo ln -sf tmux-eaw-3.0a-x86_64.AppImage tmux
  ...
  $ tmux
  ...
```

ここで、 [East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]が適用された [tmux][TMUX] の使用法の詳細については、 "[tmux 2.5 以降において East Asian Ambiguous Character を全角文字の幅で表示する][GST1]" を参照して下さい。

## AppImage ファイルの配布

[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]が適用された [tmux][TMUX] のビルド済の [AppImage ファイル][APPI]については、以下の URL より配布いたしますので、どうか宜しく御願い致します。

- EAW 対応 tmux を起動する AppImage ファイルの配布ページ
    - [https://github.com/z80oolong/tmux-eaw-appimage/releases][APPR]

## 謝辞

まず最初に、[本リポジトリの元となった Dockerfile 等][TAPP]を作成された [Nelson Enzo 氏][NELS]に心より感謝致します。

また、 [tmux][TMUX] に適用するための [East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]に関しては、以下の各氏の協力及びソースコードの参考を得ました。以下の各氏に心より感謝致します。

- [koie-hidetaka 氏][KOIE]
- [Markus Kuhn 氏][DRMK]

最後に、 [tmux][TMUX] の作者である [Nicholas Marriott 氏][NICM]を初めとする [tmux の開発コミュニティ][TMUX]及び [tmux][TMUX] に関わる全ての人々に心より感謝致します。

## 使用条件

本リポジトリは、 [East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]を適用した端末多重化ソフトウェア [tmux][TMUX] を起動するための [AppImage ファイル][APPI]を生成するための Dockerfile 等を含むリポジトリであり、以下の各氏が著作権を有し、 [MIT ライセンス][MITL] に基づいて配布されるものとします。

- [Nelson Enzo 氏][NELS]
- [Z.OOL. (mailto:zool@zool.jpn.org)][ZOOL]

本リポジトリの使用条件の詳細については、本リポジトリに同梱する ```LICENSE``` を参照して下さい。

## 追記

本リポジトリのオリジナルである [Nelson Enzo 氏による Dockerfile][NELT]の ```README.md``` の原文を以下の示します。

----

# Tmux AppImage

### What is this?
Dockerfile to create an AppImage of tmux.

### Why use Docker?
The advantages to doing it this way are:
- Obtain consistent build results on any computer.
- No need to install a slew of build packages on your own machine.
- You can trust the tmux developers code, not some rando's AppImage distribution on the interwebz :p

### How do build it?
```
## clone me
git clone https://github.com/nelsonenzo/tmux-appimage.git

## compile tmux from source by building container
docker build . -t tmux

## extract the appimage file
docker create -ti --name tmuxcontainer tmux bash
docker cp tmuxcontainer:/opt/releases/tmux-3.0a-x86_64.AppImage .
docker rm -f tmuxcontainer
```


## To use AppImage
move appimage to executable location in your $PATH
```
mv tmux.*AppImage /usr/local/bin/tmux

tmux
```

### Where has the AppImage been tested to turn?
It has been tested on these fine Linux platforms and will likely work for anything newer than centos 6.9 (which is a few years old now.) Please file an issue if you find otherwise or need support on a different platform.
```
ubuntu 18
centos 6.9
centos 7.6
fedora 31
```

### What is the sauce that makes this work?
The [Dockerfile](Dockerfile) contains all the magic ingredients to compile tmux.

[./opt/build.sh](opt/build.sh) creates the AppImage from binary using linuxdeploy tool.

<!-- 外部リンク一覧 -->

[APPI]:https://appimage.org/
[TMUX]:http://tmux.github.io/
[EAWA]:http://www.unicode.org/reports/tr11/#Ambiguous
[TAPP]:https://github.com/nelsonenzo/tmux-appimage
[TMRP]:https://github.com/tmux/tmux.git
[GST1]:https://github.com/z80oolong/tmux-eaw-fix
[APPR]:https://github.com/z80oolong/tmux-eaw-appimage/releases
[DCK1]:http://docs.docker.jp/engine/installation/
[NELS]:https://github.com/nelsonenzo
[NELT]:https://github.com/nelsonenzo/tmux-appimage
[KOIE]:https://github.com/koie
[DRMK]:http://www.cl.cam.ac.uk/~mgk25/
[NICM]:https://github.com/nicm
[ZOOL]:http://zool.jpn.org/
[MITL]:https://opensource.org/licenses/mit-license.php
