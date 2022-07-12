-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.gerar_protocolo_recurso ( nr_seq_demost_analise_p pls_dma_demons_analise.nr_sequencia%type, nr_seq_lote_p pls_grg_lote.nr_sequencia%type, nr_lote_prestador_p pls_dma_protocolo_imp.nr_lote_prestador%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera os protocolo com base no demonstrativo e o lote de envio.

	A rotina vai levantar os protocolo com base no demonstrativo nr_lote_prestador,
	e entao vai jogar o resultado em uma rotina para gravar
	
	
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */



-- Tabelas virtuais

tb_nr_sequencia_w		dbms_sql.number_table;
tb_nr_seq_lote_w		dbms_sql.number_table;
tb_nr_lote_prestador_w		dbms_sql.number_table;
tb_nr_protocolo_w		dbms_sql.number_table;
tb_dt_protocolo_w		dbms_sql.date_table;
tb_nr_seq_dma_protocolo_w	dbms_sql.number_table;
tb_nr_seq_guia_arquivo_w	dbms_sql.number_table;


-- Carrega os protocolos correspondentes

c01 CURSOR(	nr_seq_demost_analise_pc	pls_dma_demons_analise.nr_sequencia%type,
		nr_seq_lote_pc			pls_grg_lote.nr_sequencia%type,
		nr_lote_prestador_pc		pls_dma_protocolo_imp.nr_lote_prestador%type) FOR
		SELECT	nextval('pls_grg_protocolo_seq') nr_sequencia,
			nr_seq_lote_pc nr_seq_lote,
			nr_lote_prestador_pc nr_lote_prestador,
			a.nr_protocolo,
			a.dt_protocolo,
			a.nr_sequencia nr_seq_dma_protocolo,
			-- e o campo utilizado para fazer a ligacao entre o arquivo enviado e analise recebida

			nr_lote_prestador_pc nr_seq_guia_arquivo
		from	pls_dma_protocolo_imp	a,
			pls_dma_prestador_imp	b,
			pls_dma_cabecalho_imp	c		
		where	b.nr_sequencia		= a.nr_seq_dma_prestador
		and	c.nr_sequencia		= b.nr_seq_dma_cabecalho
		and	a.nr_lote_prestador	= nr_lote_prestador_pc
		and	c.nr_seq_dma_analise	= nr_seq_demost_analise_pc;


BEGIN

begin

	-- carrega os protocolos

	open c01(	nr_seq_demost_analise_p,
			nr_seq_lote_p,
			nr_lote_prestador_p);
	loop
	fetch c01 bulk collect into	tb_nr_sequencia_w,
					tb_nr_seq_lote_w,
					tb_nr_lote_prestador_w,
					tb_nr_protocolo_w,
					tb_dt_protocolo_w,
					tb_nr_seq_dma_protocolo_w,
					tb_nr_seq_guia_arquivo_w limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;

		-- Manda para o banco, nao e enviado o commit neste momento

		SELECT * FROM pls_rec_glosa_emp_pck.grava_protocolo_recurso(tb_nr_sequencia_w, tb_nr_seq_lote_w, tb_nr_lote_prestador_w, tb_nr_protocolo_w, tb_dt_protocolo_w, tb_nr_seq_dma_protocolo_w, tb_nr_seq_guia_arquivo_w, nm_usuario_p, 'N', 'S') INTO STRICT _ora2pg_r;
 tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_nr_seq_lote_w := _ora2pg_r.tb_nr_seq_lote_p; tb_nr_lote_prestador_w := _ora2pg_r.tb_nr_lote_prestador_p; tb_nr_protocolo_w := _ora2pg_r.tb_nr_protocolo_p; tb_dt_protocolo_w := _ora2pg_r.tb_dt_protocolo_p; tb_nr_seq_dma_protocolo_w := _ora2pg_r.tb_nr_seq_dma_protocolo_p; tb_nr_seq_guia_arquivo_w := _ora2pg_r.tb_nr_seq_guia_arquivo_p;
	end loop;

	if (c01%isopen) then

		close c01;
	end if;
	
	if (coalesce(ie_commit_p, 'S') = 'S') then

		commit;
	end if;

exception

	when others then
		
		if (c01%isopen) then
		
			close c01;
		end if;
		rollback;
		CALL CALL pls_rec_glosa_emp_pck.exibe_msg_erro_padrao();
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.gerar_protocolo_recurso ( nr_seq_demost_analise_p pls_dma_demons_analise.nr_sequencia%type, nr_seq_lote_p pls_grg_lote.nr_sequencia%type, nr_lote_prestador_p pls_dma_protocolo_imp.nr_lote_prestador%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
