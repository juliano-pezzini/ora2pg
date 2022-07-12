-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_grupo ( nr_grupo_usuario_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_grupo_w		bigint;
ds_result_w		varchar(1);

C01 CURSOR FOR
SELECT	nr_seq_grupo
from	usuario_grupo
where	nm_usuario_grupo = nm_usuario_p;


BEGIN
ds_result_w	:= 'N';

if (nr_grupo_usuario_p IS NOT NULL AND nr_grupo_usuario_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '')then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_result_w
	from	usuario_grupo
	where	nm_usuario_grupo = nm_usuario_p
	and	nr_seq_grupo	= nr_grupo_usuario_p;
end if;

Return ds_result_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_grupo ( nr_grupo_usuario_p text, nm_usuario_p text) FROM PUBLIC;
