# 📊 RelayFlow B2B Sales Funnel & CRM Pipeline Analytics

**Author:** Md Ubed Ur Rahman  
**Tools & Technologies:** Microsoft SQL Server (T-SQL) • Power BI Desktop (DAX & Star Schema) • Microsoft Excel  
---

## 🎯 Business Problem & Objective
B2B sales leadership lacked clear visibility into where deals stalled across the multi-stage sales funnel, which lead acquisition channels delivered high-converting revenue versus wasted outbound effort, and whether active pipeline coverage could meet regional revenue quotas.

This end-to-end analytics solution transforms raw CRM opportunity logs into a normalized **SQL Server star-schema warehouse** and an **interactive Power BI executive dashboard** designed for Sales VPs and Revenue Operations teams.

---

## 🗂️ Data Architecture & Technical Workflow

### 1. Relational Schema & Data Cleaning (`sql/01_Data_Cleaning_and_Schema.sql`)
- Standardized **108 B2B CRM deals** (`Fact_Deals`) with strict `INT`, `DATE`, and `VARCHAR` data types.
- Enforced referential integrity using **Primary and Foreign Keys** linking `Fact_Deals` to:
  - `Dim_Salespeople` (5 account executives across **India**, **UAE / GCC**, and **Europe**)
  - `Dim_FunnelStages` (7 ordered pipeline stages from `Lead` to `Won`/`Lost`)

### 2. T-SQL Business Analysis (`sql/02_B2B_Sales_Pipeline_Analysis.sql`)
- **Cumulative Funnel Progression:** Used Common Table Expressions (`CTE`) and Window Functions (`FIRST_VALUE`, `LAG`) to track top-of-funnel and stage-to-stage conversion rates.
- **Pipeline Valuation:** Calculated raw open pipeline versus probability-weighted revenue forecasts across active stages.
- **Rep & Vertical Benchmarking:** Applied `RANK()` and conditional aggregations (`CASE WHEN`) to evaluate quota attainment, sales cycle velocity, and loss root causes.

### 3. Interactive Power BI Dashboard (`RelayFlow_B2B_Sales_Pipeline_Dashboard.pbix`)
- Built a dedicated `_Measures` table with dynamic DAX formulas (`CALCULATE`, `SUMX`, `SWITCH`, `DATEDIFF`, `REMOVEFILTERS`).
- Enabled cross-filtering across **Industry**, **Region**, and **Lead Source** slicers on a single executive view.

---

## 🔍 Key Analytical Findings

- **Strong Commercial Baseline:** Closed deals achieved a **67.1% overall win rate** (`47 Won` out of `70 Closed` deals), generating **$2,479,000 in won revenue** with an average sales cycle of **49.7 days**.
- **Healthy Active Pipeline Coverage:** **38 open deals** represent **$1,884,000 in total open pipeline** and **$761,750 in probability-weighted forecast revenue**.
- **Funnel Drop-Off Bottlenecks:** Out of **108 total leads**, **43.5% (`47 deals`)** converted to `Won`, with the steepest stage-to-stage drop occurring between **Proposal (`82 deals`)** and **Negotiation (`52 deals`)**.
- **Channel ROI Disparity:** **Inbound Website** and **Partner Referrals** generated over **$1.0M+ each** with superior win rates, whereas **Cold Email** produced the lowest conversion rates and highest ghosting volume.
- **Top Performers & Vertical Drivers:** **FinTech** led all industries in total revenue, while **Aarav Mehta (`152.0%` quota)**, **Zoya Khan (`149.0%` quota)**, and **Neha Verma (`137.1%` quota)** exceeded targets.
- **Primary Loss Driver:** **`No Decision / Ghosted` (`34.78%` of lost deals)** was the #1 reason deals failed, followed by **Competitor Chosen (`26.09%`)** and **Price / Budget (`26.09%`)**.

---

## 💡 Strategic Business Recommendations

1. **Reallocate SDR Outbound Spend:** Shift outbound sales resources away from low-converting **Cold Email** lists toward **Partner Referral** incentives and high-intent **Inbound** lead capture.
2. **Enforce Proposal Stage-Gate Criteria:** Require documented economic buyer sign-off before moving deals from `Proposal` to `Negotiation` to cut **`No Decision / Ghosted` (`34.8%`)** losses in half.
3. **Replicate Top-Rep Playbooks:** Pair **Rohan Desai (`21.3%` quota attainment)** with top performers **Zoya Khan** and **Aarav Mehta** for deal-qualification coaching and objection handling.

---

## 🚀 How to Reproduce This Project
1. Run `sql/01_Data_Cleaning_and_Schema.sql` in **SQL Server Management Studio (SSMS)** after importing `data/RelayFlow_B2B_Sales_CRM_Analytics.xlsx`.
2. Execute `sql/02_B2B_Sales_Pipeline_Analysis.sql` to reproduce all funnel, pipeline, rep, and industry KPIs.
3. Open `RelayFlow_B2B_Sales_Pipeline_Dashboard.pbix` in **Power BI Desktop** and update the SQL Server data source connection to your local server instance.

---

## 📜 License & Usage
© 2026 **Md Ubed Ur Rahman**. All rights reserved. Shared for portfolio and recruiter evaluation purposes.
