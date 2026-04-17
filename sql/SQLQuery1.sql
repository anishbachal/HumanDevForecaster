USE HumanDevForecaster;
GO

-- =============================================
-- STEP 4A: UNPIVOT WDI (trim to 2021)
-- =============================================
SELECT
    country_name,
    country_code,
    series_code,
    CAST(LEFT(year_col, 4) AS INT) AS year,
    CASE WHEN value = '..' OR value = '' THEN NULL
         ELSE TRY_CAST(value AS FLOAT)
    END AS value
INTO long_wdi
FROM stg_wdi
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

-- =============================================
-- STEP 4B: UNPIVOT GFDD
-- =============================================
SELECT
    country_name,
    country_code,
    series_code,
    CAST(LEFT(year_col, 4) AS INT) AS year,
    CASE WHEN value = '..' OR value = '' THEN NULL
         ELSE TRY_CAST(value AS FLOAT)
    END AS value
INTO long_gfdd
FROM stg_gfdd
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

-- =============================================
-- STEP 4C: UNPIVOT HNP
-- =============================================
SELECT
    country_name,
    country_code,
    series_code,
    CAST(LEFT(year_col, 4) AS INT) AS year,
    CASE WHEN value = '..' OR value = '' THEN NULL
         ELSE TRY_CAST(value AS FLOAT)
    END AS value
INTO long_hnp
FROM stg_hnp
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

-- =============================================
-- STEP 4D: UNPIVOT EDUCATION
-- =============================================
SELECT
    country_name,
    country_code,
    series_code,
    CAST(LEFT(year_col, 4) AS INT) AS year,
    CASE WHEN value = '..' OR value = '' THEN NULL
         ELSE TRY_CAST(value AS FLOAT)
    END AS value
INTO long_education
FROM stg_education
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

SELECT 'long_wdi'       AS table_name, COUNT(*) AS rows FROM long_wdi
UNION ALL
SELECT 'long_gfdd',                    COUNT(*)         FROM long_gfdd
UNION ALL
SELECT 'long_hnp',                     COUNT(*)         FROM long_hnp
UNION ALL
SELECT 'long_education',               COUNT(*)         FROM long_education;

USE HumanDevForecaster;
GO

-- =============================================
-- REFERENCE TABLE: Aggregates to exclude
-- =============================================
CREATE TABLE ref_aggregates (country_code NVARCHAR(10));
INSERT INTO ref_aggregates VALUES
('WLD'),('EAS'),('ECS'),('LCN'),('MEA'),('NAC'),('SAS'),('SSF'),
('HIC'),('LMC'),('LIC'),('UMC'),('OED'),('EMU'),('EUU'),('CSS'),
('PST'),('PRE'),('INX'),('IBD'),('IBT'),('IDB'),('IDX'),('IDA'),
('ARB'),('CEB'),('EAP'),('ECA'),('LAC'),('MNA'),('SSA'),('TEA'),
('TEC'),('TLA'),('TMN'),('TSA'),('TSS');
GO

