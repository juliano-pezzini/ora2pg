-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_discharge_special ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_special_discharge_w	varchar(1);

 

BEGIN 
 
select	coalesce(max(b.IE_ALTA_ESPECIAL), 'N') 
into STRICT	ie_special_discharge_w 
from	motivo_alta		b, 
	atendimento_paciente	a 
WHERE	a.nr_atendimento	= nr_atendimento_p 
AND	a.cd_motivo_alta	= b.cd_motivo_alta;
 
 
return	ie_special_discharge_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_discharge_special ( nr_atendimento_p bigint) FROM PUBLIC;

