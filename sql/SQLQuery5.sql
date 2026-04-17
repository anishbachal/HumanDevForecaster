-- Remove junk rows from footer
DELETE FROM country_panel
WHERE LEN(country_code) > 10
   OR country_code LIKE '%[^A-Z0-9]%'
   OR country_code IN ('CC BY-4.0', 'License Type');
GO

-- Final verification
SELECT COUNT(*)                  AS total_rows        FROM country_panel;
SELECT COUNT(DISTINCT country_code) AS num_countries  FROM country_panel;
SELECT TOP 10 * FROM country_panel ORDER BY country_code, year;