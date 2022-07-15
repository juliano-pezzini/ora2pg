-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_status_nr_atend_cirur ( nr_cirurgia_p bigint, nr_atendimento_p INOUT bigint, ie_status_cirurgia_p INOUT text) AS $body$
DECLARE


ie_status_cirurgia_w 	varchar(5);
nr_atendimento_w	bigint;


BEGIN
if (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then
	begin
	select	max(ie_status_cirurgia)
	into STRICT	ie_status_cirurgia_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;

	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	agenda_paciente
	where	nr_cirurgia = nr_cirurgia_p;
	end;
end if;

ie_status_cirurgia_p 	:= ie_status_cirurgia_w;
nr_atendimento_p		:= nr_atendimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_status_nr_atend_cirur ( nr_cirurgia_p bigint, nr_atendimento_p INOUT bigint, ie_status_cirurgia_p INOUT text) FROM PUBLIC;

