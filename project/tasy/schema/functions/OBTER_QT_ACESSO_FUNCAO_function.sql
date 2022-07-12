-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_acesso_funcao (cd_estabelecimento_p bigint, cd_funcao_p bigint, qt_periodo_p bigint) RETURNS bigint AS $body$
DECLARE

qt_registro_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	log_acesso_funcao
where	cd_funcao		= cd_funcao_p
and	cd_estabelecimento	= cd_estabelecimento_p
and	dt_acesso		> clock_timestamp() - qt_periodo_p;

return	qt_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_acesso_funcao (cd_estabelecimento_p bigint, cd_funcao_p bigint, qt_periodo_p bigint) FROM PUBLIC;

