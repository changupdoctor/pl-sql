--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GET_DISTRIBUTION_BY_SEPARATE_CODES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."GET_DISTRIBUTION_BY_SEPARATE_CODES" (
    p_main_nm_for_admi IN VARCHAR2,
    p_sum_nm_for_admi IN VARCHAR2,
    p_main_nm_for_card IN VARCHAR2,
    p_sum_nm_for_card IN VARCHAR2,
    p_result OUT gender_age_tab)
IS
    v_code_admi VARCHAR2(100);
    v_code_card VARCHAR2(100);
    total_cnt NUMBER;
    temp_tab gender_age_tab := gender_age_tab();
BEGIN
    proc_get_code(p_main_nm_for_admi, p_sum_nm_for_admi, v_code_admi);
    proc_get_code(p_main_nm_for_card, p_sum_nm_for_card, v_code_card);

    SELECT SUM(cnt) INTO total_cnt
    FROM consumption
    WHERE admi_cty_no = v_code_admi AND card_tpbuz_cd = v_code_card;

    FOR rec IN (
        SELECT sex, age, SUM(cnt) AS sum_cnt
        FROM consumption
        WHERE admi_cty_no = v_code_admi AND card_tpbuz_cd = v_code_card
        GROUP BY sex, age
        ORDER BY age, sex DESC
    ) LOOP
        temp_tab.EXTEND;
        temp_tab(temp_tab.LAST) := gender_age_rec(
            rec.sex,
            map_age(rec.age), 
            ROUND((rec.sum_cnt / total_cnt) * 100, 2) -- 반올림 적용
        );
    END LOOP;

    p_result := temp_tab;
END;

/
