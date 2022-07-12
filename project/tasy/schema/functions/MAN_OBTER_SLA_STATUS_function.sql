-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_sla_status ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


cd_estabelecimento_w	smallint;
ie_tempo_w		varchar(15);
dt_inicio_w		timestamp;
dt_inicio_termino_w	timestamp;
qt_min_termino_w	bigint;
qt_min_inicio_w		bigint;
ds_retorno_w		varchar(255);
dt_metade_termino_w	timestamp;

/* ds_retorno_w
'S' = Sem início
'I' = Iniciado
'P' = Próximo do desvio
'D' = Desvio ultrapassado*/
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
	where	nr_sequencia	= nr_sequencia_p;

	if (ie_tempo_w = 'COR') then
		dt_inicio_termino_w	:= dt_inicio_w + (qt_min_termino_w / 1440);
	else
		dt_inicio_termino_w	:= man_obter_hor_com(cd_estabelecimento_w, dt_inicio_w, qt_min_termino_w);
	end if;

	dt_metade_termino_w	:= dt_inicio_termino_w - ((obter_min_entre_datas(dt_inicio_w,dt_inicio_termino_w,1) * 0.5)/1440);

	if (dt_inicio_termino_w <= clock_timestamp()) then /* SLA desvio ultrapassado*/
		ds_retorno_w := 'D';
	elsif (clock_timestamp() >= dt_metade_termino_w)  then /* SLA próximo do desvio*/
		ds_retorno_w := 'P';
	elsif (dt_inicio_termino_w >= clock_timestamp()) then /*SLA Iniciado*/
		ds_retorno_w := 'I';
	elsif (coalesce(dt_inicio_termino_w::text, '') = '') then /*SLA Sem início*/
		ds_retorno_w := 'S';
	end if;

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_sla_status ( nr_sequencia_p bigint) FROM PUBLIC;

