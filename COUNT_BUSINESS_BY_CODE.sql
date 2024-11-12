--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure COUNT_BUSINESS_BY_CODE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."COUNT_BUSINESS_BY_CODE" (
    p_city_nm IN VARCHAR2,
    p_admi_nm IN VARCHAR2,
    p_buz_major_nm IN VARCHAR2,
    p_buz_minor_nm IN VARCHAR2,
    v_count OUT NUMBER,
    v_status IN VARCHAR2
)
IS
    v_admi_cty_no VARCHAR2(20);
    v_card_tpbuz_cd VARCHAR2(20);
    v_max_yr_month VARCHAR2(6);
BEGIN
    IF v_status = 'RESULT_FOUND' THEN
        -- Retrieve administrative and business type codes
        proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);
        proc_get_code(p_buz_major_nm, p_buz_minor_nm, v_card_tpbuz_cd);

        -- Find the most recent data year and month
        SELECT MAX(ta_ym) INTO v_max_yr_month
        FROM merchant
        WHERE admi_cty_no = v_admi_cty_no AND card_tpbuz_cd = v_card_tpbuz_cd;

        -- Aggregate the count of businesses for the most recent data
        SELECT SUM(mer_cnt)
        INTO v_count
        FROM merchant
        WHERE admi_cty_no = v_admi_cty_no
          AND card_tpbuz_cd = v_card_tpbuz_cd
          AND ta_ym = v_max_yr_month;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No valid consequent found to proceed with counting.');
    END IF;
END;

/
