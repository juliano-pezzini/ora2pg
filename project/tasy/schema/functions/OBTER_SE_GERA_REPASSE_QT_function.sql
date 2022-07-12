-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gera_repasse_qt (nr_seq_propaci_p bigint, qt_proced_p bigint, cd_area_proced_p bigint, hr_inicial_p text, hr_final_p text) RETURNS bigint AS $body$
DECLARE


cd_medico_executor_w		varchar(10);
qt_procedimento_area_w		integer;
nr_interno_conta_w		bigint;
dt_procedimento_w   		timestamp;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
ds_retorno_w			smallint;


BEGIN

/*	0 - Gera repasse
	1 - Não gera
*/
select 	max(cd_medico_executor),
	max(nr_interno_conta),
	max(dt_procedimento)
into STRICT	cd_medico_executor_w,
	nr_interno_conta_w,
	dt_procedimento_w
from 	procedimento_paciente
where 	nr_sequencia = nr_seq_propaci_p;

dt_inicial_w		:= TO_DATE(TO_CHAR(dt_procedimento_w,'dd/mm/yyyy') || ' ' || coalesce(hr_inicial_p,'00:00:00'),'dd/mm/yyyy hh24:mi:ss');
dt_final_w		:= TO_DATE(TO_CHAR(dt_procedimento_w,'dd/mm/yyyy') || ' ' || coalesce(hr_final_p,'23:59:59'),'dd/mm/yyyy hh24:mi:ss');

qt_procedimento_area_w := 0;

if (dt_procedimento_w >= dt_inicial_w) and (dt_procedimento_w <= dt_final_w) then

	if (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') then

		select 	coalesce(sum(qt_procedimento),0)
		into STRICT	qt_procedimento_area_w
		from	procedimento_paciente
		where	cd_medico_executor = cd_medico_executor_w
		and	obter_area_procedimento(cd_procedimento,ie_origem_proced) = cd_area_proced_p
		and	dt_procedimento between dt_inicial_w and dt_procedimento_w
		and	nr_interno_conta <= nr_interno_conta_w;

	end if;

	if (qt_procedimento_area_w < qt_proced_p) then
		ds_retorno_w := 0;
	else
		ds_retorno_w := 1;
	end if;
else
	ds_retorno_w := 1;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gera_repasse_qt (nr_seq_propaci_p bigint, qt_proced_p bigint, cd_area_proced_p bigint, hr_inicial_p text, hr_final_p text) FROM PUBLIC;

