-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE processar_conta_drg_aus_pck.set_qt_dias_icu_a (qt_dias_icu_a_p bigint) AS $body$
BEGIN
		PERFORM set_config('processar_conta_drg_aus_pck.qt_dias_icu_a_w', qt_dias_icu_a_p, false);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE processar_conta_drg_aus_pck.set_qt_dias_icu_a (qt_dias_icu_a_p bigint) FROM PUBLIC;
