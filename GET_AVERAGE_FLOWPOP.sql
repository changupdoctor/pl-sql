--------------------------------------------------------
--  ������ ������ - �ݿ���-7��-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure GET_AVERAGE_FLOWPOP
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."GET_AVERAGE_FLOWPOP" (
    p_city_nm IN VARCHAR2,
    p_admi_nm IN VARCHAR2,
    cur_result OUT SYS_REFCURSOR
)
IS
    v_admi_cd VARCHAR2(20);  -- ���� ���� �κ�
BEGIN
    -- �� �̸��� �� �̸��� �ڵ�� ��ȯ
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cd);

    -- ��ȯ�� �ڵ带 ����Ͽ� �����α� ������ ��ȸ
    OPEN cur_result FOR
    SELECT 
        '10��' AS age_group, -ROUND(AVG(M_10_CNT), 0) AS M_CNT_AVG, ROUND(AVG(F_10_CNT), 0) AS F_CNT_AVG FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '20��', -ROUND(AVG(M_20_CNT), 0), ROUND(AVG(F_20_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '30��', -ROUND(AVG(M_30_CNT), 0), ROUND(AVG(F_30_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '40��', -ROUND(AVG(M_40_CNT), 0), ROUND(AVG(F_40_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '50��', -ROUND(AVG(M_50_CNT), 0), ROUND(AVG(F_50_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '60��', -ROUND(AVG(M_60_CNT), 0), ROUND(AVG(F_60_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '70��', -ROUND(AVG(M_70_CNT), 0), ROUND(AVG(F_70_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12);
END;

/
