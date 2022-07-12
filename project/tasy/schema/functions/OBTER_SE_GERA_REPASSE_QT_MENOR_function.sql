-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gera_repasse_qt_menor (nr_seq_propaci_p bigint, qt_proced_p bigint, cd_area_proced_p bigint) RETURNS bigint AS $body$
DECLARE

cd_medico_executor_w	varchar(10);
qt_procedimento_area_w	integer;
nr_interno_conta_w	bigint;


BEGIN

/*	0 - Gera repasse
	1 - Não gera
*/
select 	max(cd_medico_executor),
	max(nr_interno_conta)
into STRICT	cd_medico_executor_w,
	nr_interno_conta_w
from 	procedimento_paciente
where nr_sequencia = nr_seq_propaci_p;

qt_procedimento_area_w := 0;

if (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') then

	select 	coalesce(sum(qt_procedimento),0)
	into STRICT	qt_procedimento_area_w
	from	procedimento_paciente
	where	cd_medico_executor = cd_medico_executor_w
	and	obter_area_procedimento(cd_procedimento,ie_origem_proced) = cd_area_proced_p
	and	trunc(dt_procedimento,'month') = trunc(clock_timestamp(),'month')
	and	nr_interno_conta <= nr_interno_conta_w;

end if;

if (qt_procedimento_area_w >= qt_proced_p) then
	return 1;
else
	return 0;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gera_repasse_qt_menor (nr_seq_propaci_p bigint, qt_proced_p bigint, cd_area_proced_p bigint) FROM PUBLIC;
