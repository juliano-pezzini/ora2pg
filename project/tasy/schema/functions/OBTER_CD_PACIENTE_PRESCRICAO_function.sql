-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_paciente_prescricao ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE

    cd_paciente_w varchar(255);

BEGIN

    SELECT prescr_med.cd_pessoa_fisica
    INTO STRICT cd_paciente_w
    FROM prescr_medica prescr_med
    WHERE prescr_med.nr_prescricao = nr_prescricao_p;

    RETURN cd_paciente_w;

  END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_paciente_prescricao ( nr_prescricao_p bigint) FROM PUBLIC;
