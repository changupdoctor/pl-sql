--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
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
    v_admi_cd VARCHAR2(20);  -- 변수 선언 부분
BEGIN
    -- 시 이름과 동 이름을 코드로 변환
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cd);

    -- 변환된 코드를 사용하여 유동인구 데이터 조회
    OPEN cur_result FOR
    SELECT 
        '10대' AS age_group, -ROUND(AVG(M_10_CNT), 0) AS M_CNT_AVG, ROUND(AVG(F_10_CNT), 0) AS F_CNT_AVG FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '20대', -ROUND(AVG(M_20_CNT), 0), ROUND(AVG(F_20_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '30대', -ROUND(AVG(M_30_CNT), 0), ROUND(AVG(F_30_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '40대', -ROUND(AVG(M_40_CNT), 0), ROUND(AVG(F_40_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '50대', -ROUND(AVG(M_50_CNT), 0), ROUND(AVG(F_50_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '60대', -ROUND(AVG(M_60_CNT), 0), ROUND(AVG(F_60_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    UNION ALL
    SELECT 
        '70대', -ROUND(AVG(M_70_CNT), 0), ROUND(AVG(F_70_CNT), 0) FROM flowpop
        WHERE ADMI_CD = v_admi_cd AND ETL_M >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12);
END;

/
