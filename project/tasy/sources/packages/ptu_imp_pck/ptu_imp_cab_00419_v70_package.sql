-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--------------------------------------------------------------------------------00419 Resposta da Consulta de Prestador-----------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_imp_pck.ptu_imp_cab_00419_v70 ( cd_transacao_p ptu_resp_consulta_prest.cd_transacao%type, ie_tipo_cliente_p ptu_resp_consulta_prest.ie_tipo_cliente%type, cd_unimed_exec_p ptu_resp_consulta_prest.cd_unimed_executora%type, cd_unimed_benef_p ptu_resp_consulta_prest.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_resp_consulta_prest.nr_seq_execucao%type, nr_seq_origem_p ptu_resp_consulta_prest.nr_seq_origem%type, ie_confirmacao_p ptu_resp_consulta_prest.ie_confirmacao%type, cd_mens_erro_p ptu_resp_consulta_prest.cd_mensagem_erro%type, nr_versao_p ptu_resp_consulta_prest.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resp_consulta_p INOUT ptu_resp_consulta_prest.nr_sequencia%type) AS $body$
DECLARE


/*Importar dados de resposta do cabecalho da transacao 00419 - Resposta Consulta de Dados do Prestador*/


ie_tipo_cliente_w 		varchar(1);
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;


BEGIN

ie_tipo_cliente_w := ptu_converter_tipo_cliente(ie_tipo_cliente_p);

if (coalesce(cd_estabelecimento_p::text, '') = '') then
	cd_estabelecimento_w := ptu_val_scs_ws_pck.ptu_obter_estab_padrao;
else
	cd_estabelecimento_w := cd_estabelecimento_p;
end if;

insert	into ptu_resp_consulta_prest(nr_sequencia, cd_transacao, ie_tipo_cliente,
	 cd_unimed_executora, nr_seq_execucao, cd_unimed_beneficiario,
	 ie_confirmacao, nr_seq_origem, dt_atualizacao,
	 nm_usuario, nr_seq_guia, nr_seq_requisicao,
	 ds_arquivo_pedido,cd_mensagem_erro, nm_usuario_nrec,
	 dt_atualizacao_nrec, nr_versao)
values (nextval('ptu_resp_consulta_prest_seq'), cd_transacao_p, ie_tipo_cliente_w,
	 cd_unimed_exec_p, nr_seq_execucao_p, cd_unimed_benef_p,
	 ie_confirmacao_p, nr_seq_origem_p, clock_timestamp(),
	 nm_usuario_p, null, null,
	 null, cd_mens_erro_p, nm_usuario_p,
	 clock_timestamp(), nr_versao_p) returning nr_sequencia into nr_seq_resp_consulta_p;

if (cd_mens_erro_p <> '') then
	CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_p, '', cd_estabelecimento_w, nr_seq_resp_consulta_p, 'CP',
					cd_transacao_p, null, null, null, nm_usuario_p);
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_pck.ptu_imp_cab_00419_v70 ( cd_transacao_p ptu_resp_consulta_prest.cd_transacao%type, ie_tipo_cliente_p ptu_resp_consulta_prest.ie_tipo_cliente%type, cd_unimed_exec_p ptu_resp_consulta_prest.cd_unimed_executora%type, cd_unimed_benef_p ptu_resp_consulta_prest.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_resp_consulta_prest.nr_seq_execucao%type, nr_seq_origem_p ptu_resp_consulta_prest.nr_seq_origem%type, ie_confirmacao_p ptu_resp_consulta_prest.ie_confirmacao%type, cd_mens_erro_p ptu_resp_consulta_prest.cd_mensagem_erro%type, nr_versao_p ptu_resp_consulta_prest.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resp_consulta_p INOUT ptu_resp_consulta_prest.nr_sequencia%type) FROM PUBLIC;
