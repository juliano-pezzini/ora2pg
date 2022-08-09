-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_inicializar_rateio ( nr_seq_criterio_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
update	ctb_criterio_rateio_item 
set	pr_rateio	= 0, 
	qt_rateio	= 0, 
	nm_usuario	= nm_usuario_p, 
	dt_atualizacao	= clock_timestamp() 
where	nr_seq_criterio	= nr_seq_criterio_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_inicializar_rateio ( nr_seq_criterio_p bigint, nm_usuario_p text) FROM PUBLIC;
