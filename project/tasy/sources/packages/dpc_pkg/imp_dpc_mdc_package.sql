-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dpc_pkg.imp_dpc_mdc ( cd_mdc_p text, ds_name_p text, dt_end_p text, dt_start_p text, dt_update_p text, nr_seq_edition_p bigint, si_change_category_p text, nm_usuario_p text) AS $body$
BEGIN

insert into dpc_mdc(
	cd_mdc,                  
	ds_name,                 
	dt_atualizacao,          
	dt_atualizacao_nrec,     
	dt_end,                  
	dt_start,                
	dt_update,               
	nm_usuario,              
	nm_usuario_nrec,         
	nr_seq_edition,          
	nr_sequencia,            
	si_change_category)
	values (
	cd_mdc_p,                  
	ds_name_p,                 
	clock_timestamp(),          
	clock_timestamp(),     
	CASE WHEN dt_end_p='99999999' THEN null WHEN dt_end_p='00000000' THEN null  ELSE to_date(dt_end_p,'yyyy-mm-dd') END ,
    CASE WHEN dt_start_p='99999999' THEN null WHEN dt_start_p='00000000' THEN null  ELSE to_date(dt_start_p,'yyyy-mm-dd') END ,
    CASE WHEN dt_update_p='99999999' THEN null WHEN dt_update_p='00000000' THEN null  ELSE to_date(dt_update_p,'yyyy-mm-dd') END ,	
	nm_usuario_p,              
	nm_usuario_p,         
	nr_seq_edition_p,          
	nextval('dpc_mdc_seq'),            
	si_change_category_p);

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dpc_pkg.imp_dpc_mdc ( cd_mdc_p text, ds_name_p text, dt_end_p text, dt_start_p text, dt_update_p text, nr_seq_edition_p bigint, si_change_category_p text, nm_usuario_p text) FROM PUBLIC;
