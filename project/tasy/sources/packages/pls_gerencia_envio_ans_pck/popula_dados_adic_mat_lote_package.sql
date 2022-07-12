-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.popula_dados_adic_mat_lote ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


qt_registro_w			integer;
dados_mat_update_w		pls_gerencia_envio_ans_pck.dados_monitor_mat_update;
vl_glosa_w			pls_conta_mat.vl_glosa%type;
qt_pago_w			pls_conta_mat.qt_material%type;
vl_coparticipacao_w		pls_conta_coparticipacao.vl_coparticipacao%type;
cd_tabela_ref_w			pls_monitor_tiss_mat_val.cd_tabela_ref%type;
nr_seq_regra_tab_ref_w		pls_regra_tabela_tiss.nr_sequencia%type;
ie_origem_tab_ref_w		pls_monitor_tiss_mat_val.ie_origem_tab_ref%type;
cd_grupo_proc_w			pls_monitor_tiss_proc_val.cd_grupo_proc%type;
nr_seq_regra_gpo_proc_w		pls_monitor_tiss_reg_gpo.nr_sequencia%type;
ie_origem_grupo_proc_w		pls_monitor_tiss_proc_val.ie_origem_grupo_proc%type;

-- insere todos os dados adicionais dos materiais que foram selecionados

