-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_regra_usuario_padrao () RETURNS varchar AS $body$
DECLARE


ds_retorno_p	varchar(1);


BEGIN

select	coalesce(max(IE_TIPO_REGRA),'N')
into STRICT	ds_retorno_p
from	REGRA_PADRAO_USUARIO
where	ie_situacao = 'A';

return ds_retorno_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_regra_usuario_padrao () FROM PUBLIC;

