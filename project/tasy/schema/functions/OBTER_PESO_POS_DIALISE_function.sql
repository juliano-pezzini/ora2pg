-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_peso_pos_dialise (cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE


qt_peso_pos_w	double precision;


BEGIN

select	max(qt_peso_pos)
into STRICT	qt_peso_pos_w
from	hd_dialise
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	nr_sequencia		= (	SELECT	max(nr_sequencia)
					from	hd_dialise
					where	cd_pessoa_fisica	= cd_pessoa_fisica_p
					and	(qt_peso_pos IS NOT NULL AND qt_peso_pos::text <> ''));

return	qt_peso_pos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_peso_pos_dialise (cd_pessoa_fisica_p text) FROM PUBLIC;

