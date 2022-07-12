-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eme_obter_escala_trauma (nr_seq_sinal_p bigint) RETURNS bigint AS $body$
DECLARE


qt_glasgow_w		bigint;
qt_pa_sistolica_w	smallint;
qt_freq_resp_w		smallint;
qt_retorno_w		bigint;

BEGIN
select	coalesce(max(qt_glasgow),0),
	coalesce(max(qt_pa_sistolica),0),
	coalesce(max(qt_freq_resp),0)
into STRICT	qt_glasgow_w,
	qt_pa_sistolica_w,
	qt_freq_resp_w
from	eme_regul_sinal_vital
where	nr_sequencia = nr_seq_sinal_p;

/*valores 	qt_glasgow para somar na escala*/

if (qt_glasgow_w <= 3) then
	qt_glasgow_w := 0;
elsif (qt_glasgow_w between 4 and 5) then
	qt_glasgow_w := 1;
elsif (qt_glasgow_w between 6 and 8) then
	qt_glasgow_w := 2;
elsif (qt_glasgow_w between 9 and 12) then
	qt_glasgow_w := 3;
elsif (qt_glasgow_w >= 13) then
	qt_glasgow_w := 4;
end if;

/*valores pressão arterial sistólica para somar na escala*/

if (qt_pa_sistolica_w = 0) then
	qt_pa_sistolica_w := 0;
elsif (qt_pa_sistolica_w between 1 and 49) then
	qt_pa_sistolica_w := 1;
elsif (qt_pa_sistolica_w between 50 and 75) then
	qt_pa_sistolica_w := 2;
elsif (qt_pa_sistolica_w between 76 and 89) then
	qt_pa_sistolica_w := 3;
elsif (qt_pa_sistolica_w > 89) then
	qt_pa_sistolica_w := 4;
end if;

/*valores frequência respiratória*/

if (qt_freq_resp_w = 0) then
	qt_freq_resp_w := 0;
elsif (qt_freq_resp_w between 1 and 5) then
	qt_freq_resp_w := 1;
elsif (qt_freq_resp_w between 6 and 9) then
	qt_freq_resp_w := 2;
elsif (qt_freq_resp_w between 10 and 29) then
	qt_freq_resp_w := 4;
elsif (qt_freq_resp_w > 29) then
	qt_freq_resp_w := 3;
end if;

qt_retorno_w := qt_glasgow_w + qt_pa_sistolica_w + qt_freq_resp_w;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eme_obter_escala_trauma (nr_seq_sinal_p bigint) FROM PUBLIC;
