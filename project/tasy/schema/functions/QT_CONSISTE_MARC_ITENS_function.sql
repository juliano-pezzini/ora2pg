-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_consiste_marc_itens ( nr_seq_pedencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'S';

BEGIN
if (coalesce(nr_seq_pedencia_p,0) > 0) then

	select	CASE WHEN count(*)=0 THEN  'S'  ELSE 'N' END
	into STRICT	ds_retorno_w
	from	agenda_quimio_marcacao x
	where	x.nr_seq_pend_agenda = nr_seq_pedencia_p
	and	coalesce(IE_GERADO,'N') = 'N';

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_consiste_marc_itens ( nr_seq_pedencia_p bigint) FROM PUBLIC;

