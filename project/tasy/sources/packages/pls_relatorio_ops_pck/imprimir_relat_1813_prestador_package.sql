-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_relatorio_ops_pck.imprimir_relat_1813_prestador ( dt_inicio_p text, dt_fim_p text, cd_prestador_p pls_prestador.cd_prestador%type, nr_seq_prestador_p pls_conta.nr_seq_prestador_exec%type) RETURNS SETOF T_RELATORIO_1813_PREST_DATA AS $body$
DECLARE


	t_relatorio_1813_contratos_w	t_relatorio_1813_prestador_row;

	C01 CURSOR(	dt_inicio_pc		text,
			dt_fim_pc		text,
			cd_prestador_pc		pls_prestador.cd_prestador%type,
			nr_seq_prestador_pc	pls_conta.nr_seq_prestador_exec%type ) FOR
		SELECT	a.nr_seq_prestador_exec,
			coalesce(d.cd_prestador,0) cd_prestador,
			coalesce(d.cd_prestador,0) || ' - ' || substr(pls_obter_dados_prestador(a.nr_seq_prestador_exec,'N'),1,255) ds_prestador,
			a.cd_guia_ok cd_guia_referencia,
			c.nr_seq_lote_conta nr_lote_prestador,
			a.dt_atendimento_referencia dt_atendimento,
			c.dt_recebimento dt_apresentacao,
			b.dt_analise,
			a.nr_seq_analise,
			a.nr_seq_segurado,
			a.nr_sequencia nr_seq_conta,
			coalesce(sum(a.vl_total_imp),0) vl_apresentado,
			coalesce(sum(coalesce(((	SELECT 	coalesce(sum(d.vl_liberado),0) vl_liberado
					from   	pls_conta_proc d
					where 	d.nr_seq_conta = a.nr_sequencia)
					+
					(select coalesce(sum(e.vl_liberado),0) vl_liberado
					from   	pls_conta_mat e
					where 	e.nr_seq_conta = a.nr_sequencia)), 0)),0) vl_procedimentos,
			substr(obter_valor_dominio(3783, b.ie_status), 1, 255) ie_status
		from 	pls_conta 		a,
			pls_analise_conta 	b,
			pls_protocolo_conta 	c,
			pls_prestador		d
		where	b.nr_sequencia = a.nr_seq_analise
		and	c.nr_sequencia = a.nr_seq_protocolo
		and	d.nr_sequencia = a.nr_seq_prestador_exec
		and	c.dt_mes_competencia between CASE WHEN dt_inicio_pc='0' THEN  c.dt_mes_competencia  ELSE dt_inicio_pc END  and CASE WHEN dt_fim_pc='0' THEN  c.dt_mes_competencia  ELSE dt_fim_pc END
		and (d.cd_prestador = cd_prestador_pc or cd_prestador_pc = '0')
		and (a.nr_seq_prestador_exec = nr_seq_prestador_pc or nr_seq_prestador_pc = 0)
		and	d.ie_situacao = 'A'
		group 	by a.nr_seq_prestador_exec,
			d.cd_prestador,
			a.cd_guia_ok,
			c.nr_seq_lote_conta,
			a.dt_atendimento_referencia,
			c.dt_recebimento,
			b.dt_analise,
			b.ie_status,
			a.nr_seq_analise,
			a.nr_seq_segurado,
			a.nr_sequencia;

	
BEGIN

	for r_c01_w in C01(dt_inicio_p, dt_fim_p, cd_prestador_p, nr_seq_prestador_p) loop
		if (pls_obter_conta_principal(r_c01_w.cd_guia_referencia, r_c01_w.nr_seq_analise, r_c01_w.nr_seq_segurado, null) = r_c01_w.nr_seq_conta) then

			t_relatorio_1813_contratos_w.cd_prestador		:= r_c01_w.cd_prestador;
			t_relatorio_1813_contratos_w.nr_seq_prestador_exec	:= r_c01_w.nr_seq_prestador_exec;
			t_relatorio_1813_contratos_w.ds_prestador 		:= r_c01_w.ds_prestador;
			t_relatorio_1813_contratos_w.cd_guia_referencia		:= r_c01_w.cd_guia_referencia;
			t_relatorio_1813_contratos_w.nr_lote_prestador		:= r_c01_w.nr_lote_prestador;
			t_relatorio_1813_contratos_w.dt_atendimento		:= r_c01_w.dt_atendimento;
			t_relatorio_1813_contratos_w.dt_apresentacao		:= r_c01_w.dt_apresentacao;
			t_relatorio_1813_contratos_w.dt_analise			:= r_c01_w.dt_analise;
			t_relatorio_1813_contratos_w.vl_apresentado		:= r_c01_w.vl_apresentado;
			t_relatorio_1813_contratos_w.vl_procedimentos		:= r_c01_w.vl_procedimentos;
			t_relatorio_1813_contratos_w.ie_status			:= r_c01_w.ie_status;

			RETURN NEXT t_relatorio_1813_contratos_w;
		end if;
	end loop;

	return;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_relatorio_ops_pck.imprimir_relat_1813_prestador ( dt_inicio_p text, dt_fim_p text, cd_prestador_p pls_prestador.cd_prestador%type, nr_seq_prestador_p pls_conta.nr_seq_prestador_exec%type) FROM PUBLIC;
