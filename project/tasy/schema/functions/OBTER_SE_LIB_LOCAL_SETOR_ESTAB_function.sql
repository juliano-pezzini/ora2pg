-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_lib_local_setor_estab ( cd_estabelecimento_p text) RETURNS varchar AS $body$
DECLARE


ie_liberado_w	varchar(1) := 'N';


BEGIN
select	coalesce(max(ie_local_setor_lib), 'N')
into STRICT	ie_liberado_w
from	parametro_estoque
where	cd_estabelecimento		= cd_estabelecimento_p;

return ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_lib_local_setor_estab ( cd_estabelecimento_p text) FROM PUBLIC;
