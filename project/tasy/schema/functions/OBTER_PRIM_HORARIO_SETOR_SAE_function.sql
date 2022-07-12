-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prim_horario_setor_sae (cd_setor_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_prim_setor_w	timestamp;


BEGIN

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
	select	coalesce(max(coalesce(HR_INICIO_PRESCRICAO_SAE,hr_inicio_prescricao)),TO_DATE('01/01/1900 00:00:01','dd/mm/yyyy hh24:mi:ss'))
	into STRICT	dt_prim_setor_w
	from	setor_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_p;
end if;

RETURN	dt_prim_setor_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prim_horario_setor_sae (cd_setor_atendimento_p bigint) FROM PUBLIC;

