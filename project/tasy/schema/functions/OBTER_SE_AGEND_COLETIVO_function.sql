-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agend_coletivo ( nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';


BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	select	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from	agenda_consulta
	where	nr_sequencia = nr_seq_agenda_p
	and	ie_agend_coletivo = 'S'
	and	coalesce(cd_pessoa_fisica::text, '') = '';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agend_coletivo ( nr_seq_agenda_p bigint) FROM PUBLIC;

