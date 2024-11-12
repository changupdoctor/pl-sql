--------------------------------------------------------
--  ������ ������ - �ݿ���-7��-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GET_HOURLY_SALES_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."GET_HOURLY_SALES_PROC" (
    p_main_nm_for_admi IN VARCHAR2,
    p_sum_nm_for_admi IN VARCHAR2,
    p_main_nm_for_card IN VARCHAR2,
    p_sum_nm_for_card IN VARCHAR2,
    p_result OUT sales_tab)
IS
    v_code_admi VARCHAR2(100);
    v_code_card VARCHAR2(100);
    total_amt NUMBER;
    total_cnt NUMBER;
    temp_tab sales_tab := sales_tab();
BEGIN
    -- ���� ��ȣ �ڵ�� ī�� ���� �ڵ� ��������
    proc_get_code(p_main_nm_for_admi, p_sum_nm_for_admi, v_code_admi);
    proc_get_code(p_main_nm_for_card, p_sum_nm_for_card, v_code_card);

    -- ���� ���
    SELECT SUM(amt), SUM(cnt) INTO total_amt, total_cnt
    FROM consumption
    WHERE admi_cty_no = v_code_admi AND card_tpbuz_cd = v_code_card;

    -- �ð��뺰 ������ ��ȸ
    FOR rec IN (
        SELECT hour, SUM(amt) AS sum_amt, SUM(cnt) AS sum_cnt
        FROM consumption
        WHERE admi_cty_no = v_code_admi AND card_tpbuz_cd = v_code_card
        GROUP BY hour
    ) LOOP
        temp_tab.EXTEND;
        temp_tab(temp_tab.LAST) := sales_rec(
            map_time(rec.hour),  -- �ð��� ���� �Լ� ȣ��
            ROUND((rec.sum_amt / total_amt) * 100, 2),  -- ���� ���� ���
            ROUND((rec.sum_cnt / total_cnt) * 100, 2)   -- �ŷ��� ���� ���
        );
    END LOOP;

    p_result := temp_tab;
END;

/
