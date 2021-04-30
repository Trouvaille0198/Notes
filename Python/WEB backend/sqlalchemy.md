# 一、认识

ORM：Object Relational Mapping（对象关系映射）将数据库中的表与类构建映射

- 简洁易读：将数据表抽象为对象（数据模型），更直观易读
- 可移植：封装了多种数据库引擎，面对多个数据库，操作基本一致，代码易维护
- 更安全：有效避免 SQL 注入

## 1.1 概念

| 概念    | 对应               | 说明                 |
| ------- | ------------------ | -------------------- |
| engine  | 连接               | 驱动引擎             |
| session | 连接池、事务、会话 | 由此开始查询         |
| model   | 表                 | 类定义               |
| column  | 列                 |                      |
| query   | 若干行             | 可以链式添加多个文件 |



- engine
    - 位于数据库驱动之上的一个抽象概念，它适配了各种数据库驱动，提供了连接池等功能
    - 用法：`engine = create_engine(<数据库连接串>)`
        - 数据库连接串的格式是 `dialect+driver://username:password@host:port/database?参数`
        - dialect 可以是 `mysql`, `postgresql`, `oracle`, `mssql`, `sqlite`，后面的 driver 是驱动，比如MySQL的驱动pymysql， 如果不填写，就使用默认驱动
        - 再往后就是用户名、密码、地址、端口、数据库、连接参数
        - 例
            - MySQL: `engine = create_engine('mysql+pymysql://scott:tiger@localhost/foo?charset=utf8mb4')`
            - PostgreSQL: `engine = create_engine('postgresql+psycopg2://scott:tiger@localhost/mydatabase')`
            - Oracle: `engine = create_engine('oracle+cx_oracle://scott:tiger@tnsname')`
            - MS SQL: `engine = create_engine('mssql+pymssql://scott:tiger@hostname:port/dbname')`
            - SQLite: `engine = create_engine('sqlite:////absolute/path/to/foo.db')`

