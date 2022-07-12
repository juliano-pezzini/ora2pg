-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.gera_erg_prestador ( nr_seq_erg_lote_p pls_erg_recurso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera os prestadores do lote de envio de recurso de glosa.
	
	Sera varrido todos os prestadores do lote de recurso, vinculados ao lote de dados
	
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


-- Carrega o prestador

-- Como a estrutura para trabalhar no tasy e diferente do formato em xml do TISS, e buscado algumas informacoes secundarias na analise.

-- Atualmente a estrutura de prestador e apenas de 1 para 1 no schema do TISS

c01 CURSOR(	nr_seq_erg_lote_pc	pls_erg_recurso.nr_sequencia%type) FOR
	SELECT	nextval('pls_erg_prestador_seq') nr_sequencia,
		f.nr_sequencia nr_seq_erg_cabecalho,
		e.cd_prestador,
		e.cd_cpf_prest,
		e.cd_cnpj_prest,
		e.nm_prestador
	from	pls_erg_recurso		a,
		pls_grg_lote		b,
		pls_dma_demons_analise	c,
		pls_dma_cabecalho_imp	d,
		pls_dma_prestador_imp	e,
		pls_erg_cabecalho	f
	where	b.nr_sequencia		= a.nr_seq_grg_lote
	and	c.nr_sequencia		= b.nr_seq_dma_analise
	and	d.nr_seq_dma_analise	= c.nr_sequencia
	and	e.nr_seq_dma_cabecalho	= d.nr_sequencia
	and	f.nr_seq_erg_recurso	= a.nr_sequencia
	and	a.nr_sequencia		= nr_seq_erg_lote_pc;
		
BEGIN

for r_c01_w in c01(nr_seq_erg_lote_p) loop

	CALL pls_rec_glosa_emp_pck.grava_erg_prestador(	r_c01_w.nr_sequencia,
				r_c01_w.nr_seq_erg_cabecalho,
				r_c01_w.cd_prestador,
				r_c01_w.cd_cpf_prest,
				r_c01_w.cd_cnpj_prest,
				r_c01_w.nm_prestador,
				nm_usuario_p,
				'N');
	
end loop;

if (coalesce(ie_commit_p, 'S') = 'S') then

	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.gera_erg_prestador ( nr_seq_erg_lote_p pls_erg_recurso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
