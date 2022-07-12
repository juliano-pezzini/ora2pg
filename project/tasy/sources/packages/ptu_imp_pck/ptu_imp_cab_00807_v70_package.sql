-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--------------------------------------------------------------------------------00807 Resposta de Ordem de Servico---------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_imp_pck.ptu_imp_cab_00807_v70 ( cd_transacao_p ptu_resposta_req_ord_serv.cd_transacao%type, ie_tipo_cliente_p text, cd_unimed_benef_p ptu_resposta_req_ord_serv.cd_unimed_beneficiario%type, cd_unimed_exec_p ptu_resposta_req_ord_serv.cd_unimed_executora%type, cd_unimed_solic_p ptu_resposta_req_ord_serv.cd_unimed_solicitante%type, nr_seq_origem_p ptu_resposta_req_ord_serv.nr_seq_origem%type, nr_seq_execucao_p ptu_resposta_req_ord_serv.nr_seq_execucao%type, cd_unimed_p ptu_resposta_req_ord_serv.cd_unimed%type, cd_usuario_plano_p ptu_resposta_req_ord_serv.cd_usuario_plano%type, nm_prestador_p ptu_resposta_req_ord_serv.nm_prest_alto_custo%type, nr_versao_p ptu_resposta_req_ord_serv.nr_versao%type, ds_observacao_p ptu_requisicao_ordem_serv.ds_observacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_resposta_p INOUT ptu_resposta_req_ord_serv.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Importar resposta da transacao 00807 - Resposta de Ordem de Servic

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


ie_tipo_cliente_w	ptu_resposta_req_ord_serv.ie_tipo_cliente%type;
qt_registros_w		integer;


BEGIN

select	count(1)
into STRICT	qt_registros_w
from	ptu_requisicao_ordem_serv
where	nr_transacao_solicitante	= nr_seq_origem_p
and	cd_unimed_solicitante		= cd_unimed_solic_p;

if (qt_registros_w	> 0) then
	-- Validacao e necessario converter os dados para  somente uma letra

	ie_tipo_cliente_w := ptu_converter_tipo_cliente(ie_tipo_cliente_p);

	insert	into ptu_resposta_req_ord_serv(nr_sequencia, cd_transacao, ie_tipo_cliente,
		cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao,
		cd_unimed, cd_usuario_plano, nr_seq_origem,
		nm_prest_alto_custo, nm_usuario, dt_atualizacao,
		nm_usuario_nrec, dt_atualizacao_nrec, nr_versao,
		cd_unimed_solicitante, ds_observacao)
	values (nextval('ptu_resposta_req_ord_serv_seq'), cd_transacao_p, ie_tipo_cliente_w,
		cd_unimed_exec_p, cd_unimed_benef_p, nr_seq_execucao_p,
		cd_unimed_p, cd_usuario_plano_p, nr_seq_origem_p,
		nm_prestador_p, nm_usuario_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nr_versao_p,
		cd_unimed_solic_p, ds_observacao_p) returning nr_sequencia into nr_seq_resposta_p;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_pck.ptu_imp_cab_00807_v70 ( cd_transacao_p ptu_resposta_req_ord_serv.cd_transacao%type, ie_tipo_cliente_p text, cd_unimed_benef_p ptu_resposta_req_ord_serv.cd_unimed_beneficiario%type, cd_unimed_exec_p ptu_resposta_req_ord_serv.cd_unimed_executora%type, cd_unimed_solic_p ptu_resposta_req_ord_serv.cd_unimed_solicitante%type, nr_seq_origem_p ptu_resposta_req_ord_serv.nr_seq_origem%type, nr_seq_execucao_p ptu_resposta_req_ord_serv.nr_seq_execucao%type, cd_unimed_p ptu_resposta_req_ord_serv.cd_unimed%type, cd_usuario_plano_p ptu_resposta_req_ord_serv.cd_usuario_plano%type, nm_prestador_p ptu_resposta_req_ord_serv.nm_prest_alto_custo%type, nr_versao_p ptu_resposta_req_ord_serv.nr_versao%type, ds_observacao_p ptu_requisicao_ordem_serv.ds_observacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_resposta_p INOUT ptu_resposta_req_ord_serv.nr_sequencia%type) FROM PUBLIC;