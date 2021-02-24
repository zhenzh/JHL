<h1 align="center">江湖路 MUD 全自动机器人</h1>

## 目录
- [简介](#简介)
  - [开发语言](#开发语言)
  - [编码格式](#编码格式)
  - [支持客户端](#支持客户端)
    - [完成状态](#当前支持度完成状态及进展)
- [使用说明](#使用说明)
  - [常用指令](#机器人常用指令：)


## 简介

本机器人专为中文武侠类 MUD 游戏《江湖路》(118.25.151.226:8888) 制作，为实现游戏过程中全自动无人值守任务。
机器人作为 MUD 游戏的一大特色，减少了大量繁琐的重复操作，是理想的游戏辅助。
希望能以此吸引到更多有相同爱好，对 MUD 感兴趣的朋友一起交流学习。

## 开发语言

机器人主体采用 LUA 语言，尽量做到最少依赖不通用的库以及客户端所独有的库
少量代码段包含不同客户端所采用的独立语言，主要集中在机器人加载项与客户端接口模块

## 编码格式

机器人脚本完全采用 UTF-8 编码，需要使用支持 UTF-8 的 MUD 客户端读取运行

## 支持客户端

机器人计划支持多客户端，理论上可适用于任何支持 LUA 的 MUD 客户端，运行环境取决于客户端所支持的操作系统

* [X] Mudlet 
* [X] Mushclient
* [X] Lordstar
* [X] Tintin++
* [X] GoMud

### 当前支持度完成状态及进展

* Mudlet 接近 90%，可以实现全自动无看管挂机，持续测试维护中
* GoMud 50%, 客户端存在关键 BUG，需等待修复
* Tintin++ 处于支持性验证中
* 其他客户端等待后续扩展


## 使用说明

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

### 机器人常用指令：

* auto - 开始全自动挂机
* reset - 重置机器人，机器人出错或希望终止全自动时可使用
* stat - 全自动任务信息统计