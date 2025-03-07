#Which market segments contribute the most revenue?

SELECT 
    market_segment,
    SUM(adr) AS total_revenue,
    COUNT(*) AS total_bookings,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY market_segment
ORDER BY total_revenue DESC;

#What is the revenue contribution by customer type?
SELECT 
    customer_type,
    SUM(adr) AS total_revenue,
    COUNT(*) AS total_bookings,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY customer_type
ORDER BY total_revenue DESC;


#How does booking volume vary by hotel type?
SELECT 
    hotel,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY hotel
ORDER BY total_bookings DESC;

#How does lead time impact bookings?
SELECT 
    CASE 
        WHEN lead_time <= 7 THEN '0-7 days'
        WHEN lead_time <= 30 THEN '8-30 days'
        WHEN lead_time <= 90 THEN '31-90 days'
        ELSE '90+ days'
    END AS lead_time_category,
    COUNT(*) AS total_bookings,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY lead_time_category
ORDER BY total_bookings DESC;


#How does room type impact revenue?
SELECT 
    reserved_room_type,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY reserved_room_type
ORDER BY total_revenue DESC;

#Which meal types contribute the most revenue?
SELECT 
    meal,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY meal
ORDER BY total_revenue DESC;

#Customer Retention & Repeat Guests Analysis
SELECT 
    is_repeated_guest,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY is_repeated_guest
ORDER BY total_revenue DESC;


#Impact of Cancellations on Revenue by Market Segment
SELECT 
    market_segment,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS total_cancellations,
    COUNT(*) AS total_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS cancellation_rate
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY market_segment
ORDER BY cancellation_rate DESC;

#Customer Segmentation Based on Stay Duration
SELECT 
    customer_type,
    ROUND(AVG(stays_in_week_nights + stays_in_weekend_nights), 2) AS avg_stay_duration,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY customer_type
ORDER BY avg_stay_duration DESC;


#Revenue Impact of Special Requests & Premium Add-ons
SELECT 
    total_of_special_requests,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY total_of_special_requests
ORDER BY total_revenue DESC;


#Performance of Direct vs. Third-Party Bookings
SELECT 
    distribution_channel,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY distribution_channel
ORDER BY total_revenue DESC;

#Customer Lifetime Value (CLV) Analysis
SELECT 
    customer_type,
    ROUND(AVG(adr * (stays_in_week_nights + stays_in_weekend_nights)), 2) AS avg_revenue_per_customer,
    ROUND(AVG(stays_in_week_nights + stays_in_weekend_nights), 2) AS avg_stay_duration,
    COUNT(*) AS total_bookings,
    ROUND(AVG(adr * (stays_in_week_nights + stays_in_weekend_nights) * is_repeated_guest), 2) AS avg_clv
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY customer_type
ORDER BY avg_clv DESC;


#High-Value Customer Segmentation
WITH Percentiles AS (
  SELECT 
    PERCENTILE_CONT(adr, 0.70) OVER () AS high_value_threshold,
    PERCENTILE_CONT(adr, 0.40) OVER () AS medium_value_threshold
  FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
  LIMIT 1
)
SELECT 
    customer_type,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking,
    CASE 
        WHEN AVG(adr) > (SELECT high_value_threshold FROM Percentiles) THEN 'High-Value'
        WHEN AVG(adr) > (SELECT medium_value_threshold FROM Percentiles) THEN 'Medium-Value'
        ELSE 'Low-Value'
    END AS customer_value_segment
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY customer_type
ORDER BY total_revenue DESC;

#Seasonality Trends & Peak Booking Periods
SELECT 
    year,
    arrival_date_month,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY year, arrival_date_month
ORDER BY year, total_bookings DESC;



# Impact of Promotions on Revenue
SELECT 
    year,
    arrival_date_month,
    market_segment,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
WHERE market_segment IN ('Corporate', 'Direct', 'Online TA') -- Common discount targets
GROUP BY year, arrival_date_month, market_segment
ORDER BY year, arrival_date_month, total_revenue DESC;


#Predicting High-Risk Cancellations
SELECT 
    market_segment,
    is_canceled,
    COUNT(*) AS total_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS cancellation_rate,
    ROUND(AVG(lead_time), 2) AS avg_lead_time,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY market_segment, is_canceled
ORDER BY cancellation_rate DESC;


#Marketing Channel Effectiveness
SELECT 
    distribution_channel,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY distribution_channel
ORDER BY total_revenue DESC;

#Customer Segmentation for Targeted Marketing (Enhancing KPI Reporting)
SELECT 
    customer_type,
    year,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY customer_type, year
ORDER BY year, total_revenue DESC;

#Customer Churn Risk Analysis (Improving Retention Strategies)
SELECT 
    customer_type,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS total_cancellations,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS cancellation_rate
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY customer_type
ORDER BY cancellation_rate DESC;

#Loyalty Program Impact (Special Requests & Repeat Guests)
SELECT 
    is_repeated_guest,
    total_of_special_requests,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY is_repeated_guest, total_of_special_requests
ORDER BY is_repeated_guest DESC, total_revenue DESC;

#Direct vs. Indirect Booking Revenue Trends
SELECT 
    year,
    distribution_channel,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
GROUP BY year, distribution_channel
ORDER BY year, total_revenue DESC;

#Marketing Campaign Success Analysis
SELECT 
    year,
    market_segment,
    COUNT(*) AS total_bookings,
    SUM(adr) AS total_revenue,
    ROUND(AVG(adr), 2) AS avg_revenue_per_booking
FROM `hotelanalyticsproject.hotel_revenue_analysis.all_years_combined`
WHERE market_segment IN ('Corporate', 'Direct', 'Online TA')  -- Common promotion targets
GROUP BY year, market_segment
ORDER BY year, total_revenue DESC;

