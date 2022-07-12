-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_des ( nm_usuario_des_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';


BEGIN
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	usuario_grupo_des a,
	grupo_desenvolvimento b,
	gerencia_wheb c
where	a.nm_usuario_grupo	= nm_usuario_des_p
and	b.nr_sequencia		= a.nr_seq_grupo
and	c.nr_sequencia		= b.nr_seq_gerencia
and	c.ie_area_gerencia	in ('DES','TEC');

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_des ( nm_usuario_des_p text) FROM PUBLIC;

