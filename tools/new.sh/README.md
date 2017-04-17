# 从模板构建项目或文件

一个在命令行的命令`new`，用于从模板创建项目或文件。

## 用法

### 一. 创建模板文件

1. 创建`C`文件
  ```shell
  $ new filename.c
  ```

2. 创建`C++`文件
  ```shell
  $ new filename.cpp
  ```

3. 创建基于`C++`的`oj`提交代码
  ```shell
  $ new filename.acm
  $ # 目录下会有个名为filename.cpp的文件
  ```

### 二. 创建项目

首先需要新建一个项目文件夹名，比如`my-new-project`，然后`cd my-new-project`，
这时我们使用下面命令来建立不同类型的项目。

1. 新建`C`项目
  ```shell
  $ new p c
  ```

2. 新建`C++`项目
  ```shell
  $ new p cpp
  ```

3. 新建基于`gradle`的`Java`项目
  ```shell
  $ new p java
  ```
