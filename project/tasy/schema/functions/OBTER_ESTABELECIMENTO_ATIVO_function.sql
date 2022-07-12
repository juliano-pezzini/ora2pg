-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estabelecimento_ativo () RETURNS bigint AS $body$
DECLARE


estab_ativo_w	bigint;


BEGIN

estab_ativo_w	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

return	estab_ativo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estabelecimento_ativo () FROM PUBLIC;
