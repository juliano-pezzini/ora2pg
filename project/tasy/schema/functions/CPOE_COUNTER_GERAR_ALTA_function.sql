-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_counter_gerar_alta ( nr_atendimento_p atendimento_paciente.nr_atendimento%type ) RETURNS integer AS $body$
DECLARE

	qt_reg_cpoe_w	integer;
	nr_atendimento_w atendimento_paciente.nr_atendimento%type not null := nr_atendimento_p;

BEGIN
	select sum(counter)
	into STRICT	qt_reg_cpoe_w
	from (
		SELECT	count(*) counter
		from	cpoe_material
		where	nr_atendimento = nr_atendimento_w
		and     ((case dt_lib_suspensao when null then coalesce(dt_fim_cih,dt_fim) else coalesce(dt_suspensao,dt_fim) end > clock_timestamp())
		or (case dt_lib_suspensao when null then coalesce(dt_fim_cih,dt_fim) else coalesce(dt_suspensao,dt_fim) coalesce(end::text, '') = ''))
		
union

		SELECT	count(*) counter
		from	cpoe_recomendacao
		where	nr_atendimento = nr_atendimento_w
		and		((case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) end > clock_timestamp())
		or (case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) coalesce(end::text, '') = ''))
		
union

		select	count(*) counter
		from	cpoe_gasoterapia
		where	nr_atendimento = nr_atendimento_w
		and		((case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) end > clock_timestamp())
		or (case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) coalesce(end::text, '') = ''))
		
union

		select	count(*) counter
		from	cpoe_procedimento
		where	nr_atendimento = nr_atendimento_w
		and		((case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) end > clock_timestamp())
		or (case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) coalesce(end::text, '') = ''))
		
union

		select	count(*) counter
		from	cpoe_dialise
		where	nr_atendimento = nr_atendimento_w
		and		((case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) end > clock_timestamp())
		or (case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) coalesce(end::text, '') = ''))
		
union

		select	count(*) counter
		from	cpoe_hemoterapia
		where	nr_atendimento = nr_atendimento_w
		and		((case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) end > clock_timestamp())
		or (case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) coalesce(end::text, '') = ''))
		
union

		select	count(*) counter
		from	cpoe_dieta
		where	nr_atendimento = nr_atendimento_w
		and		((case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) end > clock_timestamp())
		or (case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) coalesce(end::text, '') = ''))
		
union
 
		select	count(*) counter
		from	cpoe_anatomia_patologica
		where	nr_atendimento = nr_atendimento_w
		and		((case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) end > clock_timestamp())
		or (case dt_lib_suspensao when null then dt_fim else coalesce(dt_suspensao,dt_fim) coalesce(end::text, '') = ''))
		) alias67;

	return qt_reg_cpoe_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_counter_gerar_alta ( nr_atendimento_p atendimento_paciente.nr_atendimento%type ) FROM PUBLIC;
