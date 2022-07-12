-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_moviment_benef_a1300_pck.get_nm_usuario () RETURNS USUARIO.NM_USUARIO%TYPE AS $body$
BEGIN
		return current_setting('ptu_moviment_benef_a1300_pck.nm_usuario_w')::usuario.nm_usuario%type;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_moviment_benef_a1300_pck.get_nm_usuario () FROM PUBLIC;
