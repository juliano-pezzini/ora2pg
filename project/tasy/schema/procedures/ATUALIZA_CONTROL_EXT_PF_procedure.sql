-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_control_ext_pf (CD_PESSOA_FISICA_P text, IE_CONTROL_EXT_P text, NM_USUARIO_P text) AS $body$
DECLARE

  PESSOA_FISICA_AUX_W PESSOA_FISICA_AUX%ROWTYPE;
  UP_OTHER_REC_W      boolean;
  X RECORD;

BEGIN
  FOR X IN (WITH RECURSIVE cte AS (
SELECT trim(both REGEXP_SUBSTR(CD_PESSOA_FISICA_P, '[^;|,]+', 1, LEVEL)) CD_PESSOA_FISICA
              
             WHERE trim(both REGEXP_SUBSTR(CD_PESSOA_FISICA_P, '[^;|,]+', 1, LEVEL)) IS NOT NULL
           (REGEXP_SUBSTR(CD_PESSOA_FISICA_P, '[^;|,]+', 1, LEVEL) IS NOT NULL AND (REGEXP_SUBSTR(CD_PESSOA_FISICA_P, '[^;|,]+', 1, LEVEL))::text <> '')  UNION ALL
SELECT trim(both REGEXP_SUBSTR(CD_PESSOA_FISICA_P, '[^;|,]+', 1, LEVEL)) CD_PESSOA_FISICA 
              
             WHERE trim(both REGEXP_SUBSTR(CD_PESSOA_FISICA_P, '[^;|,]+', 1, LEVEL)) IS NOT NULL
           (REGEXP_SUBSTR(CD_PESSOA_FISICA_P, '[^;|,]+', 1, LEVEL) IS NOT NULL AND (REGEXP_SUBSTR(CD_PESSOA_FISICA_P, '[^;|,]+', 1, LEVEL))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
) LOOP
      UP_OTHER_REC_W := FALSE;

      BEGIN
        SELECT PFA.*
          INTO STRICT PESSOA_FISICA_AUX_W
          FROM PESSOA_FISICA_AUX PFA
         WHERE PFA.CD_PESSOA_FISICA = X.CD_PESSOA_FISICA;
      EXCEPTION
        WHEN no_data_found THEN
             PESSOA_FISICA_AUX_W := NULL;
        WHEN too_many_rows THEN -- Pois nao possui UK com o CD_PESSOA_FISICA
             UP_OTHER_REC_W := TRUE;
      END;

      PESSOA_FISICA_AUX_W.CD_PESSOA_FISICA := X.CD_PESSOA_FISICA;
      PESSOA_FISICA_AUX_W.DT_ATUALIZACAO   := clock_timestamp();
      PESSOA_FISICA_AUX_W.NM_USUARIO       := NM_USUARIO_P;

      IF (coalesce(trim(both PESSOA_FISICA_AUX_W.IE_CONTROL_EXT)::text, '') = ''
      OR IE_CONTROL_EXT_P IN ('1', '3', '4')) THEN
         PESSOA_FISICA_AUX_W.IE_CONTROL_EXT := IE_CONTROL_EXT_P;
      ELSIF (IE_CONTROL_EXT_P = '2'
         AND PESSOA_FISICA_AUX_W.IE_CONTROL_EXT NOT IN ('1', '3', '4', '5', '6')) THEN
         PESSOA_FISICA_AUX_W.IE_CONTROL_EXT := IE_CONTROL_EXT_P;
--      ELSIF (IE_CONTROL_EXT_P = '4'

--         AND PESSOA_FISICA_AUX_W.IE_CONTROL_EXT NOT IN ('1', '3', '5', '6')) THEN

--         PESSOA_FISICA_AUX_W.IE_CONTROL_EXT := IE_CONTROL_EXT_P;
      ELSIF (IE_CONTROL_EXT_P = '5'
         AND PESSOA_FISICA_AUX_W.IE_CONTROL_EXT NOT IN ('1', '3', '6')) THEN
         PESSOA_FISICA_AUX_W.IE_CONTROL_EXT := IE_CONTROL_EXT_P;
      ELSIF (IE_CONTROL_EXT_P = '6'
         AND PESSOA_FISICA_AUX_W.IE_CONTROL_EXT NOT IN ('1', '3')) THEN
         PESSOA_FISICA_AUX_W.IE_CONTROL_EXT := IE_CONTROL_EXT_P;
      ELSIF (IE_CONTROL_EXT_P = '7'
         AND PESSOA_FISICA_AUX_W.IE_CONTROL_EXT NOT IN ('1', '2', '3', '4', '5', '6')) THEN
         PESSOA_FISICA_AUX_W.IE_CONTROL_EXT := IE_CONTROL_EXT_P;
      END IF;

      IF (coalesce(PESSOA_FISICA_AUX_W.DT_ATUALIZACAO_NREC::text, '') = '') THEN
         PESSOA_FISICA_AUX_W.DT_ATUALIZACAO_NREC := PESSOA_FISICA_AUX_W.DT_ATUALIZACAO;
      END IF;

      IF (coalesce(PESSOA_FISICA_AUX_W.NM_USUARIO_NREC::text, '') = '') THEN
         PESSOA_FISICA_AUX_W.NM_USUARIO_NREC := PESSOA_FISICA_AUX_W.NM_USUARIO;
      END IF;

      IF (coalesce(PESSOA_FISICA_AUX_W.NR_SEQUENCIA::text, '') = '') THEN
         SELECT nextval('pessoa_fisica_aux_seq')
           INTO STRICT PESSOA_FISICA_AUX_W.NR_SEQUENCIA
;

         INSERT INTO PESSOA_FISICA_AUX
         VALUES (PESSOA_FISICA_AUX_W.*);
      ELSE
         UPDATE PESSOA_FISICA_AUX PFA
            SET ROW = PESSOA_FISICA_AUX_W
          WHERE PFA.NR_SEQUENCIA = PESSOA_FISICA_AUX_W.NR_SEQUENCIA;

         IF (UP_OTHER_REC_W) THEN
            UPDATE PESSOA_FISICA_AUX PFA
               SET PFA.IE_CONTROL_EXT = PESSOA_FISICA_AUX_W.IE_CONTROL_EXT,
                   PFA.NM_USUARIO     = PESSOA_FISICA_AUX_W.NM_USUARIO,
                   PFA.DT_ATUALIZACAO = PESSOA_FISICA_AUX_W.DT_ATUALIZACAO
             WHERE PFA.CD_PESSOA_FISICA = X.CD_PESSOA_FISICA
               AND PFA.NR_SEQUENCIA <> PESSOA_FISICA_AUX_W.NR_SEQUENCIA;
         END IF;
      END IF;

      COMMIT;
  END LOOP;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_control_ext_pf (CD_PESSOA_FISICA_P text, IE_CONTROL_EXT_P text, NM_USUARIO_P text) FROM PUBLIC;

