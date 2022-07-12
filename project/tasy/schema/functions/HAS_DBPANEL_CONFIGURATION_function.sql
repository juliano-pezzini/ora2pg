-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION has_dbpanel_configuration ( nm_tabela_p text, nr_seq_visao_p bigint, nm_atributo_p text) RETURNS varchar AS $body$
DECLARE


qt_records_w	bigint;
ds_return_w	varchar(1) := 'N'; --No
BEGIN

select  sum(amount)
into STRICT    qt_records_w
from (
        SELECT  count(*) amount
        from    tabela_atrib_regra a
        where   a.nm_tabela = nm_tabela_p
        and (
                        a.nr_seq_visao = nr_seq_visao_p or
                        coalesce(nr_seq_visao_p::text, '') = '' or
			coalesce(a.nr_seq_visao::text, '') = ''
                )
        and (
                        a.nm_atributo = nm_atributo_p or
                        coalesce(nm_atributo_p::text, '') = ''
                )

union

        SELECT  count(*) amount
        from    tabela_crud_param a
        where   a.nm_tabela = nm_tabela_p
        and (
                        a.nr_seq_visao = nr_seq_visao_p or
                        coalesce(nr_seq_visao_p::text, '') = ''
                )
        and     coalesce(nm_atributo_p::text, '') = ''
) alias11;

if (qt_records_w > 0) then
	ds_return_w := 'Y'; --Yes
end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION has_dbpanel_configuration ( nm_tabela_p text, nr_seq_visao_p bigint, nm_atributo_p text) FROM PUBLIC;

