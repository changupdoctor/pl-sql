--------------------------------------------------------
--  파일이 생성됨 - 금요일-7월-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure FIND_MAX_MER_DISTRICT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ROOT"."FIND_MAX_MER_DISTRICT" (
    p_city_nm IN VARCHAR2,
    p_buz_major_nm IN VARCHAR2,
    p_buz_minor_nm IN VARCHAR2,
    v_max_district OUT VARCHAR2,
    v_max_count OUT NUMBER
)
IS
    v_card_tpbuz_cd VARCHAR2(20);
    v_admi_code VARCHAR2(20);
    v_count NUMBER;
    v_district_code VARCHAR2(20);
    v_max_mer_cnt NUMBER := 0;
    v_recent_month VARCHAR2(6);
    CURSOR c_district_codes IS
        SELECT code FROM code WHERE main_nm = p_city_nm;
BEGIN
    -- 업종 코드를 가져오기
    proc_get_code(p_buz_major_nm, p_buz_minor_nm, v_card_tpbuz_cd);

    -- 가장 최근 월을 찾기
    SELECT MAX(ta_ym) INTO v_recent_month FROM merchant;

    -- 모든 관련 행정동 코드를 가져오기
    FOR rec IN c_district_codes LOOP
        v_count := 0;

        -- 각 동에서 가장 최근 월의 업종 상점 수를 합산
        SELECT SUM(mer_cnt) INTO v_count
        FROM merchant
        WHERE admi_cty_no = rec.code AND card_tpbuz_cd = v_card_tpbuz_cd AND ta_ym = v_recent_month;

        -- 가장 많은 상점을 가진 동 찾기
        IF v_count > v_max_mer_cnt THEN
            v_max_mer_cnt := v_count;
            v_max_district := rec.code;
        END IF;
    END LOOP;

    -- 결과 출력
    DBMS_OUTPUT.PUT_LINE('The district with the most businesses of type ' || p_buz_minor_nm || ' in ' || p_city_nm || ' is ' || v_max_district || ' with ' || v_max_mer_cnt || ' businesses.');
END;

/
