-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.grava_erg_prestador ( nr_sequencia_p pls_erg_prestador.nr_sequencia%type, nr_seq_erg_cabecalho_p pls_erg_prestador.nr_seq_erg_cabecalho%type, cd_prestador_p pls_erg_prestador.cd_prestador%type, cd_cpf_prest_p pls_erg_prestador.cd_cpf_prest%type, cd_cnpj_prest_p pls_erg_prestador.cd_cnpj_prest%type, nm_prestador_p pls_erg_prestador.nm_prestador%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Grava o prestador do lote de envio de recurso de glosa
	
	Essa rotina vai apenas gravar os dados, nenhuma regra de negocio deve ser inserida
	aqui

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

insert into pls_erg_prestador(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_erg_cabecalho,
				cd_prestador,
				cd_cpf_prest,
				cd_cnpj_prest,
				nm_prestador)
values (nr_sequencia_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_erg_cabecalho_p,
	cd_prestador_p,
	cd_cpf_prest_p,
	cd_cnpj_prest_p,
	nm_prestador_p);
	
if (coalesce(ie_commit_p, 'S') = 'S') then

	commit;
end if;
	

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.grava_erg_prestador ( nr_sequencia_p pls_erg_prestador.nr_sequencia%type, nr_seq_erg_cabecalho_p pls_erg_prestador.nr_seq_erg_cabecalho%type, cd_prestador_p pls_erg_prestador.cd_prestador%type, cd_cpf_prest_p pls_erg_prestador.cd_cpf_prest%type, cd_cnpj_prest_p pls_erg_prestador.cd_cnpj_prest%type, nm_prestador_p pls_erg_prestador.nm_prestador%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
