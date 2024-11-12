--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_INDICATOR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_INDICATOR" (
    p_city_nm       in varchar2,
    p_admi_nm       in varchar2,
    v_comm_dist_vari_type   out varchar2,
    v_comm_dist_vari_name   out varchar2
) is
    v_admi_cd       varchar2(10);
begin
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cd);

    SELECT comm_dist_vari_type, comm_dist_vari_name
    INTO v_comm_dist_vari_type, v_comm_dist_vari_name
    FROM indicator
    WHERE admi_cd = to_number(v_admi_cd) AND base_quar = 3;

    dbms_output.put_line('지표 : ' || v_comm_dist_vari_type || ', 설명 : ' || v_comm_dist_vari_name);
end;

/
