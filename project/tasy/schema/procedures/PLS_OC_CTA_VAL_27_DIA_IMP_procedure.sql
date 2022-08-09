-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_val_27_dia_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
dados_segurado_w		pls_ocor_imp_pck.dados_benef;
dados_tabela_aux_w		pls_ocor_imp_pck.dados_tabela_aux_val_limit;
dados_limitacao_w		pls_ocor_imp_pck.dados_limitacao;
dados_periodo_exec_w		pls_ocor_imp_pck.t_datas_periodo_limit_row;
dados_restricao_imp_w		pls_ocor_imp_pck.dados_restricao_select;
dados_restricao_w		pls_ocor_imp_pck.dados_restricao_select;
dados_conta_proc_w		pls_ocor_imp_pck.dados_conta_proc;
dados_tb_selecao_w		pls_ocor_imp_pck.dados_table_selecao_ocor;
dado_bind_w			sql_pck.t_dado_bind;
cursor_w			sql_pck.t_cursor;

qt_proc_util_total_w		pls_conta_proc_imp.qt_executado%type;
ds_itens_util_w			varchar(4000);
ds_sql_w			varchar(4000);
i				integer;
qt_proc_selecao_w		integer;

-- Obter os beneficiários e seus dados das contas que estão na tabela de seleção. Está sendo utilizado o distinct para que seja passado uma vez apenas para cada beneficiário pois o processo
-- da validação é caro e quanto menos for executado melhor
C01 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	distinct
		b.nr_seq_segurado_conv,
		c.nr_seq_plano,
		c.nr_seq_contrato,
		c.nr_seq_intercambio,
		d.dt_execucao_conv,
		c.dt_contrato,
		c.dt_contratacao,
		c.dt_primeira_utilizacao,
		c.nr_seq_titular
	from	pls_oc_cta_selecao_imp		a,
		pls_conta_imp			b,
		pls_segurado_conta_imp_v	c,
		pls_conta_proc_imp		d,
		pls_protocolo_conta_imp		e
	where	a.nr_id_transacao	= nr_id_transacao_pc
	and	a.ie_valido		= 'S'
	and	a.ie_tipo_registro	= 'P'
	and	e.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= a.nr_seq_conta
	and	c.nr_sequencia		= b.nr_seq_segurado_conv
	and	d.nr_seq_conta		= a.nr_seq_conta
	and	d.nr_sequencia		= a.nr_seq_conta_proc
	and	d.ie_tipo_despesa_conv	= '3'
	and	e.ie_tipo_guia		= '5';

-- Obter as limitações a qual o beneficiário está atrelado, seja pelo plano ou pelo contrato de intercâmbio.
-- Está sendo utilizado o union e buscado todas as limitações do beneficiário para evitar replicação de código
-- e para que passe e verifique cada limitação apenas uma vez.
C02 CURSOR(	nr_seq_contrato_pc	pls_segurado_conta_v.nr_seq_contrato%type,
		nr_seq_plano_pc		pls_segurado_conta_v.nr_seq_plano%type,
		nr_seq_intercambio_pc	pls_segurado_conta_v.nr_seq_intercambio%type) FOR
	SELECT	a.nr_sequencia	nr_seq_limitacao,
		a.nr_seq_tipo_limitacao,
		a.qt_dia_internacao,
		a.ie_periodo,
		a.qt_meses_intervalo,
		a.ie_tipo_periodo,
		b.ie_tipo_incidencia
	from	pls_limitacao		a,
		pls_tipo_limitacao	b
	where	a.nr_seq_contrato	= nr_seq_contrato_pc
	and	((coalesce(a.nr_seq_plano_contrato::text, '') = '') or (a.nr_seq_plano_contrato = nr_seq_plano_pc))
	and	(a.qt_dia_internacao IS NOT NULL AND a.qt_dia_internacao::text <> '')
	and	b.nr_sequencia		= a.nr_seq_tipo_limitacao
	and	b.ie_situacao		= 'A'
	
union

	SELECT	a.nr_sequencia	nr_seq_limitacao,
		a.nr_seq_tipo_limitacao,
		a.qt_dia_internacao,
		a.ie_periodo,
		a.qt_meses_intervalo,
		a.ie_tipo_periodo,
		b.ie_tipo_incidencia
	from	pls_limitacao		a,
		pls_tipo_limitacao	b
	where	a.nr_seq_plano		= nr_seq_plano_pc
	and	(a.qt_dia_internacao IS NOT NULL AND a.qt_dia_internacao::text <> '')
	and	b.nr_sequencia		= a.nr_seq_tipo_limitacao
	and	b.ie_situacao		= 'A'
	