-- =============================================
-- MASTER PANEL TABLE
-- =============================================
SELECT
    w.country_name,
    w.country_code,
    w.year,

    -- Economic (WDI)
    MAX(CASE WHEN w.series_code = 'NY.GDP.PCAP.CD'     THEN w.value END) AS gdp_per_capita,
    MAX(CASE WHEN w.series_code = 'FP.CPI.TOTL.ZG'    THEN w.value END) AS inflation,
    MAX(CASE WHEN w.series_code = 'SL.UEM.TOTL.ZS'    THEN w.value END) AS unemployment,
    MAX(CASE WHEN w.series_code = 'NE.TRD.GNFS.ZS'    THEN w.value END) AS trade_pct_gdp,
    MAX(CASE WHEN w.series_code = 'GC.XPN.TOTL.GD.ZS' THEN w.value END) AS govt_expenditure,
    MAX(CASE WHEN w.series_code = 'SP.URB.TOTL.IN.ZS'  THEN w.value END) AS urban_pop_pct,
    MAX(CASE WHEN w.series_code = 'IT.NET.USER.ZS'     THEN w.value END) AS internet_users,

    -- Financial (GFDD)
    MAX(CASE WHEN g.series_code = 'GFDD.DI.01' THEN g.value END) AS private_credit_gdp,
    MAX(CASE WHEN g.series_code = 'GFDD.DI.02' THEN g.value END) AS bank_assets_gdp,
    MAX(CASE WHEN g.series_code = 'GFDD.DI.05' THEN g.value END) AS liquid_liabilities_gdp,
    MAX(CASE WHEN g.series_code = 'GFDD.SI.01' THEN g.value END) AS bank_zscore,
    MAX(CASE WHEN g.series_code = 'GFDD.SI.02' THEN g.value END) AS bank_npl,
    MAX(CASE WHEN g.series_code = 'GFDD.SI.03' THEN g.value END) AS bank_capital_ratio,
    MAX(CASE WHEN g.series_code = 'GFDD.EI.01' THEN g.value END) AS net_interest_margin,
    MAX(CASE WHEN g.series_code = 'GFDD.EI.05' THEN g.value END) AS bank_roa,
    MAX(CASE WHEN g.series_code = 'GFDD.EI.06' THEN g.value END) AS bank_roe,
    MAX(CASE WHEN g.series_code = 'GFDD.OI.02' THEN g.value END) AS bank_deposits_gdp,

    -- Health (HNP)
    MAX(CASE WHEN h.series_code = 'SP.DYN.LE00.IN' THEN h.value END) AS life_expectancy,
    MAX(CASE WHEN h.series_code = 'SH.DYN.MORT'    THEN h.value END) AS child_mortality,
    MAX(CASE WHEN h.series_code = 'SP.DYN.TFRT.IN' THEN h.value END) AS fertility_rate,
    MAX(CASE WHEN h.series_code = 'SH.H2O.SMDW.ZS' THEN h.value END) AS clean_water_access,

    -- Education
    MAX(CASE WHEN e.series_code = 'SE.PRM.ENRR'        THEN e.value END) AS primary_enrollment,
    MAX(CASE WHEN e.series_code = 'SE.SEC.ENRR'        THEN e.value END) AS secondary_enrollment,
    MAX(CASE WHEN e.series_code = 'SE.XPD.TOTL.GD.ZS'  THEN e.value END) AS edu_expenditure,
    MAX(CASE WHEN e.series_code = 'SE.ADT.LITR.ZS'     THEN e.value END) AS literacy_rate

INTO country_panel
FROM long_wdi w
LEFT JOIN long_gfdd      g ON w.country_code = g.country_code AND w.year = g.year
LEFT JOIN long_hnp       h ON w.country_code = h.country_code AND w.year = h.year
LEFT JOIN long_education e ON w.country_code = e.country_code AND w.year = e.year
WHERE w.country_code NOT IN (SELECT country_code FROM ref_aggregates)
GROUP BY
    w.country_name,
    w.country_code,
    w.year;
GO

-- Row count
SELECT COUNT(*) AS total_rows FROM country_panel;

-- Preview
SELECT TOP 20 * FROM country_panel ORDER BY country_code, year;

-- How many unique countries?
SELECT COUNT(DISTINCT country_code) AS num_countries FROM country_panel;

-- Missing % per key column
SELECT
    ROUND(SUM(CASE WHEN gdp_per_capita       IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS gdp_missing_pct,
    ROUND(SUM(CASE WHEN life_expectancy      IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS life_exp_missing_pct,
    ROUND(SUM(CASE WHEN private_credit_gdp   IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS credit_missing_pct,
    ROUND(SUM(CASE WHEN literacy_rate        IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS literacy_missing_pct,
    ROUND(SUM(CASE WHEN secondary_enrollment IS NULL THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS sec_enroll_missing_pct
FROM country_panel;

SELECT * FROM country_panel ORDER BY country_code, year;