USE HumanDevForecaster;

-- Check secondary enrollment and all missing %
SELECT
    ROUND(SUM(CASE WHEN secondary_enrollment IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
        AS sec_enroll_missing_pct,
    ROUND(SUM(CASE WHEN literacy_rate IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
        AS literacy_missing_pct,
    ROUND(SUM(CASE WHEN gdp_per_capita IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
        AS gdp_missing_pct,
    ROUND(SUM(CASE WHEN life_expectancy IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
        AS life_exp_missing_pct,
    ROUND(SUM(CASE WHEN private_credit_gdp IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
        AS credit_missing_pct,
    ROUND(SUM(CASE WHEN primary_enrollment IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
        AS primary_enroll_missing_pct
FROM country_panel;