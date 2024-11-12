--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_MERCHANT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_MERCHANT" (
    p_city_nm       in varchar2,
    p_admi_nm       in varchar2,
    p_tpbuz_nm1     in varchar2,
    p_tpbuz_nm2     in varchar2,
    v_mer_ratio     out number,
    v_stop_ratio    out number,
    v_close_ratio   out number
)
is
    v_admi_cty_no      merchant.admi_cty_no%type;
    v_card_tpbuz_cd    merchant.card_tpbuz_cd%type;
    v_mer_cnt          merchant.mer_cnt%type;
    v_stop_cnt         merchant.stop_cnt%type;
    v_close_cnt        merchant.close_cnt%type;
    v_total_cnt        number;
begin
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);
    proc_get_code(p_tpbuz_nm1, p_tpbuz_nm2, v_card_tpbuz_cd);

    SELECT sum(mer_cnt) as mer_cnt, sum(stop_cnt) as stop_cnt, sum(close_cnt) as close_cnt
    INTO v_mer_cnt, v_stop_cnt, v_close_cnt
    FROM merchant
    WHERE admi_cty_no = v_admi_cty_no AND card_tpbuz_cd = v_card_tpbuz_cd AND ta_ym = '202404';
    
    v_total_cnt := v_mer_cnt + v_stop_cnt + v_close_cnt;

    v_mer_ratio := round(v_mer_cnt / v_total_cnt, 2) * 100;
    v_stop_ratio := round(v_stop_cnt / v_total_cnt, 2) * 100;
    v_close_ratio := round(v_close_cnt / v_total_cnt, 2) * 100;
        
    dbms_output.put_line('영업점포 비율 : ' || v_mer_ratio || ', 휴업점포 비율 : ' || v_stop_ratio || ', 폐업점포 비율 : ' || v_close_ratio);
end;

/
