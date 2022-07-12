-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_sla_atrasada ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


cd_estabelecimento_w	smallint;
ie_tempo_w		varchar(15);
dt_inicio_w		timestamp;
dt_inicio_termino_w	timestamp;
qt_min_termino_w	bigint;
ds_retorno_w		varchar(1);


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	select	cd_estabelecimento,
		ie_tempo,
		dt_inicio,
		qt_min_termino
	into STRICT	cd_estabelecimento_w,
		ie_tempo_w,
		dt_inicio_w,
		qt_min_termino_w
	from	man_ordem_serv_sla
	where	nr_seq_ordem	= nr_sequencia_p;

	if (ie_tempo_w = 'COR') then
		dt_inicio_termino_w	:= dt_inicio_w + (qt_min_termino_w / 1440);
	else
		dt_inicio_termino_w	:= man_obter_hor_com(cd_estabelecimento_w, dt_inicio_w, qt_min_termino_w);
	end if;

	if (dt_inicio_termino_w < clock_timestamp()) then /* SLA atrasada */
		ds_retorno_w := 'S';
	elsif (dt_inicio_termino_w >= clock_timestamp()) then /* SLA não atrasada */
		ds_retorno_w := 'N';
	end if;

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_sla_atrasada ( nr_sequencia_p bigint) FROM PUBLIC;
