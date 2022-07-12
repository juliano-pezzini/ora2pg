-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_imp_pck.ptu_imp_dados_00807_v70 ( cd_transacao_p ptu_resposta_req_ord_serv.cd_transacao%type, ie_tipo_tabela_p ptu_resposta_req_servico.ie_tipo_tabela%type, nr_seq_item_p ptu_resposta_req_servico.nr_seq_item%type, cd_servico_p ptu_resposta_req_servico.cd_servico%type, qt_autorizada_p ptu_resposta_req_servico.qt_servico_aut%type, ie_status_req_p ptu_resposta_req_servico.ie_status_requisicao%type, cd_mens_erro_1_p ptu_inconsistencia.cd_inconsistencia%type, cd_mens_erro_2_p ptu_inconsistencia.cd_inconsistencia%type, cd_mens_erro_3_p ptu_inconsistencia.cd_inconsistencia%type, cd_mens_erro_4_p ptu_inconsistencia.cd_inconsistencia%type, cd_mens_erro_5_p ptu_inconsistencia.cd_inconsistencia%type, ds_mens_erro_p ptu_intercambio_consist.ds_observacao%type, nr_seq_resposta_p ptu_resposta_req_ord_serv.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Importar dados do bloco de servicos da resposta de ordem de servico 00807 - Resposta de Ordem de Servico

Rotina utilizada nas transacoes ptu via scs homologadas com a unimed brasil.
quando for alterar, favor verificar com o analista responsavel para a realizacao de testes.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Performance
---------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

ie_tipo_tabela_w	ptu_itens_pedido_a1100.ie_tipo_tabela%type := ptu_conversao_tipo_tabela(ie_tipo_tabela_p, cd_servico_p, 'R', null);
cd_servico_w		ptu_aut_ordem_serv_servico.cd_servico%type := ptu_conversao_item_tabela(ie_tipo_tabela_p, cd_servico_p, null);
qt_autorizada_ww	ptu_resposta_req_servico.qt_servico_aut%type;
nr_seq_resp_req_ser_w	ptu_resposta_req_servico.nr_sequencia%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;

BEGIN

if (coalesce(cd_estabelecimento_p::text, '') = '') then
	cd_estabelecimento_w := ptu_val_scs_ws_pck.ptu_obter_estab_padrao;
else
	cd_estabelecimento_w := cd_estabelecimento_p;
end if;

begin
	qt_autorizada_ww  := (ptu_obter_qtd_env_itens_scs(null, qt_autorizada_p, 'R'))::numeric;
exception
when others then
	qt_autorizada_ww   := (replace(ptu_obter_qtd_env_itens_scs(null, qt_autorizada_p, 'R'),',','.'))::numeric;
end;

insert	into ptu_resposta_req_servico(nr_sequencia, nr_seq_resp_req_ord, cd_servico,
	qt_servico_aut, ie_status_requisicao, ie_tipo_tabela,
	nm_usuario, dt_atualizacao, nm_usuario_nrec,
	dt_atualizacao_nrec, nr_seq_item, ie_origem_proced)
values (nextval('ptu_resposta_req_servico_seq'), nr_seq_resposta_p, cd_servico_w,
	qt_autorizada_ww, ie_status_req_p, ie_tipo_tabela_w,
	nm_usuario_p, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nr_seq_item_p, CASE WHEN ie_tipo_tabela_w='00' THEN 4  ELSE null END ) returning nr_sequencia into nr_seq_resp_req_ser_w;

if (ie_tipo_tabela_w	in ('0','1','4')) then
	if (cd_mens_erro_1_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_1_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, nr_seq_resp_req_ser_w, null, null, nm_usuario_p);
	end if;

	if (cd_mens_erro_2_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_2_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, nr_seq_resp_req_ser_w, null, null, nm_usuario_p);
	end if;

	if (cd_mens_erro_3_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_3_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, nr_seq_resp_req_ser_w, null, null, nm_usuario_p);
	end if;

	if (cd_mens_erro_4_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_4_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, nr_seq_resp_req_ser_w, null, null, nm_usuario_p);
	end if;

	if (cd_mens_erro_5_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_5_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, nr_seq_resp_req_ser_w, null, null, nm_usuario_p);
	end if;
elsif (ie_tipo_tabela_w	in ('2','3','5','6')) then
	if (cd_mens_erro_1_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_1_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, null, nr_seq_resp_req_ser_w, null, nm_usuario_p);
	end if;

	if (cd_mens_erro_2_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_2_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, null, nr_seq_resp_req_ser_w, null, nm_usuario_p);
	end if;

	if (cd_mens_erro_3_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_3_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, null, nr_seq_resp_req_ser_w, null, nm_usuario_p);
	end if;

	if (cd_mens_erro_4_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_4_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, null, nr_seq_resp_req_ser_w, null, nm_usuario_p);
	end if;

	if (cd_mens_erro_5_p	<> 0) then
		CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_5_p,ds_mens_erro_p,cd_estabelecimento_w, nr_seq_resposta_p, 'OR',
						cd_transacao_p, null, nr_seq_resp_req_ser_w, null, nm_usuario_p);
	end if;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_pck.ptu_imp_dados_00807_v70 ( cd_transacao_p ptu_resposta_req_ord_serv.cd_transacao%type, ie_tipo_tabela_p ptu_resposta_req_servico.ie_tipo_tabela%type, nr_seq_item_p ptu_resposta_req_servico.nr_seq_item%type, cd_servico_p ptu_resposta_req_servico.cd_servico%type, qt_autorizada_p ptu_resposta_req_servico.qt_servico_aut%type, ie_status_req_p ptu_resposta_req_servico.ie_status_requisicao%type, cd_mens_erro_1_p ptu_inconsistencia.cd_inconsistencia%type, cd_mens_erro_2_p ptu_inconsistencia.cd_inconsistencia%type, cd_mens_erro_3_p ptu_inconsistencia.cd_inconsistencia%type, cd_mens_erro_4_p ptu_inconsistencia.cd_inconsistencia%type, cd_mens_erro_5_p ptu_inconsistencia.cd_inconsistencia%type, ds_mens_erro_p ptu_intercambio_consist.ds_observacao%type, nr_seq_resposta_p ptu_resposta_req_ord_serv.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
