-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE planserv_desdobramento_cta_pck.set_gerar_log (ie_gerar_log_p text) AS $body$
BEGIN
		PERFORM set_config('planserv_desdobramento_cta_pck.ie_gerar_log_w', coalesce(ie_gerar_log_p,'N'), false);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE planserv_desdobramento_cta_pck.set_gerar_log (ie_gerar_log_p text) FROM PUBLIC;
