-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nascimento_prescricao (nr_prescricao_p bigint) RETURNS timestamp AS $body$
DECLARE


cd_recem_nato_w	varchar(10);
ie_recem_nato_w	varchar(1);
cd_pessoa_fisica_w	varchar(10);
nr_atendimento_w	bigint;

dt_retorno_w		timestamp;


BEGIN

select cd_recem_nato,
	ie_recem_nato,
	cd_pessoa_fisica,
	nr_atendimento
into STRICT	cd_recem_nato_w,
	ie_recem_nato_w,
	cd_pessoa_fisica_w,
	nr_atendimento_w
from prescr_medica
where nr_prescricao = nr_prescricao_p;

dt_retorno_w	:= null;

if (cd_recem_nato_w IS NOT NULL AND cd_recem_nato_w::text <> '') then
	select dt_nascimento
	into STRICT dt_retorno_w
	from pessoa_fisica
	where cd_pessoa_fisica = cd_recem_nato_w;
elsif (ie_recem_nato_w = 'S') then
	select dt_entrada
	into STRICT dt_retorno_w
	from atendimento_paciente
	where nr_atendimento = nr_atendimento_w;
else
	select dt_nascimento
	into STRICT dt_retorno_w
	from pessoa_fisica
	where cd_pessoa_fisica = cd_pessoa_fisica_w;
end if;

return dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nascimento_prescricao (nr_prescricao_p bigint) FROM PUBLIC;

