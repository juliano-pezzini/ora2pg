-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_seq_protocolo ( nr_interno_conta_p bigint) RETURNS bigint AS $body$
DECLARE

nr_protocolo_w	bigint;

BEGIN
 
if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then	 
	select	max(nr_seq_protocolo) 
	into STRICT	nr_protocolo_w 
	from	conta_paciente 
	where 	nr_interno_conta = nr_interno_conta_p;
end if;
 
return	nr_protocolo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_seq_protocolo ( nr_interno_conta_p bigint) FROM PUBLIC;

