-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_50_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
ds_select_w		varchar(6000);
ds_restricao_regra_w	varchar(2000);
ds_campos_regra_w	varchar(4000);
v_cur			pls_util_pck.t_cursor;
dados_tb_selecao_w	pls_ocor_imp_pck.dados_table_selecao_ocor;
qt_cnt_w		integer := pls_util_cta_pck.qt_registro_transacao_w;

C01 CURSOR(	nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia	nr_seq_validacao,
		a.ie_forma_validacao,
		a.ie_forma_validacao_vl_apres
	from	pls_oc_cta_val_liber_mat a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_pc;

BEGIN

if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') then

	--Percorre a lista da seleção, criando select conforme restrições definidas na regra
	for	r_C01_w in C01(nr_seq_combinada_p) loop

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', ie_regra_excecao_p, nr_id_transacao_p, null);

		-- Valor.
		if ( r_C01_w.ie_forma_validacao = 'V' ) then
			--Restrição aplicada na validação do valor, comparando se o valor apresentado pelo prestador é o mesmo liberado na solicitação de mat/med
			-- Igual,
			-- Na verdade gera ocorrência quando é diferente por causa do NOT EXISTS
			if (r_C01_w.ie_forma_validacao_vl_apres = 'IG') then
				ds_restricao_regra_w := 'and	solic.vl_unit_aprovado = mat.vl_total ';
			-- Maior
			elsif (r_C01_w.ie_forma_validacao_vl_apres = 'MA') then
				ds_restricao_regra_w := 'and	solic.vl_unit_aprovado >= mat.vl_total ';
			-- Menor
			elsif (r_C01_w.ie_forma_validacao_vl_apres = 'ME') then
				ds_restricao_regra_w := 'and	solic.vl_unit_aprovado <= mat.vl_total ';
			end if;
		end if;

		-- Verificar a liberação do material especial.
		ds_campos_regra_w :=	'(	select	max(solic.vl_unit_aprovado) vl_aprovado 	' || pls_util_pck.enter_w ||
					'	from	pls_solic_lib_mat_med solic 			' || pls_util_pck.enter_w ||
					'	where	solic.nr_seq_material = mat.nr_seq_material_conv' || pls_util_pck.enter_w ||
					'	and	solic.nr_seq_segurado = cta.nr_seq_segurado_conv' || pls_util_pck.enter_w ||
					'	and	solic.nr_seq_guia = cta.nr_seq_guia_conv	' || pls_util_pck.enter_w ||
					'	and	solic.ie_status = ''3'' ) ';

		-- Montar o select utilizando as restrições informadas na regra.
		ds_select_w :=	'select	sel.nr_sequencia nr_seq_selecao, 											' || pls_util_pck.enter_w ||
				'	''S'' ie_valido, 													' || pls_util_pck.enter_w ||
				'	''Este material necessita de uma autorização especial cedida pela operadora.'' || chr(13) || chr(10) || 		' || pls_util_pck.enter_w ||
				'	''Se a solicitação já está aprovada, verifique se os valores apresentados estão corretos: '' ||  chr(13) || chr(10) ||	' || pls_util_pck.enter_w ||
				'	''Vl autorizado: '' || ' || ds_campos_regra_w || ' || '' | '' || ''Vl apresentado: '' || mat.vl_total	 		' || pls_util_pck.enter_w ||
 				'from	pls_oc_cta_selecao_imp sel, 												' || pls_util_pck.enter_w ||
				'	pls_conta_mat_imp mat,													' || pls_util_pck.enter_w ||
				'	pls_conta_imp cta													' || pls_util_pck.enter_w ||
				'where	sel.nr_id_transacao = :nr_id_transacao 											' || pls_util_pck.enter_w ||
				'and	sel.ie_valido = ''S'' 													' || pls_util_pck.enter_w ||
				'and	sel.ie_tipo_registro = ''M'' 												' || pls_util_pck.enter_w ||
				'and	mat.nr_sequencia = sel.nr_seq_conta_mat 										' || pls_util_pck.enter_w ||
				'and	mat.nr_seq_conta = cta.nr_sequencia											' || pls_util_pck.enter_w ||
				'and	exists	(	select	1 												' || pls_util_pck.enter_w ||
				'			from	pls_material_restricao regra 									' || pls_util_pck.enter_w ||
				'			where	regra.nr_seq_material = mat.nr_seq_material_conv						' || pls_util_pck.enter_w ||
				'			and	regra.ie_autorizacao = ''S'' 									' || pls_util_pck.enter_w ||
				'			and	((regra.dt_inicio_vigencia <= mat.dt_execucao_conv) and						' || pls_util_pck.enter_w ||
				'				(regra.dt_fim_vigencia is null or 								' || pls_util_pck.enter_w ||
				'				regra.dt_fim_vigencia >= mat.dt_execucao_conv)))						' || pls_util_pck.enter_w ||
				'and	not exists (	select	1 												' || pls_util_pck.enter_w ||
				'			from	pls_solic_lib_mat_med solic 									' || pls_util_pck.enter_w ||
				'			where	solic.nr_seq_material = mat.nr_seq_material_conv						' || pls_util_pck.enter_w ||
				'			and	solic.nr_seq_segurado = cta.nr_seq_segurado_conv						' || pls_util_pck.enter_w ||
				'			and	solic.nr_seq_guia = cta.nr_seq_guia_conv							' || pls_util_pck.enter_w ||
				'			and	solic.ie_status = ''3'' ' || ds_restricao_regra_w || ')';

		-- inicializar as tables como sendo vazias.
		SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	dados_tb_selecao_w.nr_seq_selecao, dados_tb_selecao_w.ie_valido, dados_tb_selecao_w.ds_observacao) INTO STRICT _ora2pg_r;
 	dados_tb_selecao_w.nr_seq_selecao := _ora2pg_r.tb_nr_seq_selecao_p; dados_tb_selecao_w.ie_valido := _ora2pg_r.tb_ie_valido_p; dados_tb_selecao_w.ds_observacao := _ora2pg_r.tb_ds_observacao_p;

		begin
			-- Abre o crusor dinâmico
			open v_cur for EXECUTE ds_select_w using nr_id_transacao_p;
			loop
				-- Grava toda a massa nas tables
				fetch v_cur bulk collect into dados_tb_selecao_w.nr_seq_selecao, dados_tb_selecao_w.ie_valido, dados_tb_selecao_w.ds_observacao
				limit qt_cnt_w;

				exit when dados_tb_selecao_w.nr_seq_selecao.count = 0;

				CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	dados_tb_selecao_w.nr_seq_selecao,
										dados_tb_selecao_w.ie_valido,
										dados_tb_selecao_w.ds_observacao,
										nr_id_transacao_p,
										'SEQ');
			end loop;
			-- Fecha cursor dinâmico
			close v_cur;
		exception
		when others then
			--Fecha o cursor
			if (v_cur%ISOPEN) then
				close v_cur;
			end if;

			-- Insere o log na tabela e aborta a operação
			CALL pls_ocor_imp_pck.trata_erro_sql_dinamico(	nr_seq_combinada_p, null, ds_select_w,
									nr_id_transacao_p, nm_usuario_p, 'N');
		end;
	end loop;

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N', ie_regra_excecao_p, null, nr_id_transacao_p, null);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_50_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
