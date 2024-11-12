--------------------------------------------------------
--  ������ ������ - �ݿ���-7��-19-2024   
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
    -- Ư�� CODE ���� �������� ���� ���ν��� ȣ��
    proc_get_code(p_main_nm, p_sum_nm, v_code);

    -- LIFT ���� �ִ��� CONSEQUENT ���� ��������
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

    -- ��� ���
    DBMS_OUTPUT.PUT_LINE('�ִ� LIFT�� CONSEQUENT: ' || v_consequent);
END;

/
