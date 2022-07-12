-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_agen_espera ( nr_seq_lista_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (nr_seq_lista_p IS NOT NULL AND nr_seq_lista_p::text <> '') 	then

	select 	max(substr(OBTER_STATUS_AGENDA_PACIENTE(nr_sequencia),1,255))
	into STRICT	ds_retorno_w
	from	agenda_paciente
	where	nr_seq_lista	=	nr_seq_lista_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_agen_espera ( nr_seq_lista_p bigint) FROM PUBLIC;

