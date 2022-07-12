-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sus_parametros_aih_pck.set_ds_carater_incremento (ds_carater_incremento_p sus_parametros_aih.ds_carater_incremento%type) AS $body$
BEGIN
	PERFORM set_config('sus_parametros_aih_pck.ds_carater_incremento', ds_carater_incremento_p, false);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_parametros_aih_pck.set_ds_carater_incremento (ds_carater_incremento_p sus_parametros_aih.ds_carater_incremento%type) FROM PUBLIC;
