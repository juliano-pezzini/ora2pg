-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION param_recalcular_repasse_pck.get_qt_repasse_adic () RETURNS bigint AS $body$
BEGIN
		return current_setting('param_recalcular_repasse_pck.qt_repasse_adic_w')::bigint;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION param_recalcular_repasse_pck.get_qt_repasse_adic () FROM PUBLIC;
