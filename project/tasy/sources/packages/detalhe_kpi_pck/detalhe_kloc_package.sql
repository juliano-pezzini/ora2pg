-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
--################################################################################################################################################
CREATE OR REPLACE FUNCTION detalhe_kpi_pck.detalhe_kloc () RETURNS SETOF T_DETALHE AS $body$
DECLARE

	
	t_detalhe_row_w	t_detalhe_row;	
	
	qt_erros_w	bigint;
	qt_linhas_w	bigint;
	
	c00 CURSOR FOR
	SELECT	b.nm_usuario nm_usuario_grupo,
		b.cd_pessoa_fisica		
	from	usuario b
	where	b.nm_usuario		= nm_usuario_exec_w
	
union

	SELECT	a.nm_usuario_grupo,
		b.cd_pessoa_fisica		
	from	usuario_grupo_des a,
		usuario b
	where	a.nm_usuario_grupo	= b.nm_usuario
	and	a.nr_seq_grupo		= current_setting('detalhe_kpi_pck.nr_seq_grupo_w')::bigint
	and	coalesce(current_setting('detalhe_kpi_pck.nr_seq_grupo_w')::bigint,0) 	> 0
	
union

	select	a.nm_usuario_grupo,
		b.cd_pessoa_fisica		
	from	usuario_grupo_des a,
		usuario b,
		grupo_desenvolvimento c
	where	a.nm_usuario_grupo		= b.nm_usuario
	and	c.nr_sequencia			= a.nr_seq_grupo
	and	c.nr_seq_gerencia		= current_setting('detalhe_kpi_pck.nr_seq_gerencia_w')::bigint	
	and	coalesce(current_setting('detalhe_kpi_pck.nr_seq_gerencia_w')::bigint,0) 	> 0;	
	
	c00_w	c00%rowtype;
		
	
BEGIN
	
	open C00;
	loop
	fetch C00 into
		c00_w;
	EXIT WHEN NOT FOUND; /* apply on C00 */
	
		select  sum(coalesce(k.qt_modified,0)+coalesce(k.qt_added,0)+coalesce(k.qt_deleted,0)+coalesce(k.qt_collected,0))
		into STRICT	qt_linhas_w
		from    kpi_lines_kaloc k,
			usuario u
		where   u.ds_email 	= k.ds_email_user_git
		and     u.nm_usuario 	= c00_w.nm_usuario_grupo
		and     trunc(k.dt_atualizacao, 'month') = trunc(current_setting('detalhe_kpi_pck.dt_ref_inicio_w')::timestamp, 'month');
		
		select 	count(*)
		into STRICT	qt_erros_w
		from	os_erro_gerencia_v a,
			grupo_desenvolvimento b
		where	a.nr_Seq_grupo_Des_erro = b.nr_sequencia
		and	a.dt_liberacao 		between current_setting('detalhe_kpi_pck.dt_ref_inicio_w')::timestamp and current_setting('detalhe_kpi_pck.dt_ref_fim_w')::timestamp
		and	a.ie_plataforma		= 'H'	
		and	a.nr_seq_subtipo in (256,257) --Commit Fail and Fail in the Coding Development
		and	exists (SELECT 1
			from	MAN_ORDEM_SERV_TECNICO os
			where	os.nr_seq_ordem_serv = a.nr_sequencia
			and	(os.dt_liberacao IS NOT NULL AND os.dt_liberacao::text <> '')
			and	os.NR_SEQ_TIPO = '163') --Aprovação de code review
		and	a.cd_pessoa_fisica		= c00_w.cd_pessoa_fisica
		and	((current_setting('detalhe_kpi_pck.nr_seq_grupo_w')::coalesce(bigint::text, '') = '' or a.nr_seq_grupo_des_erro 	= current_setting('detalhe_kpi_pck.nr_seq_grupo_w')::bigint) or (current_setting('detalhe_kpi_pck.nr_seq_gerencia_w')::coalesce(bigint::text, '') = '' or b.nr_seq_gerencia 	= current_setting('detalhe_kpi_pck.nr_seq_gerencia_w')::bigint))
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');
		
		if (qt_linhas_w > 0) then
			t_detalhe_row_w.identificador	:= null;
			t_detalhe_row_w.descricao	:= obter_nome_pf(c00_w.cd_pessoa_fisica);
			t_detalhe_row_w.detalhe		:= obter_desc_expressao(308755)||': '||qt_erros_w||' '||obter_desc_expressao(717617)||': '||qt_linhas_w;

			RETURN NEXT t_detalhe_row_w;
		end if;
	
	end loop;
	close C00;
		
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION detalhe_kpi_pck.detalhe_kloc () FROM PUBLIC;