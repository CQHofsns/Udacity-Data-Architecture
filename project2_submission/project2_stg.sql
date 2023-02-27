/*Create DB for the project*/
create DATABASE DAr_PROJECT2;

/* Create 3 Schema for each process*/
create schema STG;
create schema ODS;
create schema DWH;

/*Create JSON file format with ZIP compression*/
create or replace file format project2_json_format type='JSON' strip_outer_array=true COMPRESSION="GZIP";

/*Create CSV file format with ZIP compression*/
create or replace file format project2_csv_format  type='CSV' compression='auto' field_delimiter=',' record_delimiter = '\n' skip_header=1 error_on_column_count_mismatch=true null_if = ('NULL', 'null', '', ' ') empty_field_as_null = true;

/*Create a staging area before loading to staging table */
create or replace stage project2_json_stage file_format = project2_json_format;
create or replace stage project2_csv_stage file_format = project2_csv_format;

/*Put the local file to STG stage*/
/*If json file*/
PUT file://<local_path>\YELP_ds\yelp_academic_dataset_business.json @project2_json_stage;
PUT file://<local_path>\YELP_ds\yelp_academic_dataset_checkin.json @project2_json_stage;
PUT file://<local_path>\YELP_ds\yelp_academic_dataset_tip.json @project2_json_stage;
PUT file://<local_path>\YELP_ds\yelp_academic_dataset_review.json @project2_json_stage;
PUT file://<local_path>\YELP_ds\yelp_academic_dataset_user.json @project2_json_stage;

PUT file://<local_path>\COVID_json_ds\yelp_academic_dataset_covid_features.json @project2_json_stage;

PUT file://<local_path>\COVID_json_ds\yelp_academic_dataset_covid_features.json @project2_json_stage;
PUT file://<local_path>\COVID_json_ds\yelp_academic_dataset_covid_features.json @project2_json_stage;

/*Create tables containing variant*/
create or replace table dar_project2.stg.business(business_info variant);
create or replace table dar_project2.stg.review(review_info variant);
create or replace table dar_project2.stg.user(user_info variant);
create or replace table dar_project2.stg.checkin(checkin_info variant);
create or replace table dar_project2.stg.tip(tip_info variant);
create or replace table dar_project2.stg.covid(covid_info variant);

create or replace table dar_project2.stg.precipitation(
	date int,
	precipitation varchar,
	precipitation_normal double
);

create or replace table dar_project2.stg.temperature(
	date int,
	min int,
	max int,
	normal_min double,
	normal_max double
);

/*Bulk COPY from Stage to each table*/
copy into dar_project2.stg.business
from @project2_json_stage/yelp_academic_dataset_business.json.gz
file_format= project2_json_format
on_error= ABORT_STATEMENT;

copy into dar_project2.stg.checkin
from @project2_json_stage/yelp_academic_dataset_checkin.json.gz
file_format= project2_json_format
on_error= ABORT_STATEMENT;

copy into dar_project2.stg.tip
from @project2_json_stage/yelp_academic_dataset_tip.json.gz
file_format= project2_json_format
on_error= ABORT_STATEMENT;

copy into dar_project2.stg.review
from @project2_json_stage/yelp_academic_dataset_review.json.gz
file_format= project2_json_format
on_error= ABORT_STATEMENT;

copy into dar_project2.stg.user
from @project2_json_stage/yelp_academic_dataset_user.json.gz
file_format= project2_json_format
on_error= ABORT_STATEMENT;

copy into dar_project2.stg.covid
from @project2_json_stage/yelp_academic_dataset_covid.json.gz
file_format= project2_json_format
on_error= ABORT_STATEMENT;

copy into dar_project2.stg.precipitation
from @project2_csv_stage/ds_prep.csv.gz
file_format= project2_csv_format
on_error= ABORT_STATEMENT;

copy into dar_project2.stg.temperature
from @project2_csv_stage/ds_temp.csv.gz
file_format= project2_csv_format
on_error= ABORT_STATEMENT;