-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_dados_ocor_pck.gravar_ocorrencias_regra ( nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_ocor_p pls_tipos_ocor_pck.dados_ocor, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade:	Realizar a geração ou reativação das ocorrências para os itens e/ou contas que 
	foram filtrados para regra 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ X] Outros: 
------------------------------------------------------------------------------------------------------------------- 
Pontos de atenção: 
 
Alterações: 
------------------------------------------------------------------------------------------------------------------ 
jjung 22/08/2013 - OS 625967 
------------------------------------------------------------------------------------------------------------------ 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
					 
ie_tipo_item_w			integer;				
qt_oc_benef_w			integer;
nr_seq_ocorrencia_benef_w	pls_ocorrencia_benef.nr_sequencia%type;
ie_tipo_aplicacao_ocor_w	pls_oc_cta_tipo_validacao.ie_aplicacao_ocorrencia%type;

-- Retorna a informação dos itens que estão na tabela de seleção. 
c_gera_ocor CURSOR(nr_id_transacao_pc		pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, 
	cd_estabelecimento_pc		estabelecimento.cd_estabelecimento%type) FOR 
	SELECT	 
		distinct 
		x.nr_seq_conta, 
		x.nr_seq_conta_proc, 
		x.nr_seq_conta_mat, 
		x.ie_tipo_registro, 
		x.ds_observacao, 
		a.nr_seq_segurado 
	from	pls_oc_cta_selecao_ocor_v	x, 
		pls_conta 			a 
	where	x.nr_id_transacao	= nr_id_transacao_pc 
	and	x.ie_valido		= 'S' 
	and	a.nr_sequencia		= x.nr_seq_conta 
	and	a.cd_estabelecimento	= cd_estabelecimento_pc 
	-- tratamento para lançar somente as ocorrências em contas que sejam válidas. 
	-- na tabela de seleção pode existir alguma conta fechada, porque contas fechadas são consideradas durante o processo apenas para leitura 
	-- isso existe basicamente pelo motivo de geração de contas de honorário individual 
	-- em resumo, só as contas que tiverem os status abaixo podem ter ocorrências combinadas 
	and	a.ie_status 		in ('A', 'L', 'P', 'U');

-- Retorna apenas a informação das contas que estão na tabela de seleção. 
c_gera_ocor_conta CURSOR(nr_id_transacao_pc		pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, 
	cd_estabelecimento_pc		estabelecimento.cd_estabelecimento%type) FOR 
	SELECT	 
		distinct 
		x.nr_seq_conta, 
		x.ds_observacao, 
		a.nr_seq_segurado 
	from	pls_oc_cta_selecao_ocor_v	x, 
		pls_conta 			a 
	where	x.nr_id_transacao	= nr_id_transacao_pc 
	and	x.ie_valido		= 'S' 
	and	a.nr_sequencia		= x.nr_seq_conta 
	and	a.cd_estabelecimento	= cd_estabelecimento_pc 
	-- tratamento para lançar somente as ocorrências em contas que sejam válidas. 
	-- na tabela de seleção pode existir alguma conta fechada, porque contas fechadas são consideradas durante o processo apenas para leitura 
	-- isso existe basicamente pelo motivo de geração de contas de honorário individual 
	-- em resumo, só as contas que tiverem os status abaixo podem ter ocorrências combinadas 
	and	a.ie_status 		in ('A', 'L', 'P', 'U') 
	-- Quando a aplicação for na conta não pode ter nenhum item da conta que caiu em uma exceção, caso contrário a conta toda se torna inválida para a ocorrência. 
	and	not exists (	SELECT	1 
				from	pls_oc_cta_selecao_ocor_v y 
				where	y.nr_id_transacao = nr_id_transacao_pc 
				and	y.nr_seq_conta = x.nr_seq_conta 
				and	y.ie_excecao = 'S');
	
BEGIN 
 
ie_tipo_aplicacao_ocor_w := pls_gerencia_dados_ocor_pck.obter_aplicacao_regra(dados_regra_p);
 
