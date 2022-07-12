-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_maior_vig_simpro (cd_simpro_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_vigencia_w	timestamp;
cd_estab_simpro_w	estabelecimento.cd_estabelecimento%type;


BEGIN

cd_estab_simpro_w := wheb_usuario_pck.get_cd_estabelecimento;

select 	max(dt_vigencia)
into STRICT	dt_vigencia_w
from 	simpro_preco
where 	cd_simpro = cd_simpro_p
and	coalesce(cd_estabelecimento, coalesce(cd_estab_simpro_w, 0)) = coalesce(cd_estab_simpro_w, 0);

return	dt_vigencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_maior_vig_simpro (cd_simpro_p bigint) FROM PUBLIC;

