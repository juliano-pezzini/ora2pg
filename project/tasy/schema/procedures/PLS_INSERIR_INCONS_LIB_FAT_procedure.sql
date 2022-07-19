-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_incons_lib_fat ( nr_seq_lib_fat_conta_p pls_lib_fat_conta.nr_sequencia%type, nr_seq_inconsistencia_p pls_inconsistencia_lib_fat.nr_sequencia%type, ds_complemento_p pls_lib_fat_conta_incons.ds_complemento%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
insert into pls_lib_fat_conta_incons(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_lib_fat_conta,
	nr_seq_inconsistencia,
	ds_complemento)
values (nextval('pls_lib_fat_conta_incons_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_lib_fat_conta_p,
	nr_seq_inconsistencia_p,
	ds_complemento_p);

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_incons_lib_fat ( nr_seq_lib_fat_conta_p pls_lib_fat_conta.nr_sequencia%type, nr_seq_inconsistencia_p pls_inconsistencia_lib_fat.nr_sequencia%type, ds_complemento_p pls_lib_fat_conta_incons.ds_complemento%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;

