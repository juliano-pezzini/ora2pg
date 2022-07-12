-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordem_apres_oft (nr_seq_superior_p bigint, cd_perfil_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w	bigint;


BEGIN
select	nr_seq_apresentacao
into STRICT	nr_retorno_w
from	perfil_item_oftalmologia
where	nr_seq_item = nr_seq_superior_p
and		cd_perfil = cd_perfil_p;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordem_apres_oft (nr_seq_superior_p bigint, cd_perfil_p bigint) FROM PUBLIC;
