-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_dados_campo ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		double precision;
qt_dose_diaria_w	double precision;
qt_dose_monitor_w	double precision;

/*
DD = Dose diaria
DM = Dose monitor
*/
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	coalesce(qt_dose_diaria,0),
		coalesce(qt_dose_monitor,0)
	into STRICT	qt_dose_diaria_w,
		qt_dose_monitor_w
	from	rxt_campo
	where	nr_sequencia = nr_sequencia_p;

	if (ie_opcao_p	= 'DD') then
		qt_retorno_w	:= qt_dose_diaria_w;
	elsif (ie_opcao_p	= 'DM') then
		qt_retorno_w	:= qt_dose_monitor_w;
	end if;

end if;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_dados_campo ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

