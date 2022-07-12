-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ciclo_gerado ( nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE

qt_reg_w	bigint;

BEGIN
select	count(*)
into STRICT	qt_reg_w
from	paciente_atendimento
where	nr_seq_paciente	= nr_seq_paciente_p;

if (qt_reg_w	= 0) then
	return	'N';
else
	return 'S';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ciclo_gerado ( nr_seq_paciente_p bigint) FROM PUBLIC;

