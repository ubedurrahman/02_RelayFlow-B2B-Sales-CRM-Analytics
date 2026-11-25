# 📊 RelayFlow B2B Sales Funnel & CRM Pipeline Analytics

**Author:** Md Ubed Ur Rahman  
**Tools & Technologies:** Microsoft SQL Server (T-SQL) • Power BI Desktop (DAX & Star Schema) • Microsoft Excel  

---

## 🎯 Business Problem & Objective
B2B sales leadership lacked clear visibility into where deals stalled across the multi-stage sales funnel, which lead acquisition channels delivered high-converting revenue versus wasted outbound effort, and whether active pipeline coverage could meet regional revenue quotas.

This end-to-end analytics solution transforms raw CRM opportunity logs into a normalized **SQL Server star-schema warehouse** and an **interactive Power BI executive dashboard** designed for Sales VPs and Revenue Operations teams.

---

## 🗂️ Repository Files & Technical Workflow

| File Name | Description |
| :--- | :--- |
| `01_Executive overview screenshot.png` | High-resolution preview of the Executive Overview Power BI dashboard |
| `Pdf_RelayFlow_B2B_Sales_CRM_Analytics_PowerBI.pdf` | Exported PDF version of the report for quick recruiter viewing |
| `RelayFlow_B2B_Sales_CRM_Analytics_PowerBI.pbix` | Interactive Power BI Desktop file with custom DAX measures & star schema |
| `RelayFlow_B2B_Sales_CRM_Analytics_sql_query.sql` | Complete T-SQL script covering funnel conversion, pipeline valuation, rep ranking & loss analysis |
| `RelayFlow_B2B_Sales_CRM_Analytics_Excel.xlsx` | Source B2B CRM dataset (108 deals, 5 sales reps, 7 ordered funnel stages) |

### Technical Implementation Highlights
1. **Relational Data Modeling (SQL Server):** Standardized **108 B2B CRM deals** (`Fact_Deals`) linked via Primary and Foreign Keys to `Dim_Salespeople` (5 account executives across **India**, **UAE / GCC**, and **Europe**) and `Dim_FunnelStages` (7 stages from `Lead` to `Won`/`Lost`).
2. **Advanced T-SQL Analysis:** Engineered Common Table Expressions (`CTE`) and Window Functions (`FIRST_VALUE`, `LAG`, `RANK`) to compute cumulative funnel progression, stage-to-stage drop-off, weighted pipeline forecasts, and quota attainment.
3. **Interactive Power BI & DAX:** Built a dedicated `_Measures` table (`CALCULATE`, `SUMX`, `SWITCH`, `DATEDIFF`, `REMOVEFILTERS`) with dynamic **Industry**, **Region**, and **Lead Source** slicers.

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
1. Import `RelayFlow_B2B_Sales_CRM_Analytics_Excel.xlsx` into **SQL Server Management Studio (SSMS)**.
2. Run `RelayFlow_B2B_Sales_CRM_Analytics_sql_query.sql` to execute all funnel conversion, pipeline valuation, rep ranking, and loss root-cause queries.
3. Open `RelayFlow_B2B_Sales_CRM_Analytics_PowerBI.pbix` in **Power BI Desktop** (or view `Pdf_RelayFlow_B2B_Sales_CRM_Analytics_PowerBI.pdf` directly in GitHub).

---

## 📜 License & Usage
© 2026 **Md Ubed Ur Rahman**. All rights reserved. Shared for portfolio and recruiter evaluation purposes.

