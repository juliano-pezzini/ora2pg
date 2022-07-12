-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_atend_pac_dia ( dt_inicio_p timestamp) RETURNS bigint AS $body$
DECLARE

 
qt_total_pac_dia_w		bigint;
dt_limite_w				timestamp;

BEGIN
 
dt_limite_w := ((trunc(dt_inicio_p,'dd') + 1) - 1/24/60/60);
 
select	count(distinct nr_atendimento) 
into STRICT	qt_total_pac_dia_w 
from	resumo_atendimento_paciente_v 
where	trunc(dt_entrada) <= trunc(dt_inicio_p) 
and		coalesce(dt_alta, fim_dia(dt_inicio_p)) >= dt_limite_w;
 
return	qt_total_pac_dia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_atend_pac_dia ( dt_inicio_p timestamp) FROM PUBLIC;

