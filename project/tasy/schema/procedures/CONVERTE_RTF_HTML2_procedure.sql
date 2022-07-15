-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE converte_rtf_html2 ( ds_sql_consulta_p text, ds_parametros_sql_p text, nm_usuario_p text, nr_sequencia_p INOUT text ) AS $body$
DECLARE

    params params_java_ws_pck.param_tab := params_java_ws_pck.param_tab();
    address varchar(255) := obter_valor_param_usuario(0,227,0,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);

BEGIN
    IF (address IS NOT NULL AND address::text <> '') THEN
        params.extend;
        params[1].ds_key := 'sqlConsulta';
        params[1].ds_value := ds_sql_consulta_p;
        params.extend;
        params[2].ds_key := 'parametros';
        params[2].ds_value := ds_parametros_sql_p;
        params.extend;
        params[3].ds_key := 'nmUsuario';
        params[3].ds_value := nm_usuario_p;
        nr_sequencia_p := call_java_ws('/br/com/wheb/funcoes/ConverteRTFOracle/converteRtfHtml',params);
    ELSE
        converte_rtf_html2_leg(ds_sql_consulta_p,ds_parametros_sql_p,nm_usuario_p,nr_sequencia_p);
    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE converte_rtf_html2 ( ds_sql_consulta_p text, ds_parametros_sql_p text, nm_usuario_p text, nr_sequencia_p INOUT text ) FROM PUBLIC;

