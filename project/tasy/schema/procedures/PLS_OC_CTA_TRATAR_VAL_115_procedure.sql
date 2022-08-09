-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_115 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Aplicar a validação para gerar a ocorrência em contas que tenham CID inválido no diagnostico.

		Para considerar o CID inválido será verificado a regra da validação, que vai determinar sua obrigatoriedade,
		situação e se ele esta cadastrado.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_valida_w	varchar(1);
dados_tb_sel_w	pls_tipos_ocor_pck.dados_table_selecao_ocor;
i		integer;

-- carrega as inf da ocorrencia
c_regra CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	coalesce(a.ie_valida_cid, 'N') ie_valida_cid,
		coalesce(a.ie_valida_informado, 'S') ie_valida_informado,
		coalesce(a.ie_verifica_situacao, 'S') ie_verifica_situacao
	from	pls_oc_cta_val_cid	a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

-- carrega os diagnosticos
c_diagnostico CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		coalesce(diag.cd_doenca, diag.cd_doenca_imp) cd_doenca,
		-- qt do cadastro do CID
		(	SELECT	count(1)
			from	cid_doenca	a
			
			where	a.cd_doenca_cid	= coalesce(diag.cd_doenca_imp, diag.cd_doenca)) qt_cid,
		-- CID ATIVO
		(	select	count(1)
			from	cid_doenca	a
			where	a.cd_doenca_cid	= coalesce(diag.cd_doenca, diag.cd_doenca_imp)
			and	a.ie_situacao	= 'A') qt_cid_ativo
	from	pls_oc_cta_selecao_ocor_v	sel,
		pls_diagnostico_conta		diag
	where	diag.nr_seq_conta		= sel.nr_seq_conta
	and	sel.nr_id_transacao		= nr_id_transacao_pc
	and	sel.ie_valido			= 'S';
BEGIN

-- Só aplicar a validação se existir informação da regra.
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	-- carrega as inf da ocorrencia
	for r_c_regra_w in c_regra(dados_regra_p.nr_sequencia) loop

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
		i := 0;

		-- segue apenas se a ocorrencia estiver marcada para validar o CID
		if (r_c_regra_w.ie_valida_cid = 'S') then

			-- carrega os diagnosticos
			for r_c_diag_w in c_diagnostico(nr_id_transacao_p) loop

				-- incializa a marcação se deve seguir com a validação do CID atual
				ie_valida_w := 'S';

				-- verifica se o CID NÃO esta informado e se a regra valida somente informados, então não precisa seguir com o a validação
				if (coalesce(r_c_diag_w.cd_doenca::text, '') = '') and (r_c_regra_w.ie_valida_informado = 'S') then

					ie_valida_w := 'N';
				end if;

				-- realiza a validação de fato, se necessário
				if (ie_valida_w = 'S') then


					dados_tb_sel_w.ie_valido(i)	:= 'N';
					dados_tb_sel_w.ds_observacao(i)	:= '';

					dados_tb_sel_w.nr_seq_selecao(i)	:= r_c_diag_w.nr_seq_selecao;

					-- se está informado (nos casos que não precisa, já e testado o ie_valida_w)
					if (coalesce(r_c_diag_w.cd_doenca::text, '') = '') then

						dados_tb_sel_w.ie_valido(i)	:= 'S';
						dados_tb_sel_w.ds_observacao(i)	:= substr(dados_tb_sel_w.ds_observacao(i)||' - CID não informado'||pls_util_pck.enter_w, 1,2000);

					else -- realiza as demais validações
						-- CID informado não cadastrado
						if (r_c_diag_w.qt_cid = 0) then

							dados_tb_sel_w.ie_valido(i)	:= 'S';
							dados_tb_sel_w.ds_observacao(i)	:= substr(dados_tb_sel_w.ds_observacao(i)||' - CID informado inválido'||pls_util_pck.enter_w, 1, 2000);

						end if;

						-- CID informado não está ativo
						if (r_c_diag_w.qt_cid_ativo = 0) and (r_c_regra_w.ie_verifica_situacao = 'S') then

							dados_tb_sel_w.ie_valido(i)	:= 'S';
							dados_tb_sel_w.ds_observacao(i)	:= substr(dados_tb_sel_w.ds_observacao(i)||' - CID informado não está ativo'||pls_util_pck.enter_w, 1, 2000);
						end if;
					end if;
				end if; -- fim valida CID
				-- Quando a quantidade de itens da lista tiver chegado ao máximo definido na PLS_CTA_CONSISTIR_PCK, então os registros são levados para
				-- o BD e gravados todos de uma vez, pela procedure GERENCIAL_SELECAO_VALIDACAO, que atualiza os registros conforme passado por
				-- parâmetro, o indice e as listas são reiniciados para carregar os novos registros e para que os registros atuais não sejam atualizados novamente em
				-- na próxima carga.
				if (i = pls_cta_consistir_pck.qt_registro_transacao_w) then

					-- Será passado uma lista com todas a sequencias da seleção para a conta e para seus itens, estas sequências serão atualizadas com os mesmos dados da conta,
					-- conforme passado por parâmetro,
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(
						dados_tb_sel_w.nr_seq_selecao, pls_tipos_ocor_pck.clob_table_vazia,
						'SEQ', dados_tb_sel_w.ds_observacao, dados_tb_sel_w.ie_valido, nm_usuario_p);

					-- Zerar o índice
					i := 0;

					-- Zerar as listas.
					pls_tipos_ocor_pck.limpar_nested_tables(dados_tb_sel_w);
				-- Enquanto os registros não tiverem atingido a carga para gravar na seleção incrementa o índice para armazenar os próximos registros.
				else
					i := i + 1;
				end if;

			end loop; -- fim dos diagnosticos "c_diagnostico"
			-- se ainda tem alguma coisa, envia para o banco
			if (dados_tb_sel_w.nr_seq_selecao.count > 0) then

				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(
							dados_tb_sel_w.nr_seq_selecao, pls_tipos_ocor_pck.clob_table_vazia,
							'SEQ', dados_tb_sel_w.ds_observacao, dados_tb_sel_w.ie_valido, nm_usuario_p);
			end if;

		end if; -- fim se a ocorrencia valida o CID
		-- seta os registros que serão válidos ou inválidos após o processamento
		CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);

	end loop; -- fim inf ocorrencia "c_regra"
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_115 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
