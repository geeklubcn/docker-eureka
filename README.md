# eureka

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