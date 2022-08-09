-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_log_exportacao_solic ( nr_solic_compra_p bigint, nm_usuario_p text, ds_arquivo_p text) AS $body$
BEGIN
 
update	solic_compra 
set	ie_forma_exportar = '1' 
where	nr_solic_compra = nr_solic_compra_p;
 
insert into solic_compra_exportada( 
	nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	nr_solic_compra, 
	dt_exportacao, 
	ie_forma_exportacao, 
	ds_arquivo) 
values (nextval('log_prepedido_me_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	nr_solic_compra_p, 
	clock_timestamp(), 
	'0', 
	ds_arquivo_p);
 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_log_exportacao_solic ( nr_solic_compra_p bigint, nm_usuario_p text, ds_arquivo_p text) FROM PUBLIC;
