-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_diferenca_para_peso_ideal (qt_peso_pre_p bigint, qt_peso_ideal_p bigint) RETURNS bigint AS $body$
DECLARE

qt_diferenca_peso_w	bigint;


BEGIN

qt_diferenca_peso_w := (coalesce(qt_peso_pre_p,0) - coalesce(qt_peso_ideal_p,0));

return	qt_diferenca_peso_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_diferenca_para_peso_ideal (qt_peso_pre_p bigint, qt_peso_ideal_p bigint) FROM PUBLIC;

