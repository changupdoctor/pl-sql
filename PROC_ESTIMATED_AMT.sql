--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure PROC_ESTIMATED_AMT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."PROC_ESTIMATED_AMT" (
    p_city_nm       in varchar2,
    p_admi_nm       in varchar2,
    p_tpbuz_nm1     in varchar2,
    p_tpbuz_nm2     in varchar2,
    v_admi_cty_no   out number,
    v_card_tpbuz_cd out varchar2,
    v_cnt           out number,
    v_total_pop     out number,
    v_aver_oper_per out number,
    v_aver_clos_per out number,
    v_comm_dist_vari_type   out varchar2
)
is
    v_admi_cty_cd   code.code%type;
    cursor cur_sum_cnt is
        WITH flowpop_data AS (
            SELECT 
                etl_m,
                AVG(M_10_CNT) AS avg_m_10_cnt, 
                AVG(F_10_CNT) AS avg_f_10_cnt, 
                AVG(M_20_CNT) AS avg_m_20_cnt, 
                AVG(F_20_CNT) AS avg_f_20_cnt, 
                AVG(M_30_CNT) AS avg_m_30_cnt, 
                AVG(F_30_CNT) AS avg_f_30_cnt, 
                AVG(M_40_CNT) AS avg_m_40_cnt, 
                AVG(F_40_CNT) AS avg_f_40_cnt, 
                AVG(M_50_CNT) AS avg_m_50_cnt, 
                AVG(F_50_CNT) AS avg_f_50_cnt, 
                AVG(M_60_CNT) AS avg_m_60_cnt, 
                AVG(F_60_CNT) AS avg_f_60_cnt, 
                AVG(M_70_CNT) AS avg_m_70_cnt, 
                AVG(F_70_CNT) AS avg_f_70_cnt
            FROM flowpop
            WHERE admi_cd = v_admi_cty_no
                AND etl_m >= TO_DATE('23/07/01', 'YY/MM/DD')
                AND etl_m <= TO_DATE('23/09/30', 'YY/MM/DD')
            GROUP BY etl_m
        ),
        consumption_data AS (
            SELECT 
                TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM') as ta_ymd,
                SUM(cnt) AS cnt
            FROM consumption
            WHERE admi_cty_no = v_admi_cty_cd
                AND card_tpbuz_cd = v_card_tpbuz_cd
                AND TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM') >= TO_DATE('202307', 'YYYYMM')
                AND TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM') <= TO_DATE('202309', 'YYYYMM')
            GROUP BY TO_DATE(SUBSTR(ta_ymd, 1, 6), 'YYYYMM')
        )
        SELECT 
            f.etl_m,
            f.avg_m_10_cnt, f.avg_f_10_cnt, 
            f.avg_m_20_cnt, f.avg_f_20_cnt, 
            f.avg_m_30_cnt, f.avg_f_30_cnt, 
            f.avg_m_40_cnt, f.avg_f_40_cnt, 
            f.avg_m_50_cnt, f.avg_f_50_cnt,
            f.avg_m_60_cnt, f.avg_f_60_cnt, 
            f.avg_m_70_cnt, f.avg_f_70_cnt,
            c.cnt
        FROM flowpop_data f
        JOIN consumption_data c ON f.etl_m = c.ta_ymd;
    rec     cur_sum_cnt%ROWTYPE;
begin
    proc_get_code(p_city_nm, p_admi_nm, v_admi_cty_cd);
    proc_get_code(p_tpbuz_nm1, p_tpbuz_nm2, v_card_tpbuz_cd);
    
    v_admi_cty_no := to_number(v_admi_cty_cd);

    OPEN cur_sum_cnt;

    LOOP
        FETCH cur_sum_cnt INTO rec;
        EXIT WHEN cur_sum_cnt%NOTFOUND;

        v_total_pop := rec.avg_m_10_cnt + rec.avg_f_10_cnt +  
            rec.avg_m_20_cnt + rec.avg_f_20_cnt + 
            rec.avg_m_30_cnt + rec.avg_f_30_cnt + 
            rec.avg_m_40_cnt + rec.avg_f_40_cnt + 
            rec.avg_m_50_cnt + rec.avg_f_50_cnt + 
            rec.avg_m_60_cnt + rec.avg_f_60_cnt +
            rec.avg_m_70_cnt + rec.avg_f_70_cnt;
        v_cnt := rec.cnt;

        dbms_output.put_line('인구수 합계 : ' || v_total_pop || ', 매출건수 합계 : ' || v_cnt);
    END LOOP;

    CLOSE cur_sum_cnt;

    v_total_pop := ROUND(v_total_pop / 3, 2);
    v_cnt := ROUND(v_cnt / 3, 2);
    
    dbms_output.put_line('총 인구수 합계 : ' || v_total_pop || ', 매출건수 합계 : ' || v_cnt);
    
    SELECT aver_oper_per, aver_clos_per, comm_dist_vari_type
    INTO v_aver_oper_per, v_aver_clos_per, v_comm_dist_vari_type
    FROM indicator
    WHERE admi_cd = v_admi_cty_no AND base_quar = 3;
    
    dbms_output.put_line('운영점포 : ' || v_aver_oper_per || ', 폐업점포 : ' || v_aver_clos_per || ', 상권지표 : ' || v_comm_dist_vari_type);

end;

/
