-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_classe_tp_usuario (nr_seq_classe_p bigint, nm_usuario_p text, ie_tipo_titulo_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(255);
cd_perfil_w	bigint;

c01 CURSOR FOR
SELECT	ie_liberado
from	classe_tit_pagar_usuario
where	nr_seq_classe				= nr_seq_classe_p
and	coalesce(nm_usuario_lib, nm_usuario_p) 	= nm_usuario_p
and	coalesce(cd_perfil, coalesce(cd_perfil_w,0))	= coalesce(cd_perfil_w,0)
and	coalesce(ie_tipo_titulo,coalesce(ie_tipo_titulo_p,'X'))	= coalesce(ie_tipo_titulo_p,'X')
order	by CASE WHEN coalesce(nm_usuario_lib::text, '') = '' THEN  1  ELSE 2 END ,
	coalesce(cd_perfil, 0),
	coalesce(ie_tipo_titulo,'X');


BEGIN

cd_perfil_w		:= obter_perfil_ativo;

ie_retorno_w	:= 'S';
open c01;
loop
fetch c01 into
	ie_retorno_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_classe_tp_usuario (nr_seq_classe_p bigint, nm_usuario_p text, ie_tipo_titulo_p text) FROM PUBLIC;

