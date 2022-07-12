-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_lider_wheb (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


    ie_lider_w varchar(1) := 'N';


BEGIN
    $if $$tasy_local_dict=true $then
    return 'S';
    $else
    if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
        begin
            EXECUTE 'begin verifica_cargo_usuario@whebl01_dbcorp(:nm_usuario_p,''A,G''); end;'
                using nm_usuario_p;
            ie_lider_w := 'S';
        exception
            when others then
                ie_lider_w := 'N';
        end;
    end if;
    return ie_lider_w;
    $end
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_lider_wheb (nm_usuario_p text) FROM PUBLIC;
