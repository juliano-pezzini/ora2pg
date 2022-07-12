-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE diops_fin_gerar_assist_pck.diops_fin_gravar_assistencial ( ie_etapa_p text, ie_tipo_p text, ie_tipo_quadro_p text, ie_ato_p text, ie_tipo_dado_p text, ds_grupo_diops_p text, vl_item_p bigint, nr_seq_periodo_p bigint, nm_usuario_p text, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_conta_copartic_p bigint, nr_tipo_pre_pagamento_p bigint, ds_conta_contabil_p INOUT text, ie_cobertura_p INOUT text, ds_plano_p INOUT text) AS $body$
DECLARE


	/*
	ie_tipo_p: 		H - Hospitalar	O - Odontologico
	ie_etapa_p:		C - Cabecalho	R - Registros
	ie_tipo_dado_p:	RP	RC	RE	IE	OP
	*/


	ie_tipo_conta_w		varchar(1);

	vl_consulta_rp_w	double precision	:= null;
	vl_consulta_rc_w	double precision	:= null;
	vl_consulta_re_w	double precision	:= null;
	vl_consulta_ie_w	double precision	:= null;
	vl_consulta_corresp_w	double precision	:= null;
	vl_exame_rp_w		double precision	:= null;
	vl_exame_rc_w		double precision	:= null;
	vl_exame_re_w		double precision	:= null;
	vl_exame_ie_w		double precision	:= null;
	vl_exame_corresp_w	double precision	:= null;
	vl_terapia_rp_w		double precision	:= null;
	vl_terapia_rc_w		double precision	:= null;
	vl_terapia_re_w		double precision	:= null;
	vl_terapia_ie_w		double precision	:= null;
	vl_terapia_corresp_w	double precision	:= null;
	vl_intern_rp_w		double precision	:= null;
	vl_intern_rc_w		double precision	:= null;
	vl_intern_re_w		double precision	:= null;
	vl_intern_ie_w		double precision	:= null;
	vl_intern_corresp_w	double precision	:= null;
	vl_atendimento_rp_w	double precision	:= null;
	vl_atendimento_rc_w	double precision	:= null;
	vl_atendimento_re_w	double precision	:= null;
	vl_atendimento_ie_w	double precision	:= null;
	vl_atendimento_corresp_w 	double precision	:= null;
	vl_despesas_rp_w	double precision	:= null;
	vl_despesas_rc_w	double precision	:= null;
	vl_despesas_re_w	double precision	:= null;
	vl_despesas_ie_w	double precision	:= null;
	vl_despesas_corresp_w	double precision	:= null;
	vl_consulta_op_w	double precision	:= null;
	vl_exame_op_w		double precision	:= null;
	vl_terapia_op_w		double precision	:= null;
	vl_intern_op_w		double precision	:= null;
	vl_atendimento_op_w	double precision	:= null;
	vl_despesas_op_w	double precision	:= null;
	vl_odonto_rp_w		double precision	:= 0;
	vl_odonto_rc_w		double precision	:= 0;
	vl_odonto_re_w		double precision	:= 0;
	vl_odonto_ie_w		double precision	:= 0;

	
