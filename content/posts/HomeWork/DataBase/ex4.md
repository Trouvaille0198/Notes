# 实验四

​																																	孙天野 19120198

对 school 数据库做如下操作：

1. **建立计算机学院总评不及格成绩学生的视图，包括学生学号、姓名、性别、手机、所选课程和成绩**

    ```sql
    CREATE VIEW view1 ( xh, xm, xb, sjhm, km, zpcj ) AS (
    	SELECT
    		e.xh,
    		xm,
    		xb,
    		sjhm,
    		km,
    		zpcj 
    	FROM
    		e
    		INNER JOIN s ON e.xh = s.xh
    		INNER JOIN c ON e.kh = c.kh 
    	WHERE
    	e.zpcj < 60 
    	AND s.yxh = 1)
    ```

    ![image-20211223134705794](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211223134705794.png)

2. **求年龄大于所有女同学年龄的男学生姓名和年龄**

    ```sql
    SELECT
    	xm,
    	2021-year ( s.csrq ) AS age	
    FROM
    	s 
    WHERE
    	s.xb = "男" 
    	AND s.csrq <(
    	SELECT
    		min( s.csrq ) 
    	FROM
    		s 
    WHERE
    	s.xb = "女")
    ```

    ![image-20211223134734056](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211223134734056.png)

3. **在 E 表中修改 08305001 课程的平时成绩，若成绩小于等于 75 分时提高 5%，若成绩大于 75 分时提高 4%**

    ```sql
    UPDATE e SET pscj = pscj * 1.05 WHERE pscj <= 75; 
    UPDATE e SET pscj = pscj * 1.04 WHERE pscj > 75;
    ```

4. **删除没有开课的学院**

    ```sql
    DELETE 
    FROM
    	d 
    WHERE
    	NOT EXISTS (
    	SELECT
    		* 
    	FROM
    		o
    		INNER JOIN c ON o.kh = c.kh 
    	WHERE
    	c.yxh = d.yxh 
    	)
    ```

    

