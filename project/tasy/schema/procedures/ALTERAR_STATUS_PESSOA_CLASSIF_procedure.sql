-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_pessoa_classif ( nr_seq_classif_p bigint, ie_status_p text, ds_justif_inativacao_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_status_p = 'A') then

	update	pessoa_classif
	set	dt_inativacao  = NULL,
		nm_usuario_inativacao  = NULL,
		ds_justif_inativacao  = NULL,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_classif_p;

else

	update	pessoa_classif
	set	dt_inativacao = clock_timestamp(),
		nm_usuario_inativacao = nm_usuario_p,
		ds_justif_inativacao = ds_justif_inativacao_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_classif_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_pessoa_classif ( nr_seq_classif_p bigint, ie_status_p text, ds_justif_inativacao_p text, nm_usuario_p text) FROM PUBLIC;

