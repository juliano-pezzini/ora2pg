-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_atendimento_prescr (nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE

			 
ie_tipo_atendimento_w	smallint;
			

BEGIN 
 
select	max(a.ie_tipo_atendimento) 
into STRICT	ie_tipo_atendimento_w 
from	atendimento_paciente a, 
	prescr_medica p 
where	a.nr_atendimento 	= p.nr_atendimento 
and	p.nr_prescricao 	= nr_prescricao_p;
 
return	ie_tipo_atendimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_atendimento_prescr (nr_prescricao_p bigint) FROM PUBLIC;

