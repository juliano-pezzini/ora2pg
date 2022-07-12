-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mostra_agenda_multi ( nr_seq_agenda_p bigint, ie_tipo_profissional_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'N';
qt_registro_w		bigint	:= 0;


BEGIN

begin
select	count(*)
into STRICT	qt_registro_w
from	agenda_consulta_prof
where	nr_seq_agenda		= nr_seq_agenda_p
and	ie_tipo_profissional	= ie_tipo_profissional_p;
exception
	when others then
	qt_registro_w		:= 0;
end;

if (qt_registro_w > 0) then

	ie_retorno_w		:= 'S';

end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mostra_agenda_multi ( nr_seq_agenda_p bigint, ie_tipo_profissional_p text) FROM PUBLIC;
