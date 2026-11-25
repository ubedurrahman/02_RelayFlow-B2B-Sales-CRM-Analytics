--PROJECT: RelayFlow B2B_Sales & CRM_Analytics
--AUTHOR:  Md Ubed Ur Rahman
--ENGINE:  Microsoft SQL Server (T-SQL)
--TABLES:  dbo.Fact_Deals, dbo.Dim_Salespeople, dbo.Dim_FunnelStages
  -----------------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------------

USE RelayFlow_B2B_Sales_CRM_Analytics;
GO

-- SQL ANALYSIS I: FUNNEL CONVERSION, PIPELINE VALUE & WIN RATE--
--1: Conversion Rate at Each Funnel Stage
--Tracks both Top-of-Funnel Conversion (%) and Stage-to-Stage Pass Rate (%)
------------------------------------------------------------------------------
WITH FunnelProgress AS (
    SELECT 
        s.Stage_Order,
        s.Stage,
        COUNT(f.Deal_ID) AS Deals_Reached
    FROM dbo.Dim_FunnelStages s
    LEFT JOIN dbo.Fact_Deals f 
        ON (
            (s.Stage_Order = 1) -- All 108 deals enter at Lead
            OR (s.Stage_Order = 2 AND f.Stage IN ('Qualified', 'Meeting', 'Proposal', 'Negotiation', 'Won', 'Lost'))
            OR (s.Stage_Order = 3 AND f.Stage IN ('Meeting', 'Proposal', 'Negotiation', 'Won', 'Lost'))
            OR (s.Stage_Order = 4 AND f.Stage IN ('Proposal', 'Negotiation', 'Won', 'Lost'))
            OR (s.Stage_Order = 5 AND f.Stage IN ('Negotiation', 'Won'))
            OR (s.Stage_Order = 6 AND f.Stage = 'Won')
        )
    WHERE s.Stage <> 'Lost'
    GROUP BY s.Stage_Order, s.Stage
)
SELECT 
    Stage_Order,
    Stage,
    Deals_Reached,
    CAST(Deals_Reached * 100.0 / FIRST_VALUE(Deals_Reached) OVER (ORDER BY Stage_Order) AS DECIMAL(5,2)) AS Top_Of_Funnel_Conv_Pct,
    CAST(Deals_Reached * 100.0 / NULLIF(LAG(Deals_Reached) OVER (ORDER BY Stage_Order), 0) AS DECIMAL(5,2)) AS Stage_To_Stage_Conv_Pct
FROM FunnelProgress
ORDER BY Stage_Order;
GO

--2: Total Open Pipeline & Probability-Weighted Forecast by Stage
------------------------------------------------------------------------------
SELECT 
    s.Stage_Order,
    f.Stage,
    COUNT(f.Deal_ID) AS Open_Deals,
    SUM(f.Deal_Value_USD) AS Total_Open_Pipeline_USD,
    CAST(SUM(f.Deal_Value_USD * (f.Probability_Pct / 100.0)) AS DECIMAL(12,2)) AS Weighted_Pipeline_USD,
    CAST(AVG(CAST(f.Deal_Value_USD AS FLOAT)) AS DECIMAL(10,2)) AS Avg_Open_Deal_USD
FROM dbo.Fact_Deals f
JOIN dbo.Dim_FunnelStages s 
    ON f.Stage = s.Stage
WHERE f.Outcome = 'Open'
GROUP BY s.Stage_Order, f.Stage
ORDER BY s.Stage_Order;
GO

