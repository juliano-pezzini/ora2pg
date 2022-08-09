-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_bionexo ( nr_solic_compra_p bigint, ie_status_p text, ds_mensagem_p text, nm_usuario_p text) AS $body$
BEGIN
 
insert into w_bionexo_log( 
	nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	nr_solic_compra, 
	ie_status, 
	ds_mensagem) 
values (	nextval('w_bionexo_log_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	nr_solic_compra_p, 
	ie_status_p, 
	ds_mensagem_p);
	 
if (ie_status_p = 'ER') then 
	update	solic_compra 
	set	ie_status_bionexo = 'ER' 
	where	nr_solic_compra = nr_solic_compra_p;
end if;
	 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_bionexo ( nr_solic_compra_p bigint, ie_status_p text, ds_mensagem_p text, nm_usuario_p text) FROM PUBLIC;
