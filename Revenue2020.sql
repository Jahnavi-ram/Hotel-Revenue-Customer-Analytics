SELECT table_name, COUNT(column_name) AS column_count
FROM `hotelanalyticsproject.hotel_revenue_analysis.INFORMATION_SCHEMA.COLUMNS`
GROUP BY table_name;

SELECT column_name, data_type  
FROM `hotelanalyticsproject.hotel_revenue_analysis.INFORMATION_SCHEMA.COLUMNS`  
WHERE table_name = 'historical_revenue_2020';

SELECT *, COUNT(*) AS duplicate_count
FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`
GROUP BY hotel,is_canceled,lead_time,arrival_date_year,arrival_date_month,arrival_date_week_number,arrival_date_day_of_month,stays_in_weekend_nights,  stays_in_week_nights,adults,children,babies,meal,country,market_segment,distribution_channel,is_repeated_guest,previous_cancellations,previous_bookings_not_canceled,reserved_room_type,assigned_room_type,booking_changes,deposit_type,agent,company,days_in_waiting_list,customer_type,adr,required_car_parking_spaces,total_of_special_requests,reservation_status,reservation_status_date
HAVING duplicate_count > 1
ORDER BY duplicate_count DESC;




UPDATE `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`
SET company = 'Individual'
WHERE company = 'NULL';

UPDATE `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`
SET company = CONCAT('Company_', company)
WHERE company NOT LIKE 'Individual';

SELECT DISTINCT company FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`;
SELECT DISTINCT agent FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`;
UPDATE `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`
SET agent = 'Novalue'
WHERE agent = 'NULL';


SELECT *, COUNT(*) AS duplicate_count
FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`
GROUP BY hotel, is_canceled, lead_time, arrival_date_year, 
         arrival_date_month, arrival_date_week_number, arrival_date_day_of_month, 
         stays_in_weekend_nights, stays_in_week_nights, adults, children, babies, 
         meal, country, market_segment, distribution_channel, is_repeated_guest, 
         previous_cancellations, previous_bookings_not_canceled, reserved_room_type, 
         assigned_room_type, booking_changes, deposit_type, agent, company, 
         days_in_waiting_list, customer_type, adr, required_car_parking_spaces, 
         total_of_special_requests, reservation_status, reservation_status_date
HAVING duplicate_count > 1;


CREATE OR REPLACE TABLE `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020` AS
WITH deduplicated_data AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY hotel, is_canceled, lead_time, arrival_date_year, 
                                               arrival_date_month, arrival_date_week_number, arrival_date_day_of_month, 
                                               stays_in_weekend_nights, stays_in_week_nights, adults, children, babies, 
                                               meal, country, market_segment, distribution_channel, is_repeated_guest, 
                                               previous_cancellations, previous_bookings_not_canceled, reserved_room_type, 
                                               assigned_room_type, booking_changes, deposit_type, agent, company, 
                                               days_in_waiting_list, customer_type, CAST(adr AS STRING), 
                                               required_car_parking_spaces, total_of_special_requests, reservation_status, reservation_status_date) 
           AS row_num
    FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`
)
SELECT * EXCEPT(row_num) FROM deduplicated_data
WHERE row_num = 1;

SELECT COUNT(*) AS total_rows
FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`;

SELECT 
    COUNT(*) AS total_records,
    COUNTIF(hotel IS NULL) AS missing_hotel,
    COUNTIF(is_canceled IS NULL) AS missing_is_canceled,
    COUNTIF(lead_time IS NULL) AS missing_lead_time,
    COUNTIF(arrival_date_year IS NULL) AS missing_arrival_date_year,
    COUNTIF(arrival_date_month IS NULL) AS missing_arrival_date_month,
    COUNTIF(customer_type IS NULL) AS missing_customer_type,
    COUNTIF(adr IS NULL) AS missing_adr
FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`;

