-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estab_id_pfcs (cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

    cd_estab_pfcs_w pfcs_organization.id_organization%type;

BEGIN
    cd_estab_pfcs_w := null;

    if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
        select ('ESTAB'||max(cd_estabelecimento_integracao)||'_'||to_char(cd_estabelecimento_p))
        into STRICT    cd_estab_pfcs_w
        from    empresa_integr_dados
        where   upper(cd_identificador) = 'PFCS'
        and     coalesce(cd_estabelecimento::text, '') = '';
    end if;

    RETURN cd_estab_pfcs_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION obter_estab_id_pfcs (cd_estabelecimento_p bigint) FROM PUBLIC;
