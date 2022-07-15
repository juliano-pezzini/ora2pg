-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_retorno_convenio ( nr_seq_retorno_p bigint, nm_usuario_p text, ie_tipo_log_p text, ds_log_p text) AS $body$
BEGIN

insert into convenio_retorno_log(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_retorno,
		ie_status_retorno,
		ds_log)
	values (nextval('convenio_retorno_log_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_retorno_p,
		ie_tipo_log_p,
		ds_log_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_retorno_convenio ( nr_seq_retorno_p bigint, nm_usuario_p text, ie_tipo_log_p text, ds_log_p text) FROM PUBLIC;

