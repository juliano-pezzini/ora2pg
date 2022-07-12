-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_cpoe_proc (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_cpoe_proc_w	varchar(1) := 'N';


BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
  select	coalesce(max('S'),'N') 
	into STRICT ie_cpoe_proc_w 
	from cpoe_procedimento a 
	where a.nr_atendimento = nr_atendimento_p;
end if;
 
return	ie_cpoe_proc_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_cpoe_proc (nr_atendimento_p bigint) FROM PUBLIC;

