/*Adding constraint to User table*/
create or replace table dar_project2.ods.user_normalized(
	user_id varchar primary key,
    name varchar,
    review_count int,
    yelping_since date,
    useful int,
    funny int,
    cool int,
    fans int,
    elite varchar,
    average_stars double,
    compliment_hot int,
    compliment_more int,
    compliment_profile int,
    compliment_cute int,
    compliment_list int,
    compliment_note int,
    compliment_plain int,
    compliment_cool int,
    compliment_funny int,
    compliment_writer int,
    compliment_photos int,
    foreign key(user_id) references dar_project2.ods.user_friend_info(user_id)
) as
select
	user_id,
    name,
    review_count,
    yelping_since,
    useful,
    funny,
    cool,
    fans,
    elite,
    average_stars,
    compliment_hot,
    compliment_more,
    compliment_profile,
    compliment_cute,
    compliment_list,
    compliment_note,
    compliment_plain,
    compliment_cool,
    compliment_funny,
    compliment_writer,
    compliment_photos
from dar_project2.ods.user_raw
where user_id is not null;


/*Create new table user-friend and populating data into table*/
create or replace table user_friend_info (
	user_id varchar primary key,
	friend_id varchar,
    foreign key(friend_id) references dar_project2.ods.user_normalized(user_id)
) as
select
	user_id,
    friends.value:: varchar AS friend_id
from dar_project2.ods.user_raw,
lateral flatten(input=>split(friends, ', ')) AS friends;

/*Create Business City table*/
create or replace table dar_project2.ods.business_city(
	city_id int autoincrement primary key,
    city_name varchar
); 
insert into dar_project2.ods.business_city(city_name)
select distinct
	city
from dar_project2.ods.business_raw;

/*Create Business State table*/
create or replace table dar_project2.ods.business_state(
	state_id int autoincrement primary key,
    state_name varchar
); 
insert into dar_project2.ods.business_state(state_name)
select distinct
	state
from dar_project2.ods.business_raw;

/*Adding constraint to Covid table*/
create or replace table dar_project2.ods.business_covid_feature(
	business_id varchar primary key,
    highlights varchar,
    delivery_or_takeout varchar,
    grubhub_enabled varchar,
    call_to_action_enabled varchar,
    request_a_quote_enabled varchar,
    covid_banner varchar,
    temporary_closed_until varchar,
    virtual_services_offered varchar
) as 
select
	*
from dar_project2.ods.covid_raw where business_id is not null;

/*Normalize business table*/
create or replace table dar_project2.ods.business_normalized(
    business_id varchar primary key,
    name varchar,
	address varchar,
    city_id int,
    state_id int,
    postal_code varchar,
    latitude double,
    longitude double,
    stars double,
    review_count int,
    is_open int,
    restaurant_takeout varchar,
	business_parking varchar,
    category varchar,
    hours varchar,
    foreign key(business_id) references dar_project2.ods.business_covid_feature(business_id),
    foreign key(city_id) references dar_project2.ods.business_city(city_id),
    foreign key(state_id) references dar_project2.ods.business_state(state_id)
) as 
select
	b.business_id,
    b.name,
    b.address,
    c.city_id,
    s.state_id,
    b.postal_code,
    b.latitude,
    b.longitude,
    b.stars,
    b.review_count,
    b.is_open,
    b.restaurant_takeout,
    b.business_parking,
    b.category,
    b.hours
from dar_project2.ods.business_raw as b
join dar_project2.ods.business_city as c on c.city_name= b.city
join dar_project2.ods.business_state as s on s.state_name= b.state
where business_id is not null;


/*Normalize checkin table*/
create or replace table dar_project2.ods.checkin_normalized(
	business_id varchar primary key,
    date datetime,
    foreign key(business_id) references dar_project2.ods.business_normalized(business_id)
) as
select
	*
from dar_project2.ods.checkin_raw where business_id is not null;


/*Normalize review table*/
create or replace table dar_project2.ods.review_normalized(
	review_id varchar primary key,
    user_id varchar,
    business_id varchar,
    stars int,
    date date,
    text varchar,
    useful int,
    funny int,
    cool int,
    foreign key(user_id) references dar_project2.ods.user_normalized(user_id),
    foreign key(business_id) references dar_project2.ods.business_normalized(business_id),
    foreign key(date) references dar_project2.ods.weather(date)
) as
select
	*
from dar_project2.ods.review_raw where review_id is not null;


/*Normalize tip table*/
create or replace table dar_project2.ods.tip_normalized(
	tip_id int autoincrement primary key,
	text varchar,
    date date,
    compliment_count int,
    business_id varchar,
    user_id varchar,
    foreign key(business_id) references dar_project2.ods.business_normalized(business_id),
    foreign key(user_id) references dar_project2.ods.user_normalized(user_id),
    foreign key(date) references dar_project2.ods.weather(date)
);
insert into dar_project2.ods.tip_normalized(text, date, compliment_count, business_id, user_id)
select
	*
from dar_project2.ods.tip_raw;

/*JOIN temperature and precipitation tables*/
create or replace table dar_project2.ods.weather(
	date date primary key,
    temp_min int,
    temp_max int,
    normal_temp_min double,
    normal_temp_max double,
    precipitation double,
    precipitation_normal double
)
as
select
	temp.date,
    coalesce(temp.temp_min, (select median(temp_min) from dar_project2.ods.temperature_raw)),
    coalesce(temp.temp_max, (select median(temp_max) from dar_project2.ods.temperature_raw)),
    coalesce(temp.normal_temp_min, (select median(normal_temp_min) from dar_project2.ods.temperature_raw)),
    coalesce(temp.normal_temp_max, (select median(normal_temp_max) from dar_project2.ods.temperature_raw)),
    coalesce(prec.precipitation, (select median(precipitation) from dar_project2.ods.precipitation_raw)),
    coalesce(prec.precipitation_normal, (select median(precipitation_normal) from dar_project2.ods.precipitation_raw))
from
	dar_project2.ods.temperature_raw as temp
join
	dar_project2.ods.precipitation_raw as prec
on
	temp.date= prec.date