# eureka

- Java: 8
- SpringBoot: 2.6.3
- SpringCloud: 2021.0.0

## ENV

- JAVA_OPTS: ""
- JAVA_HEAP_OPTS: "-Xms2g -Xmx2g"
- SERVER_PORT: 8001
- EUREKA_instance_hostname: eureka-1
- EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eureka-2:8002/eureka/,http://eureka-3:8003/eureka/
- EUREKA_CLIENT_REGISTERWITHEUREKA: "true"
- EUREKA_CLIENT_FETCHREGISTRY: "true"

## 使用

Eureka为AP，Zookeeper为CP。
zk需要过半存活才可使用，eureka只要有一个存活就可使用。因此独立部署或者组成集群均可保障高可用

### Standalone Mode

- 关闭EurekaServer中的Client注册行为。镜像默认为关闭默认。
- EurekaClient向多个EurekaServer进行注册

```yaml
version: '3'
services:
  eureka-1:
    build: .
    restart: always
    ports:
      - "8001:8001"
    environment:
      SERVER_PORT: 8001
      EUREKA_instance_hostname: eureka-1
  eureka-2:
    build: .
    restart: always
    ports:
      - "8002:8002"
    environment:
      SERVER_PORT: 8002
      EUREKA_instance_hostname: eureka-2
  eureka-3:
    build: .
    restart: always
    ports:
      - "8003:8003"
    environment:
      SERVER_PORT: 8003
      EUREKA_instance_hostname: eureka-3
```

### Peer Awareness

- 开启EurekaServer中的Client注册行为
- EurekaClient向任意一个EurekaServer进行注册，会被扩散到所有EurekaServer

```yaml
version: '3'
services:
  eureka-1:
    build: .
    restart: always
    ports:
      - "8001:8001"
    environment:
      SERVER_PORT: 8001
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eureka-2:8002/eureka/,http://eureka-3:8003/eureka/
      EUREKA_CLIENT_REGISTERWITHEUREKA: "true"
      EUREKA_CLIENT_FETCHREGISTRY: "true"
      EUREKA_instance_hostname: eureka-1
  eureka-2:
    build: .
    restart: always
    ports:
      - "8002:8002"
    environment:
      SERVER_PORT: 8002
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eureka-1:8001/eureka/,http://eureka-3:8003/eureka/
      EUREKA_CLIENT_REGISTERWITHEUREKA: "true"
      EUREKA_CLIENT_FETCHREGISTRY: "true"
      EUREKA_instance_hostname: eureka-2
  eureka-3:
    build: .
    restart: always
    ports:
      - "8003:8003"
    environment:
      SERVER_PORT: 8003
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://eureka-1:8001/eureka/,http://eureka-2:8002/eureka/
      EUREKA_CLIENT_REGISTERWITHEUREKA: "true"
      EUREKA_CLIENT_FETCHREGISTRY: "true"
      EUREKA_instance_hostname: eureka-3
```

![eureka_0](https://raw.githubusercontent.com/geeklubcn/docker-eureka/master/.doc/eureka_0.png)


### 测试方式

```shell
curl http://localhost:8001/eureka/apps
```

## 配置说明

### 健康检测

依赖actuator. 确认pom.xml中包含相关依赖

```xml

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

测试请求

```shell
curl http://localhost:8761/actuator/health
```

### 构造镜像

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

## 其他

- https://cloud.spring.io/spring-cloud-netflix/reference/html/#spring-cloud-eureka-server