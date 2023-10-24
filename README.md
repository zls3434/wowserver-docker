# wowserver-docker

> 一个基于TrinityCore的WOW服务端docker的镜像编译包
> 
> WOW服务端基于Wolk 3.3.5a版本,客户端版本12340
> 
> 国内仓库: [wowserver-docker](https://gitee.com/LostDream/wowserver-docker "wowserver-docker - Gitee")

## 需求

需要一个可用的Mysql数据库,可自行选择安装或连接已有数据库.建议使用Mysql官方docker镜像.

## docker hub 镜像

Auth账户服务 `zls3434/wowserver-auth:v3.3.5`

World游戏服务器 `zls3434/wowserver-world:v3.3.5`

## 使用说明

### 编译镜像

可参考`Makefile`文件中的命令

```bash
# 预编译,编译环境镜像和运行时环境镜像
# zls3434/wow-build:latest
# zls3434/wow-base:latest 
sudo make prebuild
# 下载TrinityCore源码
sudo make download
# 执行TrinityCore源码编译及生成服务镜像
# zls3434/wowserver-auth:v3.3.5-20231023(后缀为当前日期)
# zls3434/wowserver-world:v3.3.5-20231023(后缀为当前日期)
sudo make build
```

### 数据库初始化

按照官方文档初始化数据库: [Database-Installation](https://trinitycore.info/en/install/Database-Installation "Database-Installation - TrinityCore MMo Project Wiki")

### 镜像目录结构

```
/wowserver
├── bin
├── data
├── etc
└── logs
```

`/wowserver`目录是服务端的根目录

`bin`目录下放置服务端可执行程序,worldserver所需的数据库sql文件也需映射到此目录下

`data`目录为worldserver的地图资源文件目录,将map mmap等资源所在文件夹映射到此目录下.authserver不需要

`etc`目录为配置文件所在目录,将对应的配置文件映射到此目录下

`logs`目录为日志输出目录,映射此目录以输出日志文件到本地磁盘,方便查看

### 需下载的资源文件

worldserver所需的data文件及数据库sql文件

OneDrive: [wow-resource](https://1drv.ms/f/s!AseXanlJ4N-RwVyJHVsuboGDVpjs?e=11Zuat)

百度网盘: [wow-resource](https://pan.baidu.com/s/1-1L7S4fBuncvWA6NxpKpnA?pwd=wtrz)

### 配置文件

参考编译目录dist/etc中的配置文件模板,修改数据库连接,日志输出路径,worldserver需配置data目录,开启telnet连接以便操作控制台命令

authserver.conf

```conf
LogsDir = "../logs" # 日志输出路径
LoginDatabaseInfo = "host.docker.internal;3306;trinity;trinity;auth" # 数据库连接
```

worldserver.conf

```conf
DataDir = "../data" # 配置data资源文件目录
LogsDir = "../logs" # 日志输出路径
LoginDatabaseInfo     = "host.docker.internal;3306;trinity;trinity;auth" # 数据库连接
WorldDatabaseInfo     = "host.docker.internal;3306;trinity;trinity;world" # 数据库连接
CharacterDatabaseInfo = "host.docker.internal;3306;trinity;trinity;characters" # 数据库连接
Ra.Enable = 1 # 开启telnet远程连接
```

其他配置如无需要请保持默认,新手不建议修改

### 参考部署脚本

docker-compose.yaml

```yaml
version: '3'
services:
  wow-auth:
    image: zls3434/wowserver-auth:v3.3.5
    container_name: wow-auth
    extra_hosts:
      - host.docker.internal:host-gateway
    ports:
      - 3724:3724
    restart: always
    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000
    volumes:
      - ./etc/authserver.conf:/wowserver/etc/authserver.conf
      - ./logs:/wowserver/logs
  wow-world:
    image: zls3434/wowserver-world:v3.3.5
    container_name: wow-world
    stdin_open: true # docker run -i
    tty: true        # docker run -t
    extra_hosts:
      - host.docker.internal:host-gateway
    ports:
      - 8085:8085
      - 3443:3443
    restart: always
    ulimits:
      nproc: 65535
      nofile:
        soft: 20000
        hard: 40000
    volumes:
      - ./TDB_full_world_335.23061_2023_06_14.sql:/wowserver/bin/TDB_full_world_335.23061_2023_06_14.sql
      - ./data:/wowserver/data
      - ./etc/worldserver.conf:/wowserver/etc/worldserver.conf
      - ./logs:/wowserver/logs

```