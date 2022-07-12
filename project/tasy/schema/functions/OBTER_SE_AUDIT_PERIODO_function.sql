-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_audit_periodo (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


qt_audit_periodo_w	bigint;
nr_interno_conta_w	bigint;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;



BEGIN

select 	coalesce(max(nr_interno_conta),0),
	max(dt_periodo_inicial),
	max(dt_periodo_final)
into STRICT	nr_interno_conta_w,
	dt_periodo_inicial_w,
	dt_periodo_final_w
from 	auditoria_conta_paciente
where 	nr_sequencia = nr_sequencia_p;

select 	count(*)
into STRICT	qt_audit_periodo_w
from 	auditoria_conta_paciente
where 	nr_interno_conta = nr_interno_conta_w
and 	nr_sequencia <> nr_sequencia_p
and 	dt_periodo_inicial = dt_periodo_inicial_w
and 	dt_periodo_final = dt_periodo_final_w;

if (qt_audit_periodo_w > 0) then
	return	'S';
else
	return  'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_audit_periodo (nr_sequencia_p bigint) FROM PUBLIC;

