-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_feq_card_prism_md ( qt_freq_cardiaca_p bigint, ie_lactante_p text ) RETURNS bigint AS $body$
DECLARE

    qt_pto_fc_w smallint := 0;

BEGIN
if (coalesce(qt_freq_cardiaca_p::text, '') = '') then
	qt_pto_fc_w:= 0;
elsif (ie_lactante_p = 'S') and
	((qt_freq_cardiaca_p > 160) or (qt_freq_cardiaca_p <= 90)) then
	qt_pto_fc_w:= 4;
elsif (ie_lactante_p = 'S') and
	(qt_freq_cardiaca_p >= 91 AND qt_freq_cardiaca_p <= 159) then
	qt_pto_fc_w:= 0;
elsif (ie_lactante_p = 'N') and
	((qt_freq_cardiaca_p > 150) or (qt_freq_cardiaca_p <= 80)) then
	qt_pto_fc_w:= 4;
elsif (ie_lactante_p = 'N') and
	(qt_freq_cardiaca_p >= 81 AND qt_freq_cardiaca_p <= 149) then
	qt_pto_fc_w:= 0;
end if;

    RETURN qt_pto_fc_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_feq_card_prism_md ( qt_freq_cardiaca_p bigint, ie_lactante_p text ) FROM PUBLIC;

