-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_erro_etiqueta ( nr_seq_lab_etiqueta_p bigint, ds_erro_p text, nm_usuario_p text) AS $body$
BEGIN

if	not(coalesce(nr_seq_lab_etiqueta_p::text, '') = '') then

	update 	lab_etiqueta_contingencia
	set	dt_atualizacao 	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p,
		ds_erro		= ds_erro_p
	where	nr_sequencia 	=  nr_seq_lab_etiqueta_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_erro_etiqueta ( nr_seq_lab_etiqueta_p bigint, ds_erro_p text, nm_usuario_p text) FROM PUBLIC;

