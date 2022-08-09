-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_alt_status_ag ( ie_status_agenda_p text, ds_retorno_p INOUT text) AS $body$
DECLARE



ie_status_agenda_w	varchar(2);

C01 CURSOR FOR
	SELECT	max(ie_status_agenda)
	from	agenda_regra_alt_status
	where	ie_situacao		= 'A'
	and	ie_status_agenda	= ie_status_agenda_p
	order by 1;


BEGIN

if (ie_status_agenda_p IS NOT NULL AND ie_status_agenda_p::text <> '')then
	open C01;
	loop
	fetch C01 into
		ie_status_agenda_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_status_agenda_w IS NOT NULL AND ie_status_agenda_w::text <> '')then
			ds_retorno_p	:= ie_status_agenda_w;
		end if;
		end;
	end loop;
	close C01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_alt_status_ag ( ie_status_agenda_p text, ds_retorno_p INOUT text) FROM PUBLIC;
