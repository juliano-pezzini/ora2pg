-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_status_integ_cmb ( nr_seq_envio_p bigint, ie_status_p text, ds_retorno_p text, nm_usuario_p text) AS $body$
BEGIN

update 	pls_envio_ptu
set	ie_status = ie_status_p,
	ds_retorno = ds_retorno_p,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where	nr_sequencia = nr_seq_envio_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_status_integ_cmb ( nr_seq_envio_p bigint, ie_status_p text, ds_retorno_p text, nm_usuario_p text) FROM PUBLIC;
