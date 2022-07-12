-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_entrada_pas_setor (nr_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE

				 
dt_entrada_unidade_w	timestamp;
dt_entrada_w			timestamp;
ds_retorno_w			timestamp;

BEGIN
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '')	then 
	 
	select	max(dt_entrada) 
	into STRICT	dt_entrada_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
	 
	select	max(dt_entrada_unidade) 
	into STRICT	dt_entrada_unidade_w 
	from	atend_paciente_unidade 
	where	coalesce(ie_passagem_setor,'N') = 'S' 
	and		to_date(to_char(dt_entrada_unidade,'dd/mm/yyyy hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss') = to_date(to_char(dt_entrada_w,'dd/mm/yyyy hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss') 
	and		nr_atendimento = nr_atendimento_p;
 
end if;
 
if (dt_entrada_unidade_w IS NOT NULL AND dt_entrada_unidade_w::text <> '') then 
	ds_retorno_w	:= dt_entrada_unidade_w + 1/(1440*60);
else 
	ds_retorno_w := null;
end if;
	 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_entrada_pas_setor (nr_atendimento_p bigint) FROM PUBLIC;
