-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_imp_pck.ptu_imp_dados_00419_v70 ( nm_prestador_p ptu_resp_nomes_prest.nm_prestador%type, cd_unimed_prestador_p ptu_resp_nomes_prest.cd_unimed_prestador%type, cd_prestador_p ptu_resp_nomes_prest.cd_prestador%type, cd_especialidade_p ptu_resp_nomes_prest.cd_especialidade%type, ie_tipo_rede_min_p ptu_resp_nomes_prest.ie_tipo_rede_min%type, nr_seq_resp_consulta_p ptu_resp_nomes_prest.nr_seq_resp_prest%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/*Importar dados de resposta dos itens da transacao 00419 - Resposta Consulta de Dados do Prestador*/



BEGIN

insert	into ptu_resp_nomes_prest(nr_sequencia, cd_unimed_prestador, ie_tipo_rede_min,
	nm_prestador, cd_prestador, nr_seq_resp_prest,
	dt_atualizacao, nm_usuario, cd_especialidade,
	nm_usuario_nrec, dt_atualizacao_nrec)
values (nextval('ptu_resp_nomes_prest_seq'), cd_unimed_prestador_p, ie_tipo_rede_min_p,
	nm_prestador_p, cd_prestador_p, nr_seq_resp_consulta_p,
	clock_timestamp(), nm_usuario_p, null,
	nm_usuario_p, clock_timestamp());

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_pck.ptu_imp_dados_00419_v70 ( nm_prestador_p ptu_resp_nomes_prest.nm_prestador%type, cd_unimed_prestador_p ptu_resp_nomes_prest.cd_unimed_prestador%type, cd_prestador_p ptu_resp_nomes_prest.cd_prestador%type, cd_especialidade_p ptu_resp_nomes_prest.cd_especialidade%type, ie_tipo_rede_min_p ptu_resp_nomes_prest.ie_tipo_rede_min%type, nr_seq_resp_consulta_p ptu_resp_nomes_prest.nr_seq_resp_prest%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
