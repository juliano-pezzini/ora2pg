-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_utils.get_establishment_code (nr_seq_organization_p bigint) RETURNS bigint AS $body$
DECLARE

        cd_establishment_w estabelecimento.cd_estabelecimento%type;

BEGIN
        select  max(org.cd_estabelecimento)
        into STRICT    cd_establishment_w
        from    pfcs_organization org
        where   org.nr_sequencia = nr_seq_organization_p;

        return cd_establishment_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pfcs_pck_utils.get_establishment_code (nr_seq_organization_p bigint) FROM PUBLIC;
