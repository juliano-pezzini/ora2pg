-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grupo_usuario_wheb ( nm_usuario_p text) RETURNS bigint AS $body$
DECLARE



nr_seq_grupo_w	bigint;


BEGIN

select	max(a.nr_seq_grupo)
into STRICT	nr_seq_grupo_w
from	usuario_grupo_des a,
		grupo_desenvolvimento b
where	upper(a.nm_usuario_grupo) = upper(nm_usuario_p)
and 	a.nr_seq_grupo = b.nr_sequencia
and 	coalesce(b.ie_situacao,'A') = 'A';

return nr_seq_grupo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grupo_usuario_wheb ( nm_usuario_p text) FROM PUBLIC;

