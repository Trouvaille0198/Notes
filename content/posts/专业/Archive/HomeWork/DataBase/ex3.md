---
draft: true
---

# 实验三

​																																	孙天野 19120198

1. **查询每门课程中分数最高的学生学号和学生姓名。**

    ```sql
    SELECT
    	e.kh,
    	s.xh,
    	s.xm 
    FROM
    	s
    	INNER JOIN e ON s.xh = e.xh 
    WHERE
    	( e.kh, e.zpcj ) IN (
    	SELECT
    		e.kh,
    		max( zpcj ) 
    	FROM
    		e 
    GROUP BY
    	e.kh)
    ```

    ![image-20211216123714030](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211216123714030.png)

2. **查询年龄小于本学院平均年龄，所有课程总评成绩都高于所选课程平均总评成绩的学生学号、姓名和平均总评成绩，按年龄排序。**

    ```sql
    SELECT
    	s.xh,
    	s.xm,
    	avg( e.zpcj ) 
    FROM
    	s
    	INNER JOIN e ON s.xh = e.xh 
    WHERE
    	( 2021-year ( s.csrq ) )< ( SELECT avg( 2021-year ( c.csrq ) ) FROM s AS c WHERE c.yxh = s.yxh ) 
    	AND NOT EXISTS (
    	SELECT
    		* 
    	FROM
    		e AS a 
    	WHERE
    		a.xh = e.xh 
    		AND a.zpcj <(
    		SELECT
    			avg( b.zpcj ) 
    		FROM
    			e AS b 
    		WHERE
    			b.kh = a.kh 
    		) 
    	) 
    GROUP BY
    	s.xh,
    	s.xm 
    ORDER BY
    	(
    	2021-year ( s.csrq ) 
    	)
    ```

3. **求年龄大于所有女同学年龄的男学生姓名和年龄。**

    ```sql
    SELECT
    	xm,
    	2021-year ( csrq ) 
    FROM
    	s 
    WHERE
    	xb = '男' 
    	AND 2021-year ( csrq )>(
    	SELECT
    		max(
    		2021-year ( a.csrq )) 
    	FROM
    		s as a
    WHERE
    	xb = '女')
    ```
    
    ![image-20211216133401892](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211216133401892.png)
    
4. **检索每学期每门课的学生排名情况，输出学期，课程号，学号，成绩，排名；按学期降序，相同按课程号升序，课程相同按排名从高到低。**

    ```sql
    SELECT
    	e1.xq,
    	e1.kh,
    	e1.xh,
    	e1.zpcj,	
    	count(*) AS pm 
    FROM
    	e AS e1,
    	e AS e2 
    WHERE
    	(
    		e2.zpcj > e1.zpcj 
    	OR ( e1.zpcj = e2.zpcj AND e1.xh = e2.xh )) 
    	AND e1.kh = e2.kh 
    	AND e1.xq = e2.xq 
    GROUP BY
    	e1.xq,
    	e1.kh,
    	e1.xh,
    	e1.zpcj
    ORDER BY
    	e1.xq DESC,
    	e1.kh ASC,
    	e1.zpcj DESC;
    ```

5. **查询计算机学院男生选修本学院教授开设的课不及格的且还未重修的课，输出学生的学期，学号，课号，按学期升序，学期相同按学号升序排列。**

    ```sql
    SELECT
    	e.xq,
    	s.xh,
    	e.kh 
    FROM
    	e
    	INNER JOIN s ON e.xh = s.xh
    	INNER JOIN t ON e.gh = t.gh
    	INNER JOIN c ON e.kh = c.kh 
    WHERE
    	s.xb = '男' 
    	AND s.yxh = 1 
    	AND t.xl = '教授' 
    	AND t.yxh = 1 
    	AND e.zpcj < 60 
    ORDER BY
    	e.xq,
    	s.xh
    ```
    

