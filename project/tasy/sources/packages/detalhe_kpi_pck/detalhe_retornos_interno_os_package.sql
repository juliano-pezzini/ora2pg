-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--################################################################################################################################################	
CREATE OR REPLACE FUNCTION detalhe_kpi_pck.detalhe_retornos_interno_os () RETURNS SETOF T_DETALHE AS $body$
DECLARE

	
	t_detalhe_row_w	t_detalhe_row;	
	
	c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.ds_dano_breve,
		OBTER_QT_TROCA_GRUPO_OS(a.nr_sequencia,c.nr_sequencia,null) qt_voltas	
	from 	os_encerrada_gerencia_v a,
		man_ordem_servico b,
		grupo_desenvolvimento c
	where	a.nr_sequencia				= b.nr_sequencia
	and	a.dt_fim_real 	between dt_ref_inicio_w and dt_ref_fim_w
	and	c.nr_seq_gerencia	= nr_seq_gerencia_w
	and	coalesce(nr_seq_gerencia_w,0) > 0
	and	OBTER_QT_TROCA_GRUPO_OS(a.nr_sequencia,c.nr_sequencia,null) >= 3
	and	exists (SELECT	1
		from	man_ordem_log_grupo_des x,
			grupo_desenvolvimento y
		where	x.nr_seq_ordem_serv 	= a.nr_sequencia
		and	x.nr_seq_grupo_des	= c.nr_sequencia)
	
union

	select	a.nr_sequencia,
		b.ds_dano_breve,
		OBTER_QT_TROCA_GRUPO_OS(a.nr_sequencia,nr_seq_grupo_w,null) qt_voltas	
	from	os_encerrada_gerencia_v a,
		man_ordem_servico b
	where	a.nr_sequencia				= b.nr_sequencia
	and	a.dt_fim_real 	between dt_ref_inicio_w and dt_ref_fim_w
	and	OBTER_QT_TROCA_GRUPO_OS(a.nr_sequencia,nr_seq_grupo_w,null) >= 3
	and	coalesce(nr_seq_grupo_w,0) > 0
	and	exists (select	1
		from	man_ordem_log_grupo_des x
		where	x.nr_seq_ordem_serv 	= a.nr_sequencia
		and	x.nr_seq_grupo_des	= nr_seq_grupo_w);
	
	c01_w	c01%rowtype;	
	
	
BEGIN
	
	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	
		t_detalhe_row_w.identificador	:= c01_w.nr_sequencia;
		t_detalhe_row_w.descricao	:= c01_w.ds_dano_breve;
		t_detalhe_row_w.detalhe		:= obter_desc_expressao(297875)||': '||c01_w.qt_voltas;

		RETURN NEXT t_detalhe_row_w;		
	
	end loop;
	close C01;
	
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION detalhe_kpi_pck.detalhe_retornos_interno_os () FROM PUBLIC;
