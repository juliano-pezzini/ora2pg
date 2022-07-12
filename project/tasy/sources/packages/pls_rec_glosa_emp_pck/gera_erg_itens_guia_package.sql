-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.gera_erg_itens_guia ( nr_seq_erg_lote_p pls_erg_recurso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera as guias de envio de recurso de glosa
	
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	Para respeitar o Schema tiss so serao considerada as guias que possuirem algum
	recurso a nivel de item.
	
	Ainda, no Schema TISS nao existe uma distincao clara sobre Procedimentos e
	materiais, no que se diz respeito ao recurso de glosa, portanto todos serao considerados
	como "Itens", de forma generica, sendo "classificados" apenas pelo atributo cd_tabela
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


-- Tabelas virtuais

tb_nr_sequencia_w		dbms_sql.number_table;
tb_nr_seq_erg_guia_w		dbms_sql.number_table;
tb_dt_inicio_w			dbms_sql.date_table;
tb_dt_final_w			dbms_sql.date_table;
tb_cd_tabela_w			dbms_sql.varchar2_table;
tb_cd_procedimento_w		dbms_sql.varchar2_table;
tb_ds_procedimento_w		dbms_sql.varchar2_table;
tb_cd_grau_participacao_w	dbms_sql.varchar2_table;
tb_cd_glosa_w			dbms_sql.varchar2_table;
tb_ds_justificativa_w		dbms_sql.varchar2_table;
tb_vl_recursado_w		dbms_sql.number_table;
tb_nr_seq_grg_guia_proc_w	dbms_sql.number_table;
tb_nr_seq_grg_guia_mat_w	dbms_sql.number_table;

-- Carrega os itens

c01 CURSOR(	nr_seq_erg_lote_pc	pls_erg_recurso.nr_sequencia%type) FOR
	SELECT	nextval('pls_erg_guia_item_seq') nr_sequencia,
		t.nr_seq_erg_guia,
		t.dt_inicio,
		t.dt_fim,
		t.cd_tabela,
		t.cd_procedimento,
		t.ds_procedimento,
		t.cd_grau_participacao,
		t.cd_glosa,
		t.ds_justificativa,
		t.vl_recursado,
		t.nr_seq_grg_guia_proc,
		t.nr_seq_grg_guia_mat
	from (	SELECT	c.nr_sequencia nr_seq_erg_guia,
			coalesce(d.dt_inicio_fat_imp, e.dt_realizacao_imp) dt_inicio,
			d.dt_fim_fat_imp dt_fim,
			e.cd_tabela_imp cd_tabela,
			e.cd_procedimento_imp cd_procedimento,
			substr(obter_descricao_procedimento(e.cd_procedimento, e.ie_origem_proced),1,150) ds_procedimento,
			g.cd_grau_participacao,
			substr(tiss_obter_dados_motivo_glosa(f.nr_seq_motivo_glosa,'C'),1,255) cd_glosa,
			f.ds_justificativa ds_justificativa,
			e.vl_recursado,
			e.nr_sequencia nr_seq_grg_guia_proc,
			null nr_seq_grg_guia_mat
		from	pls_erg_recurso			a,
			pls_erg_cabecalho		b,
			pls_erg_guia			c,
			pls_grg_guia			d,
			pls_grg_guia_proc		e,
			pls_grg_guia_proc_glosa		f,
			pls_dma_procedimento_imp	g
		where	b.nr_seq_erg_recurso	= a.nr_sequencia
		and	c.nr_seq_erg_cabecalho	= b.nr_sequencia
		and	d.nr_sequencia		= c.nr_seq_grg_guia
		and	e.nr_seq_grg_guia	= d.nr_sequencia
		and	f.nr_seq_grg_proc	= e.nr_sequencia
		and	g.nr_sequencia		= e.nr_seq_dma_procedimento
		-- Garantia que vai buscar apenas uma glosa por item, evitando cardinalidade indevida

		and	f.nr_sequencia		= (	select	max(x.nr_sequencia) nr_sequencia
							from	pls_grg_guia_proc_glosa	x
							where	x.nr_seq_grg_proc	= e.nr_sequencia
							and	(x.ds_justificativa IS NOT NULL AND x.ds_justificativa::text <> ''))
		-- so gera a nivel de item, se ao menos 1 item da guia teve recursa no mesmo nivel

		and (	select	count(1)
				from	pls_grg_guia_proc	x
				where	x.nr_seq_grg_guia	= c.nr_seq_grg_guia
				and	x.ie_origem_acao	= 'I') > 0
		and	e.vl_recursado > 0
		and	a.nr_sequencia		= nr_seq_erg_lote_pc
		
union all

		select	c.nr_sequencia nr_seq_erg_guia,
			coalesce(d.dt_inicio_fat_imp, e.dt_realizacao_imp) dt_inicio,
			d.dt_fim_fat_imp dt_fim,
			e.cd_tabela_imp cd_tabela,
			e.cd_material_imp cd_procedimento,
			substr(pls_obter_desc_material(e.nr_seq_material),1,150) ds_procedimento,
			g.cd_grau_participacao,
			substr(tiss_obter_dados_motivo_glosa(f.nr_seq_motivo_glosa,'C'),1,255) cd_glosa,
			f.ds_justificativa ds_justificativa,
			e.vl_recursado,
			null nr_seq_grg_guia_proc,
			e.nr_sequencia nr_seq_grg_guia_mat
		from	pls_erg_recurso			a,
			pls_erg_cabecalho		b,
			pls_erg_guia			c,
			pls_grg_guia			d,
			pls_grg_guia_mat		e,
			pls_grg_guia_mat_glosa		f,
			pls_dma_procedimento_imp	g
		where	b.nr_seq_erg_recurso	= a.nr_sequencia
		and	c.nr_seq_erg_cabecalho	= b.nr_sequencia
		and	d.nr_sequencia		= c.nr_seq_grg_guia
		and	e.nr_seq_grg_guia	= d.nr_sequencia
		and	f.nr_seq_grg_mat	= e.nr_sequencia
		and	g.nr_sequencia		= e.nr_seq_dma_procedimento
		-- Garantia que vai buscar apenas uma glosa por item, evitando cardinalidade indevida

		and	f.nr_sequencia		= (	select	max(x.nr_sequencia) nr_sequencia
							from	pls_grg_guia_mat_glosa	x
							where	x.nr_seq_grg_mat	= e.nr_sequencia
							and	(x.ds_justificativa IS NOT NULL AND x.ds_justificativa::text <> ''))
		-- so gera a nivel de item, se ao menos 1 item da guia teve recursa no mesmo nivel

		and (	select	count(1)
				from	pls_grg_guia_mat	x
				where	x.nr_seq_grg_guia	= c.nr_seq_grg_guia
				and	x.ie_origem_acao	= 'I') > 0
		and	e.vl_recursado > 0
		and	a.nr_sequencia		= nr_seq_erg_lote_pc ) t;

BEGIN

begin
-- Carrega os itens

open c01(nr_seq_erg_lote_p);
loop
	fetch c01 bulk collect into	tb_nr_sequencia_w,
					tb_nr_seq_erg_guia_w,
					tb_dt_inicio_w,
					tb_dt_final_w,
					tb_cd_tabela_w,
					tb_cd_procedimento_w,
					tb_ds_procedimento_w,
					tb_cd_grau_participacao_w,
					tb_cd_glosa_w,
					tb_ds_justificativa_w,
					tb_vl_recursado_w,
					tb_nr_seq_grg_guia_proc_w,
					tb_nr_seq_grg_guia_mat_w limit  pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;
	
	SELECT * FROM pls_rec_glosa_emp_pck.grava_erg_itens_guia(	tb_nr_sequencia_w, tb_nr_seq_erg_guia_w, tb_dt_inicio_w, tb_dt_final_w, tb_cd_tabela_w, tb_cd_procedimento_w, tb_ds_procedimento_w, tb_cd_grau_participacao_w, tb_cd_glosa_w, tb_ds_justificativa_w, tb_vl_recursado_w, tb_nr_seq_grg_guia_proc_w, tb_nr_seq_grg_guia_mat_w, nm_usuario_p, 'N', 'S') INTO STRICT _ora2pg_r;
 	tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_nr_seq_erg_guia_w := _ora2pg_r.tb_nr_seq_erg_guia_p; tb_dt_inicio_w := _ora2pg_r.tb_dt_inicio_p; tb_dt_final_w := _ora2pg_r.tb_dt_final_p; tb_cd_tabela_w := _ora2pg_r.tb_cd_tabela_p; tb_cd_procedimento_w := _ora2pg_r.tb_cd_procedimento_p; tb_ds_procedimento_w := _ora2pg_r.tb_ds_procedimento_p; tb_cd_grau_participacao_w := _ora2pg_r.tb_cd_grau_participacao_p; tb_cd_glosa_w := _ora2pg_r.tb_cd_glosa_p; tb_ds_justificativa_w := _ora2pg_r.tb_ds_justificativa_p; tb_vl_recursado_w := _ora2pg_r.tb_vl_recursado_p; tb_nr_seq_grg_guia_proc_w := _ora2pg_r.tb_nr_seq_grg_guia_proc_p; tb_nr_seq_grg_guia_mat_w := _ora2pg_r.tb_nr_seq_grg_guia_mat_p;	
end loop;

exception

	when others then
	
		if (c01%isopen) then
			
			close c01;
		end if;
		
		rollback;
		CALL pls_rec_glosa_emp_pck.exibe_msg_erro_gerar_erg();
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.gera_erg_itens_guia ( nr_seq_erg_lote_p pls_erg_recurso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;