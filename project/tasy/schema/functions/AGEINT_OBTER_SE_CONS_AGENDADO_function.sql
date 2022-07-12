-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_cons_agendado (cd_agenda_p bigint, dt_agenda_p timestamp, cd_pessoa_fisica_p text, nr_seq_ageint_item_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1) := 'S';
qt_agenda_pac_dia_w	bigint;
nr_seq_agenda_cons_w	agenda_integrada_item.nr_seq_agenda_cons%type;
			

BEGIN

select	coalesce(max(nr_seq_agenda_cons),0)
into STRICT	nr_seq_agenda_cons_w
from	agenda_integrada_item
where	nr_sequencia = nr_seq_ageint_item_p;

select 	count(*)
into STRICT	qt_agenda_pac_dia_w
from	agenda_consulta
where	trunc(dt_agenda) between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 86399/86400
and	cd_pessoa_fisica = cd_pessoa_fisica_p
and	cd_agenda = cd_agenda_p
and	nr_sequencia	 <> nr_seq_agenda_cons_w
and	ie_status_agenda <> 'C';

if (qt_agenda_pac_dia_w > 0) then
	ie_retorno_w := 'N';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_cons_agendado (cd_agenda_p bigint, dt_agenda_p timestamp, cd_pessoa_fisica_p text, nr_seq_ageint_item_p bigint) FROM PUBLIC;

