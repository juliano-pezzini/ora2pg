-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finalizar_consulta_pa ( cd_medico_p bigint, qt_horas_p bigint) AS $body$
DECLARE

 
nr_atendimento_w	bigint;
					

BEGIN 
 
if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') and (qt_horas_p IS NOT NULL AND qt_horas_p::text <> '') then 
	select	max(nr_atendimento) 
	into STRICT	nr_atendimento_w 
	from 	atendimento_ps_v 
	where 	cd_medico_resp = cd_medico_p 
	and  	dt_entrada between (clock_timestamp() - (qt_horas_p / 24)) and clock_timestamp() 
	and  	(hr_inicio_consulta IS NOT NULL AND hr_inicio_consulta::text <> '') 
	and  	coalesce(hr_fim_consulta::text, '') = '' 
	and  	coalesce(dt_alta::text, '') = '';
end if;
 
 
if (nr_atendimento_w > 0) then 
	update	atendimento_paciente 
	set	dt_fim_consulta = clock_timestamp() 
	where	nr_atendimento = nr_atendimento_w;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finalizar_consulta_pa ( cd_medico_p bigint, qt_horas_p bigint) FROM PUBLIC;
