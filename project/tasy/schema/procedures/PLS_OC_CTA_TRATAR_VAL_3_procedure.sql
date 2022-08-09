-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_3 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de Sexo exclusivo do procedimento em cima das contas ou itens
	que foram filtrados pelos filtros da regra e verificar se os mesmos continuam válidos
	ou não.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
 ------------------------------------------------------------------------------------------------------------------
 jjung OS 601977 10/06/2013 - Criação da procedure.
 ------------------------------------------------------------------------------------------------------------------
 jjung OS 602057 - 18/06/2013

 Alteração:	Retirado o campo dados_filtro_w.ieececao e substituido pelo ie_gera_ocorrencia.

 Motivo:	Foi identificado que a lógica do campo ie_excecao era muito confusa e poderia
	trazer problemas.
 ------------------------------------------------------------------------------------------------------------------
 jjung 29/06/2013

Alteração:	Adicionado parametro nos métodos de atualização dos campos IE_VALIDO e IE_VALIDO_TEMP
	da PLS_TIPOS_OCOR_PCK

Motivo:	Se tornou necessário diferenciar os filtros das validações na hora de realizar esta operação
	para que os filtros de exceção funcionem corretamente.
------------------------------------------------------------------------------------------------------------------
 jjung 25/07/2013

Alteração:	Alterado forma de buscar os procedimentos que estão na tabela de seleção. Também foi alterado
	a forma de verificação do sexo do procedimento para que não considere procedimento nem
	beneficiário com sexo indeterminado.

Motivo:	Foi visto que a ocorrência estava sendo gerada quando o beneficiário ou o procedimento
	tinham o sexo como Indeterminado o que se entende que não é o certo.
------------------------------------------------------------------------------------------------------------------
dlehmkuhl OS 688483 - 14/04/2014 -

Alteração:	Modificada a forma de trabalho em relação a atualização dos campos de controle
	que basicamente decidem se a ocorrência será ou não gerada. Foi feita também a
	substituição da rotina obter_se_gera.

Motivo:	Necessário realizar essas alterações para corrigir bugs principalmente no que se
	refere a questão de aplicação de filtros (passo anterior ao da validação). Também
	tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
	para não inviabilizar a nova solicitação que diz que a exceção deve verificar todo
	o atendimento.
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Procedimentos que entraram nos filtros e nas validações até então.
C01 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type,
		ie_evento_pc		dados_regra_p.ie_evento%type) FOR
	SELECT	c.nr_sequencia nr_seq_conta_proc,
		b.nr_sequencia nr_seq_conta,
		CASE WHEN  ie_evento_pc='IMP' THEN 		c.cd_procedimento_imp  ELSE c.cd_procedimento END  cd_procedimento,
		c.ie_origem_proced,
		coalesce(b.nr_seq_segurado, b.nr_seq_segurado_prot) nr_seq_segurado,
		a.nr_sequencia nr_seq_selecao
	from	pls_oc_cta_selecao_ocor_v	a,
		pls_conta_ocor_v		b,
		pls_conta_proc_ocor_v		c
	where	a.nr_id_transacao	= nr_id_transacao_pc
	and	a.ie_valido		= 'S'
	and	a.ie_tipo_registro	= 'P'
	and	b.nr_sequencia		= a.nr_seq_conta
	and	c.nr_seq_conta		= a.nr_seq_conta
	and	c.nr_sequencia		= a.nr_seq_conta_proc;

