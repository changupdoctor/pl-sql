--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_UNIT_PRICE_CNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_UNIT_PRICE_CNT" (
    p_city_nm       IN VARCHAR2,
    p_admi_nm       IN VARCHAR2,
    p_tpbuz_nm1     IN VARCHAR2,
    p_tpbuz_nm2     IN VARCHAR2,
    cur_unit_price_cnt  OUT SYS_REFCURSOR
) IS
    v_admi_cty_no       consumption.admi_cty_no%TYPE;
    v_card_tpbuz_cd     consumption.card_tpbuz_cd%TYPE;
BEGIN
    -- 코드 테이블에서 adm_city_no와 card_tpbuz_cd를 가져오기
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);
    proc_get_code(p_tpbuz_nm1, p_tpbuz_nm2, v_card_tpbuz_cd);

    -- 결과 커서 반환
    OPEN cur_unit_price_cnt FOR
        SELECT ta_ymd, cnt,
               CASE 
                   WHEN cnt > 0 THEN ROUND(amt / cnt, 1) 
                   ELSE 0 
               END AS unit_price
        FROM (
            SELECT SUBSTR(ta_ymd, 1, 6) AS ta_ymd, 
                   SUM(cnt) AS cnt, 
                   SUM(amt) AS amt
            FROM consumption
            WHERE admi_cty_no = v_admi_cty_no AND card_tpbuz_cd = v_card_tpbuz_cd AND TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM') > TO_DATE('202310', 'YYYYMM')
            GROUP BY SUBSTR(ta_ymd, 1, 6)
        )
        ORDER BY ta_ymd;
END;

/
