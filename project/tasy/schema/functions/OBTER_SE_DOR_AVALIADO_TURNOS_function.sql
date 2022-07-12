-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_dor_avaliado_turnos ( nr_atendimento_p bigint, dt_sinal_vital_p timestamp ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
qt_turnos_atendimento_w	bigint;
qt_turno_avaliados_w	bigint;


BEGIN

select  	count(distinct nr_sequencia)
into STRICT	qt_turnos_atendimento_w
from	turno_Atendimento;

select 	count(distinct nr_seq_turno_atend)
into STRICT	qt_turno_avaliados_w
from	w_eis_escala_dor
where	nr_atendimento = nr_atendimento_p
and	dt_sinal_vital = dt_sinal_vital_p;

if (qt_turnos_atendimento_w = qt_turno_avaliados_w) then
	ds_retorno_w:= 'S';
else
	ds_retorno_w:= 'N';
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_dor_avaliado_turnos ( nr_atendimento_p bigint, dt_sinal_vital_p timestamp ) FROM PUBLIC;
