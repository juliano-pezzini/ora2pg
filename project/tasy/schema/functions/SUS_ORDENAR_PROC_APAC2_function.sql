-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_ordenar_proc_apac2 (nr_interno_conta_p bigint, cd_procedimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_procedimento_w  		bigint;
ie_origem_proced_w  		smallint;
cd_procedimento_apac_w    	bigint;
ie_origem_proc_apac_w    	bigint;
nr_ordem_w      		integer;


BEGIN 
 
select	c.cd_procedimento, 
	c.ie_origem_proced 
into STRICT	cd_procedimento_apac_w, 
	ie_origem_proc_apac_w 
from	sus_apac_unif      c, 
   	conta_paciente     b 
where  c.nr_interno_conta   = nr_interno_conta_p 
and 	b.nr_interno_conta   = c.nr_interno_conta;
 
if (cd_procedimento_p   = cd_procedimento_apac_w) then 
   nr_ordem_w   := 1;
else 
   nr_ordem_w   := 2;
end if;
 
return    nr_ordem_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_ordenar_proc_apac2 (nr_interno_conta_p bigint, cd_procedimento_p bigint) FROM PUBLIC;

