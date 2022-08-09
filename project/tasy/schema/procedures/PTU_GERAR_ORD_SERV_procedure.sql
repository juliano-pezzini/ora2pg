-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_ord_serv ( nr_seq_ordem_serv_p ptu_requisicao_ordem_serv.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resposta_p INOUT ptu_resposta_req_ord_serv.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina utilizada para validação da transação 00806 - Ordem de serviço do PTU
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_cliente_w		ptu_requisicao_ordem_serv.ie_tipo_cliente%type;
cd_unimed_executora_w		ptu_requisicao_ordem_serv.cd_unimed_executora%type;
cd_unimed_beneficiario_w	ptu_requisicao_ordem_serv.cd_unimed_beneficiario%type;
nr_transacao_solicitante_w	ptu_requisicao_ordem_serv.nr_transacao_solicitante%type;
cd_unimed_w			ptu_requisicao_ordem_serv.cd_unimed%type;
cd_usuario_plano_w		ptu_requisicao_ordem_serv.cd_usuario_plano%type;
nr_seq_guia_w			ptu_requisicao_ordem_serv.nr_seq_guia%type;
nr_seq_requisicao_w		ptu_requisicao_ordem_serv.nr_seq_requisicao%type;
nr_seq_prestador_w		ptu_requisicao_ordem_serv.nr_seq_prestador%type;
cd_unimed_solicitante_w		ptu_requisicao_ordem_serv.cd_unimed_solicitante%type;
nr_versao_w			ptu_requisicao_ordem_serv.nr_versao%type;


BEGIN

select	ie_tipo_cliente,
	cd_unimed_executora,
	cd_unimed_beneficiario,
	nr_transacao_solicitante,
	cd_unimed,
	cd_usuario_plano,
	nr_seq_guia,
	nr_seq_requisicao,
	coalesce(nr_seq_prestador,0),
	cd_unimed_solicitante,
	nr_versao
into STRICT	ie_tipo_cliente_w,
	cd_unimed_executora_w,
	cd_unimed_beneficiario_w,
	nr_transacao_solicitante_w,
	cd_unimed_w,
	cd_usuario_plano_w,
	nr_seq_guia_w,
	nr_seq_requisicao_w,
	nr_seq_prestador_w,
	cd_unimed_solicitante_w,
	nr_versao_w
from	ptu_requisicao_ordem_serv
where	nr_sequencia	= nr_seq_ordem_serv_p;

insert	into ptu_resposta_req_ord_serv(nr_sequencia, cd_transacao, ie_tipo_cliente,
	cd_unimed_executora, cd_unimed_beneficiario, cd_unimed_solicitante,
	nr_seq_execucao, cd_unimed, cd_usuario_plano,
	nr_seq_origem, nm_prest_alto_custo, nr_seq_requisicao,
	nr_seq_guia, ds_observacao, nm_usuario,
	dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec,
	nr_versao)
values (nextval('ptu_resposta_req_ord_serv_seq'), '00807', ie_tipo_cliente_w,
	cd_unimed_executora_w, cd_unimed_beneficiario_w, cd_unimed_solicitante_w,
	nr_seq_ordem_serv_p, cd_unimed_w, cd_usuario_plano_w,
	nr_transacao_solicitante_w, '', nr_seq_requisicao_w,
	nr_seq_guia_w, '', nm_usuario_p,
	clock_timestamp(), nm_usuario_p, clock_timestamp(),
	nr_versao_w) returning nr_sequencia into nr_seq_resposta_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_ord_serv ( nr_seq_ordem_serv_p ptu_requisicao_ordem_serv.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resposta_p INOUT ptu_resposta_req_ord_serv.nr_sequencia%type) FROM PUBLIC;
