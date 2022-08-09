-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE marcar_regra_perf_enferm ( nr_seq_result_p pe_item_nursing_profile.nr_seq_result%type, nr_seq_prescr_p pe_prescr_item_result.nr_seq_prescr%type, nm_usuario_p pe_prescr_item_result.nm_usuario%type, nr_seq_item_p pe_item_resultado.nr_seq_item%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, check_p INOUT bigint) AS $body$
DECLARE

    c_scripts_w CURSOR FOR SELECT ds_script from pe_item_nursing_profile where nr_seq_result = nr_seq_result_p and (ds_script IS NOT NULL AND ds_script::text <> '');
    retorno_script_w varchar(1);
    insert_w bigint := 1;
BEGIN
    for linha in c_scripts_w loop
        EXECUTE linha.ds_script into STRICT retorno_script_w USING(cd_pessoa_fisica_p);
        IF upper(retorno_script_w) <> 'S' THEN
            insert_w := 0;
        END IF;
    end loop;
    if insert_w = 1 then
        check_p := 1;
        CALL INSERIR_PRES_ITEM_RESULT(nm_usuario_p, nr_seq_item_p, nr_seq_result_p, nr_seq_prescr_p);
    end if;
EXCEPTION
    WHEN no_data_found THEN
        check_p := 0;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE marcar_regra_perf_enferm ( nr_seq_result_p pe_item_nursing_profile.nr_seq_result%type, nr_seq_prescr_p pe_prescr_item_result.nr_seq_prescr%type, nm_usuario_p pe_prescr_item_result.nm_usuario%type, nr_seq_item_p pe_item_resultado.nr_seq_item%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, check_p INOUT bigint) FROM PUBLIC;