-- Regra de validacao do sexo exclusivo do procedimento.
C02 CURSOR(nr_seq_oc_cta_combinada_pc	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_oc_cta_val_sexo_proc a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_combinada_pc
	and	a.ie_valida_sexo_proc	= 'S';

i			integer;
nr_seq_selecao_w	dbms_sql.number_table;
ie_valido_w		dbms_sql.varchar2_table;
ds_observacao_w		dbms_sql.varchar2_table;

ie_sexo_w		pessoa_fisica.ie_sexo%type;
ie_sexo_exclusivo_w	procedimento.ie_sexo_sus%type;
ie_gera_ocorrencia_w	pls_oc_cta_selecao_ocor_v.ie_valido%type;

dados_filtro_w		pls_tipos_ocor_pck.dados_filtro;
BEGIN

-- Deve existir a informação da regra e da transação para que seja possível executar a validação
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') and (nr_id_transacao_p IS NOT NULL AND nr_id_transacao_p::text <> '') then

	-- Dados da regra de validacção do sexo do procedimento, só irá retornar algo se for para validar o sexo do procedimento( ie_valida_sexo_proc = 'S')
	for	r_C02_w in C02(dados_regra_p.nr_sequencia) loop

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

		-- Incializar as listas para cada regra.
		ie_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
		ds_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
		nr_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;

		-- Iniciar o índice para preenchimento da tabela.
		i := 0;
		-- Procedimentos que entraram nos filtros da regra. Só entraram procedimentos que tiverem registro
		-- na tabela pls_oc_cta_selecao_ocor_v e o mesmo for válido (ie_valido = 'S').
		for	r_C01_w in C01(nr_id_transacao_p, dados_regra_p.ie_evento) loop

			ie_gera_ocorrencia_w := 'S';
			-- Inicializar os valores que serão atualizados na tabela de seleção.
			ds_observacao_w(i) := null;
			nr_seq_selecao_w(i) := r_C01_w.nr_seq_selecao;

			-- Só é possível executar a validação se obtiver a informação do segurado e do procedimento;
			if (r_C01_w.nr_seq_segurado IS NOT NULL AND r_C01_w.nr_seq_segurado::text <> '') and (r_C01_w.nr_seq_conta_proc IS NOT NULL AND r_C01_w.nr_seq_conta_proc::text <> '') then

				-- Obter o sexo exclusivo do procedimento
				select	coalesce(max(ie_sexo_sus), 'I')
				into STRICT	ie_sexo_exclusivo_w
				from	procedimento
				where	ie_origem_proced	= r_C01_w.ie_origem_proced
				and	cd_procedimento		= r_C01_w.cd_procedimento;

				-- Se o procedimento tiver sexo exclusivo informado então deve ser verificado o  sexo do beneficiário.
				if (ie_sexo_exclusivo_w <> 'I') then

					-- Obter o sexo do beneficiário.
					select	max(b.ie_sexo)
					into STRICT	ie_sexo_w
					from	pls_segurado a,
						pessoa_fisica b
					where	a.nr_sequencia		= r_C01_w.nr_seq_segurado
					and	b.cd_pessoa_fisica	= a.cd_pessoa_fisica;

					-- Se o procedimento é exclusivo para um dos sexos e o sexo do beneficiário for o mesmo então ele é exceção e não
					-- será gerado a ocorrência. Se o beneficiário não tiver sexo informado deve ser gerada a ocorrência para que seja verificado o cadastro
					-- do mesmo.
					if (ie_sexo_w = ie_sexo_exclusivo_w) or (ie_sexo_w = 'I') then
						ie_gera_ocorrencia_w := 'N';
					end if;
				else
					-- Se o procedimento não exigir sexo exclusivo então a ocorrência não pode ser gerada para este item.
					ie_gera_ocorrencia_w := 'N';
				end if;

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
				ds_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
				nr_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
			-- Enquanto os registros não tiverem atingido a carga para gravar na seleção incrementa o índice para armazenar os próximos registros.
			else
				i := i + 1;
			end if;

		end loop; -- C01
		-- Quando tiver sobrado algo na lista irá gravar o que restou após a execução do loop.
		if (nr_seq_selecao_w.count > 0) then
			-- Será passado uma lista com todas a sequencias da seleção para a conta e para seus itens, estas sequências serão atualizadas com os mesmos dados da conta,
			-- conforme passado por parâmetro,
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
									'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
		end if;

		-- seta os registros que serão válidos ou inválidos após o processamento
		CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);

	end loop;-- C02
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_3 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
