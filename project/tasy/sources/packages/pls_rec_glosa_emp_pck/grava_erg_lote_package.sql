-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.grava_erg_lote ( nr_sequencia_p pls_erg_recurso.nr_sequencia%type, cd_estabelecimento_p pls_erg_recurso.cd_estabelecimento%type, nr_seq_grg_lote_p pls_erg_recurso.nr_seq_grg_lote%type, dt_geracao_lote_p pls_erg_recurso.dt_geracao_lote%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Grava o lote de envio de recurso de glosa
	
	Essa rotina vai apenas gravar os dados, nenhuma regra de negocio deve ser inserida
	aqui

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

insert into pls_erg_recurso(	nr_sequencia,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_grg_lote,
				dt_geracao_lote,
				dt_geracao_arquivo)
values (	nr_sequencia_p,
		cd_estabelecimento_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_grg_lote_p,
		dt_geracao_lote_p,
		null);
		
if (coalesce(ie_commit_p, 'S') = 'S') then

	commit;
end if;
		
		
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.grava_erg_lote ( nr_sequencia_p pls_erg_recurso.nr_sequencia%type, cd_estabelecimento_p pls_erg_recurso.cd_estabelecimento%type, nr_seq_grg_lote_p pls_erg_recurso.nr_seq_grg_lote%type, dt_geracao_lote_p pls_erg_recurso.dt_geracao_lote%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
