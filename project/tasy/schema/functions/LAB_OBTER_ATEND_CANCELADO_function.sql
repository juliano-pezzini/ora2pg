-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_atend_cancelado (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_atend_cancel_w varchar(1) := 'N';

BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	select	CASE WHEN coalesce(x.dt_cancelamento::text, '') = '' THEN  'N'  ELSE 'S' END  
	into STRICT	ie_atend_cancel_w 
	from	atendimento_paciente x 
	where	x.nr_atendimento = nr_atendimento_p;
end if;
 
return	ie_atend_cancel_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_atend_cancelado (nr_atendimento_p bigint) FROM PUBLIC;

