# 🪙 Zen Wallet

一个基于 Flutter 构建的多链加密货币钱包应用，支持以太坊（EVM）与 Solana 链，具备助记词生成、钱包导入、Token 资产管理、二维码收发等核心功能。

---

## ✨ 功能特性

- 🔐 **助记词生成与管理** — 符合 BIP39 标准，支持安全存储
- 📥 **钱包导入** — 通过助记词或私钥导入已有钱包
- 🌐 **多链支持** — 以太坊（EVM 兼容链）& Solana
- 💰 **Token 资产展示** — 展示原生代币与 ERC-20/SPL 资产
- 📤 **收发转账** — 二维码扫描 & 生成，配合地址输入完成链上交易
- 🔒 **安全存储** — 私钥与助记词加密存储于设备安全区

## 🏗️ 项目架构

项目采用 **Clean Architecture** 分层结构，结合 Riverpod 进行依赖注入与状态管理：

```
lib/
├── main.dart                  # 应用入口
│
├── app/                       # App 初始化 & 全局配置
├── routing/                   # go_router 路由定义
│
├── domain/                    # 业务层（纯 Dart，无框架依赖）
│   ├── models/                # 数据模型（freezed 生成）
│   ├── repositories/          # Repository 抽象接口
│   └── states/                # 业务状态定义
│
├── data/                      # 数据层（接口实现 & 外部服务）
│   ├── repositories/          # Repository 实现
│   ├── adapters/              # 数据适配器（API / 本地存储）
│   └── providers/             # Riverpod Provider 注册
│
└── ui/                        # 表现层
    ├── core/                  # 主题、颜色、通用样式
    ├── widgets/               # 公共 UI 组件
    ├── landing/               # 启动 / 欢迎页
    ├── authentication/        # 认证相关页面
    ├── seed_phrase/           # 助记词页面
    ├── import_wallet/         # 导入钱包页面
    └── home/                  # 主页（资产列表、转账等）
```

---

## 🚀 快速开始

### 安装依赖

```bash
flutter pub get
```

### 代码生成（freezed / json_serializable）

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 配置环境变量

复制并编辑环境配置文件：

```bash
cp assets/.env.example assets/.env
```

在 `.env` 中填写 RPC 节点地址等配置项。

### 运行应用

```bash
flutter run
```

---
