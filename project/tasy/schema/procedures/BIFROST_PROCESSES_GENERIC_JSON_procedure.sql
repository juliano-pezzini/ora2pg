-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bifrost_processes_generic_json ((IE_EVENTO_P text, JSON_DATA_P text, NM_USUARIO_P text) IS JSON_DATA_W PHILIPS_JSON) RETURNS varchar AS $body$
DECLARE


  X RECORD;
BEGIN
    IF ((JSON_VALUE_P IS NOT NULL AND JSON_VALUE_P::text <> '')
    AND JSON_VALUE_P.TYPEVAL BETWEEN 3 AND 5) THEN
      RETURN JSON_VALUE_P.VALUE_OF();
    ELSE
      RETURN NULL;
    END IF;
  END;

  FUNCTION GET_KEYS_OF_TABLE(KEYS_P PHILIPS_JSON_LIST) RETURN PHILIPS_JSON_LIST IS
    KEYS_TABLE_W PHILIPS_JSON_LIST := PHILIPS_JSON_LIST();
  BEGIN
    IF (KEYS_P IS NOT NULL AND KEYS_P::text <> '') THEN
       FOR I IN 1 .. KEYS_P.COUNT LOOP
           IF (SUBSTR(KEYS_P.GET[I].GET_STRING(), -4) = '_TBL') THEN
              KEYS_TABLE_W.APPEND(KEYS_P.GET[I].GET_STRING());
           END IF;
       END LOOP;
    END IF;

    RETURN KEYS_TABLE_W;
  END;

  PROCEDURE BIFROST_PROCESSES_JSON_INTERNO(IE_EVENTO_P     VARCHAR2,
                                           NM_TABELA_P     VARCHAR2,
                                           NR_SEQ_SUP_P    NUMBER,
                                           JSON_DATA_P     PHILIPS_JSON_VALUE,
                                           NM_USUARIO_P    VARCHAR2,
                                           DT_REFERENCIA_P DATE) IS
    JSON_AUX_W     PHILIPS_JSON;
    JSON_LIST_W    PHILIPS_JSON_LIST;
    KEYS_TABLE_W   PHILIPS_JSON_LIST;
    NR_SEQUENCIA_W JSON_SCHEMA_T.NR_SEQUENCIA%TYPE;
    NM_TABELA_W    VARCHAR(60);
    VL_CAMPO_W     VARCHAR(4000);
  BEGIN
    IF (coalesce(JSON_DATA_P::text, '') = '') THEN
       RETURN;
    END IF;

    IF (JSON_DATA_P.IS_ARRAY()) THEN
       JSON_LIST_W := PHILIPS_JSON_LIST(JSON_DATA_P);
    ELSE
       JSON_LIST_W := PHILIPS_JSON_LIST();
       JSON_LIST_W.APPEND(JSON_DATA_P);
    END IF;

    FOR I IN 1 .. JSON_LIST_W.COUNT LOOP
        JSON_AUX_W := PHILIPS_JSON(JSON_LIST_W.GET(I));

        IF (JSON_AUX_W.COUNT > 0) THEN
            SELECT nextval('json_schema_t_seq')
              INTO STRICT NR_SEQUENCIA_W
;

            FOR X IN (SELECT UTC.COLUMN_NAME
                        FROM USER_TAB_COLUMNS UTC
                       WHERE UTC.TABLE_NAME = NM_TABELA_P) LOOP
                IF ((JSON_AUX_W.GET(X.COLUMN_NAME) IS NOT NULL AND (JSON_AUX_W.GET(X.COLUMN_NAME))::text <> '')
                AND GET_VALUE(JSON_AUX_W.GET(X.COLUMN_NAME)) IS NOT NULL) THEN
                    VL_CAMPO_W := GET_VALUE(JSON_AUX_W.GET(X.COLUMN_NAME));

                    INSERT INTO JSON_SCHEMA_T(NR_SEQUENCIA, IE_EVENTO, DT_ATUALIZACAO, NM_USUARIO, NR_SEQUENCIA_SUP, NM_TABELA, NM_ATRIBUTO, VL_CAMPO)
                    VALUES (NR_SEQUENCIA_W,
                       IE_EVENTO_P,
                       DT_REFERENCIA_P,
                       NM_USUARIO_P,
                       NR_SEQ_SUP_P,
                       NM_TABELA_P,
                       X.COLUMN_NAME,
                       VL_CAMPO_W);
                END IF;
            END LOOP;

            COMMIT;

            KEYS_TABLE_W := GET_KEYS_OF_TABLE(JSON_AUX_W.GET_KEYS());

            FOR I IN 1 .. KEYS_TABLE_W.COUNT LOOP
                NM_TABELA_W := KEYS_TABLE_W.GET[I].GET_STRING();

                BIFROST_PROCESSES_JSON_INTERNO(IE_EVENTO_P,
                                               SUBSTR(NM_TABELA_W, 1, LENGTH(NM_TABELA_W) - 4),
                                               NR_SEQUENCIA_W,
                                               JSON_AUX_W.GET(NM_TABELA_W),
                                               NM_USUARIO_P,
                                               DT_REFERENCIA_P);
            END LOOP;
        END IF;
    END LOOP;
  END;

BEGIN
  DELETE FROM JSON_SCHEMA_T T
   WHERE T.IE_EVENTO = IE_EVENTO_P
   AND T.NM_USUARIO = NM_USUARIO_P;

  COMMIT;

  JSON_DATA_W := PHILIPS_JSON(JSON_DATA_P);

  IF ((JSON_DATA_W IS NOT NULL AND JSON_DATA_W::text <> '')
  AND JSON_DATA_W.COUNT > 0) THEN
     DT_REFERENCIA_W := clock_timestamp();--NVL(DT_REFERENCIA_P, SYSDATE);
     KEYS_TABLE_W    := GET_KEYS_OF_TABLE(JSON_DATA_W.GET_KEYS());

     FOR I IN 1 .. KEYS_TABLE_W.COUNT LOOP
         NM_TABELA_W := KEYS_TABLE_W.GET[I].GET_STRING();

         BIFROST_PROCESSES_JSON_INTERNO(IE_EVENTO_P,
                                        SUBSTR(NM_TABELA_W, 1, LENGTH(NM_TABELA_W) - 4),
                                        NULL,
                                        JSON_DATA_W.GET(NM_TABELA_W),
                                        NM_USUARIO_P,
                                        DT_REFERENCIA_W);
     END LOOP;
  END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bifrost_processes_generic_json ((IE_EVENTO_P text, JSON_DATA_P text, NM_USUARIO_P text) IS JSON_DATA_W PHILIPS_JSON) FROM PUBLIC;

