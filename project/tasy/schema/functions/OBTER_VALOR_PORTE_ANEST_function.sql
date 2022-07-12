-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_porte_anest ( cd_edicao_amb_p bigint, nr_porte_anestesico_p bigint, dt_inicio_vigencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision;


BEGIN

begin
select	max(coalesce(a.vl_porte_anestesico,0))
into STRICT	vl_retorno_w
from	porte_anestesico a
where	a.cd_edicao_amb 		= cd_edicao_amb_p
and	a.nr_porte_anestesico 	= nr_porte_anestesico_p
and	a.dt_inicio_vigencia		= (SELECT max(a.dt_inicio_vigencia)
					   from	porte_anestesico b
					   where a.cd_edicao_amb = b.cd_edicao_amb
					   and	a.nr_porte_anestesico = b.nr_porte_anestesico
					   and	b.dt_inicio_vigencia <= dt_inicio_vigencia_p);
exception
when others then
	vl_retorno_w := 0;
end;


return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_porte_anest ( cd_edicao_amb_p bigint, nr_porte_anestesico_p bigint, dt_inicio_vigencia_p timestamp) FROM PUBLIC;
