-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_adm_protocolo (nr_seq_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retono_w	varchar(5);
ie_local_w	varchar(5);


BEGIN
if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then
	select 	max(ie_local_adm)
	into STRICT	ie_local_w
	from	paciente_atend_medic
	where	nr_seq_atendimento = nr_seq_atendimento_p;

	if (ie_local_w = 'C') then
		ds_retono_w 	:= 	1;
	elsif (ie_local_w = 'D') then
		ds_retono_w 	:= 	2;
	elsif (ie_local_w = 'H') then
		ds_retono_w 	:= 	3;
	end if;
end if;

return	ds_retono_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_adm_protocolo (nr_seq_atendimento_p bigint) FROM PUBLIC;

