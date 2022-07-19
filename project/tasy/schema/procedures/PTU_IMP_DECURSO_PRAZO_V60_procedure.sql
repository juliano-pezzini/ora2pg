-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_imp_decurso_prazo_v60 ( nr_seq_execucao_p ptu_resposta_autorizacao.nr_seq_execucao%type, cd_unimed_executora_p ptu_decurso_prazo.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_decurso_prazo.cd_unimed_beneficiario%type, ie_tipo_cliente_p ptu_decurso_prazo.ie_tipo_cliente%type, cd_transacao_p ptu_decurso_prazo.cd_transacao%type, ds_arquivo_p ptu_decurso_prazo.ds_arquivo_pedido%type, nr_versao_p ptu_decurso_prazo.nr_versao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_dec_prazo_p INOUT ptu_decurso_prazo.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Importar a transação 00700 - Decurso de Prazo do PTU
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_cliente_w		ptu_decurso_prazo.ie_tipo_cliente%type;
nr_seq_origem_w			ptu_resposta_autorizacao.nr_seq_origem%type;
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type;
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;


BEGIN


select	nr_seq_guia,
	nr_seq_requisicao,
	nr_seq_origem
into STRICT	nr_seq_guia_w,
	nr_seq_requisicao_w,
	nr_seq_origem_w
from	ptu_resposta_autorizacao
where	nr_seq_execucao		= nr_seq_execucao_p
and	cd_unimed_executora	= cd_unimed_executora_p;

ie_tipo_cliente_w := ptu_converter_tipo_cliente(ie_tipo_cliente_p);

insert	into ptu_decurso_prazo(nr_sequencia, cd_transacao, ie_tipo_cliente,
	cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao,
	dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
	nm_usuario_nrec, nr_versao, nr_seq_requisicao,
	nr_seq_guia, nr_seq_origem, ds_arquivo_pedido)
values (nextval('ptu_decurso_prazo_seq'), cd_transacao_p, ie_tipo_cliente_w,
	cd_unimed_executora_p, cd_unimed_beneficiario_p, nr_seq_execucao_p,
	clock_timestamp(), nm_usuario_p, clock_timestamp(),
	nm_usuario_p, nr_versao_p, nr_seq_requisicao_w,
	nr_seq_guia_w, nr_seq_origem_w, ds_arquivo_p) returning nr_sequencia into nr_seq_dec_prazo_p;

if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then
	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L','Recebido o Decurso de Prazo da Unimed '|| cd_unimed_executora_p, '', nm_usuario_p );
elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
	CALL pls_guia_gravar_historico(nr_seq_guia_w,2,'Recebido o Decurso de Prazo da Unimed '|| cd_unimed_executora_p, '', nm_usuario_p );
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_decurso_prazo_v60 ( nr_seq_execucao_p ptu_resposta_autorizacao.nr_seq_execucao%type, cd_unimed_executora_p ptu_decurso_prazo.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_decurso_prazo.cd_unimed_beneficiario%type, ie_tipo_cliente_p ptu_decurso_prazo.ie_tipo_cliente%type, cd_transacao_p ptu_decurso_prazo.cd_transacao%type, ds_arquivo_p ptu_decurso_prazo.ds_arquivo_pedido%type, nr_versao_p ptu_decurso_prazo.nr_versao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_dec_prazo_p INOUT ptu_decurso_prazo.nr_sequencia%type) FROM PUBLIC;

