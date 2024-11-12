--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_YEAR_AMT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_YEAR_AMT" (
    p_city_nm       in varchar2,
    p_admi_nm       in varchar2,
    p_tpbuz_nm1     in varchar2,
    p_tpbuz_nm2     in varchar2,
    cur_year_amt    out sys_refcursor
) IS
    v_admi_cty_no      consumption.admi_cty_no%type;
    v_card_tpbuz_cd    consumption.card_tpbuz_cd%type;
BEGIN
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);
    proc_get_code(p_tpbuz_nm1, p_tpbuz_nm2, v_card_tpbuz_cd);

    OPEN cur_year_amt for
        SELECT SUBSTR(ta_ymd, 1, 6) AS ta_ymd, CAST(SUM(amt) AS NUMBER(38, 2)) AS amt
        FROM consumption
        WHERE admi_cty_no = v_admi_cty_no
          AND card_tpbuz_cd = v_card_tpbuz_cd
          AND TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM') > TO_DATE('202304', 'YYYYMM')
        GROUP BY SUBSTR(ta_ymd, 1, 6)
        ORDER BY ta_ymd;
END;

/