-- Quando a regra for para gera apenas para a conta então se busca apenas as contas da tabela de seleção e aplica-se a ocorrência apenas para a conta ignorando os itens, isto para que funcione 
-- a opção de que o usuário possa escolher aonde a ocorrência será aplicada quando a opção for somente filtros. Também foi idealizado que para as validações de conta, caso seja usado filtro por 
-- item será mais rápido acessar apenas as contas e não verificar cada item da conta. 
-- Conta 
if (ie_tipo_aplicacao_ocor_w = 'C') then 
				 
	-- grava as ocorrências 
	for r_c_gera_ocor_conta in c_gera_ocor_conta(nr_id_transacao_p, cd_estabelecimento_p) loop 
		-- Gera ocorrência ou Reativar 
		qt_oc_benef_w := pls_tipos_ocor_pck.obter_qt_ocorrencia(r_c_gera_ocor_conta.nr_seq_conta, null, 
							null, dados_regra_p);
		 
		-- se não tiver registros insere glosa 
		if (qt_oc_benef_w = 0) then 
 
			-- Insere a ocorrência para o item selecionado. 
			pls_inserir_ocorrencia(	r_c_gera_ocor_conta.nr_seq_segurado, dados_regra_p.nr_seq_ocorrencia, null, 
						null, r_c_gera_ocor_conta.nr_seq_conta, null, null, null, nm_usuario_p, 
						r_c_gera_ocor_conta.ds_observacao, dados_ocor_p.nr_seq_motivo_glosa, 8, 
						dados_regra_p.cd_estabelecimento, 'N' ,null, 
						nr_seq_ocorrencia_benef_w, null, null, null, null);
		else 
			-- Se o item já tiver a ocorrência lançada será reativado a ocorrência. 
			CALL pls_reativar_ocor_conta(	dados_regra_p.nr_seq_ocorrencia, r_c_gera_ocor_conta.nr_seq_conta, null , null, 
							nm_usuario_p);
		end if;
		commit;
	end loop; -- c_gera_ocor_conta 
-- Se não for para gerar por conta entende-se que deve ser gerado para qualquer registro da tabela de seleção. 
else
 
	-- grava as ocorrências 
	for r_c_gera_ocor in c_gera_ocor(nr_id_transacao_p, cd_estabelecimento_p) loop 
		-- Gera ocorrência ou Reativar 
		qt_oc_benef_w := pls_tipos_ocor_pck.obter_qt_ocorrencia(r_c_gera_ocor.nr_seq_conta, r_c_gera_ocor.nr_seq_conta_proc, 
							r_c_gera_ocor.nr_seq_conta_mat, dados_regra_p);
		 
		-- se não tiver registros insere glosa 
		if (qt_oc_benef_w = 0) then 
		 
			-- gerar para conta 
			if (r_c_gera_ocor.ie_tipo_registro = 'C') then 
				ie_tipo_item_w := 8;
			-- gerar para procedimento 
			elsif (r_c_gera_ocor.ie_tipo_registro = 'P') then 
				ie_tipo_item_w := 3;
			-- gerar para material	 
			elsif (r_c_gera_ocor.ie_tipo_registro = 'M') then 
				ie_tipo_item_w := 4;
			-- senão é nulo 
			else 
				ie_tipo_item_w := null;
			end if;
 
			-- Insere a ocorrência para o item selecionado. 
			pls_inserir_ocorrencia(	r_c_gera_ocor.nr_seq_segurado, dados_regra_p.nr_seq_ocorrencia, null, 
						null, r_c_gera_ocor.nr_seq_conta, r_c_gera_ocor.nr_seq_conta_proc, 
						r_c_gera_ocor.nr_seq_conta_mat, null, nm_usuario_p, 
						r_c_gera_ocor.ds_observacao, dados_ocor_p.nr_seq_motivo_glosa, ie_tipo_item_w, 
						dados_regra_p.cd_estabelecimento, 'N' ,null, 
						nr_seq_ocorrencia_benef_w, null,	 
						null, null, null);
		else 
			-- Se o item já tiver a ocorrência lançada será reativado a ocorrência. 
			CALL pls_reativar_ocor_conta( dados_regra_p.nr_seq_ocorrencia, r_c_gera_ocor.nr_seq_conta, 
						 r_c_gera_ocor.nr_seq_conta_proc, r_c_gera_ocor.nr_seq_conta_mat, nm_usuario_p);
		end if;
		commit;
	end loop; -- c_gera_ocor		 
end if;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_dados_ocor_pck.gravar_ocorrencias_regra ( nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_ocor_p pls_tipos_ocor_pck.dados_ocor, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
