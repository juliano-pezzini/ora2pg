-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_rqe_esp_medico (CD_MEDICO_P text) RETURNS varchar AS $body$
DECLARE

DS_RETORNO_W      varchar(20);

BEGIN
  IF (CD_MEDICO_P IS NOT NULL AND CD_MEDICO_P::text <> '') THEN

      SELECT MAX(A.NR_RQE)
        INTO STRICT DS_RETORNO_W
      FROM MEDICO_ESPECIALIDADE A
      WHERE CD_PESSOA_FISICA  = CD_MEDICO_P
        AND (NR_RQE IS NOT NULL AND NR_RQE::text <> '');

  END IF;

  RETURN DS_RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_rqe_esp_medico (CD_MEDICO_P text) FROM PUBLIC;

