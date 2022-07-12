-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION has_locator_configuration ( nr_seq_localizador_p bigint, nm_atributo_p text) RETURNS varchar AS $body$
DECLARE


qt_records_w	bigint;
ds_return_w	varchar(1) := 'N'; --No
BEGIN

select  count(*)
into STRICT    qt_records_w
from    locator_column_rule a,
        tipo_localizar_atributo b
where   a.nr_seq_atributo = b.nr_sequencia
and (b.nm_atributo = nm_atributo_p or coalesce(nm_atributo_p::text, '') = '')
and	b.nr_seq_tipo_localizar = nr_seq_localizador_p;

if (qt_records_w > 0) then
	ds_return_w := 'Y'; --Yes
end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION has_locator_configuration ( nr_seq_localizador_p bigint, nm_atributo_p text) FROM PUBLIC;
