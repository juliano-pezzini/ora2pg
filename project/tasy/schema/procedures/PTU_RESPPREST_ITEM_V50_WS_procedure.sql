-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_respprest_item_v50_ws (nm_prestador_p ptu_resp_nomes_prest.nm_prestador%type, cd_unimed_prestador_p ptu_resp_nomes_prest.cd_unimed_prestador%type, cd_prestador_p ptu_resp_nomes_prest.cd_prestador%type, cd_especialidade_p ptu_resp_nomes_prest.cd_especialidade%type, ie_alto_custo_p ptu_resp_nomes_prest.ie_alto_custo%type, nr_seq_resp_consulta_p ptu_resp_nomes_prest.nr_seq_resp_prest%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

ptu_imp_scs_ws_pck.ptu_imp_resp_prest_item(	nm_prestador_p,		cd_unimed_prestador_p,			cd_prestador_p,
											cd_especialidade_p,	ie_alto_custo_p,				nr_seq_resp_consulta_p,
											nm_usuario_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_respprest_item_v50_ws (nm_prestador_p ptu_resp_nomes_prest.nm_prestador%type, cd_unimed_prestador_p ptu_resp_nomes_prest.cd_unimed_prestador%type, cd_prestador_p ptu_resp_nomes_prest.cd_prestador%type, cd_especialidade_p ptu_resp_nomes_prest.cd_especialidade%type, ie_alto_custo_p ptu_resp_nomes_prest.ie_alto_custo%type, nr_seq_resp_consulta_p ptu_resp_nomes_prest.nr_seq_resp_prest%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