BEGIN

	if (ie_etapa_p = 'C') then

		if (ie_tipo_p = 'H') then
			ie_tipo_conta_w		:= '1';

			vl_consulta_rp_w	:= 0;
			vl_consulta_rc_w	:= 0;
			vl_consulta_re_w	:= 0;
			vl_consulta_ie_w	:= 0;
			vl_consulta_corresp_w	:= 0;
			vl_exame_rp_w		:= 0;
			vl_exame_rc_w		:= 0;
			vl_exame_re_w		:= 0;
			vl_exame_ie_w		:= 0;
			vl_exame_corresp_w	:= 0;
			vl_terapia_rp_w		:= 0;
			vl_terapia_rc_w		:= 0;
			vl_terapia_re_w		:= 0;
			vl_terapia_ie_w		:= 0;
			vl_terapia_corresp_w	:= 0;
			vl_intern_rp_w		:= 0;
			vl_intern_rc_w		:= 0;
			vl_intern_re_w		:= 0;
			vl_intern_ie_w		:= 0;
			vl_intern_corresp_w	:= 0;
			vl_atendimento_rp_w	:= 0;
			vl_atendimento_rc_w	:= 0;
			vl_atendimento_re_w	:= 0;
			vl_atendimento_ie_w	:= 0;
			vl_atendimento_corresp_w	:= 0;
			vl_despesas_rp_w	:= 0;
			vl_despesas_rc_w	:= 0;
			vl_despesas_re_w	:= 0;
			vl_despesas_ie_w	:= 0;
			vl_despesas_corresp_w	:= 0;
			vl_consulta_op_w	:= 0;
			vl_exame_op_w		:= 0;
			vl_terapia_op_w		:= 0;
			vl_intern_op_w		:= 0;
			vl_atendimento_op_w	:= 0;
			vl_despesas_op_w	:= 0;

		elsif (ie_tipo_p = 'O') then
			ie_tipo_conta_w		:= '2';
		end if;

		if (ie_tipo_quadro_p = '1') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '1' || ie_ato_p || '1';
			ie_cobertura_p		:= '1';
			ds_plano_p		:= 'IFAL';
		elsif (ie_tipo_quadro_p = '2') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '1' || ie_ato_p || '2';
			ie_cobertura_p		:= '1';
			ds_plano_p		:= 'IFPL';
		elsif (ie_tipo_quadro_p = '3') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '1' || ie_ato_p || '3';
			ie_cobertura_p		:= '1';
			ds_plano_p		:= 'PLAL';
		elsif (ie_tipo_quadro_p = '4') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '1' || ie_ato_p || '4';
			ie_cobertura_p		:= '1';
			ds_plano_p		:= 'PLAP';
		elsif (ie_tipo_quadro_p = '5') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '1' || ie_ato_p || '5';
			ie_cobertura_p		:= '1';
			ds_plano_p		:= 'PCEA';
		elsif (ie_tipo_quadro_p = '6') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '1' || ie_ato_p || '6';
			ie_cobertura_p		:= '1';
			ds_plano_p		:= 'PCEL';
		elsif (ie_tipo_quadro_p = '7') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '2' || ie_ato_p || '1';
			ie_cobertura_p		:= '2';
			ds_plano_p		:= 'IFAL';
		elsif (ie_tipo_quadro_p = '8') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '2' || ie_ato_p || '2';
			ie_cobertura_p		:= '2';
			ds_plano_p		:= 'IFPL';
		elsif (ie_tipo_quadro_p = '9') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '2' || ie_ato_p || '3';
			ie_cobertura_p		:= '2';
			ds_plano_p		:= 'PLAL';
		elsif (ie_tipo_quadro_p = '10') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '2' || ie_ato_p || '4';
			ie_cobertura_p		:= '2';
			ds_plano_p		:= 'PLAP';
		elsif (ie_tipo_quadro_p = '11') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '2' || ie_ato_p || '5';
			ie_cobertura_p		:= '2';
			ds_plano_p		:= 'PCEA';
		elsif (ie_tipo_quadro_p = '12') then
			ds_conta_contabil_p	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '2' || ie_ato_p || '6';
			ie_cobertura_p		:= '2';
			ds_plano_p		:= 'PCEL';
		elsif (ie_tipo_quadro_p = '13') then
			ds_conta_contabil_p 	:= '411' || nr_tipo_pre_pagamento_p || ie_tipo_conta_w || '1' || ie_ato_p || '8';
			ie_cobertura_p		:= '1';
			ds_plano_p		:= 'CRAS';
		end if;
		insert into w_diops_fin_cob_assist(nr_sequencia, nr_seq_periodo, ds_conta_contabil, ie_tipo_quadro,
			nm_usuario, nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec,
			ds_plano, ie_cobertura, ie_tipo,
			vl_consulta_rp, vl_consulta_rc, vl_consulta_re, vl_consulta_ie, vl_consulta_op, vl_consulta_corresp,
			vl_exame_rp, vl_exame_rc, vl_exame_re, vl_exame_ie, vl_exame_op, vl_exame_corresp,
			vl_terapia_rp, vl_terapia_rc, vl_terapia_re, vl_terapia_ie, vl_terapia_op, vl_terapia_corresp,
			vl_intern_rp, vl_intern_rc, vl_intern_re, vl_intern_ie, vl_intern_op, vl_intern_corresp,
			vl_atendimento_rp, vl_atendimento_rc, vl_atendimento_re, vl_atendimento_ie, vl_atendimento_op, vl_atendimento_corresp,
			vl_despesas_rp, vl_despesas_rc, vl_despesas_re, vl_despesas_ie, vl_despesas_op, vl_despesas_corresp,
			nr_seq_conta_proc, nr_seq_conta_mat, nr_seq_conta,
			vl_odonto_rp, vl_odonto_rc, vl_odonto_re, vl_odonto_ie)
		values (nextval('diops_fin_cob_assist_seq'), nr_seq_periodo_p, ds_conta_contabil_p, ie_tipo_quadro_p,
			nm_usuario_p, nm_usuario_p, clock_timestamp(), clock_timestamp(),
			ds_plano_p, ie_cobertura_p, ie_tipo_p,
			vl_consulta_rp_w, vl_consulta_rc_w, vl_consulta_re_w, vl_consulta_ie_w, vl_consulta_op_w, vl_consulta_corresp_w,
			vl_exame_rp_w, vl_exame_rc_w, vl_exame_re_w, vl_exame_ie_w, vl_exame_op_w, vl_exame_corresp_w,
			vl_terapia_rp_w, vl_terapia_rc_w, vl_terapia_re_w, vl_terapia_ie_w, vl_terapia_op_w, vl_terapia_corresp_w,
			vl_intern_rp_w, vl_intern_rc_w, vl_intern_re_w, vl_intern_ie_w, vl_intern_op_w, vl_intern_corresp_w,
			vl_atendimento_rp_w, vl_atendimento_rc_w, vl_atendimento_re_w, vl_atendimento_ie_w, vl_atendimento_op_w, vl_atendimento_corresp_w,
			vl_despesas_rp_w, vl_despesas_rc_w, vl_despesas_re_w, vl_despesas_ie_w, vl_despesas_op_w, vl_despesas_corresp_w,
			null, null, null,
			vl_odonto_rp_w, vl_odonto_rc_w, vl_odonto_re_w, vl_odonto_ie_w);

	elsif (ie_etapa_p = 'R') then

		if (ie_tipo_p = 'H') then
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_rp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_rc	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_re	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_ie	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_corresp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_rp		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_rc		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_re		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_ie		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_corresp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_rp		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_rc		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_re		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_ie		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_corresp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_rp		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_rc		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_re		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_ie		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_corresp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_rp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_rc	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_re	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_ie	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_corresp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_rp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_rc	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_re	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_ie	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_corresp	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_op	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_op		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_op		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_op		:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_op	:= 0;
			current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_op	:= 0;

			if (ds_grupo_diops_p = 'Consultas') then
				if (ie_tipo_dado_p = 'RP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_rp	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_rc	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_re	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'IE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_ie	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'OP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_op	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'AC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_consulta_corresp	:= vl_item_p;
				end if;
			elsif (ds_grupo_diops_p = 'Exames') then
				if (ie_tipo_dado_p = 'RP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_rp		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_rc		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_re		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'IE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_ie		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'OP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_op		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'AC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_exame_corresp	:= vl_item_p;
				end if;
			elsif (ds_grupo_diops_p = 'Terapias') then
				if (ie_tipo_dado_p = 'RP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_rp		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_rc		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_re		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'IE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_ie		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'OP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_op		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'AC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_terapia_corresp	:= vl_item_p;
				end if;
			elsif (ds_grupo_diops_p = obter_desc_expressao(825075)) then --Internacao
				if (ie_tipo_dado_p = 'RP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_rp		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_rc		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_re		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'IE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_ie		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'OP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_op		:= vl_item_p;
				elsif (ie_tipo_dado_p = 'AC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_intern_corresp	:= vl_item_p;
				end if;
			elsif (ds_grupo_diops_p = 'Outros atendimentos') then
				if (ie_tipo_dado_p = 'RP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_rp	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_rc	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_re	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'IE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_ie	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'OP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_op	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'AC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_atendimento_corresp := vl_item_p;
				end if;
			elsif (ds_grupo_diops_p = 'Demais despesas') then
				if (ie_tipo_dado_p = 'RP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_rp	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_rc	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'RE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_re	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'IE') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_ie	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'OP') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_op	:= vl_item_p;
				elsif (ie_tipo_dado_p = 'AC') then
					current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_despesas_corresp	:= vl_item_p;
				end if;
			end if;

		elsif (ie_tipo_p = 'O') then
			if (ie_tipo_dado_p = 'RP') then
				current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_odonto_rp		:= vl_item_p;
			elsif (ie_tipo_dado_p = 'RC') then
				current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_odonto_rc		:= vl_item_p;
			elsif (ie_tipo_dado_p = 'RE') then
				current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_odonto_re		:= vl_item_p;
			elsif (ie_tipo_dado_p = 'IE') then
				current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.vl_odonto_ie		:= vl_item_p;
			end if;
		end if;

		select	nextval('diops_fin_cob_assist_seq')
		into STRICT	current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.nr_sequencia
		;

		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.nr_seq_periodo	:= nr_seq_periodo_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.ds_conta_contabil	:= ds_conta_contabil_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.ie_tipo_quadro	:= ie_tipo_quadro_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.nm_usuario		:= nm_usuario_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.nm_usuario_nrec	:= nm_usuario_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.dt_atualizacao	:= clock_timestamp();
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.dt_atualizacao_nrec	:= clock_timestamp();
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.ds_plano		:= ds_plano_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.ie_cobertura		:= ie_cobertura_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.ie_tipo		:= ie_tipo_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.nr_seq_conta_proc	:= nr_seq_conta_proc_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.nr_seq_conta_mat	:= nr_seq_conta_mat_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.nr_seq_conta		:= nr_seq_conta_p;
		current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype.nr_seq_conta_copartic	:= nr_seq_conta_copartic_p;

		current_setting('diops_fin_gerar_assist_pck.diops_cob_assist_w')::t_diops_fin_cob_assist(current_setting('diops_fin_gerar_assist_pck.diops_cob_assist_w')::t_diops_fin_cob_assist.count) := current_setting('diops_fin_gerar_assist_pck.item_cob_assist_w')::w_diops_fin_cob_assist%rowtype;

		if (current_setting('diops_fin_gerar_assist_pck.diops_cob_assist_w')::t_diops_fin_cob_assist.count >= 1000) then
			begin
			forall i in current_setting('diops_fin_gerar_assist_pck.diops_cob_assist_w')::t_diops_fin_cob_assist.first .. current_setting('diops_fin_gerar_assist_pck.diops_cob_assist_w')::t_diops_fin_cob_assist.last
				insert into w_diops_fin_cob_assist values current_setting('diops_fin_gerar_assist_pck.diops_cob_assist_w')::t_diops_fin_cob_assist(i);
			commit;
			current_setting('diops_fin_gerar_assist_pck.diops_cob_assist_w')::t_diops_fin_cob_assist.delete;
			end;
		end if;

	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diops_fin_gerar_assist_pck.diops_fin_gravar_assistencial ( ie_etapa_p text, ie_tipo_p text, ie_tipo_quadro_p text, ie_ato_p text, ie_tipo_dado_p text, ds_grupo_diops_p text, vl_item_p bigint, nr_seq_periodo_p bigint, nm_usuario_p text, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_conta_copartic_p bigint, nr_tipo_pre_pagamento_p bigint, ds_conta_contabil_p INOUT text, ie_cobertura_p INOUT text, ds_plano_p INOUT text) FROM PUBLIC;
