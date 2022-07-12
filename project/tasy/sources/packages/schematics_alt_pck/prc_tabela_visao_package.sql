-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE schematics_alt_pck.prc_tabela_visao (nr_seq_dic_obj_p bigint, nr_seq_obj_wcpanel_p bigint, cd_funcao_p bigint) AS $body$
DECLARE

    cd_funcao_v     dic_objeto.cd_funcao%type;
    cd_funcao_wcp_v dic_objeto.cd_funcao%type;

BEGIN
    cd_funcao_v     := schematics_alt_pck.fnc_get_cdfuncao_dicobjeto(nr_seq_dic_obj_p);
    cd_funcao_wcp_v := schematics_alt_pck.fnc_get_cdfuncao_dicobjeto(nr_seq_obj_wcpanel_p);
    CALL schematics_alt_pck.prc_flag_alteracao_funcao(cd_funcao_v);
    CALL schematics_alt_pck.prc_flag_alteracao_funcao(cd_funcao_wcp_v);
    CALL schematics_alt_pck.prc_flag_alteracao_funcao(cd_funcao_p);
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematics_alt_pck.prc_tabela_visao (nr_seq_dic_obj_p bigint, nr_seq_obj_wcpanel_p bigint, cd_funcao_p bigint) FROM PUBLIC;
