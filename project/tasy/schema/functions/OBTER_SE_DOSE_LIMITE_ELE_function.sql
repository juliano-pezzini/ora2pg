-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_dose_limite_ele ( nr_seq_elemento_p bigint, qt_dose_p bigint) RETURNS varchar AS $body$
DECLARE

qt_max_w	double precision;
qt_min_w		double precision;
ds_retorno_w	varchar(255);

BEGIN
if (nr_seq_elemento_p IS NOT NULL AND nr_seq_elemento_p::text <> '') then
	select 	coalesce(max(qt_max),99999999999),
		coalesce(max(qt_min),0)
	into STRICT	qt_max_w,
		qt_min_w
	from	nut_elemento
	where 	nr_sequencia = nr_seq_elemento_p;
	if (((qt_max_w > 0) and (coalesce(qt_dose_p,0) > qt_max_w)) or (coalesce(qt_dose_p,0) < qt_min_w)) then
		ds_retorno_w := wheb_mensagem_pck.get_texto(309464); -- O valor informado está fora da faixa padrão deste elemento
	end if;
end if;
return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_dose_limite_ele ( nr_seq_elemento_p bigint, qt_dose_p bigint) FROM PUBLIC;
