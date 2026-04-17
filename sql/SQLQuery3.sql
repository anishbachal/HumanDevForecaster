USE HumanDevForecaster;
GO

-- Drop if exists
DROP TABLE IF EXISTS long_sec_enroll;
GO

-- Unpivot
SELECT
    country_name,
    country_code,
    series_code,
    CAST(LEFT(year_col, 4) AS INT) AS year,
    CASE WHEN value = '..' OR value = '' THEN NULL
         ELSE TRY_CAST(value AS FLOAT)
    END AS value
INTO long_sec_enroll
FROM stg_sec_enroll
UNPIVOT (
    value FOR year_col IN (
        [1990__yr1990_],[1991__yr1991_],[1992__yr1992_],[1993__yr1993_],
        [1994__yr1994_],[1995__yr1995_],[1996__yr1996_],[1997__yr1997_],
        [1998__yr1998_],[1999__yr1999_],[2000__yr2000_],[2001__yr2001_],
        [2002__yr2002_],[2003__yr2003_],[2004__yr2004_],[2005__yr2005_],
        [2006__yr2006_],[2007__yr2007_],[2008__yr2008_],[2009__yr2009_],
        [2010__yr2010_],[2011__yr2011_],[2012__yr2012_],[2013__yr2013_],
        [2014__yr2014_],[2015__yr2015_],[2016__yr2016_],[2017__yr2017_],
        [2018__yr2018_],[2019__yr2019_],[2020__yr2020_],[2021__yr2021_]
    )
) AS unpvt;
GO

-- Verify
SELECT COUNT(*) AS rows FROM long_sec_enroll;
SELECT TOP 5 * FROM long_sec_enroll;