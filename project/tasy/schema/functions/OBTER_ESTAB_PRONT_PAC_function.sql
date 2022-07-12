-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estab_pront_pac (cd_pessoa_fisica_p text, nr_prontuario_p bigint) RETURNS bigint AS $body$
DECLARE


cd_estabelecimento_w	bigint;


BEGIN

select	a.cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	pessoa_fisica_pront_estab a
where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
and	a.nr_prontuario = nr_prontuario_p;


return	cd_estabelecimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estab_pront_pac (cd_pessoa_fisica_p text, nr_prontuario_p bigint) FROM PUBLIC;