union

	select	a.nr_sequencia	nr_seq_limitacao,
		a.nr_seq_tipo_limitacao,
		a.qt_dia_internacao,
		a.ie_periodo,
		a.qt_meses_intervalo,
		a.ie_tipo_periodo,
		b.ie_tipo_incidencia
	from	pls_limitacao		a,
		pls_tipo_limitacao	b
	where	a.nr_seq_intercambio	= nr_seq_intercambio_pc
	and	(a.qt_dia_internacao IS NOT NULL AND a.qt_dia_internacao::text <> '')
	and	b.nr_sequencia		= a.nr_seq_tipo_limitacao
	and	b.ie_situacao		= 'A';

-- Obter os itens que estão na tabela auxiliar. Será passado por último para os itens que estão na tabela de seleção para que seja inserida ocorrência apenas para estes itens.
C03 CURSOR(	nr_id_transacao_pc		pls_oc_cta_val_limit_aux.nr_id_transacao%type,
		nr_seq_segurado_pc		pls_oc_cta_val_limit_aux.nr_seq_segurado%type,
		nr_seq_tipo_limitacao_pc	pls_oc_cta_val_limit_aux.nr_seq_tipo_limitacao%type) FOR
	SELECT	a.nr_seq_conta,
		a.nr_seq_conta_proc,
		a.qt_item,
		a.ie_selecao,
		b.nr_sequencia nr_seq_selecao
	from	pls_oc_cta_val_limit_aux	a,
		pls_oc_cta_selecao_imp		b
	where	a.nr_id_transacao	= b.nr_id_transacao
	and	a.nr_seq_conta		= b.nr_seq_conta
	and	a.nr_seq_conta_proc	= b.nr_seq_conta_proc
	and	a.nr_id_transacao	= nr_id_transacao_pc
	and	a.nr_seq_segurado	= nr_seq_segurado_pc
	and	a.nr_seq_tipo_limitacao	= nr_seq_tipo_limitacao_pc
	order by a.ie_selecao;
BEGIN

