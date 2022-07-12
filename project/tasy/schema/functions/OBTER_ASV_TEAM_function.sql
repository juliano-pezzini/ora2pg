-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_asv_team ( nr_atendimento_p bigint ) RETURNS varchar AS $body$
DECLARE

    nr_asv_team_w varchar(255);

BEGIN
    SELECT
        b.nr_asv_team
    INTO STRICT nr_asv_team_w
    FROM
        atend_paciente_unidade       a,
        atend_paciente_unidade_inf   b
    WHERE
        b.nr_seq_atend_pac_unidade = a.nr_seq_interno
        AND a.nr_atendimento = nr_atendimento_p;

    RETURN nr_asv_team_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_asv_team ( nr_atendimento_p bigint ) FROM PUBLIC;
