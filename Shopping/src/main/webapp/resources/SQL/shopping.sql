desc tbl_test;

select to_char(writeday, 'yyyy-mm-dd hh24:mi:ss') AS writeday
from tbl_test;

select seq, name, age, to_char(writeday, 'yyyy-mm-dd hh24:mi:ss') AS writeday
from tbl_test;

create table dowell_member (
pk_emp_no      number,
emp_name       VARCHAR2(10),
id             VARCHAR2(20),
passwd         VARCHAR2(20),
email          VARCHAR2(100),
phone          VARCHAR2(20)
);

select pk_emp_no, emp_name, id, passwd, email, phone
from dowell_member
