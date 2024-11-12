--------------------------------------------------------
--  ������ ������ - �ݿ���-7��-19-2024   
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
    v_admi_cty_no VARCHAR2(20);  -- ������ �ڵ� ���� ����
    v_card_tpbuz_cd VARCHAR2(20);  -- ���� �ڵ� ���� ����
    v_latest_month VARCHAR2(6);  -- ������ ���� ���� �ֱ� ��
BEGIN
    -- �� �̸��� �� �̸����� ������ �ڵ� ��ȯ
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);

    -- ���� ��з���� �Һз������� ���� �ڵ� ��ȯ
    proc_get_code(p_buz_major_nm, p_buz_minor_nm, v_card_tpbuz_cd);

    -- ������ ���� ���� �ֱ� �� ã��
    SELECT MAX(SUBSTR(ta_ymd, 1, 6))
    INTO v_latest_month
    FROM consumption
    WHERE admi_cty_no = v_admi_cty_no AND card_tpbuz_cd = v_card_tpbuz_cd;

    -- ��ȯ�� �ڵ�� ���� �ֱ� ���� �������� �ֱ� 6�������� ���� ������ ��ȸ
    OPEN cur_result FOR
    SELECT 
        TO_CHAR(TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM'), 'YYYY-MM') AS sales_month,
        FLOOR(SUM(amt) / 10000) AS total_sales   -- ������� ���� ������ ��ȯ�ϰ� �Ҽ��� ���� ����
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