-- Aqui serão buscados os beneficiários das contas que estão na tabela de seleção.
for	r_C01_w in C01(nr_id_transacao_p) loop

	-- Atualizar os dados do beneficiário atual.
	dados_segurado_w.nr_sequencia		:= r_C01_w.nr_seq_segurado_conv;
	dados_segurado_w.nr_seq_contrato	:= r_C01_w.nr_seq_contrato;
	dados_segurado_w.nr_seq_plano		:= r_C01_w.nr_seq_plano;
	dados_segurado_w.nr_seq_intercambio	:= r_C01_w.nr_seq_intercambio;
	dados_segurado_w.dt_adesao		:= r_C01_w.dt_contratacao;
	dados_segurado_w.dt_contrato		:= r_C01_w.dt_contrato;
	dados_segurado_w.dt_primeira_utilizacao	:= r_C01_w.dt_primeira_utilizacao;
	dados_segurado_w.nr_seq_titular		:= r_C01_w.nr_seq_titular;

	-- Para cada beneficiário serão buscadas as limitações contratuais do plano e do contrato do beneficiário que for beneficiário da operadora, para intercâmbio
	-- será feito de outra forma pois devido ao campo ser diferente então temos mais facilidade buscando o intercâmbio em outro momento, apenas quando ele for
	-- informado.
	for	r_C02_w in C02(r_C01_w.nr_seq_contrato, r_C01_w.nr_seq_plano, r_C01_w.nr_seq_intercambio) loop

		pls_ocor_imp_pck.gerencia_tabela_aux_val_limit( 'T', null, nr_id_transacao_p, dados_tabela_aux_w, nm_usuario_p);

		-- Obter os dados da limitação atual para realizar as consistências devidas.
		dados_limitacao_w.nr_sequencia		:= r_C02_w.nr_seq_limitacao;
		dados_limitacao_w.nr_seq_tipo_limitacao	:= r_C02_w.nr_seq_tipo_limitacao;
		dados_limitacao_w.qt_permitida		:= r_C02_w.qt_dia_internacao;
		dados_limitacao_w.ie_periodo		:= r_C02_w.ie_periodo;
		dados_limitacao_w.qt_meses_intervalo	:= r_C02_w.qt_meses_intervalo;
		dados_limitacao_w.ie_tipo_periodo	:= r_C02_w.ie_tipo_periodo;
		dados_limitacao_w.ie_tipo_incidencia	:= r_C02_w.ie_tipo_incidencia;

		-- Verificar se o tipo de período informado é referente a datas.
		if (dados_limitacao_w.ie_tipo_periodo in ('D','S','M')) then

			-- Verificar o tipo de período informado na regra para obter o período de verificação da regra. Através das datas obtidas nesta seção serão buscados os
			-- procedimentos executados pelo benenficiário para verificar se ultrapassa a quantidade permitida pelo contrato.
			dados_periodo_exec_w := pls_ocor_imp_pck.obter_periodo_exec_limit(	dados_limitacao_w,
												dados_segurado_w,
												r_C01_w.dt_execucao_conv,
												nm_usuario_p);

			-- Atualiza os dados da limitacao com a informação de começo e fim de período.
			dados_limitacao_w.dt_inicio_periodo	:= dados_periodo_exec_w.dt_inicio;
			dados_limitacao_w.dt_fim_periodo	:= dados_periodo_exec_w.dt_fim;

			-- Se não tiver encontrado as datas verifica procedimentos apenas na mesma data do procedimento.
			if (coalesce(dados_limitacao_w.dt_inicio_periodo::text, '') = '') then

				dados_limitacao_w.dt_inicio_periodo := trunc(r_C01_w.dt_execucao_conv);
			end if;

			if (coalesce(dados_limitacao_w.dt_fim_periodo::text, '') = '') then

				dados_limitacao_w.dt_fim_periodo := fim_dia(r_C01_w.dt_execucao_conv);
			end if;
		end if;

		dado_bind_w.delete;

		dado_bind_w := pls_obter_restr_val_27_imp(	dados_segurado_w, nr_id_transacao_p, dados_limitacao_w, 'P', null, null, 'IMP', dado_bind_w);

		dado_bind_w := pls_obter_restr_val_27_imp(	dados_segurado_w, nr_id_transacao_p, dados_limitacao_w, 'P', null, null, 'N', dado_bind_w);

		-- Só executa a verificação se alguma restrição for informada. Se estiverem todas nulas pode ser que o tipo de inicidência do tipo
		-- de limitação não esteja informado, este campo é obrigatório e sem ele não será aplicada a validação. Se tiver uma das restrições informadas então será
		-- aplicada a informação.
		if (dados_restricao_w.qt_restricao > 0) and (dados_restricao_imp_w.qt_restricao > 0) then
			-- Montar o select que busca os procedimentos executados.
			ds_sql_w :=	'select	conta.nr_sequencia nr_seq_conta, 			' || pls_util_pck.enter_w ||
					'	proc.nr_sequencia nr_seq_conta_proc, 			' || pls_util_pck.enter_w ||
					'	proc.qt_executado qt_proc, 				' || pls_util_pck.enter_w ||
					'	proc.dt_execucao_conv dt_procedimento, 			' || pls_util_pck.enter_w ||
					'	(select	count(1)					' || pls_util_pck.enter_w ||
					'	from	pls_oc_cta_selecao_imp x			' || pls_util_pck.enter_w ||
					'	where	x.nr_id_transacao	= :nr_id_transacao_p 	' || pls_util_pck.enter_w ||
					'	and	x.ie_valido = ''S''				' || pls_util_pck.enter_w ||
					'	and	x.ie_tipo_registro = ''P''			' || pls_util_pck.enter_w ||
					'	and	x.nr_seq_conta = conta.nr_sequencia		' || pls_util_pck.enter_w ||
					'	and	x.nr_seq_conta_proc = proc.nr_sequencia) qt_tran' || pls_util_pck.enter_w ||
					'from	pls_conta_imp conta, 					' || pls_util_pck.enter_w ||
					'	pls_conta_proc_imp proc 				' || pls_util_pck.enter_w ||
					'where	1 = 1 							' || pls_util_pck.enter_w ||
					dados_restricao_imp_w.ds_restricao_conta 			  || pls_util_pck.enter_w ||
					'and	proc.nr_seq_conta = conta.nr_sequencia 			' || pls_util_pck.enter_w ||
					'and	proc.ie_tipo_despesa_conv = ''3'' 			' || pls_util_pck.enter_w ||
					dados_restricao_imp_w.ds_restricao_proc 			  || pls_util_pck.enter_w ||
					'union all							' || pls_util_pck.enter_w ||
					'select	conta.nr_sequencia nr_seq_conta, 			' || pls_util_pck.enter_w ||
					'	proc.nr_sequencia nr_seq_conta_proc, 			' || pls_util_pck.enter_w ||
					'	proc.qt_ok qt_proc, 					' || pls_util_pck.enter_w ||
					'	proc.dt_procedimento ,					' || pls_util_pck.enter_w ||
					'	(select	count(1)					' || pls_util_pck.enter_w ||
					'	from	pls_oc_cta_selecao_ocor_v 			' || pls_util_pck.enter_w ||
					'	where	nr_id_transacao	= :nr_id_transacao_p 		' || pls_util_pck.enter_w ||
					'	and	ie_valido = ''S''				' || pls_util_pck.enter_w ||
					'	and	ie_tipo_registro = ''P''			' || pls_util_pck.enter_w ||
					'	and	nr_seq_conta = conta.nr_sequencia		' || pls_util_pck.enter_w ||
					'	and	nr_seq_conta_proc = proc.nr_sequencia) qt_tran	' || pls_util_pck.enter_w ||
					'from	pls_conta_ocor_v conta, 				' || pls_util_pck.enter_w ||
					'	pls_conta_proc_ocor_v proc 				' || pls_util_pck.enter_w ||
					'where	1 = 1 							' || pls_util_pck.enter_w ||
					dados_restricao_w.ds_restricao_conta 				  || pls_util_pck.enter_w ||
					'and	proc.nr_seq_conta = conta.nr_sequencia 			' || pls_util_pck.enter_w ||
					'and	proc.ie_tipo_despesa = ''3'' 				' || pls_util_pck.enter_w ||
					dados_restricao_w.ds_restricao_proc 				  || pls_util_pck.enter_w ||
					'order by dt_procedimento ';

			dado_bind_w := sql_pck.bind_variable(':nr_id_transacao_p', nr_id_transacao_p, dado_bind_w);

			begin
				-- Abrir um novo cursor
				dado_bind_w := sql_pck.executa_sql_cursor(ds_sql_w, dado_bind_w);

				loop
					fetch cursor_w into
						dados_conta_proc_w.nr_seq_conta,
						dados_conta_proc_w.nr_seq_conta_proc,
						dados_conta_proc_w.qt_procedimento,
						dados_conta_proc_w.dt_procedimento,
						qt_proc_selecao_w;
					EXIT WHEN NOT FOUND; /* apply on cursor_w */

					-- Verificar se está na tabela de selecao para atualizar o campo IE_SELECAO da tabela auxiliar.
					if (qt_proc_selecao_w = 0) then

						dados_tabela_aux_w.ie_selecao := 'N';
					else
						dados_tabela_aux_w.ie_selecao := 'S';
					end if;

					-- Gravar os dados selecionados para gravar na tabela auxiliar. Todo o processo de gravação ou atualização será feito na procedure
					-- GERENCIA_TABELA_AUX_VAL_LIMIT da PLS_OCOR_IMP_PCK.
					dados_tabela_aux_w.nr_seq_segurado		:= r_C01_w.nr_seq_segurado_conv;
					dados_tabela_aux_w.nr_seq_tipo_limitacao	:= dados_limitacao_w.nr_seq_tipo_limitacao;
					dados_tabela_aux_w.nr_id_transacao		:= nr_id_transacao_p;
					dados_tabela_aux_w.ie_liberado			:= 'S';
					dados_tabela_aux_w.qt_item			:= dados_conta_proc_w.qt_procedimento;
					dados_tabela_aux_w.nr_seq_conta			:= dados_conta_proc_w.nr_seq_conta;
					dados_tabela_aux_w.nr_seq_conta_proc		:= dados_conta_proc_w.nr_seq_conta_proc;

					pls_ocor_imp_pck.gerencia_tabela_aux_val_limit( 'I', 'P', nr_id_transacao_p, dados_tabela_aux_w, nm_usuario_p);
				end loop;
				close cursor_w;
			exception
			when others then
				if (cursor_w%isopen) then
					-- Fechar os cursores que continuam abertos, os cursores que utilizam FOR - LOOP não necessitam serem fechados, serão fechados automaticamente.
					close cursor_w;
				end if;

				-- Insere o log na tabela e aborta a operação
				CALL pls_ocor_imp_pck.trata_erro_sql_dinamico(	nr_seq_combinada_p, null, ds_sql_w,
										nr_id_transacao_p, nm_usuario_p, 'N');
			end;
		end if;
		-- Zerar o totalizador para executar a soma dos procedimentos que foram executados pelo beneficiário.
		i := 0;
		qt_proc_util_total_w := 0;
		ds_itens_util_w := '';
		SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	dados_tb_selecao_w.nr_seq_selecao, dados_tb_selecao_w.ie_valido, dados_tb_selecao_w.ds_observacao) INTO STRICT _ora2pg_r;
 	dados_tb_selecao_w.nr_seq_selecao := _ora2pg_r.tb_nr_seq_selecao_p; dados_tb_selecao_w.ie_valido := _ora2pg_r.tb_ie_valido_p; dados_tb_selecao_w.ds_observacao := _ora2pg_r.tb_ds_observacao_p;

		for r_C03_w in C03(	nr_id_transacao_p, r_C01_w.nr_seq_segurado_conv,
					dados_limitacao_w.nr_seq_tipo_limitacao) loop

			qt_proc_util_total_w := qt_proc_util_total_w + r_C03_w.qt_item;

			ds_itens_util_w	:= substr(ds_itens_util_w || pls_util_pck.enter_w || wheb_mensagem_pck.get_texto(502127/*Conta:*/
) || ' ' || r_C03_w.nr_seq_conta || ' | ' ||
						wheb_mensagem_pck.get_texto(296423/*Procedimento:*/
 ) || ' ' || r_C03_w.nr_seq_conta_proc || ' | ' ||
						wheb_mensagem_pck.get_texto(614525/*Quantidade:*/
) || ' ' || r_C03_w.qt_item, 1, 4000);

			-- Irá gerar a ocorrência apenas quando a quantidade utilizada ultrapassar a permitida e quando o procedimento estiver na tabela de
			-- seleção.
			if (qt_proc_util_total_w > dados_limitacao_w.qt_permitida) and (r_C03_w.ie_selecao = 'S') then

				dados_tb_selecao_w.nr_seq_selecao(i)	:= r_C03_w.nr_seq_selecao;
				dados_tb_selecao_w.ie_valido(i)		:= 'S';
				dados_tb_selecao_w.ds_observacao(i)	:= substr(	wheb_mensagem_pck.get_texto(791838) || ' ' || pls_util_pck.enter_w ||
											wheb_mensagem_pck.get_texto(791839) || ' ' || dados_limitacao_w.qt_permitida || ' ' ||
											wheb_mensagem_pck.get_texto(791840) || ' ' || dados_limitacao_w.qt_meses_intervalo || ' ' ||
											obter_valor_dominio(4171, dados_limitacao_w.ie_tipo_periodo) || pls_util_pck.enter_w || pls_util_pck.enter_w ||
											wheb_mensagem_pck.get_texto(791841) || ' ' || pls_util_pck.enter_w ||
											ds_itens_util_w, 1, 4000);

				/*
				791838 - A diária ultrapassa a quantidade permitida pelas limitações contratuais do beneficiário.
				791839 - Este beneficiário possui liberação para estar apenas
				791840 - dia(s) internado neste mesmo contexto em um período de
				791841 - Diárias utilizadas no período:
				*/
				-- Gravar na tabela de seleção as contas selecionadas
				if (dados_tb_selecao_w.nr_seq_selecao.count >= pls_util_cta_pck.qt_registro_transacao_w) then

					CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao,
											dados_tb_selecao_w.ie_valido,
											dados_tb_selecao_w.ds_observacao,
											nr_id_transacao_p,
											'SEQ');

					SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	dados_tb_selecao_w.nr_seq_selecao, dados_tb_selecao_w.ie_valido, dados_tb_selecao_w.ds_observacao) INTO STRICT _ora2pg_r;
 	dados_tb_selecao_w.nr_seq_selecao := _ora2pg_r.tb_nr_seq_selecao_p; dados_tb_selecao_w.ie_valido := _ora2pg_r.tb_ie_valido_p; dados_tb_selecao_w.ds_observacao := _ora2pg_r.tb_ds_observacao_p;
					i := 0;
				else
					i := i + 1;
				end if;
			end if;
		end loop;

		if (dados_tb_selecao_w.nr_seq_selecao.count >= 0) then

			CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao,
									dados_tb_selecao_w.ie_valido,
									dados_tb_selecao_w.ds_observacao,
									nr_id_transacao_p,
									'SEQ');

			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	dados_tb_selecao_w.nr_seq_selecao, dados_tb_selecao_w.ie_valido, dados_tb_selecao_w.ds_observacao) INTO STRICT _ora2pg_r;
 	dados_tb_selecao_w.nr_seq_selecao := _ora2pg_r.tb_nr_seq_selecao_p; dados_tb_selecao_w.ie_valido := _ora2pg_r.tb_ie_valido_p; dados_tb_selecao_w.ds_observacao := _ora2pg_r.tb_ds_observacao_p;
		end if;

		pls_ocor_imp_pck.gerencia_tabela_aux_val_limit( 'T', 'P', nr_id_transacao_p, dados_tabela_aux_w, nm_usuario_p);
	end loop;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_val_27_dia_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
