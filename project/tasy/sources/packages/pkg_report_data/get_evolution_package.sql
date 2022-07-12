-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_report_data.get_evolution (IE_EVOLU_REL_P TIPO_EVOLUCAO.IE_EVOLU_REL%TYPE, CD_TIPO_EVOLUCAO_P TIPO_EVOLUCAO.CD_TIPO_EVOLUCAO%TYPE DEFAULT NULL) RETURNS TIPO_EVOLUCAO.CD_TIPO_EVOLUCAO%TYPE AS $body$
DECLARE


    CD_TIPO_EVOLUCAO_W TIPO_EVOLUCAO.CD_TIPO_EVOLUCAO%TYPE;

    
BEGIN
    
      CD_TIPO_EVOLUCAO_W := NULL;

      IF (IE_EVOLU_REL_P IS NOT NULL AND IE_EVOLU_REL_P::text <> '') THEN
        IF coalesce(CD_TIPO_EVOLUCAO_P::text, '') = '' THEN
          SELECT MAX(CD_TIPO_EVOLUCAO)
            INTO STRICT CD_TIPO_EVOLUCAO_W
            FROM TIPO_EVOLUCAO T
           WHERE T.IE_SITUACAO = 'A'
             AND T.IE_EVOLU_REL = IE_EVOLU_REL_P;
        ELSE
          SELECT MAX(CD_TIPO_EVOLUCAO)
            INTO STRICT CD_TIPO_EVOLUCAO_W
            FROM TIPO_EVOLUCAO T
           WHERE T.IE_SITUACAO = 'A'
             AND T.IE_EVOLU_REL = IE_EVOLU_REL_P
             AND T.CD_TIPO_EVOLUCAO = CD_TIPO_EVOLUCAO_P;
        END IF;
      END IF;

    RETURN CD_TIPO_EVOLUCAO_W;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_report_data.get_evolution (IE_EVOLU_REL_P TIPO_EVOLUCAO.IE_EVOLU_REL%TYPE, CD_TIPO_EVOLUCAO_P TIPO_EVOLUCAO.CD_TIPO_EVOLUCAO%TYPE DEFAULT NULL) FROM PUBLIC;