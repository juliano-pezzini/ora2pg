-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_tipo_tratamento (nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_trat_w	varchar(5);


BEGIN
if (nr_seq_tipo_p IS NOT NULL AND nr_seq_tipo_p::text <> '') then

	select	max(ie_tipo)
	into STRICT	ie_tipo_trat_w
	from	rxt_tipo
	where	nr_sequencia = nr_seq_tipo_p;

end if;

return ie_tipo_trat_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_tipo_tratamento (nr_seq_tipo_p bigint) FROM PUBLIC;

