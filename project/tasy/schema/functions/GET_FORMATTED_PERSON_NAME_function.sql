-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_formatted_person_name ( cd_pessoa_fisica_p text, ds_format_p text default 'full', cd_establishment_p bigint default null) RETURNS varchar AS $body$
DECLARE


formatted_name_w	varchar(255);
nr_seq_person_name_w	person_name.nr_sequencia%type;
establishment_w		estabelecimento.cd_estabelecimento%type;


BEGIN

establishment_w := coalesce(cd_establishment_p, obter_estabelecimento_ativo);

select	max(nr_seq_person_name)
into STRICT	nr_seq_person_name_w
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

formatted_name_w := pkg_name_utils.get_person_name(nr_seq_person_name_w, establishment_w, ds_format_p);

return formatted_name_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_formatted_person_name ( cd_pessoa_fisica_p text, ds_format_p text default 'full', cd_establishment_p bigint default null) FROM PUBLIC;

