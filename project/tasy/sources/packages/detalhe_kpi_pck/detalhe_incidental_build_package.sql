-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--################################################################################################################################################
CREATE OR REPLACE FUNCTION detalhe_kpi_pck.detalhe_incidental_build () RETURNS SETOF T_DETALHE AS $body$
DECLARE

	
	t_detalhe_row_w	t_detalhe_row;	
	
	c01 CURSOR FOR
	SELECT 	distinct
		m.nr_sequencia,
		m.ds_dano_breve	
	from 	reg_plano_teste_controle a,
		reg_tc_pendencies p,
		reg_tc_evidence_item i,
		reg_tc_so_pendencies o,
		man_ordem_servico m,
		man_doc_erro e,
		grupo_desenvolvimento g,
		gerencia_wheb gw
	where   a.nr_sequencia 		= p.nr_seq_controle_plano
	and 	p.nr_sequencia 		= i.nr_seq_ect
	and 	i.nr_sequencia 		= o.nr_seq_ev_item
	and 	m.nr_sequencia 		= o.nr_seq_service_order
	and 	m.nr_sequencia 		= e.nr_seq_ordem
	and 	e.nr_seq_grupo_des	= g.nr_sequencia
	and	g.nr_seq_gerencia	= gw.nr_sequencia
	and	gw.nr_seq_diretoria	= nr_seq_diretoria_w
	and	coalesce(nr_seq_diretoria_w,0) > 0
	and	m.dt_ordem_servico	between dt_ref_inicio_w and dt_ref_fim_w
	and 	obter_status_tc_ev_item(p.nr_sequencia, 'd') = 'Falhou'
	AND 	a.ie_resultado 		= 'RP'
	and 	exists (SELECT 1
		from  	man_ordem_serv_analise_vv x
		where  	m.nr_sequencia = x.nr_seq_ordem_serv
		and  	x.ie_severidade in (3, 4, 5))
	
union

	select 	distinct
		m.nr_sequencia,
		m.ds_dano_breve	
	from 	reg_plano_teste_controle a,
		reg_tc_pendencies p,
		reg_tc_evidence_item i,
		reg_tc_so_pendencies o,
		man_ordem_servico m,
		man_doc_erro e,
		grupo_desenvolvimento g
	where   a.nr_sequencia 		= p.nr_seq_controle_plano
	and 	p.nr_sequencia 		= i.nr_seq_ect
	and 	i.nr_sequencia 		= o.nr_seq_ev_item
	and 	m.nr_sequencia 		= o.nr_seq_service_order
	and 	m.nr_sequencia 		= e.nr_seq_ordem
	and 	e.nr_seq_grupo_des	= g.nr_sequencia
	and	g.nr_seq_gerencia	= nr_seq_gerencia_w
	and	coalesce(nr_seq_gerencia_w,0) > 0
	and	m.dt_ordem_servico	between dt_ref_inicio_w and dt_ref_fim_w
	and 	obter_status_tc_ev_item(p.nr_sequencia, 'd') = 'Falhou'
	AND 	a.ie_resultado 		= 'RP'
	and 	exists (select 1
		from  	man_ordem_serv_analise_vv x
		where  	m.nr_sequencia = x.nr_seq_ordem_serv
		and  	x.ie_severidade in (3, 4, 5))
	
union

	select 	distinct
		m.nr_sequencia,
		m.ds_dano_breve	
	from 	reg_plano_teste_controle a,
		reg_tc_pendencies p,
		reg_tc_evidence_item i,
		reg_tc_so_pendencies o,
		man_ordem_servico m,
		man_doc_erro e
	where   a.nr_sequencia 		= p.nr_seq_controle_plano
	and 	p.nr_sequencia 		= i.nr_seq_ect
	and 	i.nr_sequencia 		= o.nr_seq_ev_item
	and 	m.nr_sequencia 		= o.nr_seq_service_order
	and 	m.nr_sequencia 		= e.nr_seq_ordem
	and 	e.nr_seq_grupo_des	= nr_seq_grupo_w
	and	coalesce(nr_seq_grupo_w,0) > 0	
	and	m.dt_ordem_servico	between dt_ref_inicio_w and dt_ref_fim_w
	and 	obter_status_tc_ev_item(p.nr_sequencia, 'd') = 'Falhou'
	AND 	a.ie_resultado 		= 'RP'
	and 	exists (select 1
		from  	man_ordem_serv_analise_vv x
		where  	m.nr_sequencia = x.nr_seq_ordem_serv
		and  	x.ie_severidade in (3, 4, 5))
	
union

	select 	distinct
		m.nr_sequencia,
		m.ds_dano_breve	
	from 	reg_plano_teste_controle a,
		reg_tc_pendencies p,
		reg_tc_evidence_item i,
		reg_tc_so_pendencies o,
		man_ordem_servico m,
		man_doc_erro e
	where   a.nr_sequencia 		= p.nr_seq_controle_plano
	and 	p.nr_sequencia 		= i.nr_seq_ect
	and 	i.nr_sequencia 		= o.nr_seq_ev_item
	and 	m.nr_sequencia 		= o.nr_seq_service_order
	and 	m.nr_sequencia 		= e.nr_seq_ordem
	and 	e.cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	coalesce(cd_pessoa_fisica_w,'X') <> 'X'	
	and	m.dt_ordem_servico	between dt_ref_inicio_w and dt_ref_fim_w
	and 	obter_status_tc_ev_item(p.nr_sequencia, 'd') = 'Falhou'
	AND 	a.ie_resultado 		= 'RP'
	and 	exists (select 1
		from  	man_ordem_serv_analise_vv x
		where  	m.nr_sequencia = x.nr_seq_ordem_serv
		and  	x.ie_severidade in (3, 4, 5));

	c01_w	c01%rowtype;	
	
	
BEGIN
	
	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	
		t_detalhe_row_w.identificador	:= c01_w.nr_sequencia;
		t_detalhe_row_w.descricao	:= c01_w.ds_dano_breve;
		t_detalhe_row_w.detalhe		:= null;

		RETURN NEXT t_detalhe_row_w;		
	
	end loop;
	close C01;
	
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION detalhe_kpi_pck.detalhe_incidental_build () FROM PUBLIC;
