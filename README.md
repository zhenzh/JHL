<h2 align="center">江湖路 MUD 全自动机器人</h2>

## 目录

- [目录](#目录)
- [简介](#简介)
  - [使用语言](#使用语言)
  - [编码格式](#编码格式)
  - [支持客户端](#支持客户端)
    - [支持度状态及进展](#支持度状态及进展)
- [安装及配置](#安装及配置)
  - [Mudlet](#mudlet)
    - [Windows](#windows)
    - [MacOS](#macos)
    - [Linux](#linux)
    - [机器人配置](#机器人配置)
  - [Tintin++](#tintin)
    - [Docker](#docker)
    - [Windows](#windows-1)
    - [MacOS/Linux](#macoslinux)
  - [Mushclient](#mushclient)
- [游戏角色配置](#游戏角色配置)
- [开始游戏](#开始游戏)
- [机器人指令](#机器人指令)

## 简介

本机器人专为中文武侠类 MUD 游戏《江湖路》(106.225.179.81:8888) 制作，为实现游戏过程中全自动无人值守任务。

机器人作为 MUD 游戏的一大特色，减少了大量繁琐的重复操作，是理想的游戏辅助。

希望能以此吸引到更多有相同爱好，对 MUD 感兴趣的朋友一起交流学习。

### 使用语言

机器人主体采用 LUA 语言，尽量做到最少依赖不通用的库以及客户端所独有的库

少量代码段包含不同客户端所采用的独立语言，主要集中在机器人加载项与客户端接口模块

### 编码格式

机器人脚本完全采用 UTF-8 编码，需要使用支持 UTF-8 的 MUD 客户端读取运行

### 支持客户端

机器人计划支持多客户端，理论上可适用于任何支持 LUA 的 MUD 客户端，运行环境取决于客户端所支持的操作系统

- [X] Mudlet
- [X] Mushclient
- [X] Tintin++

#### 支持度状态及进展

- Mudlet 95% 已完成，可以实现全自动无人值守任务，持续测试维护中
- Tintin++ 90% 已完成，已测试在 Ubuntu 上全自动无人值守任务，持续测试维护中
- 其他客户端等待后续扩展

## 安装及配置

### [Mudlet](https://www.mudlet.org)

<p align="left">
    <a href="https://www.mudlet.org/download/">下载地址</a> •
    <a href="https://forums.mudlet.org/index.php">论坛</a> •
    <a href="https://wiki.mudlet.org/w/Manual:Contents">使用手册</a>
</p>

#### Windows

双击执行 `Mudlet-<version>-windows-installer.exe`，将会打开 Mudlet 主界面，首次执行后安装即已自动完成。

用户无需额外操作，可直接关闭主界面退出。后续用户可改从本地已安装的应用程序 Mudlet.exe 处启动，`Mudlet-<version>-windows-installer.exe` 文件无需保留。

- 本地安装路径在用户目录 `AppData` 下，以 Administrator 用户为例：
  
  应用程序和相关库文件将被自动安装到 `C:\Users\Administrator\AppData\Local\Mudlet`

  用户配置文件将被放置在 `C:\Users\Administrator\.config\mudlet`

#### MacOS

直接安装 `Mudlet-<version>.dmg` 文件。

安装完成后，用户配置文件将被放置在 `$HOME/.config/mudlet` 目录下。

#### Linux

解压 `Mudlet-<version>-linux-x64.AppImage.tar`

```sh
tar xf Mudlet-<version>-linux-x64.AppImage.tar
```

在图形终端内直接运行解压后的 .AppImage 文件，使其自动完成配置文件目录的初始化。

首次运行后，用户配置文件将被放置在 `$HOME/.config/mudlet` 目录下。

#### 机器人配置

- 下载 [mudlet 分支](https://github.com/zhenzh/JHL/archive/mudlet.zip)

- 解压至用户配置目录 .config 下，与原 mudlet 目录合并。

- 修改客户端环境配置文件 `.config/mudlet/profiles/current/autosave.xml`

将 `<filepath>` 中 `.config/mudlet/script/江湖路全自动机器人.xml` 文件所在路径改为当前用户配置目录

```xml
<mInstalledModules>
    <key>江湖路全自动机器人</key>
        <filepath>C:/Users/Administrator/.config/mudlet/script/江湖路全自动机器人.xml</filepath>
        <globalSave>0</globalSave>
    <priority>0</priority>
</mInstalledModules>
```

### [Tintin++](https://tintin.mudhalla.net/)

<p align="left">
    <a href="https://tintin.mudhalla.net/download.php">下载地址</a> •
    <a href="https://github.com/scandum/tintin/discussions">论坛</a> •
    <a href="https://tintin.mudhalla.net/manual/">使用手册</a>
</p>

#### Docker

安装 Docker 软件，参见 Docker [官方安装文档](https://docs.docker.com/engine/install/)。

下载 [tintin 分支](https://github.com/zhenzh/JHL/archive/tintin.zip)

打开命令行界面（Windows 打开 PowerShell）构建 docker 容器镜像：`docker build -t jhl:latest <机器人所在路径>`

#### Windows

仅支持 Window10 以上版本，通过 Docker 容器镜像运行。详细步骤参见 Docker(#Docker)

#### MacOS/Linux

安装 tintin++，详细步骤参见[官网安装说明](https://tintin.mudhalla.net/install.php)。

安装 Lua5.1（如果没有 5.1 版本可选，5.2 版本也可以兼容）：

- MacOS `brew install lua@5.1`
- Ubuntu/Debian `apt get -y install lua5.1-0`
- Alpine `apk add lua5.1`

### [Mushclient](http://www.gammon.com.au/mushclient/mushclient.htm)

<p align="left">
    <a href="http://www.gammon.com.au/downloads/dlmushclient.htm">下载地址</a> •
    <a href="http://www.gammon.com.au/scripts/forum.php?bbsection_id=1">论坛</a> •
    <a href="http://www.gammon.com.au/scripts/doc.php?general=contents">使用手册</a>
</p>

待更新

## 游戏角色配置

- 从用户配置目录中整体复制 `profiles/JHL` 并更名为 `profiles/<角色 ID>`。注意 `profiles/JHL` 目录为默认模板，不可删除。

- 修改 `profiles/<角色 ID>/char.cfg` 文件，根据游戏角色自身情况调整相关配置

注意：修改配置文件请使用支持 UTF-8 格式的文本编辑器，Windows 自带的记事本和写字板编辑可能出现乱码及添加隐藏字符等问题，造成机器人加载失败。

Windows 上可使用 vscode，notepad++，notpad2，ultraedit 等编辑工具

## 开始游戏

启动客户端，进入游戏后会有机器人加载信息，确认所有模块都加载成功

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

## 机器人指令

- `auto [-f]` 开始全自动挂机
  - `-f`        可选参数，清空先前记录的所有任务暂存状态

- `reset [-f]` 重置机器人，机器人出错或希望终止全自动时可使用
  - `-f`        可选参数，重置后将归零当前记录的重置、重连、死亡次数统计

- `stat [-l|-s] [NUMBER]` 全自动任务信息统计
  - `-l`        可选参数，详细显示统计时间段内完成的所有任务清单
  - `-s`        可选参数，分类显示统计时间段内任务完成情况的概览
  - `NUMBER`    可选参数，需填具体数字，表示希望统计从当前时刻算起，过去多少小时内的任务情况