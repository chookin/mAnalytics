# init mysql
1.  初始化数据库

<pre>
$ scripts/mysql_install_db --defaults-file=etc/my.cnf
</pre>
2.  启动, 确保相应的端口和socket没有被占用

<pre>
$ mkdir var
$ bin/mysqld_safe  --defaults-file=etc/my.cnf &
</pre>
3.  修改mysql本地服务器localhost的root帐号密码

<pre>
$ bin/mysqladmin -u root password "123456"
</pre>

4. 创建mysql账户

<pre>
$ bin/mysql -u root -p123456
grant all on *.* to 'yyttest'@'%' identified by 'Abc123';
grant all on *.* to 'yyttest'@'localhost' identified by 'Abc123';
select user, host, password from mysql.user;
flush privileges;
exit;
</pre>
test login:

<pre>
$ bin/mysql -u yyttest -pAbc123
</pre>
# init db
<pre>
source   ~/mAnalytics/resources/sql/labs.sql;
source   ~/mAnalytics/resources/sql/report_conf.sql;
source   ~/mAnalytics/resources/sql/setting_ip.sql;
source   ~/mAnalytics/resources/sql/setting_rgn.sql;
</pre>
# 初始化系统角色与权限的步骤
1、将附件的cmb_access.sql  cmb_node.sql  cmb_role.sql上传至主库所在服务器的某个路径下,假设为~/mAnalytics/mysql_init_db

2、登录主库所在服务器, 依次执行以下命令
<pre>
use CMB_TARGET;
source   ~/mAnalytics/resources/sql/cmb_access.sql;
source   ~/mAnalytics/resources/sql/cmb_node.sql
source   ~/mAnalytics/resources/sql/cmb_role.sql
Insert into cmb_user(id, account,nickname,password,bind_account,status) values(1,'admin','admin','1b6c4ef06f9035b85d2aaac0f00f5bc1','admin',1);
Insert into cmb_role_user(role_id, user_id) values(1, 1);
</pre>
note: insert user info to CMB_TARGET.cmb_user, and the username/password is admin/StoneSun88*99

# Appendix
## 数据库导出导入
1.  导出数据库表结构

<pre>
$ bin/mysqldump -d -u someuser -p mydatabase > mydatabase.sql
</pre>
参数说明：
* -u 指示用户名
* -p 指示需要输入密码，当然可以在命令行中提供密码，但是密码需紧跟着-p标志，中间不能有密码。
* -d 表示不导出表数据，和--no-data意义一样。
2.  导出数据库中的数据表
在命令行后面追加需要导出的数据库表名即可。

<pre>
$ bin/mysqldump -d -u someuser -p -h mysql_hostname mydatabase products categories users > mydatabase.sql
</pre>
3.  导出多个数据库

<pre>
$ bin/mysql -u root -p --databases db_a db_b db_c > dbs.sql;
</pre>
4.  导入数据库

<pre>
$ bin/mysql -u someuser -p anotherdatabase < mydatabase.sql
</pre>
或者，登录mysql,执行

<pre>
mysql> source mydatabase.sql
</pre>
## config firewall
防火墙默认没有开启3306端口，若要远程访问，需要开启这个端口。编辑/etc/sysconfig/iptables，添加：
<pre>
-A INPUT -m state --state NEW -m tcp -p -dport 3306 -j ACCEPT
</pre>
