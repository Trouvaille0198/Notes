# 一、环境安装

## 1.1 Node.js

1. 执行以下命令，下载 Node.js Linux 64位二进制安装包。

    ```
    wget https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-x64.tar.xz
    ```

2. 执行以下命令，解压安装包。

    ```
    tar xvf node-v10.16.3-linux-x64.tar.xz
    ```

3. 依次执行以下命令，创建软链接。

    ```
    ln -s /root/node-v10.16.3-linux-x64/bin/node /usr/local/bin/node
    ```

    ```
    ln -s /root/node-v10.16.3-linux-x64/bin/npm /usr/local/bin/npm
    ```

    成功创建软链接后，即可在云服务器任意目录下使用 node 及 npm 命令。

4. 依次执行以下命令，查看 Node.js 及 npm 版本信息。

    ```
    node -v
    ```

    ```
    npm -v
    ```