--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_MERCHANT_CNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_MERCHANT_CNT" (
    p_city_nm       in varchar2,
    p_admi_nm       in varchar2,
    p_tpbuz_nm1     in varchar2,
    p_tpbuz_nm2     in varchar2,
    cur_merchant_cnt    out sys_refcursor
) is
    v_admi_cty_no       merchant.admi_cty_no%type;
    v_card_tpbuz_cd     merchant.card_tpbuz_cd%type;
begin
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_no);
    proc_get_code(p_tpbuz_nm1, p_tpbuz_nm2, v_card_tpbuz_cd);

    open cur_merchant_cnt for
        SELECT ta_ym, sum(mer_cnt) as mer_cnt
        FROM merchant
        WHERE admi_cty_no = v_admi_cty_no AND card_tpbuz_cd = v_card_tpbuz_cd AND to_date(ta_ym, 'YYYYMM') > to_date('202310', 'YYYYMM')
        GROUP BY ta_ym
        ORDER BY ta_ym;

end;

/