-- 3: Overall Win Rate & Executive Pipeline Summary
------------------------------------------------------------------------------
SELECT 
    COUNT(Deal_ID) AS Total_Deals,
    COUNT(CASE WHEN Outcome = 'Won' THEN 1 END) AS Won_Deals,
    COUNT(CASE WHEN Outcome = 'Lost' THEN 1 END) AS Lost_Deals,
    COUNT(CASE WHEN Outcome = 'Open' THEN 1 END) AS Open_Deals,
    CAST(
        COUNT(CASE WHEN Outcome = 'Won' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN Outcome IN ('Won', 'Lost') THEN 1 END), 0) 
    AS DECIMAL(5,2)) AS Overall_Win_Rate_Pct,
    SUM(CASE WHEN Outcome = 'Won' THEN Deal_Value_USD ELSE 0 END) AS Total_Won_Revenue_USD,
    SUM(CASE WHEN Outcome = 'Open' THEN Deal_Value_USD ELSE 0 END) AS Total_Open_Pipeline_USD,
    CAST(SUM(CASE WHEN Outcome = 'Open' THEN Deal_Value_USD * (Probability_Pct / 100.0) ELSE 0 END) AS DECIMAL(12,2)) AS Weighted_Open_Pipeline_USD
FROM dbo.Fact_Deals;
GO


--SQL ANALYSIS II: DEAL SIZE, SALES CYCLE, SALESPERSON & INDUSTRY
------------------------------------------------------------------------------
--1: Overall Average Deal Size & Average Sales-Cycle Length (Days)
------------------------------------------------------------------------------
SELECT 
    Outcome,
    COUNT(Deal_ID) AS Deal_Count,
    CAST(AVG(CAST(Deal_Value_USD AS FLOAT)) AS DECIMAL(10,2)) AS Avg_Deal_Size_USD,
    MIN(Deal_Value_USD) AS Min_Deal_Size_USD,
    MAX(Deal_Value_USD) AS Max_Deal_Size_USD,
    AVG(DATEDIFF(DAY, Created_Date, Close_Date)) AS Avg_Sales_Cycle_Days,
    MIN(DATEDIFF(DAY, Created_Date, Close_Date)) AS Fastest_Cycle_Days,
    MAX(DATEDIFF(DAY, Created_Date, Close_Date)) AS Longest_Cycle_Days
FROM dbo.Fact_Deals
WHERE Outcome IN ('Won', 'Lost')
GROUP BY Outcome;
GO

-- 2: Average Deal Size & Sales-Cycle Length by Industry (Won Deals)
-- Highlights FinTech's high ticket size vs. Healthcare's longer compliance cycle
------------------------------------------------------------------------------
SELECT 
    Industry,
    COUNT(Deal_ID) AS Won_Deals,
    SUM(Deal_Value_USD) AS Total_Won_Revenue_USD,
    CAST(AVG(CAST(Deal_Value_USD AS FLOAT)) AS DECIMAL(10,2)) AS Avg_Won_Deal_Size_USD,
    AVG(DATEDIFF(DAY, Created_Date, Close_Date)) AS Avg_Sales_Cycle_Days
FROM dbo.Fact_Deals
WHERE Outcome = 'Won'
GROUP BY Industry
ORDER BY Avg_Won_Deal_Size_USD DESC;
GO

-- 3: Revenue, Win Rate & Quota Attainment by Salesperson
------------------------------------------------------------------------------
SELECT 
    sp.Salesperson_ID,
    sp.Salesperson_Name,
    sp.Region,
    sp.Quota_USD,
    COUNT(CASE WHEN f.Outcome = 'Won' THEN 1 END) AS Won_Deals,
    COUNT(CASE WHEN f.Outcome = 'Lost' THEN 1 END) AS Lost_Deals,
    CAST(
        COUNT(CASE WHEN f.Outcome = 'Won' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN f.Outcome IN ('Won', 'Lost') THEN 1 END), 0) 
    AS DECIMAL(5,2)) AS Win_Rate_Pct,
    SUM(CASE WHEN f.Outcome = 'Won' THEN f.Deal_Value_USD ELSE 0 END) AS Won_Revenue_USD,
    CAST(
        SUM(CASE WHEN f.Outcome = 'Won' THEN f.Deal_Value_USD ELSE 0 END) * 100.0 / 
        NULLIF(sp.Quota_USD, 0) 
    AS DECIMAL(5,2)) AS Quota_Attainment_Pct,
    SUM(CASE WHEN f.Outcome = 'Open' THEN f.Deal_Value_USD ELSE 0 END) AS Open_Pipeline_USD,
    RANK() OVER (ORDER BY SUM(CASE WHEN f.Outcome = 'Won' THEN f.Deal_Value_USD ELSE 0 END) DESC) AS Revenue_Rank
