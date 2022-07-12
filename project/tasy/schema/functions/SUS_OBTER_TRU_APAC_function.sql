-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_tru_apac ( qt_ureia_pre_hemo_p sus_apac_unif.qt_ureia_pre_hemo%type, qt_ureia_pos_hemo_p sus_apac_unif.qt_ureia_pos_hemo%type) RETURNS SUS_APAC_UNIF.NR_TRU%TYPE AS $body$
DECLARE


nr_retorno_w	sus_apac_unif.nr_tru%type := null;
/*
TRU = (((Uréia pré-hemodiálise (mg/dl) - Uréia pós-hemodiálise (mg/dl)) / Uréia pré-hemodiálise (mg/dl)) * 100)
*/
BEGIN

if (qt_ureia_pre_hemo_p IS NOT NULL AND qt_ureia_pre_hemo_p::text <> '') and (qt_ureia_pos_hemo_p IS NOT NULL AND qt_ureia_pos_hemo_p::text <> '') then
	begin

	nr_retorno_w := (((qt_ureia_pre_hemo_p - qt_ureia_pos_hemo_p) / qt_ureia_pre_hemo_p) * 100);

	end;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_tru_apac ( qt_ureia_pre_hemo_p sus_apac_unif.qt_ureia_pre_hemo%type, qt_ureia_pos_hemo_p sus_apac_unif.qt_ureia_pos_hemo%type) FROM PUBLIC;
