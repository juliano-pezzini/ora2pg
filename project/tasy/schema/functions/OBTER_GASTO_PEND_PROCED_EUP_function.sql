-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_gasto_pend_proced_eup ( nr_atendimento_p bigint, ie_filtra_dt_exec_p text, dt_alta_p timestamp) RETURNS varchar AS $body$
DECLARE

 
qt_prescr_w		double precision;
ie_pendente_w		varchar(1)	:= 'N';


BEGIN 
 
select	count(*) 
into STRICT	qt_prescr_w 
from	prescr_proced_pend_eup_v 
where	nr_atendimento = nr_atendimento_p 
and	(coalesce(dt_liberacao, dt_liberacao_medico) IS NOT NULL AND (coalesce(dt_liberacao, dt_liberacao_medico))::text <> '') 
and	((ie_filtra_dt_exec_p = 'N') or (ie_filtra_dt_exec_p = 'S' AND dt_prev_execucao < dt_alta_p));
 
if (qt_prescr_w <> 0) then 
	ie_pendente_w	:= 'S';
end if;
 
return ie_pendente_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_gasto_pend_proced_eup ( nr_atendimento_p bigint, ie_filtra_dt_exec_p text, dt_alta_p timestamp) FROM PUBLIC;

