-- Update secondary_enrollment in country_panel
UPDATE cp
SET cp.secondary_enrollment = ls.value
FROM country_panel cp
JOIN long_sec_enroll ls
    ON  cp.country_code = ls.country_code
    AND cp.year         = ls.year
WHERE ls.value IS NOT NULL;
GO

-- Check how many rows were updated
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN secondary_enrollment IS NOT NULL THEN 1 ELSE 0 END) AS filled_rows,
    ROUND(SUM(CASE WHEN secondary_enrollment IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1)
        AS still_missing_pct
FROM country_panel;