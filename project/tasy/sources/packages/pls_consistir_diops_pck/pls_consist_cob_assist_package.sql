-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consistir_diops_pck.pls_consist_cob_assist ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

	
	c_itens_grupo_ans CURSOR FOR
		SELECT	a.nr_seq_conta,
			a.nr_seq_conta_proc nr_seq_item
		from	w_diops_fin_cob_assist	a,
			pls_conta_proc		b,
			pls_conta		c,
			pls_protocolo_conta	d
		where	d.nr_sequencia		= c.nr_seq_protocolo
		and	c.nr_sequencia		= b.nr_seq_conta
		and	b.nr_sequencia		= a.nr_seq_conta_proc
		and	a.nr_seq_periodo	= nr_seq_periodo_p
		and	coalesce(b.nr_seq_grupo_ans::text, '') = ''
		and	(a.nr_seq_conta IS NOT NULL AND a.nr_seq_conta::text <> '')
		and	d.dt_mes_competencia between dt_periodo_inicial_w and dt_periodo_final_w
		
union all

		SELECT	a.nr_seq_conta,
			a.nr_seq_conta_mat nr_seq_item
		from	w_diops_fin_cob_assist	a,
			pls_conta_mat		b,
			pls_conta		c,
			pls_protocolo_conta	d
		where	d.nr_sequencia		= c.nr_seq_protocolo
		and	c.nr_sequencia		= b.nr_seq_conta
		and	b.nr_sequencia		= a.nr_seq_conta_mat
		and	a.nr_seq_periodo	= nr_seq_periodo_p
		and	coalesce(b.nr_seq_grupo_ans::text, '') = ''
		and	(a.nr_seq_conta IS NOT NULL AND a.nr_seq_conta::text <> '')
		and	d.dt_mes_competencia between dt_periodo_inicial_w and dt_periodo_final_w;
		
	c_itens_grupo_ans_w	c_itens_grupo_ans%rowtype;
	
	c_itens_dif CURSOR FOR
		SELECT	x.ds_tipo_quadro
		from	(SELECT	nr_sequencia,
				ie_tipo_quadro,
				substr(obter_valor_dominio(5832,ie_tipo_quadro),1,255) ds_tipo_quadro,
				((coalesce(vl_consulta_rp,0) + coalesce(vl_consulta_rc,0) + coalesce(vl_consulta_re,0) + coalesce(vl_consulta_ie,0)) +
				(coalesce(vl_exame_rp,0) + coalesce(vl_exame_rc,0) + coalesce(vl_exame_re,0) + coalesce(vl_exame_ie,0)) +
				(coalesce(vl_terapia_rp,0) + coalesce(vl_terapia_rc,0) + coalesce(vl_terapia_re,0) + coalesce(vl_terapia_ie,0)) +
				(coalesce(vl_intern_rp,0) + coalesce(vl_intern_rc,0) + coalesce(vl_intern_re,0) + coalesce(vl_intern_ie,0)) +
				(coalesce(vl_atendimento_rp,0) + coalesce(vl_atendimento_rc,0) + coalesce(vl_atendimento_re,0) + coalesce(vl_atendimento_ie,0)) +
				(coalesce(vl_despesas_rp,0) + coalesce(vl_despesas_rc,0) + coalesce(vl_despesas_re,0) + coalesce(vl_despesas_ie,0)) +
				(coalesce(vl_odonto_rp,0) + coalesce(vl_odonto_re,0) + coalesce(vl_odonto_rc,0) + coalesce(vl_odonto_ie,0))) vl_total,
				diops_obter_valor_balancete(nr_seq_periodo,ds_conta_contabil,'D') vl_balancete
			from	diops_fin_cob_assist
			where	nr_seq_periodo	= nr_seq_periodo_p
			and	ie_tipo	= 'H'
			order by (ie_tipo_quadro)::numeric ) x
		where	vl_total <> vl_balancete;
	
	c_itens_dif_w	c_itens_dif%rowtype;
	
	
BEGIN
	
	delete	
	from 	diops_periodo_inconsist a
	where	a.nr_seq_periodo	= nr_seq_periodo_p
	and	a.nr_seq_inconsistencia	in (63,64);
	
	commit;
	
	PERFORM set_config('pls_consistir_diops_pck.nr_quadro_w', 31, false);
	
	open c_itens_grupo_ans;
	loop
	fetch c_itens_grupo_ans into
		c_itens_grupo_ans_w;
	EXIT WHEN NOT FOUND; /* apply on c_itens_grupo_ans */
		begin
		PERFORM set_config('pls_consistir_diops_pck.nr_conta_medica_macro_w', c_itens_grupo_ans_w.nr_seq_conta, false);
		PERFORM set_config('pls_consistir_diops_pck.nr_item_proc_mat_macro_w', c_itens_grupo_ans_w.nr_seq_item, false);

		CALL pls_consistir_diops_pck.pls_gravar_consistencia(nr_seq_periodo_p, cd_estabelecimento_p, 63);
		end;
	end loop;
	close c_itens_grupo_ans;	
	
	open c_itens_dif;
	loop
	fetch c_itens_dif into
		c_itens_dif_w;
	EXIT WHEN NOT FOUND; /* apply on c_itens_dif */
		begin
		PERFORM set_config('pls_consistir_diops_pck.ds_tipo_item_macro_w', c_itens_dif_w.ds_tipo_quadro, false);
		CALL pls_consistir_diops_pck.pls_gravar_consistencia(nr_seq_periodo_p, cd_estabelecimento_p, 64);
		end;
	end loop;
	close c_itens_dif;
	
	PERFORM set_config('pls_consistir_diops_pck.nr_quadro_w', 0, false);
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_diops_pck.pls_consist_cob_assist ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;