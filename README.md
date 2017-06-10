# aliyun-ons-http-ruby-example



## 开发测试环境
    ruby	2.2.3p173
    gem		2.4.5.1
    Bundler	1.10.6

## 安装依赖库
```sh
$ cd aliyun-ons-http-ruby-example/
$ bundle install
```
### 配制
  修改 `config.yml` 参数。
 
  ```
    onsUrl: "publictest-rest.ons.aliyun.com",
    producerID: "producerID",
    consumerID: "consumerID",
    accessKey: "accessKey",
    secretKey: "secretKey",
    topic: "topic"
    path: "/"

  ```
  
### 运行Producer
```sh
$ ruby http_producer.rb
```

### 运行Consumer
```sh
$ ruby http_consumer.rb
```