-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE processar_conta_pck.set_vl_deduzido_conta (vl_deduzido_conta_p bigint) AS $body$
BEGIN
		PERFORM set_config('processar_conta_pck.vl_deduzido_conta_w', vl_deduzido_conta_p, false);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE processar_conta_pck.set_vl_deduzido_conta (vl_deduzido_conta_p bigint) FROM PUBLIC;
