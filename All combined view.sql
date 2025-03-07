CREATE OR REPLACE VIEW `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined` AS
SELECT *, '2018' AS year FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2018`
UNION ALL
SELECT *, '2019' AS year FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2019`
UNION ALL
SELECT *, '2020' AS year FROM `hotelanalyticsproject.hotel_revenue_analysis.historical_revenue_2020`;


SELECT year, COUNT(*) AS total_records
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY year
ORDER BY year;

SELECT 
    year,
    AVG(lead_time) AS avg_lead_time,
    AVG(adr) AS avg_adr,
    AVG(stays_in_week_nights) AS avg_week_nights,
    AVG(stays_in_weekend_nights) AS avg_weekend_nights,
    COUNT(*) AS total_bookings
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY year
ORDER BY year;

SELECT 
    year,
    arrival_date_month,
    COUNT(*) AS total_bookings
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY year, arrival_date_month
ORDER BY year, total_bookings DESC;


SELECT 
    year,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS total_cancellations,
    COUNT(*) AS total_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS cancellation_rate
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY year
ORDER BY year;


SELECT 
    year,
    SUM(adr) AS total_revenue,
    AVG(adr) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY year
ORDER BY year;
