-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_consulta_agequi (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'N';


BEGIN


begin
select	'S'
into STRICT	ie_retorno_w
from	agenda_quimio
where	nr_seq_agenda_cons = nr_seq_agenda_p  LIMIT 1;
exception
when others then
	ie_retorno_w := 'N';
end;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_consulta_agequi (nr_seq_agenda_p bigint) FROM PUBLIC;