C01 CURSOR(	nr_seq_lote_pc		pls_monitor_tiss_lote.nr_sequencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT 	c.nr_sequencia,
		pls_gerencia_envio_ans_pck.obter_cod_material_tuss(a.nr_seq_material, ( SELECT max(x.NR_SEQ_TUSS_MAT_ITEM)
											from pls_material x
											where x.nr_sequencia = a.nr_seq_material), a.dt_atendimento_referencia) cd_material,
		a.nr_seq_material,
		CASE WHEN coalesce(f.dt_pagamento_recurso::text, '') = '' THEN CASE WHEN coalesce(f.dt_pagamento_previsto::text, '') = '' THEN 0  ELSE CASE WHEN a.qt_material=0 THEN 1  ELSE a.qt_material END  END   ELSE CASE WHEN a.qt_material=0 THEN 1  ELSE a.qt_material END  END  qt_pago,
		CASE WHEN coalesce(a.vl_provisao,0)=0 THEN  CASE WHEN coalesce(a.vl_material_imp,0)=0 THEN a.vl_material  ELSE a.vl_material_imp END   ELSE a.vl_provisao END 	vl_apresentado,
		CASE WHEN coalesce(a.qt_material_imp, 0)=0 THEN  a.qt_material  ELSE a.qt_material_imp END  qt_apresentado,
		CASE WHEN coalesce(f.dt_pagamento_recurso::text, '') = '' THEN CASE WHEN coalesce(f.dt_pagamento_previsto::text, '') = '' THEN 0  ELSE a.vl_liberado END   ELSE a.vl_liberado END  vl_pago,
		a.vl_glosa,
		a.ie_tipo_despesa,
		CASE WHEN coalesce(f.dt_pagamento_recurso::text, '') = '' THEN  CASE WHEN coalesce(f.dt_pagamento_previsto::text, '') = '' THEN  null  ELSE a.nr_seq_prest_fornec END   ELSE a.nr_seq_prest_fornec END  nr_seq_prest_fornec,
		CASE WHEN coalesce(f.dt_pagamento_recurso::text, '') = '' THEN  CASE WHEN coalesce(f.dt_pagamento_previsto::text, '') = '' THEN  null  ELSE pls_obter_dados_prestador(a.nr_seq_prest_fornec, 'CGC') END   ELSE pls_obter_dados_prestador(a.nr_seq_prest_fornec, 'CGC') END  cd_cgc_fornecedor,
		pls_monitor_obter_cd_mat_tuss(a.nr_seq_material) cd_material_tuss,
		f.dt_pagamento_previsto,
		a.nr_seq_conta,
		a.nr_sequencia nr_seq_conta_mat,
		pls_gerencia_envio_ans_pck.obter_valor_coparticipacao(a.nr_seq_conta, f.ie_tipo_guia, f.ie_tipo_atendimento, null, a.nr_sequencia, 'N', f.nr_seq_conta_rec) vl_coparticipacao,
		a.cd_unidade_medida
	from 	pls_monitor_tiss_cta_val f,
		pls_monitor_tiss_mat_val c,
		pls_conta_mat 		a
	where	f.nr_seq_lote_monitor = nr_seq_lote_pc
	and f.nr_sequencia in ( select y.nr_sequencia
                            from pls_monitor_tiss_cta_val y,
                                 pls_monitor_tiss_alt x
                            where x.ie_tipo_evento not in ('AV', 'AD','FR')
                                and x.ie_status in ('P', 'N')
                                 and x.dt_evento between dt_mes_competencia_ini_w and dt_mes_competencia_fim_w
                                and  y.nr_seq_lote_monitor = nr_seq_lote_pc
                                and y.nr_seq_conta = x.nr_seq_conta)
	and	f.ie_conta_atualizada = 'S'
	and	c.nr_seq_cta_val = f.nr_sequencia
	and	a.nr_sequencia = c.nr_seq_conta_mat
	and	a.ie_status in ('A', 'C', 'L', 'M', 'P', 'S', 'U');
BEGIN

qt_registro_w := 0;

---Obtem as informaes dos procedimentos da conta e insere na tabela para ajuste das informaes

for	r_C01_w in C01( nr_seq_lote_p, cd_estabelecimento_p) loop

	vl_glosa_w		:= r_C01_w.vl_glosa;
	qt_pago_w		:= r_C01_w.qt_pago;
	vl_coparticipacao_w	:= 0;

	if (coalesce(vl_glosa_w,0) > coalesce(r_C01_w.vl_apresentado, 0)) then
		vl_glosa_w	:= r_C01_w.vl_apresentado;
	end if;

	if (vl_glosa_w < 0) then
		vl_glosa_w := 0;
	end if;

	if (coalesce(r_C01_w.vl_pago,0) = 0) and (qt_pago_w	> 0) then
		qt_pago_w	:= 0;
	end if;

	SELECT * FROM pls_gerencia_envio_ans_pck.obter_tipo_tabela_tiss(	null, null, null, r_C01_w.ie_tipo_despesa, r_C01_w.nr_seq_material, cd_estabelecimento_p, cd_tabela_ref_w, nr_seq_regra_tab_ref_w, ie_origem_tab_ref_w) INTO STRICT cd_tabela_ref_w, nr_seq_regra_tab_ref_w, ie_origem_tab_ref_w;

	SELECT * FROM pls_gerencia_envio_ans_pck.obter_grupo_proc_ans(	null, null, '', r_C01_w.nr_seq_material, r_C01_w.ie_tipo_despesa, cd_estabelecimento_p, 'N', cd_grupo_proc_w, nr_seq_regra_gpo_proc_w, ie_origem_grupo_proc_w) INTO STRICT cd_grupo_proc_w, nr_seq_regra_gpo_proc_w, ie_origem_grupo_proc_w;

	--Armazena o valor que cada um dos campos da PLS_MONITOR_TISS_MAT_VAL receber

	dados_mat_update_w.nr_sequencia(qt_registro_w)		:= r_C01_w.nr_sequencia;
	dados_mat_update_w.cd_grupo_proc(qt_registro_w)		:= cd_grupo_proc_w;
	dados_mat_update_w.cd_material(qt_registro_w)		:= r_C01_w.cd_material;
	dados_mat_update_w.nr_seq_material(qt_registro_w)	:= r_C01_w.nr_seq_material;
	dados_mat_update_w.qt_liberado(qt_registro_w)		:= qt_pago_w;
	dados_mat_update_w.vl_material(qt_registro_w)		:= coalesce(r_C01_w.vl_apresentado, 0);
	dados_mat_update_w.qt_material(qt_registro_w)		:= coalesce(r_C01_w.qt_apresentado,1);
	dados_mat_update_w.vl_liberado(qt_registro_w)		:= r_C01_w.vl_pago;
	dados_mat_update_w.vl_glosa(qt_registro_w)		:= vl_glosa_w;
	dados_mat_update_w.cd_tabela_ref(qt_registro_w)		:= cd_tabela_ref_w;
	dados_mat_update_w.ie_tipo_despesa(qt_registro_w)	:= r_C01_w.ie_tipo_despesa;
	dados_mat_update_w.nr_seq_prest_fornec(qt_registro_w)	:= r_C01_w.nr_seq_prest_fornec;
	dados_mat_update_w.cd_cgc_fornecedor(qt_registro_w)	:= r_C01_w.cd_cgc_fornecedor;
	dados_mat_update_w.cd_material_tuss(qt_registro_w)	:= r_C01_w.cd_material_tuss;
	dados_mat_update_w.vl_coparticipacao(qt_registro_w)	:= r_C01_w.vl_coparticipacao;
	dados_mat_update_w.nr_seq_regra_tab_ref(qt_registro_w)	:= nr_seq_regra_tab_ref_w;
	dados_mat_update_w.ie_origem_tab_ref(qt_registro_w)	:= ie_origem_tab_ref_w;
	dados_mat_update_w.nr_seq_regra_gpo_proc(qt_registro_w)	:= nr_seq_regra_gpo_proc_w;
	dados_mat_update_w.ie_origem_grupo_proc(qt_registro_w)	:= ie_origem_grupo_proc_w;
	dados_mat_update_w.cd_unidade_medida(qt_registro_w)	:= r_C01_w.cd_unidade_medida;

	-- material nunca tem pacote. Se ele tiver pacote informado significa que foi configurado para abrir pacote nas contas mdicas

	-- se foi configurado para abrir, tudo  enviado como se fossem itens normais

	dados_mat_update_w.nr_seq_pacote(qt_registro_w)		:= null;
	dados_mat_update_w.ie_item_atualizado(qt_registro_w)	:= 'S';

	if (qt_registro_w >= current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer) then
		-- manda os dados para o banco

		CALL pls_gerencia_envio_ans_pck.atualizar_monitor_tiss_mat( dados_mat_update_w, nm_usuario_p );

		-- Limpa as variveis do type DADOS_MONITOR_MAT_UPDATE

		dados_mat_update_w := pls_gerencia_envio_ans_pck.limpar_type_dados_mat_update(dados_mat_update_w);

		qt_registro_w := 0;
	else
		qt_registro_w := qt_registro_w + 1;
	end if;
end loop;

--Atualiza os dados da PLS_MONITOR_TISS_PROC_VAL que restaram nas variveis do type DADOS_MONITOR_PROC_UPDATE

CALL pls_gerencia_envio_ans_pck.atualizar_monitor_tiss_mat( dados_mat_update_w, nm_usuario_p);

--Limpa as variveis do type DADOS_MONITOR_PROC_UPDATE

dados_mat_update_w := pls_gerencia_envio_ans_pck.limpar_type_dados_mat_update(dados_mat_update_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.popula_dados_adic_mat_lote ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
