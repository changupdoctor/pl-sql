--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GET_DAY_SALES_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."GET_DAY_SALES_PROC" (
    p_main_nm_for_admi IN VARCHAR2,
    p_sum_nm_for_admi IN VARCHAR2,
    p_main_nm_for_card IN VARCHAR2,
    p_sum_nm_for_card IN VARCHAR2,
    p_result OUT day_sales_tab)
IS
    v_code_admi VARCHAR2(100);
    v_code_card VARCHAR2(100);
    total_sales_amt NUMBER := 0;
    temp_tab day_sales_tab := day_sales_tab();
BEGIN
    proc_get_code(p_main_nm_for_admi, p_sum_nm_for_admi, v_code_admi);
    proc_get_code(p_main_nm_for_card, p_sum_nm_for_card, v_code_card);

    SELECT SUM(amt) INTO total_sales_amt
    FROM consumption
    WHERE admi_cty_no = v_code_admi AND card_tpbuz_cd = v_code_card;

    FOR record IN (
        SELECT day, SUM(amt) AS total_amt
        FROM consumption
        WHERE admi_cty_no = v_code_admi AND card_tpbuz_cd = v_code_card
        GROUP BY day
        ORDER BY day
    ) LOOP
        temp_tab.EXTEND;
        temp_tab(temp_tab.LAST) := day_sales_rec(
            map_day_to_korean(record.day),  -- 요일을 한글로 변환하여 저장
            ROUND((record.total_amt / total_sales_amt) * 100, 2)  -- 매출 비중 계산
        );
    END LOOP;

    p_result := temp_tab;
END;

/
