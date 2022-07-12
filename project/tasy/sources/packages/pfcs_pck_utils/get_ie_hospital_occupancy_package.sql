-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_utils.get_ie_hospital_occupancy (cd_unit_p bigint) RETURNS varchar AS $body$
DECLARE

        ie_hospital_occupancy_w setor_atendimento.ie_ocup_hospitalar%type;

BEGIN
        select  coalesce(max(ie_ocup_hospitalar),PFCS_PCK_CONSTANTS.IE_YES_BR)
        into STRICT    ie_hospital_occupancy_w
        from    setor_atendimento
        where   cd_setor_atendimento = cd_unit_p;

        return ie_hospital_occupancy_w;
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_pck_utils.get_ie_hospital_occupancy (cd_unit_p bigint) FROM PUBLIC;