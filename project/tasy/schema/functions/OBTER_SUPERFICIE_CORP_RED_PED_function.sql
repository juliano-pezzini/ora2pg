-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_superficie_corp_red_ped as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_superficie_corp_red_ped ( qt_peso_p bigint, qt_altura_p bigint, qt_porcent_reducao_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, ie_formula_sup_corporea_p text DEFAULT NULL) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM obter_superficie_corp_red_ped_atx ( ' || quote_nullable(qt_peso_p) || ',' || quote_nullable(qt_altura_p) || ',' || quote_nullable(qt_porcent_reducao_p) || ',' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(ie_formula_sup_corporea_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_superficie_corp_red_ped_atx ( qt_peso_p bigint, qt_altura_p bigint, qt_porcent_reducao_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, ie_formula_sup_corporea_p text DEFAULT NULL) RETURNS bigint AS $body$
DECLARE


    qt_resultado_w              double precision;
    qt_idade_calc_w             varchar(3);
    qt_idade_paciente_w         smallint;
    qt_max_result_w             double precision;
    sql_w                       varchar(200);
    ie_formula_sup_corporea_w	varchar(10);
    nr_dec_sc_w                 bigint;
BEGIN
    qt_idade_calc_w := obter_param_usuario(281, 381, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, qt_idade_calc_w);
    SELECT
        MAX(qt_max_sc_onc)
    INTO STRICT qt_max_result_w
    FROM
        parametro_medico
    WHERE
        cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

        
    select coalesce(coalesce(ie_formula_sup_corporea_p,max(ie_formula_sup_corporea)),'M'),
           max(nr_dec_sc)
    into STRICT   ie_formula_sup_corporea_w,
           nr_dec_sc_w
    from   parametro_medico
    where  cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento;

        

    qt_idade_paciente_w := obter_idade_pf(cd_pessoa_fisica_p, clock_timestamp(), 'A');

    BEGIN
        sql_w := 'CALL OBTER_SUPERF_CORP_RED_PED_MD(:1, :2, :3, :4, :5, :6, :7, :8) INTO :qt_resultado_w';
        EXECUTE sql_w
            USING IN qt_idade_paciente_w, IN qt_idade_calc_w, IN qt_peso_p, IN qt_altura_p, IN ie_formula_sup_corporea_w, IN qt_porcent_reducao_p,
            IN qt_max_result_w, IN nr_dec_sc_w, OUT qt_resultado_w;

    EXCEPTION
        WHEN OTHERS THEN
            qt_resultado_w := NULL;
    END;


    RETURN qt_resultado_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_superficie_corp_red_ped ( qt_peso_p bigint, qt_altura_p bigint, qt_porcent_reducao_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, ie_formula_sup_corporea_p text DEFAULT NULL) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_superficie_corp_red_ped_atx ( qt_peso_p bigint, qt_altura_p bigint, qt_porcent_reducao_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, ie_formula_sup_corporea_p text DEFAULT NULL) FROM PUBLIC;
