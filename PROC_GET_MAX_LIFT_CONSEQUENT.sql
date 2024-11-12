--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_GET_MAX_LIFT_CONSEQUENT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_GET_MAX_LIFT_CONSEQUENT" (
    p_main_nm       IN VARCHAR2,
    p_sum_nm        IN VARCHAR2,
    v_consequent    OUT VARCHAR2
)
IS
    v_code          VARCHAR2(100);
BEGIN
    -- 특정 CODE 값을 가져오는 기존 프로시저 호출
    proc_get_code(p_main_nm, p_sum_nm, v_code);

    -- LIFT 값이 최대인 CONSEQUENT 값을 가져오기
    BEGIN
        SELECT NVL(MAX(consequents), '0')
        INTO v_consequent
        FROM association
        WHERE card_tpbuz_cd = v_code
        AND lift = (SELECT MAX(lift) FROM association WHERE card_tpbuz_cd = v_code);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_consequent := '0';
    END;

    -- 결과 출력
    DBMS_OUTPUT.PUT_LINE('최대 LIFT의 CONSEQUENT: ' || v_consequent);
END;

/
