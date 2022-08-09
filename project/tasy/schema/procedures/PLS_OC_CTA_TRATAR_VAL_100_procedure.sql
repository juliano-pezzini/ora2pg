-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_100 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de item dentro do período de vigência.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
*/
i			integer;
nr_seq_selecao_w	dbms_sql.number_table;
ie_valido_w		dbms_sql.varchar2_table;
ds_observacao_w		dbms_sql.varchar2_table;
ie_gera_ocorrencia_w	pls_oc_cta_selecao_ocor_v.ie_valido%type;
qt_hora_min_w		double precision;

-- Informações da validação de período de internação com relação ao item
C02 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	qt_tempo_max,
		qt_tempo_min,
		ie_tipo_val_tempo
	from	pls_oc_cta_val_tempo_item
	where	nr_seq_oc_cta_comb = nr_seq_oc_cta_comb_p;

C03 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
		ie_valido_pc	text) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		proc.ie_situacao ie_situacao,
		c_proc.dt_inicio_proc dt_inicio,
		c_proc.dt_fim_proc dt_fim
	from	pls_oc_cta_selecao_ocor_v 	sel,
		pls_conta_proc_ocor_v 		c_proc,
		procedimento			proc
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and	sel.ie_valido = 'S'
	and	sel.ie_tipo_registro = 'P'
	and	c_proc.nr_sequencia  = sel.nr_seq_conta_proc
	and	c_proc.cd_procedimento = proc.cd_procedimento
	and	c_proc.ie_origem_proced = proc.ie_origem_proced
	and	(c_proc.dt_inicio_proc IS NOT NULL AND c_proc.dt_inicio_proc::text <> '')
	and	(c_proc.dt_fim_proc IS NOT NULL AND c_proc.dt_fim_proc::text <> '')
	
union all

	SELECT	sel.nr_sequencia nr_seq_selecao,
		mat.ie_situacao	ie_situacao,
		c_mat.dt_inicio_atend dt_inicio,
		c_mat.dt_fim_atend dt_fim
	from	pls_oc_cta_selecao_ocor_v sel,
		pls_conta_mat_ocor_v c_mat,
		pls_material	mat
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and	sel.ie_tipo_registro = 'M'
	and	sel.ie_valido = 'S'
	and	c_mat.nr_sequencia   = sel.nr_seq_conta_mat
	and	c_mat.nr_seq_material = mat.nr_sequencia
	and	(c_mat.dt_inicio_atend IS NOT NULL AND c_mat.dt_inicio_atend::text <> '')
	and	(c_mat.dt_fim_atend IS NOT NULL AND c_mat.dt_fim_atend::text <> '');
BEGIN


-- Deve existir informação da regra para aplicar a validação
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') and (nr_id_transacao_p is not  null) then

	for	r_C02_w in C02(dados_regra_p.nr_sequencia) loop

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

		nr_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
		ie_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
		ds_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
		-- Iniciar o índice para preenchimento da tabela.
		i := 0;

		for	r_C03_w in C03(nr_id_transacao_p, 'S') loop

			ie_gera_ocorrencia_w := 'N';
			-- Inicializar os valores que serão atualizados na tabela de seleção.
			nr_seq_selecao_w(i) := r_C03_w.nr_seq_selecao;
			ds_observacao_w(i)  := null;

			--verifica se o tratamento é por hora ou minutos e já faz a conversão
			case(r_C02_w.ie_tipo_val_tempo)
				when  	'H'  then
					select (r_C03_w.dt_fim - r_C03_w.dt_inicio) * 24
					into STRICT	qt_hora_min_w
					;
				when	'M'  then
					select	((r_C03_w.dt_fim - r_C03_w.dt_inicio) * 24) * 60
					into STRICT	qt_hora_min_w
					;
			end case;

			if ( qt_hora_min_w < r_C02_w.qt_tempo_min) then
				ds_observacao_w(i) 	:= 'O tempo de realização do item, não atingiu o mínimo exigido.';
				ie_gera_ocorrencia_w	:= 'S';
			elsif ( qt_hora_min_w > r_C02_w.qt_tempo_max) then
				ds_observacao_w(i) 	:= 'O tempo de realização do item, ultrapassa o limite estabelecido.';
				ie_gera_ocorrencia_w	:= 'S';
			end if;

			-- Verificar se o registro atual é válido ou não conforme as parametrizações de regras e regras de exceção.
			ie_valido_w(i) := ie_gera_ocorrencia_w;

			-- Quando a quantidade de itens da lista tiver chegado ao máximo definido na PLS_CTA_CONSISTIR_PCK, então os registros são levados para
			-- o BD e gravados todos de uma vez, pela procedure GERENCIAL_SELECAO_VALIDACAO, que atualiza os registros conforme passado por
			-- parâmetro, o indice e as listas são reiniciados para carregar os novos registros e para que os registros atuais não sejam atualizados novamente em
			-- na próxima carga.
			if (i = pls_cta_consistir_pck.qt_registro_transacao_w) then

				-- Será passado uma lista com todas a sequencias da seleção para a conta e para seus itens, estas sequências serão atualizadas com os mesmos dados da conta,
				-- conforme passado por parâmetro,
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
										'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);

				-- Zerar o índice
				i := 0;

				-- Zerar as listas.
				ie_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
				nr_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
			-- Enquanto os registros não tiverem atingido a carga para gravar na seleção incrementa o índice para armazenar os próximos registros.
			else
				i := i + 1;
			end if;

		end loop; --C03
		-- Quando tiver sobrado algo na lista irá gravar o que restou após a execução do loop.
		if (nr_seq_selecao_w.count > 0) then
			-- Será passado uma lista com todas a sequencias da seleção para a conta e para seus itens, estas sequências serão atualizadas com os mesmos dados da conta,
			-- conforme passado por parâmetro,
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
									'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
		end if;

		-- seta os registros que serão válidos ou inválidos após o processamento
		CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
	end loop; -- C02
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_100 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
