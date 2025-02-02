use project3;
select * from job_data;

/*
A. Jobs Reviewed Over Time:
Your Task: Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.
*/
-- select ds,count(job_id),sum(time_spent) from job_data
-- group by ds;

-- select j.ds,sum(d.j_count/d.t_time) from job_data j
-- inner join (select ds,count(job_id) as j_count,sum(time_spent) as t_time from job_data
-- group by ds) d on d.ds=j.ds
-- group by j.ds;
select date(ds),round(count(job_id)/(sum(time_spent)/3600),0) as "jobs_per_hour" from job_data
group by ds;

select avg(jobs_per_hour) from
		(select ds,round(count(job_id)/(sum(time_spent)/3600),0) as "jobs_per_hour"
		 from job_data
		 group by ds) s;


-- select * from job_data;
-- select avg(t) as 'avg jobs reviewed per day per hour',
-- avg(p) as 'avg jobs reviewed per day per second'
-- from
-- (select 
-- ds,
-- ((count(job_id)*3600)/sum(time_spent)) as t,
-- ((count(job_id))/sum(time_spent)) as p
-- from 
-- job_data
-- where 
-- month(ds)=11
-- group by ds) a;

/*
B. throughput Analysis:
Objective: Calculate the 7-day rolling average of throughput (number of events per second).
Your Task: Write an SQL query to calculate the 7-day rolling average of throughput. 
		   Additionally, explain whether you prefer using the daily metric or the 7-day
           rolling average for throughput, and why.
*/
with days7 as (select date(ds) as date,
					  (count(job_id) over(order by ds rows between  6 preceding  and current row) /
				      sum(time_spent) over(order by ds rows between 6 preceding  and current row) ) as throughput_7DayRolling
                   from job_data)
select date,count(j.job_id)/sum(j.time_spent) as throught_perDay,
			round(avg(throughput_7DayRolling),4) as rolling_avg7days from days7 d
inner join job_data j on j.ds=d.date
group by date
order by date;

/*
C. Language Share Analysis:
Objective: Calculate the percentage share of each language in the last 30 days.
Your Task: Write an SQL query to calculate the percentage share of each language over the last 30 days.
*/
select language as lan, round(((count(language)/8)*100),2) as lan_share_percent
from job_data group by language;

/*
D. Duplicate Rows Detection:
Objective: Identify duplicate rows in the data.
Your Task: Write an SQL query to display duplicate rows from the job_data table.
*/
select ds,job_id,actor_id,event,language,time_spent,org,count(*) from job_data
group by ds,job_id,actor_id,event,language,time_spent,org
having count(*)>1;


