USE company_analysis_project;

-- Q1 - Total funding per category

SELECT COALESCE(NULLIF(category_code, ''), 'Unknown') AS category,
       ROUND(SUM(funding_total_usd), 2) AS total_funding_usd,
       COUNT(*) AS funded_companies
FROM companies
WHERE funding_total_usd IS NOT NULL
GROUP BY COALESCE(NULLIF(category_code, ''), 'Unknown')
ORDER BY total_funding_usd DESC;

-- Q2 - Top 3 companies by total funding

SELECT company_name,
       COALESCE(NULLIF(category_code, ''), 'Unknown') AS category,
       COALESCE(NULLIF(country_code, ''), 'Unknown') AS country,
       status,
       ROUND(funding_total_usd, 2) AS total_funding_usd
FROM companies
WHERE funding_total_usd IS NOT NULL
ORDER BY funding_total_usd DESC
LIMIT 3;

-- Q3 - Yearly funding trend

SELECT YEAR(first_funding_at) AS funding_year,
       ROUND(SUM(funding_total_usd), 2) AS total_funding_usd,
       COUNT(*) AS funded_companies
FROM companies
WHERE funding_total_usd IS NOT NULL
  AND first_funding_at IS NOT NULL
GROUP BY YEAR(first_funding_at)
ORDER BY funding_year;

-- Q4 - First funding, last funding, and total funded companies per category

SELECT COALESCE(NULLIF(category_code, ''), 'Unknown') AS category,
       MIN(first_funding_at) AS first_funding_date,
       MAX(last_funding_at) AS last_funding_date,
       COUNT(*) AS funded_companies
FROM companies
WHERE funding_total_usd IS NOT NULL
GROUP BY COALESCE(NULLIF(category_code, ''), 'Unknown')
ORDER BY funded_companies DESC;

-- Q5 - Funding percentage by category using CTE

WITH category_funding AS (
  SELECT COALESCE(NULLIF(category_code, ''), 'Unknown') AS category,
         ROUND(SUM(funding_total_usd), 2) AS total_funding_usd
  FROM companies
  WHERE funding_total_usd IS NOT NULL
  GROUP BY COALESCE(NULLIF(category_code, ''), 'Unknown')
)
SELECT category,
       total_funding_usd,
       ROUND(total_funding_usd / SUM(total_funding_usd) OVER () * 100, 2) AS pct_share
FROM category_funding
ORDER BY total_funding_usd DESC;

-- Q6 - Rank companies by funding

SELECT company_name,
       COALESCE(NULLIF(category_code, ''), 'Unknown') AS category,
       COALESCE(NULLIF(country_code, ''), 'Unknown') AS country,
       ROUND(funding_total_usd, 2) AS total_funding_usd,
       RANK() OVER (ORDER BY funding_total_usd DESC) AS rnk
FROM companies
WHERE funding_total_usd IS NOT NULL;

-- Q7 - Countries with more than 100 funded companies

SELECT COALESCE(NULLIF(country_code, ''), 'Unknown') AS country,
       COUNT(*) AS funded_companies,
       ROUND(SUM(funding_total_usd), 2) AS total_funding_usd
FROM companies
WHERE funding_total_usd IS NOT NULL
GROUP BY COALESCE(NULLIF(country_code, ''), 'Unknown')
HAVING COUNT(*) > 100
ORDER BY funded_companies DESC;

-- Q8 - Year-over-year funding change using LAG

WITH yearly AS (
  SELECT YEAR(first_funding_at) AS funding_year,
         ROUND(SUM(funding_total_usd), 2) AS total_funding_usd
  FROM companies
  WHERE funding_total_usd IS NOT NULL
    AND first_funding_at IS NOT NULL
  GROUP BY YEAR(first_funding_at)
)
SELECT funding_year,
       total_funding_usd,
       LAG(total_funding_usd, 1) OVER (ORDER BY funding_year) AS previous_year_funding,
       ROUND(total_funding_usd - LAG(total_funding_usd, 1) OVER (ORDER BY funding_year), 2) AS yoy_change
FROM yearly
ORDER BY funding_year;

-- Q9 - Company funding tiers using CASE WHEN

SELECT company_name,
       COALESCE(NULLIF(category_code, ''), 'Unknown') AS category,
       ROUND(funding_total_usd, 2) AS total_funding_usd,
       CASE
         WHEN funding_total_usd >= 1000000000 THEN 'Mega Funded'
         WHEN funding_total_usd >= 100000000 THEN 'Large Funded'
         WHEN funding_total_usd >= 10000000 THEN 'Growth Funded'
         ELSE 'Early / Small Funded'
       END AS funding_tier
FROM companies
WHERE funding_total_usd IS NOT NULL
ORDER BY funding_total_usd DESC;

-- Q10 - Running total of funding by first funding date

SELECT company_name,
       first_funding_at,
       ROUND(funding_total_usd, 2) AS total_funding_usd,
       ROUND(SUM(funding_total_usd) OVER (
         ORDER BY first_funding_at, company_name
       ), 2) AS running_total_funding
FROM companies
WHERE funding_total_usd IS NOT NULL
  AND first_funding_at IS NOT NULL
ORDER BY first_funding_at, company_name;
