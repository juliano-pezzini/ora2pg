-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_mensagem_log_gtplan ( nr_solic_gtplan_p text, ie_status_p text, ds_mensagem_p text, nm_usuario_p text) AS $body$
BEGIN

insert into log_gtplan(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_solic_gtplan,
	ie_status,
	ds_mensagem)
values (	nextval('log_gtplan_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_solic_gtplan_p,
	ie_status_p,
	ds_mensagem_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_mensagem_log_gtplan ( nr_solic_gtplan_p text, ie_status_p text, ds_mensagem_p text, nm_usuario_p text) FROM PUBLIC;

