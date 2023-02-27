/*Convert to multi-columns tables*/
create or replace table dar_project2.ods.business_raw(
	business_id varchar,
    name varchar,
	address varchar,
    city varchar,
    state varchar,
    postal_code varchar,
    latitude double,
    longitude double,
    stars double,
    review_count int,
    is_open int,
    restaurant_takeout varchar,
	business_parking varchar,
    category varchar,
    hours varchar
);

insert into dar_project2.ods.business_raw
select
	business_info: business_id,
    business_info: name,
    business_info: address,
    business_info: city,
    business_info: state,
    business_info: postal_code,
    business_info: latitude,
    business_info: longitude,
    business_info: stars,
    business_info: review_count,
    business_info: is_open,
    business_info: attributes.RestaurantsTakeOut,
    business_info: attributes.BusinessParking::string,
    business_info: categories::string,
    business_info: hours::string
from
	dar_project2.stg.business;
	

create or replace table dar_project2.ods.review_raw(
	review_id varchar,
    user_id varchar,
    business_id varchar,
    stars int,
    date date,
    text varchar,
    useful int,
    funny int,
    cool int
);

insert into dar_project2.ods.review_raw
select
	review_info: review_id,
    review_info: user_id,
    review_info: business_id,
    review_info: stars,
    review_info: date,
    review_info: text,
    review_info: useful,
    review_info: funny,
    review_info: cool
from
	dar_project2.stg.review;
	

create or replace table dar_project2.ods.user_raw(
	user_id varchar,
    name varchar,
    review_count int,
    yelping_since date,
    friends varchar,
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
    compliment_photos int
);

insert into dar_project2.ods.user_raw
select
	user_info: user_id,
    user_info: name,
    user_info: review_count,
    user_info: yelping_since,
    user_info: friends::string,
    user_info: useful,
    user_info: funny,
    user_info: cool,
    user_info: fans,
    user_info: elite::string,
    user_info: average_stars,
    user_info: compliment_hot,
    user_info: compliment_more,
    user_info: compliment_profile,
    user_info: compliment_cute,
    user_info: compliment_list,
    user_info: compliment_note,
    user_info: compliment_plain,
    user_info: compliment_cool,
    user_info: compliment_funny,
    user_info: compliment_writer,
    user_info: compliment_photos
from
	dar_project2.stg.user
	

create or replace table dar_project2.ods.checkin_raw(
	business_id varchar,
    date datetime
);

insert into dar_project2.ods.checkin_raw
select
	checkin_info: business_id,
    date.value:: date
from dar_project2.stg.checkin,
lateral flatten(input=>split(checkin_info: date, ', ')) AS date;


create or replace table tip_raw(
	text varchar,
    date date,
    compliment_count int,
    business_id varchar,
    user_id varchar
);

insert into dar_project2.ods.tip_raw
select
	tip_info: text,
    tip_info: date,
    tip_info: compliment_count,
    tip_info: business_id,
    tip_info: user_id
from dar_project2.stg.tip

create or replace table covid_raw(
	business_id varchar,
    highlights varchar,
    delivery_or_takeout varchar,
    grubhub_enabled varchar,
    call_to_action_enabled varchar,
    request_a_quote_enabled varchar,
    covid_banner varchar,
    temporary_closed_until varchar,
    virtual_services_offered varchar
);

insert into dar_project2.ods.covid_raw
select
	covid_info: business_id,
    covid_info: highlights,
    covid_info: delivery_or_takeout,
    covid_info: grubhub_enabled,
    covid_info: call_to_action_enabled,
    covid_info: request_a_quote_enabled,
    covid_info: covid_banner,
    covid_info: temporary_closed_until,
    covid_info: virtual_services_offered
from dar_project2.stg.covid


create or replace table dar_project2.ods.temperature_raw(
	date date primary key,
    temp_min int,
    temp_max int,
    normal_temp_min double,
    normal_temp_max double
);

insert into dar_project2.ods.temperature_raw
select
	try_to_date(to_char(date), 'YYYYMMDD'),
    try_to_decimal(min),
    try_to_decimal(max),
    try_to_double(normal_min),
    try_to_double(normal_max)
from
	dar_project2.stg.temperature


create or replace table dar_project2.ods.precipitation_raw(
	date date primary key,
    precipitation double,
    precipitation_normal double
);

insert into dar_project2.ods.precipitation_raw
select
	try_to_date(to_char(date), 'YYYYMMDD'),
	try_to_double(precipitation),
    try_to_double(precipitation_normal)
from
	dar_project2.stg.precipitation