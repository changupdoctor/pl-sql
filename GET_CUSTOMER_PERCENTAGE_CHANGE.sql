--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GET_CUSTOMER_PERCENTAGE_CHANGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."GET_CUSTOMER_PERCENTAGE_CHANGE" (
    p_city_nm       in varchar2,
    p_admi_nm       in varchar2,
    p_tpbuz_nm1     in varchar2,
    p_tpbuz_nm2     in varchar2,
    cur_result OUT SYS_REFCURSOR
)
IS
    v_admi_cty_no      consumption.admi_cty_no%type;
    v_card_tpbuz_cd    consumption.card_tpbuz_cd%type;
    v_current_year     VARCHAR2(4) := TO_CHAR(SYSDATE, 'YYYY');
    v_previous_year    VARCHAR2(4) := TO_CHAR(SYSDATE, 'YYYY') - 1;
BEGIN
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);
    proc_get_code(p_tpbuz_nm1, p_tpbuz_nm2, v_card_tpbuz_cd);

    OPEN cur_result FOR
    WITH data AS (
        SELECT 
            SUBSTR(ta_ymd, 1, 4) AS year,
            SUBSTR(ta_ymd, 5, 2) AS month,
            sex,
            CASE WHEN age >= 8 THEN 8 ELSE age END AS age_group,
            cnt
        FROM 
            consumption
        WHERE 
            admi_cty_no = v_admi_cty_no AND
            card_tpbuz_cd = v_card_tpbuz_cd AND
            ( (SUBSTR(ta_ymd, 1, 4) = v_current_year AND SUBSTR(ta_ymd, 5, 2) BETWEEN '01' AND '04') OR
              (SUBSTR(ta_ymd, 1, 4) = v_previous_year AND SUBSTR(ta_ymd, 5, 2) BETWEEN '01' AND '04') )
    ),
    total_counts AS (
        SELECT
            year,
            SUM(cnt) AS total_cnt
        FROM
            data
        GROUP BY
            year
    ),
    period_data AS (
        SELECT 
            d.year,
            d.sex, 
            d.age_group, 
            SUM(d.cnt) AS total_cnt,
            t.total_cnt AS overall_total,
            (SUM(d.cnt) / t.total_cnt) * 100 AS percentage
        FROM 
            data d
        JOIN
            total_counts t ON d.year = t.year
        GROUP BY 
            d.year, d.sex, d.age_group, t.total_cnt
    )
    SELECT 
        cp.sex,
        cp.age_group AS age,
        ROUND((cp.percentage - pp.percentage), 2) AS change_in_percentage
    FROM 
        period_data cp
        JOIN period_data pp ON cp.sex = pp.sex AND cp.age_group = pp.age_group AND pp.year = v_previous_year
    WHERE
        cp.year = v_current_year;
END;

/
