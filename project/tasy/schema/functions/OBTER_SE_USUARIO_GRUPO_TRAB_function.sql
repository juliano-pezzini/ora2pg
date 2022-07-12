-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_grupo_trab (nr_seq_grupo_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE



ie_retorno_w	varchar(1)	:= 'N';
qt_registrO_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	man_grupo_trabalho b,
	man_grupo_trab_usuario a
where	a.nr_seq_grupo_trab	= b.nr_sequencia
and	b.nr_sequencia		= nr_seq_grupo_p
and	a.nm_usuario_param	= nm_usuario_p;

if (qt_registro_w > 0) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_grupo_trab (nr_seq_grupo_p bigint, nm_usuario_p text) FROM PUBLIC;

