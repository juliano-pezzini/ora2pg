-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_log_pck.set_erro_banco (ds_mensagem_p text) AS $body$
BEGIN
	PERFORM set_config('wheb_log_pck.ds_msg_erro_w', substr(ds_mensagem_p,1,2000), false);
	end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_log_pck.set_erro_banco (ds_mensagem_p text) FROM PUBLIC;