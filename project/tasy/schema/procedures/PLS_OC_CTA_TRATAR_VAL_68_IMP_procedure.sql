-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_68_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE


_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de item dentro do período de vigência.
*/
qt_cnt_w		integer;
nr_index_sel_w		integer;
ds_obs_w		pls_oc_cta_selecao_imp.ds_observacao%type;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;

-- Informações da validação de período de internação com relação ao item
C02 CURSOR(	nr_seq_oc_cta_comb_p	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_validar_proc_mat
	from	pls_oc_cta_val_vig_item a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

C03 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type,
		ie_valido_pc		text,
		ds_obs_pc		pls_oc_cta_selecao_imp.ds_observacao%type) FOR
	SELECT	sel.nr_sequencia,
		'P' ie_tipo_item,
		ie_valido_pc,
		ds_obs_pc,
		c_proc.dt_execucao_conv		dt_item,
		c_proc.cd_procedimento_conv	cd_procedimento,
		proc.ie_origem_proced		ie_origem_proced,
		null				nr_seq_material,
		null				dt_inclusao,
		null				dt_exclusao,
		proc.ie_situacao		ie_situacao
	from	pls_oc_cta_selecao_imp 	sel,
		pls_conta_proc_imp		c_proc,
		procedimento			proc
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and	sel.ie_valido = 'S'
	and	sel.ie_tipo_registro = 'P'
	and	c_proc.nr_sequencia  = sel.nr_seq_conta_proc
	and	c_proc.cd_procedimento_conv 	= proc.cd_procedimento
	and	c_proc.ie_origem_proced_conv	= proc.ie_origem_proced
	
union all

	SELECT	sel.nr_sequencia,
		'M' ie_tipo_item,
		ie_valido_pc,
		ds_obs_pc,
		c_mat.dt_execucao_conv 		dt_item,
		null				cd_procedimento,
		null				ie_origem_proced,
		c_mat.nr_seq_material_conv	nr_seq_material,
		trunc(mat.dt_inclusao)		dt_inclusao,
		trunc(mat.dt_exclusao)		dt_exclusao,
		mat.ie_situacao			ie_situacao
	from	pls_oc_cta_selecao_imp sel,
		pls_conta_mat_imp c_mat,
		pls_material	mat
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and	sel.ie_tipo_registro = 'M'
	and	sel.ie_valido = 'S'
	and	c_mat.nr_sequencia	= sel.nr_seq_conta_mat
	and	c_mat.nr_seq_material_conv = mat.nr_sequencia;
BEGIN

-- Deve existir informação da regra para aplicar a validação
if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') then

	for	r_C02_w in C02(nr_seq_combinada_p) loop

		-- Obter o controle padrão para quantidade de registros que será enviada a cada vez para a tabela de seleção.
		qt_cnt_w := pls_util_pck.qt_registro_transacao_w;

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', ie_regra_excecao_p, nr_id_transacao_p, null);

		-- Incializar as listas para cada regra.
		SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

		nr_index_sel_w := 0;
		for	r_C03_w in C03(nr_id_transacao_p, 'S', ds_obs_w) loop

			--Utilizar datas da conta selecionada
			if (r_C02_w.ie_validar_proc_mat = 'S') then

				if (r_C03_w.ie_tipo_item = 'P') then
					ds_obs_w := null;
					if (r_C03_w.ie_situacao = 'I') then
						ds_obs_w	:= 'Procedimento inativo';
					end if;

					if (pls_obter_se_proc_ativo_vig(r_C03_w.cd_procedimento, r_C03_w.ie_origem_proced, r_C03_w.dt_item) = 'N') then
						ds_obs_w := 'Procedimento fora do período de vigência';
					end if;

					--Inicio do proc/mat maior que data de inicio de internação
					--e data fim do procedimento antes da data da alta da internação(ou caso ainda não tenha a data da alta)
					if (ds_obs_w IS NOT NULL AND ds_obs_w::text <> '') then

						tb_seq_selecao_w(nr_index_sel_w) := r_C03_w.nr_sequencia;
						tb_observacao_w(nr_index_sel_w) :=	ds_obs_w;
						tb_valido_w(nr_index_sel_w) :=	'S';
						nr_index_sel_w := nr_index_sel_w + 1;
					end if;
				else

					if	((( r_C03_w.dt_item < r_C03_w.dt_exclusao) or (coalesce(r_C03_w.dt_exclusao::text, '') = '')) and
						    r_C03_w.dt_item >= r_C03_w.dt_inclusao	)then
						ds_obs_w := null;
					else
						ds_obs_w := 'Material fora do período de vigência ';
					end if;

					if (r_C03_w.ie_situacao = 'I') then
						ds_obs_w := 'Material inativo ';
					end if;

					if (r_C03_w.dt_item >= r_C03_w.dt_exclusao) then
						ds_obs_w := 'Material excluído no dia '||to_char(r_C03_w.dt_exclusao,'dd/mm/yyyy');
					end if;

					if (ds_obs_w IS NOT NULL AND ds_obs_w::text <> '') then

						tb_seq_selecao_w(nr_index_sel_w) := r_C03_w.nr_sequencia;
						tb_observacao_w(nr_index_sel_w) :=	ds_obs_w;
						tb_valido_w(nr_index_sel_w) :=	'S';
						nr_index_sel_w := nr_index_sel_w + 1;
					end if;
				end if;
			end if;

			if ( nr_index_sel_w = pls_cta_consistir_pck.qt_registro_transacao_w ) then
				CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w,
													nr_id_transacao_p,'SEQ');

				-- Incializar as listas para cada regra.
				SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
				nr_index_sel_w		:= 0;
			end if;

		end loop; --C03
	end loop; -- C02
	/* Verificar se não chegou ao limite definido para gravar a transacao
	Daí gravar o conteudo existente na transacao */
	if (tb_seq_selecao_w.count > 0) then
		CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w, nr_id_transacao_p,'SEQ');
	end if;

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N', ie_regra_excecao_p, null, nr_id_transacao_p, null);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_68_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;
