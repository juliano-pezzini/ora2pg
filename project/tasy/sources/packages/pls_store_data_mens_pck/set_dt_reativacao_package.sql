-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_store_data_mens_pck.set_dt_reativacao (dt_reativacao_p pls_segurado.dt_reativacao%type) AS $body$
BEGIN
		current_setting('pls_store_data_mens_pck.segurado_w')::pls_segurado%rowtype.dt_reativacao	:= dt_reativacao_p;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_store_data_mens_pck.set_dt_reativacao (dt_reativacao_p pls_segurado.dt_reativacao%type) FROM PUBLIC;
