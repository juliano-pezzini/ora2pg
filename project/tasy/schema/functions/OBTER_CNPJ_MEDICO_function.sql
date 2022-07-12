-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cnpj_medico ( cd_medico_p text, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


cd_cgc_w	varchar(14);


BEGIN

select	max(cd_cgc)
into STRICT	cd_cgc_w
from	procedimento_participante
where	cd_pessoa_fisica = cd_medico_p
and	nr_sequencia = nr_sequencia_p;


return	cd_cgc_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cnpj_medico ( cd_medico_p text, nr_sequencia_p bigint) FROM PUBLIC;
