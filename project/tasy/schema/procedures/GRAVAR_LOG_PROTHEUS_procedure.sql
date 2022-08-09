-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_protheus ( ds_status_p text, ds_entidade_p text, ds_motivo_p text, nm_usuario_p text) AS $body$
BEGIN

insert into log_protheus(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	ds_status,
	ds_entidade,
	ds_motivo)
values (	nextval('log_protheus_seq'),
	clock_timestamp(),
	nm_usuario_p,
	ds_status_p,
	ds_entidade_p,
	substr(ds_motivo_p,1,4000));

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_protheus ( ds_status_p text, ds_entidade_p text, ds_motivo_p text, nm_usuario_p text) FROM PUBLIC;