FROM dbo.Dim_Salespeople sp
LEFT JOIN dbo.Fact_Deals f 
    ON sp.Salesperson_ID = f.Salesperson_ID
GROUP BY sp.Salesperson_ID, sp.Salesperson_Name, sp.Region, sp.Quota_USD
ORDER BY Won_Revenue_USD DESC;
GO

-- 4: Revenue, Win Rate & Pipeline Share by Industry
------------------------------------------------------------------------------
SELECT 
    Industry,
    COUNT(Deal_ID) AS Total_Deals,
    COUNT(CASE WHEN Outcome = 'Won' THEN 1 END) AS Won_Deals,
    COUNT(CASE WHEN Outcome = 'Lost' THEN 1 END) AS Lost_Deals,
    COUNT(CASE WHEN Outcome = 'Open' THEN 1 END) AS Open_Deals,
    CAST(
        COUNT(CASE WHEN Outcome = 'Won' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN Outcome IN ('Won', 'Lost') THEN 1 END), 0) 
    AS DECIMAL(5,2)) AS Win_Rate_Pct,
    SUM(CASE WHEN Outcome = 'Won' THEN Deal_Value_USD ELSE 0 END) AS Won_Revenue_USD,
    CAST(
        SUM(CASE WHEN Outcome = 'Won' THEN Deal_Value_USD ELSE 0 END) * 100.0 / 
        SUM(SUM(CASE WHEN Outcome = 'Won' THEN Deal_Value_USD ELSE 0 END)) OVER () 
    AS DECIMAL(5,2)) AS Revenue_Share_Pct,
    SUM(CASE WHEN Outcome = 'Open' THEN Deal_Value_USD ELSE 0 END) AS Open_Pipeline_USD
FROM dbo.Fact_Deals
GROUP BY Industry
ORDER BY Won_Revenue_USD DESC;
GO


-- SQL Analysis III : Lead Source Conversion & Revenue ROI Analysis
------------------------------------------------------------------------------
SELECT 
    Lead_Source,
    COUNT(Deal_ID) AS Total_Leads,
    COUNT(CASE WHEN Outcome = 'Won' THEN 1 END) AS Won_Deals,
    COUNT(CASE WHEN Outcome = 'Lost' THEN 1 END) AS Lost_Deals,
    CAST(
        COUNT(CASE WHEN Outcome = 'Won' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN Outcome IN ('Won', 'Lost') THEN 1 END), 0) 
    AS DECIMAL(5,2)) AS Win_Rate_Pct,
    SUM(CASE WHEN Outcome = 'Won' THEN Deal_Value_USD ELSE 0 END) AS Won_Revenue_USD,
    CAST(AVG(CASE WHEN Outcome = 'Won' THEN CAST(Deal_Value_USD AS FLOAT) END) AS DECIMAL(10,2)) AS Avg_Won_Deal_USD
FROM dbo.Fact_Deals
GROUP BY Lead_Source
ORDER BY Won_Revenue_USD DESC;
GO

-- SQL Analysis IV : Lost Deal Root-Cause Breakdown
------------------------------------------------------------------------------
SELECT 
    Loss_Reason,
    COUNT(Deal_ID) AS Lost_Deals,
    SUM(Deal_Value_USD) AS Lost_Revenue_USD,
    CAST(COUNT(Deal_ID) * 100.0 / SUM(COUNT(Deal_ID)) OVER () AS DECIMAL(5,2)) AS Pct_Of_Lost_Deals
FROM dbo.Fact_Deals
WHERE Outcome = 'Lost'
GROUP BY Loss_Reason
ORDER BY Lost_Revenue_USD DESC;
GO




