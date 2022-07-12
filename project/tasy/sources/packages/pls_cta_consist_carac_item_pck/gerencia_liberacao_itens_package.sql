-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_consist_carac_item_pck.gerencia_liberacao_itens ( nr_seq_lote_prot_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Ler as regras de Carascterísticas da conta X Características do item e vincular
	os itens liberados através da tabela pls_conta_proc_regra_lib.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações
-------------------------------------------------------------------------------------------------------------------
jjung OS 629123 - 08/11/2013 -  Criação da procedure.
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cs_grupos CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ie_tipo_validacao
	from	pls_lib_item_regra_grupo a
	where	a.ie_situacao = 'A';
BEGIN

-- Alimentar os parametros.
current_setting('pls_cta_consist_carac_item_pck.dados_parametros_w')::dados_parametros.nr_seq_lote		:= nr_seq_lote_prot_p;
current_setting('pls_cta_consist_carac_item_pck.dados_parametros_w')::dados_parametros.nr_seq_protocolo	:= nr_seq_protocolo_p;
current_setting('pls_cta_consist_carac_item_pck.dados_parametros_w')::dados_parametros.nr_seq_conta		:= nr_seq_conta_p;
current_setting('pls_cta_consist_carac_item_pck.dados_parametros_w')::dados_parametros.nr_seq_lote_processo	:= nr_seq_lote_processo_p;
current_setting('pls_cta_consist_carac_item_pck.dados_parametros_w')::dados_parametros.cd_estabelecimento	:= cd_estabelecimento_p;
current_setting('pls_cta_consist_carac_item_pck.dados_parametros_w')::dados_parametros.nm_usuario		:= nm_usuario_p;

-- Limpar as listas.
CALL CALL pls_cta_consist_carac_item_pck.limpar_listas();

-- Varrer as regras.
for	rw_grupos_w in cs_grupos loop

	-- Processar as regras do grupo atual. Aqui será filtrado os itens conforme passado por parâmetro e irá ser confrontadas as características da conta e do item e
	-- então inseridos na tabela que define quem foi liberado e quem não foi.
	CALL pls_cta_consist_carac_item_pck.processar_regras_grupo(rw_grupos_w.nr_sequencia);
end loop; -- cs_grupos
-- Mandar as listas para o banco
CALL pls_cta_consist_carac_item_pck.gravar_listas();
CALL pls_cta_consist_carac_item_pck.atualizar_listas();

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consist_carac_item_pck.gerencia_liberacao_itens ( nr_seq_lote_prot_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;