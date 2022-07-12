-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.grava_lote_recurso ( nr_sequencia_p pls_grg_lote.nr_sequencia%type, nr_seq_dma_analise_p pls_dma_demons_analise.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_dmp_pagto_p pls_dma_demons_analise.nr_sequencia%type, nr_seq_pls_fatura_p pls_fatura.nr_sequencia%type, ie_status_p pls_grg_lote.ie_status%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Grava um novo lote de recurso.
	
	Essa  rotina nao deve possuir nenhuma regra de negocio, apenas realizar o insert
	
	Essa rotina tambem nao e feito com FORALL, pois ela e chamada unitariamente,
	para poder dividir os lotes de recurso conforme os envios recebidos.
	
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

insert into pls_grg_lote(	nr_sequencia,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_dma_analise,
				nr_seq_dmp_pagto,
				nr_seq_pls_fatura,
				ie_status)
values (	nr_sequencia_p,
		cd_estabelecimento_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_dma_analise_p,
		nr_seq_dmp_pagto_p,
		nr_seq_pls_fatura_p,
		ie_status_p);
		
if (coalesce(ie_commit_p, 'S') = 'S') then

	commit;
end if;

		
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.grava_lote_recurso ( nr_sequencia_p pls_grg_lote.nr_sequencia%type, nr_seq_dma_analise_p pls_dma_demons_analise.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_dmp_pagto_p pls_dma_demons_analise.nr_sequencia%type, nr_seq_pls_fatura_p pls_fatura.nr_sequencia%type, ie_status_p pls_grg_lote.ie_status%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
