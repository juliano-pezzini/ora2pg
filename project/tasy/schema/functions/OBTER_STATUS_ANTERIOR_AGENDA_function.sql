-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_anterior_agenda ( nr_seq_agenda_p bigint, ie_status_agenda_p text) RETURNS varchar AS $body$
DECLARE


dt_acao_w		timestamp;
ie_status_agenda_w	varchar(15);
ie_status_agenda_ww	varchar(15) := null;

c01 CURSOR FOR
	SELECT	dt_acao,
		ie_status_agenda
	from	agenda_historico_acao
	where	nr_seq_agenda = nr_seq_agenda_p
	and	(ie_status_agenda IS NOT NULL AND ie_status_agenda::text <> '')
	and	dt_acao < (	SELECT	max(dt_acao)
				from	agenda_historico_acao
				where	nr_seq_agenda		= nr_seq_agenda_p
				and	ie_status_agenda	= ie_status_agenda_p)
	order by dt_acao;


BEGIN

open c01;
loop
fetch c01 into
	dt_acao_w,
	ie_status_agenda_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_status_agenda_ww := ie_status_agenda_w;
	end;
end loop;
close c01;

return	ie_status_agenda_ww;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_anterior_agenda ( nr_seq_agenda_p bigint, ie_status_agenda_p text) FROM PUBLIC;
