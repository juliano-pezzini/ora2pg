-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION validate_eclipse_status (nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE


return_w varchar(1);

C01 CURSOR FOR
SELECT
  get_eclipse_claim_status(nr_interno_conta,'CLAIM') as claim,
  get_eclipse_claim_status(nr_interno_conta,'REPORT') as report
from  conta_paciente 
where nr_seq_protocolo = nr_seq_protocolo_p;

BEGIN
	return_w := 'N';
	for c1 in C01 loop
		if (return_w = 'N' and
        c1.claim like 'Completed' and 
        c1.report not like 'Completed') then 
			return_w := 'Y';
		end if;
	end loop;
	return return_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION validate_eclipse_status (nr_seq_protocolo_p bigint) FROM PUBLIC;
