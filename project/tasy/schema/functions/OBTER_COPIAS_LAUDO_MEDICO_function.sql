-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_copias_laudo_medico (cd_medico_p text) RETURNS bigint AS $body$
DECLARE


qt_copias_w			bigint;


BEGIN

select	coalesce(max(nr_copias),0)
into STRICT	qt_copias_w
from	medico_regra_copia_laudo
where	cd_pessoa_fisica		= cd_medico_p;

return	qt_copias_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_copias_laudo_medico (cd_medico_p text) FROM PUBLIC;

