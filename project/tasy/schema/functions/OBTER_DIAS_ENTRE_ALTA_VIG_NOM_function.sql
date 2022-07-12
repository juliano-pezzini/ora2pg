-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dias_entre_alta_vig_nom ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_dias_internacao_w	double precision := 0;
dt_final_w		timestamp;
dt_alta_w		timestamp;
ds_retorno_w		bigint;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select	max(dt_final_vigencia)
	into STRICT	dt_final_w
	from	atend_categoria_convenio
	where	nr_atendimento = nr_atendimento_p;

	select	distinct
		coalesce(Obter_data_alta_Atend(nr_atendimento),clock_timestamp())
	into STRICT	dt_alta_w
	from	atend_categoria_convenio
	where	nr_atendimento = nr_atendimento_p
	and	(Obter_data_alta_Atend(nr_atendimento) IS NOT NULL AND (Obter_data_alta_Atend(nr_atendimento))::text <> '');

end if;

if (dt_alta_w > dt_final_w) then
	qt_dias_internacao_w	:= (dt_alta_w - dt_final_w);
	ds_retorno_w := lpad(to_char(trunc(qt_dias_internacao_w)),3,'0');
elsif (dt_final_w > dt_alta_w) then
	qt_dias_internacao_w	:= (dt_final_w - dt_alta_w);
	ds_retorno_w :=  lpad(to_char(trunc(qt_dias_internacao_w)),3,'0');
end if;

RETURN	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dias_entre_alta_vig_nom ( nr_atendimento_p bigint) FROM PUBLIC;

