---
draft: true
---

# 实验二

​																																	孙天野 19120198

对 school 数据库做如下查询：

1. **验证在 1000 万个以上记录时在索引和不索引时的查询时间区别。**

    没有索引的情况：

    <img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211214175749837.png" alt="image-20211214175749837" style="zoom:50%;" />

    建立索引的过程：

    <img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211214180215055.png" alt="image-20211214180215055" style="zoom:50%;" />

    建立索引后：

    <img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211214180200647.png" alt="image-20211214180200647" style="zoom:50%;" />

    用以插入记录的脚本：

    ```python
    import pymysql
    import string
    from pymysql import cursors
    conn = pymysql.connect(host= 'localhost',user='root',passwd='',db='school',charset='utf8')
    cursor = conn.cursor()
    cursor.execute("delete from a")
    conn.commit
    
    for j in range(0,100):
    	values = []
    	i=0
    	for i in range(100000*j,100000*(j+1)):
    		values.append((i))
    	cursor.executemany('insert into a values(%s)',values)
    	print("insert"+str((j+1)*100000))
    	conn.commit()
    
    
    cursor.close
    conn.close()
    ```

2. **查询 2011 年进校年龄大于 20 岁的男学生的学号与姓名。**

    ```sql
    SELECT
    	xh,
    	xm
    FROM
    	s
    WHERE
    	2011 - YEAR(csrq) > 20
    	AND xb = '男';
    ```
    
3. **检索刘晓明不学的课程的课程号。**

    ```sql
    SELECT
    	kh
    FROM
    	c
    WHERE
    	kh NOT IN (
    		SELECT
    			kh
    		FROM
    			e
    			INNER JOIN s ON e.xh = s.xh
    		WHERE
    			xm = '刘晓明'
    	);
    ```
    
    ```sql
    SELECT
    	c.kh
    FROM
    	c
    WHERE
    	'刘晓明' not in (
        select xm 
        from s inner join e on s.xh=e.xh
        where e.kh=c.kh
        );
    ```
    
    ```sql
    SELECT
    	c.kh
    FROM
    	c
    WHERE
    	not exists (
        select *
        from s inner join e on s.xh=e.xh
        where e.kh=c.kh and s.xm='刘晓明'
        );
    ```
    
    ![image-20211216124216706](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211216124216706.png)
    
4. **查询计算机学院男生成绩及格、教授开设的课程的课程号、课名、开课教师姓名，按开课教师升序，课程号降序排序。**

    ```sql
    SELECT
    	e.kh,
    	c.km,
    	t.xm 
    FROM
    	e
    	INNER JOIN s ON e.xh = s.xh
    	INNER JOIN t ON e.gh = t.gh
    	INNER JOIN c ON e.kh = c.kh 
    WHERE
    	s.xb = '男' 
    	AND t.xl = '教授' 
    	AND zpcj >= 60 
    ORDER BY
    	t.gh ASC,
    	c.kh DESC
    ```

5. **检索学号比张颖同学大，年龄比张颖同学小的同学学号、姓名。**

    ```sql
    SELECT xh,xm
    FROM s
    WHERE 
    	xh>(SELECT xh FROM s WHERE xm='张颖') 
    	AND 
    	csrq<(SELECT csrq FROM s WHERE xm='张颖')
    ```

    ![image-20211216124258498](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211216124258498.png)

6. **检索同时选修了“08305001”和“08305002”的学生学号和姓名。**

    ```sql
    SELECT
    	xh,
    	xm 
    FROM
    	s 
    WHERE
    	xh IN (
    	SELECT
    		a.xh 
    	FROM
    		e AS a,
    		e AS b 
    	WHERE
    		a.kh = '08305001' 
    	AND b.kh = '08305002' 
    	AND a.xh = b.xh)
    ```

    ![image-20211216124320697](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211216124320697.png)

7. **查询每个学生选课情况（包括没有选修课程的学生）。**

    ```sql
    SELECT
    	s.xm,
    	c.km 
    FROM
    	s
    	LEFT JOIN e ON s.xh = e.xh
    	LEFT JOIN c ON e.kh = c.kh
    ```
    
    ![image-20211216124342967](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211216124342967.png)