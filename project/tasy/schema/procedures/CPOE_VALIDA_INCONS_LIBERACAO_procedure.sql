-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_valida_incons_liberacao (nr_prescricao_p bigint, nr_atendimento_p bigint, nm_usuario_p text, ie_consistencias_p INOUT text) AS $body$
DECLARE

 
ie_consis_inconsis_prescr_w	char(1);
ie_inconsistency_w			integer;


BEGIN 
 
ie_consistencias_p := '';
 
select	count(*) 
into STRICT	ie_inconsistency_w 
from	cpoe_inconsistency 
where	nr_atendimento	= nr_atendimento_p 
and	nm_usuario	= nm_usuario_p;
 
if (coalesce(ie_inconsistency_w,0) > 0) then 
	 
	select max(coalesce('S','N')) 
	into STRICT ie_consis_inconsis_prescr_w 
	from cpoe_inconsistency 
	where nr_atendimento = nr_atendimento_p 
	and	nm_usuario = nm_usuario_p 
	and coalesce(ie_libera,'0') = 'N';
 
	if (coalesce(ie_consis_inconsis_prescr_w,'N') = 'S') then 
		CALL cpoe_delete_prescription(nr_prescricao_p,'');	
		ie_consistencias_p := 'N';
	else 
		select max(coalesce('S','N')) 
		into STRICT ie_consis_inconsis_prescr_w 
		from cpoe_inconsistency 
		where nr_atendimento = nr_atendimento_p 
		and	nm_usuario	= nm_usuario_p 
		and coalesce(ie_libera,'0') = 'S';
 
		if (coalesce(ie_consis_inconsis_prescr_w,'N') = 'S') then 
			ie_consistencias_p := 'S';
		end if;		
	end if;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_valida_incons_liberacao (nr_prescricao_p bigint, nr_atendimento_p bigint, nm_usuario_p text, ie_consistencias_p INOUT text) FROM PUBLIC;
