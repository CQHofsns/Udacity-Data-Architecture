/*Create dimension business table*/
create or replace table dar_project2.dwh.dimension_business(
    business_id varchar primary key,
    name varchar,
    city_name varchar,
    state_name varchar,
    address varchar,
    postal_code varchar,
    latitude double,
    longitude double,
    stars double,
    review_count int,
    is_open int,
    restaurant_takeout varchar
) as
select
    business.business_id,
    business.name,
    city.city_name,
    state.state_name,
    business.address,
    business.postal_code,
    business.latitude,
    business.longitude,
    business.stars,
    business.review_count,
    business.is_open,
    business.restaurant_takeout
from
	dar_project2.ods.business_normalized as business
join dar_project2.ods.business_city as city on city.city_id= business.city_id
join dar_project2.ods.business_state as state on state.state_id= business.state_id;

/*Create dimension reivew date*/
create or replace table dar_project2.dwh.dimension_review_date(
	date date primary key,
    review_year int,
    review_month int,
    review_day int
) as
select distinct
	date,
    year(date),
    month(date),
    day(date)
from dar_project2.ods.review_normalized;

/*Create dimension weather*/
create or replace table dar_project2.dwh.dimension_weather(
	date date primary key,
    temp_min int,
    temp_max int,
    normal_temp_min double,
    normal_temp_max double,
    precipitation double,
    precipitation_normal double
) as
select
	*
from dar_project2.ods.weather;


/*Create fact daily review table*/
create or replace table dar_project2.dwh.fact_daily_review(
	business_review_id int autoincrement primary key,
    business_id varchar,
    date date,
    avg_stars double,
    avg_useful double,
    avg_funny double,
    avg_cool double,
    foreign key(business_id) references dar_project2.dwh.dimension_business(business_id),
    foreign key(date) references dar_project2.dwh.dimension_weather(date),
    foreign key(date) references dar_project2.dwh.dimension_review_date(date)
);

insert into dar_project2.dwh.fact_daily_review(business_id, date, avg_stars, avg_useful, avg_funny, avg_cool)
select
    business_id,
    date,
    avg(stars)::double as avg_stars,
    avg(useful)::double as avg_useful,
    avg(funny)::double as avg_funny,
    avg(cool)::double as avg_cool
from 
    dar_project2.ods.review_normalized
group by
    business_id,
    date;
	
/*Report Query*/
select
	dim_business.name,
    fact.date,
    fact.avg_stars,
    fact.avg_useful,
    fact.avg_funny,
    fact.avg_cool,
    dim_weather.temp_min,
    dim_weather.temp_max,
    dim_weather.precipitation
from
	dar_project2.dwh.fact_daily_review as fact
join
	dar_project2.dwh.dimension_business as dim_business 
on dim_business.business_id= fact.business_id
join
	dar_project2.dwh.dimension_review_date as dim_date
on
	dim_date.date= fact.date
join
	dar_project2.dwh.dimension_weather as dim_weather
on
	dim_weather.date= fact.date

