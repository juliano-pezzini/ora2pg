-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION same_obter_pendencia_documento (nr_seq_documento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w	varchar(255);


BEGIN

if (nr_seq_documento_p IS NOT NULL AND nr_seq_documento_p::text <> '') then

	select	max(a.ds_pendencia)
	into STRICT	ds_resultado_w
	from  	same_pendencia a
	where	a.nr_sequencia = nr_seq_documento_p;

end if;

return	ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION same_obter_pendencia_documento (nr_seq_documento_p bigint) FROM PUBLIC;

