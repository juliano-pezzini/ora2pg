-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agenda_serv_prof ( nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ie_profissional_w varchar(1);


BEGIN

if (nr_seq_agenda_P is not  null) then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT 	ie_profissional_w
	from 	agenda_consulta_prof
	where 	nr_seq_agenda 	= nr_seq_agenda_p;
end if;

return ie_profissional_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agenda_serv_prof ( nr_seq_agenda_p bigint) FROM PUBLIC;
