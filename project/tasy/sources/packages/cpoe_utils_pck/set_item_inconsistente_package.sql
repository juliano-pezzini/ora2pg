-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_utils_pck.set_item_inconsistente (ie_item_inconsistente_p text) AS $body$
BEGIN
        PERFORM set_config('cpoe_utils_pck.ie_item_inconsistente_w', ie_item_inconsistente_p, false);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_utils_pck.set_item_inconsistente (ie_item_inconsistente_p text) FROM PUBLIC;
