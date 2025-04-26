CREATE TABLE stscd_20250426 AS SELECT * FROM stschd;

CREATE TABLE ADSCHD_20250426 AS SELECT * FROM ADSCHD;

CREATE TABLE ADSCHDDTL_20250426 AS SELECT * FROM ADSCHDDTL;

 

 

UPDATE ADSCHDDTL A SET A.CLEARDATE = (CASE WHEN a.cleardate = TO_date('26/04/2025','dd/mm/rrrr') THEN TO_date('28/04/2025','dd/mm/rrrr')

                                        WHEN a.cleardate = TO_date('28/04/2025','dd/mm/rrrr') THEN TO_date('29/04/2025','dd/mm/rrrr')

                                        ELSE a.cleardate END)

WHERE A.ORDERID IN (SELECT sts.ORGORDERID FROM stschd sts, SBSECURITIES SB WHERE sts.DUETYPE IN('RS', 'RM' )AND sts.TXDATE>='24/APR/2025');

 

UPDATE stschd a SET a.cleardate = (CASE WHEN a.cleardate = TO_date('26/04/2025','dd/mm/rrrr') THEN TO_date('28/04/2025','dd/mm/rrrr')

                                        WHEN a.cleardate = TO_date('28/04/2025','dd/mm/rrrr') THEN TO_date('29/04/2025','dd/mm/rrrr')

                                        ELSE a.cleardate END)

WHERE a.txdate >='24/apr/2025' AND a.duetype IN ('RM','RS') AND STATUS = 'N';

COMMIT;
