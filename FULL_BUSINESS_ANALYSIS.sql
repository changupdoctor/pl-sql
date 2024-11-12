--------------------------------------------------------
--  ������ ������ - �ݿ���-7��-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure FULL_BUSINESS_ANALYSIS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."FULL_BUSINESS_ANALYSIS" (
    p_city_nm IN VARCHAR2,
    p_admi_nm IN VARCHAR2,
    p_buz_major_nm IN VARCHAR2,
    p_buz_minor_nm IN VARCHAR2,
    v_consequent OUT VARCHAR2,
    v_selected_district_count OUT NUMBER,
    v_out_max_district OUT VARCHAR2,
    v_max_mer_count OUT NUMBER,
    v_out_max_district_name OUT VARCHAR2
)
IS
    v_admi_cty_no VARCHAR2(20);
    v_card_tpbuz_cd VARCHAR2(20);
    v_max_yr_month VARCHAR2(6);
    v_mer_count NUMBER;
    v_temp_mer_count NUMBER := 0;
    v_district_code VARCHAR2(20);
    CURSOR c_district_codes IS
        SELECT code FROM code WHERE main_nm = p_city_nm;
BEGIN
    v_max_mer_count := 0;
    -- �ڵ� ��ȯ
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);
    proc_get_code(p_buz_major_nm, p_buz_minor_nm, v_card_tpbuz_cd);

    -- ��� ���� �ִ� LIFT �� ��ȸ
    SELECT NVL(MAX(consequents), '0')
    INTO v_consequent
    FROM association
    WHERE card_tpbuz_cd = v_card_tpbuz_cd
    AND lift = (SELECT MAX(lift) FROM association WHERE card_tpbuz_cd = v_card_tpbuz_cd);

    IF v_consequent != '0' THEN
        -- ��� ������ �ش��ϴ� ���� ���� �ڵ带 ã��
        SELECT code INTO v_card_tpbuz_cd
        FROM code
        WHERE sum_nm = v_consequent;

        -- �ֱ� �� ������ ��ȸ
        SELECT MAX(ta_ym) INTO v_max_yr_month FROM merchant;

        -- ������ �������� ��� ���� �� ����
        SELECT SUM(mer_cnt) INTO v_selected_district_count
        FROM merchant
        WHERE admi_cty_no = v_admi_cty_no AND card_tpbuz_cd = v_card_tpbuz_cd AND ta_ym = v_max_yr_month;

        -- �� ������ �ش� ������ ���� ���� �� ã��
        FOR rec IN c_district_codes LOOP
            SELECT SUM(mer_cnt) INTO v_temp_mer_count
            FROM merchant
            WHERE admi_cty_no = rec.code AND card_tpbuz_cd = v_card_tpbuz_cd AND ta_ym = v_max_yr_month;

            IF v_temp_mer_count > v_max_mer_count THEN
                v_max_mer_count := v_temp_mer_count;
                v_out_max_district := rec.code;
            END IF;
        END LOOP;

        -- ���� ���� ������ �ִ� ���� �̸� ��ȸ
        SELECT sum_nm INTO v_out_max_district_name
        FROM code
        WHERE code = v_out_max_district;

        -- ��� ���
        DBMS_OUTPUT.PUT_LINE('The district with the most businesses of type ' || v_consequent || ' in ' || p_city_nm || ' is ' || v_out_max_district_name || ' with ' || v_max_mer_count || ' businesses.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No valid consequent found. Exiting procedure.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;

/
