-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_prof_item ( nr_seq_agenda_item_p bigint, cd_medico_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'S';
qt_prof_item_w		integer;
qt_prof_item_lib_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_prof_item_w
from	agenda_integrada_prof_item
where	nr_seq_agenda_item	= nr_seq_agenda_item_p;

if (qt_prof_item_w > 0) then
	select	count(*)
	into STRICT	qt_prof_item_w
	from	agenda_integrada_prof_item
	where	nr_seq_Agenda_item	= nr_seq_agenda_item_p
	and	cd_pessoa_fisica	= cd_medico_p;

	if (qt_prof_item_w > 0) then
		ds_Retorno_w	:= 'S';
	else
		ds_Retorno_w	:= 'N';
	end if;
elsif (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
	select	count(*)
	into STRICT	qt_prof_item_lib_w
	from	ageint_medico_item
	where	cd_pessoa_fisica	= cd_medico_p
	and	nr_seq_item		= nr_seq_agenda_item_p;

	/*if	(qt_prof_item_lib_w	= 0) then
		ds_retorno_w	:= 'A';
	else
		ds_retorno_w	:= 'S';
	end if;*/
	if (qt_prof_item_lib_w	> 0) then
		ds_retorno_w	:= 'S';
	end if;
else
	ds_Retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_prof_item ( nr_seq_agenda_item_p bigint, cd_medico_p text) FROM PUBLIC;
