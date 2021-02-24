<h1 align="center">江湖路 MUD 全自动机器人</h1>

## 目录
- [简介](#简介)
- [使用说明](#使用说明)
  - [下载及安装配置](#初始化配置)
    - [Windows](#Windows)
    - [MacOS](#MacOS)
    - [Linux](#Linux)
  - [开始游戏](#启动客户端，开始游戏)
  - [常用指令](#机器人常用指令)

## 简介

本机器人专为中文武侠类 MUD 游戏《江湖路》(118.25.151.226:8888) 制作，为实现游戏过程中全自动无人值守任务。
机器人作为 MUD 游戏的一大特色，减少了大量繁琐的重复操作，是理想的游戏辅助。
希望能以此吸引到更多有相同爱好，对 MUD 感兴趣的朋友一起交流学习。

## 使用说明

Mudlet [下载地址](https://www.mudlet.org/download/)

### 初始化配置

  #### Windows

  双击执行 Mudlet-<version>-windows-installer.exe，将会打开 Mudlet 主界面，首次执行后安装即已自动完成。
  用户无需额外操作，可直接关闭主界面退出。后续用户可改从本地已安装的应用程序 Mudlet.exe 处启动，Mudlet-<version>-windows-installer.exe 文件无需保留。

  本地安装路径在用户目录 AppData 下，以 Administrator 用户为例：
      应用程序和相关库文件将被自动安装到 C:\Users\Administrator\AppData\Local\Mudlet
      用户配置文件将被放置在 C:\Users\Administrator\.config\mudlet

  #### MacOS

  直接安装 Mudlet-<version>.dmg 文件。
  安装完成后，用户配置文件将被放置在 $HOME/.config/mudlet 目录下。

  #### Linux

  解压 Mudlet-<version>-linux-x64.AppImage.tar
  ```sh
  tar xf Mudlet-<version>-linux-x64.AppImage.tar
  ```

  在图形终端内直接运行解压后的 .AppImage 文件，使其自动完成配置文件目录的初始化。
  首次运行后，用户配置文件将被放置在 $HOME/.config/mudlet 目录下。

### 下载机器人 [mudlet 分支](https://github.com/zhenzh/JHL/archive/mudlet.zip)，解压至用户配置目录 .config 下，与原 mudlet 目录合并。

### 修改初始机器人加载文件 .config/mudlet/profiles/current/autosave.xml，调整为当前用户配置目录路径
  ```xml
  <mInstalledModules>
      <key>全门派全自动</key>
          <filepath>C:/Users/Administrator/.config/mudlet/script/全门派全自动.xml</filepath>
          <globalSave>0</globalSave>
      <priority>0</priority>
  </mInstalledModules>
  ```

### 游戏角色配置的创建

  * 从用户配置目录中整体复制 profiles/JHL 并更名为 profiles/<角色 ID>。注意 profiles/JHL 目录为默认模板，不可删除
  * 修改 profiles/<角色 ID>/char.cfg 文件，根据游戏角色自身情况调整相关配置

### 启动客户端，开始游戏

进入游戏后会有机器人加载信息，确认所有模块都加载成功

```sh
加载 client.lua ...................... 成功
加载 common.lua ...................... 成功
加载 gps/gps.lua ..................... 成功
加载 game/info.lua ................... 成功
加载 game/action.lua ................. 成功
加载 control/admin.lua ............... 成功
加载 control/statistics.lua .......... 成功
加载 main.lua ........................ 成功
```

### 机器人常用指令

* auto - 开始全自动挂机
* reset - 重置机器人，机器人出错或希望终止全自动时可使用
* stat - 全自动任务信息统计