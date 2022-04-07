### container-server
server demo, integration container-web

##### start server
    npm start

##### package
    npm pkg
    can build package support mac/windows/linux
    output directory: ./output
    
##### integration
    package container-web
    move to ./dist
    npm pkg
    
##### use
    一、准备环境：
    	linux centos 7.6
    	内核3.10以上 可通过命令uname -r查询
    二、安装docker
    	以下命令需要使用root执行，如果非root，命令前加sudo
    	1. 安装需要的软件包
    		yum install -y yum-utils device-mapper-persistent-data lvm2
    	2. 设置yum源（以下两个任选其一）
    		yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    		yum-config-manager --add-repo http://download.docker.com/linux/centos/docker-ce.repo
    	3. 安装docker
    		yum install docker
    	4. 启动docker并设置开机自启
    		systemctl start docker
    		systemctl enable docker
    三、执行
    	1. 将zip包上传至服务器，解压：unzip container.zip
    	2. 执行./container-server &
