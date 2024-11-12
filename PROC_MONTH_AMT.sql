--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_MONTH_AMT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_MONTH_AMT" (
    p_city_nm       in varchar2,
    p_admi_nm       in varchar2,
    p_tpbuz_nm1     in varchar2,
    p_tpbuz_nm2     in varchar2,
    v_amt           OUT NUMBER
) IS
    v_admi_cty_no      consumption.admi_cty_no%type;
    v_card_tpbuz_cd    consumption.card_tpbuz_cd%type;
BEGIN
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);
    proc_get_code(p_tpbuz_nm1, p_tpbuz_nm2, v_card_tpbuz_cd);

    SELECT SUM(amt) AS amt
        INTO v_amt
        FROM consumption
        WHERE admi_cty_no = v_admi_cty_no
          AND card_tpbuz_cd = v_card_tpbuz_cd
          AND TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM') = TO_DATE('202404', 'YYYYMM')
        GROUP BY SUBSTR(ta_ymd, 1, 6);

    dbms_output.put_line('매출액 : ' || v_amt);
END;

/
