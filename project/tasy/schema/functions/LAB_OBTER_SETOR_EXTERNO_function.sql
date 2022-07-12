-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_setor_externo (cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_setor_externo_w	varchar(10);


BEGIN
if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
	select 	MAX(cd_setor_externo)
	into STRICT 	cd_setor_externo_w
	from 	setor_atendimento
	where 	cd_setor_atendimento = cd_setor_atendimento_p;
end if;

return	cd_setor_externo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_setor_externo (cd_setor_atendimento_p bigint) FROM PUBLIC;

