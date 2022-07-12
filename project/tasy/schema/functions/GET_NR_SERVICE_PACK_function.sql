-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_nr_service_pack (cd_versao_p text, nr_pacote_p bigint) RETURNS bigint AS $body$
DECLARE

nr_service_pack_w bigint := null;

BEGIN
    select nr_service_pack into STRICT nr_service_pack_w from (
        SELECT coalesce(max(nr_service_pack),0) nr_service_pack
          from ajuste_versao_cliente 
         where cd_versao = cd_versao_p and nr_pacote = nr_pacote_p order by Nr_Sequencia desc) alias2 LIMIT 1;
    return Nr_Service_Pack_W;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_nr_service_pack (cd_versao_p text, nr_pacote_p bigint) FROM PUBLIC;

