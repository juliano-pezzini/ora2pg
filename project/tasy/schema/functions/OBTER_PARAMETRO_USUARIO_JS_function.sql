-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_parametro_usuario_js ( cd_funcao_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


vl_parametro_w		varchar(255) := '';


BEGIN

vl_parametro_w := obter_param_usuario(cd_funcao_p, nr_sequencia_p, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, vl_parametro_w);

return vl_parametro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_parametro_usuario_js ( cd_funcao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
