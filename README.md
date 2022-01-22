# eureka

- Java: 8
- SpringBoot: 2.6.3
- SpringCloud: 2021.0.0

## ENV

- JAVA_OPTS: ""
- JAVA_HEAP_OPTS: "-Xms2g -Xmx2g"
- SERVER_PORT: 8761
- EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://localhost:${SERVER_PORT}/eureka/ 

## 测试方式

```shell
curl http://localhost:8761/eureka/apps
```

## 构造镜像

构造jar包

```shell
mvn clean install -Dmaven.test.skip
```

Docker镜像

```shell
docker build -t geenlubcn/eureka:v1 .
```

多中心

```shell
docker-compose up
```