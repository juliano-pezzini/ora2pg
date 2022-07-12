-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_contab_pf ( cd_empresa_p bigint, cd_pessoa_fisica_p text, ie_tipo_p text, dt_vigencia_p timestamp, cd_estabelecimento_p bigint default 0) RETURNS varchar AS $body$
DECLARE


cd_conta_contabil_w		varchar(40);

c01 CURSOR FOR
SELECT	cd_conta_contabil
from	pessoa_fisica_conta_ctb
where	cd_empresa		= cd_empresa_p
and	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	ie_tipo_conta		= ie_tipo_p
and (cd_estabelecimento_p = 0 or coalesce(cd_estabelecimento, 0)	= cd_estabelecimento_p)
and (coalesce(dt_inicio_vigencia, dt_vigencia_p) <= dt_vigencia_p and coalesce(dt_fim_vigencia, dt_vigencia_p) >= dt_vigencia_p)
order by dt_inicio_vigencia;


BEGIN

OPEN C01;
LOOP
FETCH C01 into
	cd_conta_contabil_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

end loop;
close c01;

RETURN cd_conta_contabil_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_contab_pf ( cd_empresa_p bigint, cd_pessoa_fisica_p text, ie_tipo_p text, dt_vigencia_p timestamp, cd_estabelecimento_p bigint default 0) FROM PUBLIC;
