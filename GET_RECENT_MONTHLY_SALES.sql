--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GET_RECENT_MONTHLY_SALES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."GET_RECENT_MONTHLY_SALES" (
    p_city_nm IN VARCHAR2,
    p_admi_nm IN VARCHAR2,
    p_buz_major_nm IN VARCHAR2,
    p_buz_minor_nm IN VARCHAR2,
    cur_result OUT SYS_REFCURSOR
)
IS
    v_admi_cty_no VARCHAR2(20);  -- 행정동 코드 저장 변수
    v_card_tpbuz_cd VARCHAR2(20);  -- 업종 코드 저장 변수
    v_latest_month VARCHAR2(6);  -- 데이터 상의 가장 최근 월
BEGIN
    -- 시 이름과 동 이름으로 행정동 코드 변환
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);

    -- 업종 대분류명과 소분류명으로 업종 코드 변환
    proc_get_code(p_buz_major_nm, p_buz_minor_nm, v_card_tpbuz_cd);

    -- 데이터 상의 가장 최근 월 찾기
    SELECT MAX(SUBSTR(ta_ymd, 1, 6))
    INTO v_latest_month
    FROM consumption
    WHERE admi_cty_no = v_admi_cty_no AND card_tpbuz_cd = v_card_tpbuz_cd;

    -- 변환된 코드와 가장 최근 월을 기준으로 최근 6개월간의 매출 데이터 조회
    OPEN cur_result FOR
    SELECT 
        TO_CHAR(TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM'), 'YYYY-MM') AS sales_month,
        FLOOR(SUM(amt) / 10000) AS total_sales   -- 매출액을 만원 단위로 변환하고 소수점 이하 버림
    FROM 
        consumption
    WHERE
        admi_cty_no = v_admi_cty_no AND
        card_tpbuz_cd = v_card_tpbuz_cd AND
        SUBSTR(ta_ymd, 1, 6) BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(v_latest_month, 'YYYYMM'), -5), 'YYYYMM')
                                AND v_latest_month
    GROUP BY
        TO_CHAR(TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM'), 'YYYY-MM')
    ORDER BY
        sales_month;
END;

/
