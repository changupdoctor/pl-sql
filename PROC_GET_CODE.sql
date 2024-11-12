--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_GET_CODE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_GET_CODE" (
    p_main_nm       in varchar2,
    p_sum_nm        in varchar2,
    v_code          out varchar2
)
is
begin
    select code
    into v_code
    from code
    where main_nm=p_main_nm and sum_nm=p_sum_nm;

    dbms_output.put_line(p_main_nm || ' ' || p_sum_nm || '의 CODE : ' || v_code);
end;

/
