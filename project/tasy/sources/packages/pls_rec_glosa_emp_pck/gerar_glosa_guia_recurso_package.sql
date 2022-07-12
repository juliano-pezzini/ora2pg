-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.gerar_glosa_guia_recurso ( nr_seq_demost_analise_p pls_dma_demons_analise.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera as glosas para as guias importadas

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- tabelas virtuais

tb_nr_sequencia_w		dbms_sql.number_table;
tb_nr_seq_grg_guia_w		dbms_sql.number_table;
tb_nr_seq_motivo_glosa_w	dbms_sql.number_table;
tb_ds_justificativa_w		dbms_sql.varchar2_table;
tb_nr_seq_dma_guia_w		dbms_sql.number_table;


-- carrega as glosas

c01 CURSOR(nr_seq_demost_analise_pc	pls_dma_demons_analise.nr_sequencia%type) FOR
	SELECT	nextval('pls_grg_guia_glosa_seq') nr_sequencia,
		a.nr_sequencia nr_seq_grg_guia,
		pls_obter_seq_motivo_glosa(c.cd_glosa) nr_seq_motivo_glosa,
		null ds_justificativa,
		c.nr_sequencia nr_seq_dma_guia_glosa
	from	pls_grg_guia		a,
		pls_dma_guia_imp	b,
		pls_dma_guia_glosa_imp	c,
		pls_dma_protocolo_imp	d,
		pls_dma_prestador_imp	e,
		pls_dma_cabecalho_imp	f
	where	b.nr_sequencia		= a.nr_seq_dma_guia
	and	c.nr_seq_dma_guia	= b.nr_sequencia
	and	d.nr_sequencia		= b.nr_seq_dma_protocolo
	and	e.nr_sequencia		= d.nr_seq_dma_prestador
	and	f.nr_sequencia		= e.nr_seq_dma_cabecalho
	and	f.nr_seq_dma_analise	= nr_seq_demost_analise_pc;
		

BEGIN

begin
	-- carrega as glosas

	open c01(nr_seq_demost_analise_p);
	loop
	fetch c01 bulk collect into	tb_nr_sequencia_w,
					tb_nr_seq_grg_guia_w,
					tb_nr_seq_motivo_glosa_w,
					tb_ds_justificativa_w,
					tb_nr_seq_dma_guia_w limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;
		
		-- Joga no banco

		SELECT * FROM pls_rec_glosa_emp_pck.grava_glosa_guia_recurso(	tb_nr_sequencia_w, tb_nr_seq_grg_guia_w, tb_nr_seq_motivo_glosa_w, tb_ds_justificativa_w, tb_nr_seq_dma_guia_w, nm_usuario_p, 'N', 'S') INTO STRICT _ora2pg_r;
 	tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_nr_seq_grg_guia_w := _ora2pg_r.tb_nr_seq_grg_guia_p; tb_nr_seq_motivo_glosa_w := _ora2pg_r.tb_nr_seq_motivo_glosa_p; tb_ds_justificativa_w := _ora2pg_r.tb_ds_justificativa_p; tb_nr_seq_dma_guia_w := _ora2pg_r.tb_nr_seq_dma_guia_p;

	end loop; -- Fim carga dos dados
	
	if (c01%isopen) then
		
			close c01;
	end if;

exception

	when others then
	
		if (c01%isopen) then
		
			close c01;
		end if;
		
		CALL CALL pls_rec_glosa_emp_pck.exibe_msg_erro_padrao();
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.gerar_glosa_guia_recurso ( nr_seq_demost_analise_p pls_dma_demons_analise.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
