-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conta_pacote (nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_resultado_w		varchar(01);


BEGIN 
 
select	coalesce(max('S'),'N') 
into STRICT	ie_resultado_w 
from 	conta_paciente_v 
where 	(nr_seq_proc_pacote IS NOT NULL AND nr_seq_proc_pacote::text <> '') 
and 	nr_interno_conta = nr_interno_conta_p;
 
return ie_resultado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conta_pacote (nr_interno_conta_p bigint) FROM PUBLIC;
