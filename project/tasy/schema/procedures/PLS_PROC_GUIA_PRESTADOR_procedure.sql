-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_proc_guia_prestador ( nr_seq_guia_p bigint, ds_procedimento_imp_p text, cd_procedimento_imp_p text, qt_solicitada_imp_p bigint, cd_tipo_tabela_imp_p text, nr_seq_proc_autor_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into pls_guia_plano_proc(
			nr_sequencia, nm_usuario, dt_atualizacao,
			nr_seq_guia, cd_procedimento_imp, ds_procedimento_imp,
			qt_solicitada_imp, cd_tipo_tabela_imp, nr_seq_proc_autor)
                values (nextval('pls_guia_plano_proc_seq'), nm_usuario_p, clock_timestamp(),
			nr_seq_guia_p,cd_procedimento_imp_p, ds_procedimento_imp_p,
			qt_solicitada_imp_p, cd_tipo_tabela_imp_p, nr_seq_proc_autor_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_proc_guia_prestador ( nr_seq_guia_p bigint, ds_procedimento_imp_p text, cd_procedimento_imp_p text, qt_solicitada_imp_p bigint, cd_tipo_tabela_imp_p text, nr_seq_proc_autor_p bigint, nm_usuario_p text) FROM PUBLIC;

