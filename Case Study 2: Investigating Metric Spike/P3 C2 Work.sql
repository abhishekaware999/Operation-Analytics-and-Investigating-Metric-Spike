use project3;
select * from users;
select * from events;
select * from email_events;
-- alter table users change column ï»¿user_id user_id int;
-- alter table email_events change column ï»¿user_id user_id int;
/*
A. Weekly User Engagement:
Objective: Measure the activeness of users on a weekly basis.
Your Task: Write an SQL query to calculate the weekly user engagement.
*/
select *,user_engagement-lag(user_engagement) over(partition by 'week_number') as changeInEngagement
from
(select week(occurred_at) as week_number,
	   count(event_type) as user_engagement
from events where event_type = 'engagement'
group by week(occurred_at)) s;

/*
B.User Growth Analysis:
Objective: Analyze the growth of users over time for a product.
Your Task: Write an SQL query to calculate the user growth for the product.
*/
select year(created_at) as year,
	   month(created_at) as month,
       count(user_id) as new_user,
       state
from users 
group by year(created_at), month(created_at),state;

select *,
	new_user - lag(new_user) over(order by year,month) as user_growth_perMonth
from 
(select year(created_at) as year,
	   month(created_at) as month,
       count(user_id) as new_user
from users 
group by year(created_at), month(created_at)) s;

/*
Weekly Retention Analysis:
Objective: Analyze the retention of users on a weekly basis after signing up for a product.
Your Task: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.
*/
select * from events;
select extract(week from occurred_at) as weeks, 
count(distinct user_id) as no_of_users from events
where event_type="signup_flow" and event_name="complete_signup" 
group by weeks order by weeks;

#4. calc the weekly user engagement per device

select * from events;
select device, extract(week from occurred_at) as weeks, 
count(distinct user_id) as no_of_users from events 
where event_type="engagement"
group by device, weeks order by weeks; 

#5. calc the users email engagement metrics

select * from email_events;
select count(action) as action_count, action from email_events group by action;
select 
(sum(case when 
email_category="email_opened" then 1 else 0 end)/sum(case when email_category="email_sent" then 1 else 0 end))*100 as open_rate,
(sum(case when 
email_category="email_clickthrough" then 1 else 0 end)/sum(case when email_category="email_sent" then 1 else 0 end))*100 as click_rate
from (
	select *, 
	case 
		when action in ("sent_weekly_digest", "sent_reengagement_email") then ("email_sent")
		when action in ("email_open") then ("email_opened")
		when action in ("email_clickthrough") then ("email_clickthrough")
	end as email_category
	from email_events_table) as alias;


