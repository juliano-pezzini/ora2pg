-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicate_anzics ( NR_SEQUENCIA_VERSION_OLD_P ANZICS_VERSION.NR_SEQUENCIA%TYPE ) AS $body$
DECLARE

  NM_USUARIO_W                ANZICS_VERSION.NM_USUARIO%TYPE;
  DT_ATUALIZACAO_W            ANZICS_VERSION.DT_ATUALIZACAO%TYPE;
  NR_SEQUENCIA_VERSION_NEW_W  ANZICS_VERSION.NR_SEQUENCIA%TYPE;
  NR_SEQUENCIA_GROUP_NEW_W    ANZICS_GROUP.NR_SEQUENCIA%TYPE;
  NR_SEQUENCIA_GROUP_OLD_W    ANZICS_GROUP.NR_SEQUENCIA%TYPE;
  NR_SEQUENCIA_ITEM_NEW_W     ANZICS_ITEM.NR_SEQUENCIA%TYPE;
  NR_SEQUENCIA_ITEM_OLD_W     ANZICS_ITEM.NR_SEQUENCIA%TYPE;
  ANZICS_VERSION_ROW_W        ANZICS_VERSION%ROWTYPE;
  EXIST_W                     varchar(1);

  ITEM_IDX_COLLECTION         integer := 0;
  ITEM_RULE_IDX_COLLECTION    integer := 0;
  ITEM_RESULT_IDX_COLLECTION  integer := 0;

  TYPE ANZICS_GROUP_TYPE        IS TABLE OF ANZICS_GROUP%ROWTYPE        INDEX BY integer;
  TYPE ANZICS_ITEM_TYPE         IS TABLE OF ANZICS_ITEM%ROWTYPE         INDEX BY integer;
  TYPE ANZICS_ITEM_RULE_TYPE    IS TABLE OF ANZICS_ITEM_RULE%ROWTYPE    INDEX BY integer;
  TYPE ANZICS_ITEM_RESULT_TYPE  IS TABLE OF ANZICS_ITEM_RESULT%ROWTYPE  INDEX BY integer;

  ANZICS_GROUP_ROW          ANZICS_GROUP_TYPE;
  ANZICS_ITEM_ROW           ANZICS_ITEM_TYPE;
  ANZICS_ITEM_RULE_ROW      ANZICS_ITEM_RULE_TYPE;
  ANZICS_ITEM_RESULT_ROW    ANZICS_ITEM_RESULT_TYPE;

  ITEM_C CURSOR(NR_SEQUENCIA_GROUP_OLD_P  ANZICS_ITEM.NR_SEQ_GROUP%TYPE)
    FOR
      SELECT  I.*
      FROM    ANZICS_ITEM I
      WHERE   I.NR_SEQ_GROUP = NR_SEQUENCIA_GROUP_OLD_P;

  ITEM_RULE_C CURSOR(NR_SEQUENCIA_ITEM_OLD_P  ANZICS_ITEM.NR_SEQUENCIA%TYPE)
    FOR
      SELECT  RU.*
      FROM    ANZICS_ITEM_RULE RU
      WHERE   RU.NR_SEQ_ITEM = NR_SEQUENCIA_ITEM_OLD_P;

  ITEM_RESULT_C CURSOR(NR_SEQUENCIA_ITEM_OLD_P  ANZICS_ITEM.NR_SEQUENCIA%TYPE)
    FOR
      SELECT  RE.*
      FROM    ANZICS_ITEM_RESULT RE
      WHERE   RE.NR_SEQ_ITEM = NR_SEQUENCIA_ITEM_OLD_P;
BEGIN
  BEGIN
    BEGIN
      SELECT  V.*
      INTO STRICT    ANZICS_VERSION_ROW_W
      FROM    ANZICS_VERSION V
      WHERE   V.NR_SEQUENCIA = NR_SEQUENCIA_VERSION_OLD_P;

      EXIST_W := 'S';
    EXCEPTION
      WHEN no_data_found OR too_many_rows THEN
        EXIST_W := 'N';
    END;

    IF (EXIST_W = 'S') THEN
      NR_SEQUENCIA_VERSION_NEW_W := OBTER_NEXTVAL_SEQUENCE('ANZICS_VERSION');

      NM_USUARIO_W := COALESCE(WHEB_USUARIO_PCK.GET_NM_USUARIO, ANZICS_VERSION_ROW_W.NM_USUARIO_NREC);
      DT_ATUALIZACAO_W := clock_timestamp();

      ANZICS_VERSION_ROW_W.NR_SEQUENCIA         := NR_SEQUENCIA_VERSION_NEW_W;
      ANZICS_VERSION_ROW_W.DT_ATUALIZACAO       := DT_ATUALIZACAO_W;
      ANZICS_VERSION_ROW_W.DT_ATUALIZACAO_NREC  := DT_ATUALIZACAO_W;
      ANZICS_VERSION_ROW_W.NM_USUARIO           := NM_USUARIO_W;
      ANZICS_VERSION_ROW_W.NM_USUARIO_NREC      := NM_USUARIO_W;
      ANZICS_VERSION_ROW_W.DS_VERSION           := SUBSTR(OBTER_DESC_EXPRESSAO(303214) || ' - ' || ANZICS_VERSION_ROW_W.DS_VERSION, 0, 30);

      INSERT INTO ANZICS_VERSION VALUES (ANZICS_VERSION_ROW_W.*);

      SELECT  G.* BULK COLLECT
      INTO STRICT    ANZICS_GROUP_ROW
      FROM    ANZICS_GROUP G
      WHERE   G.NR_SEQ_ANZICS_VERSION = NR_SEQUENCIA_VERSION_OLD_P;

      <<ANZICS_GROUP_LOOP>>
      FOR GROUP_IDX_COLLECTION IN 1 .. ANZICS_GROUP_ROW.COUNT LOOP
        NR_SEQUENCIA_GROUP_NEW_W := OBTER_NEXTVAL_SEQUENCE('ANZICS_GROUP');
        NR_SEQUENCIA_GROUP_OLD_W := ANZICS_GROUP_ROW[GROUP_IDX_COLLECTION].NR_SEQUENCIA;

        ANZICS_GROUP_ROW[GROUP_IDX_COLLECTION].NR_SEQUENCIA           := NR_SEQUENCIA_GROUP_NEW_W;
        ANZICS_GROUP_ROW[GROUP_IDX_COLLECTION].DT_ATUALIZACAO         := DT_ATUALIZACAO_W;
        ANZICS_GROUP_ROW[GROUP_IDX_COLLECTION].DT_ATUALIZACAO_NREC    := DT_ATUALIZACAO_W;
        ANZICS_GROUP_ROW[GROUP_IDX_COLLECTION].NM_USUARIO             := NM_USUARIO_W;
        ANZICS_GROUP_ROW[GROUP_IDX_COLLECTION].NM_USUARIO_NREC        := NM_USUARIO_W;
        ANZICS_GROUP_ROW[GROUP_IDX_COLLECTION].NR_SEQ_ANZICS_VERSION  := NR_SEQUENCIA_VERSION_NEW_W;

        <<ANZICS_ITEM_LOOP>>
        FOR ANZICS_ITEM_ROW_W IN ITEM_C(NR_SEQUENCIA_GROUP_OLD_W)
        LOOP
          NR_SEQUENCIA_ITEM_OLD_W := ANZICS_ITEM_ROW_W.NR_SEQUENCIA;
          ITEM_IDX_COLLECTION     := ITEM_IDX_COLLECTION + 1;

          NR_SEQUENCIA_ITEM_NEW_W := OBTER_NEXTVAL_SEQUENCE('ANZICS_ITEM');

          ANZICS_ITEM_ROW(ITEM_IDX_COLLECTION)                      := ANZICS_ITEM_ROW_W;
          ANZICS_ITEM_ROW[ITEM_IDX_COLLECTION].NR_SEQUENCIA         := NR_SEQUENCIA_ITEM_NEW_W;
          ANZICS_ITEM_ROW[ITEM_IDX_COLLECTION].DT_ATUALIZACAO       := DT_ATUALIZACAO_W;
          ANZICS_ITEM_ROW[ITEM_IDX_COLLECTION].DT_ATUALIZACAO_NREC  := DT_ATUALIZACAO_W;
          ANZICS_ITEM_ROW[ITEM_IDX_COLLECTION].NM_USUARIO           := NM_USUARIO_W;
          ANZICS_ITEM_ROW[ITEM_IDX_COLLECTION].NM_USUARIO_NREC      := NM_USUARIO_W;
          ANZICS_ITEM_ROW[ITEM_IDX_COLLECTION].NR_SEQ_GROUP         := NR_SEQUENCIA_GROUP_NEW_W;

          <<ANZICS_ITEM_RULE_LOOP>>
          FOR ANZICS_ITEM_RULE_ROW_W IN ITEM_RULE_C(NR_SEQUENCIA_ITEM_OLD_W)
          LOOP
            ITEM_RULE_IDX_COLLECTION := ITEM_RULE_IDX_COLLECTION + 1;

            ANZICS_ITEM_RULE_ROW(ITEM_RULE_IDX_COLLECTION)                      := ANZICS_ITEM_RULE_ROW_W;
            ANZICS_ITEM_RULE_ROW[ITEM_RULE_IDX_COLLECTION].NR_SEQUENCIA         := OBTER_NEXTVAL_SEQUENCE('ANZICS_ITEM_RULE');
            ANZICS_ITEM_RULE_ROW[ITEM_RULE_IDX_COLLECTION].NR_SEQ_ITEM          := NR_SEQUENCIA_ITEM_NEW_W;
            ANZICS_ITEM_RULE_ROW[ITEM_RULE_IDX_COLLECTION].DT_ATUALIZACAO       := DT_ATUALIZACAO_W;
            ANZICS_ITEM_RULE_ROW[ITEM_RULE_IDX_COLLECTION].DT_ATUALIZACAO_NREC  := DT_ATUALIZACAO_W;
            ANZICS_ITEM_RULE_ROW[ITEM_RULE_IDX_COLLECTION].NM_USUARIO           := NM_USUARIO_W;
            ANZICS_ITEM_RULE_ROW[ITEM_RULE_IDX_COLLECTION].NM_USUARIO_NREC      := NM_USUARIO_W;
          END LOOP ANZICS_ITEM_RULE_LOOP;

          <<ANZICS_ITEM_RESULT_LOOP>>
          FOR ANZICS_ITEM_RESULT_ROW_W IN ITEM_RESULT_C(NR_SEQUENCIA_ITEM_OLD_W)
          LOOP
            ITEM_RESULT_IDX_COLLECTION := ITEM_RESULT_IDX_COLLECTION + 1;

            ANZICS_ITEM_RESULT_ROW(ITEM_RESULT_IDX_COLLECTION)                      := ANZICS_ITEM_RESULT_ROW_W;
            ANZICS_ITEM_RESULT_ROW[ITEM_RESULT_IDX_COLLECTION].NR_SEQUENCIA         := OBTER_NEXTVAL_SEQUENCE('ANZICS_ITEM_RESULT');
            ANZICS_ITEM_RESULT_ROW[ITEM_RESULT_IDX_COLLECTION].NR_SEQ_ITEM          := NR_SEQUENCIA_ITEM_NEW_W;
            ANZICS_ITEM_RESULT_ROW[ITEM_RESULT_IDX_COLLECTION].DT_ATUALIZACAO       := DT_ATUALIZACAO_W;
            ANZICS_ITEM_RESULT_ROW[ITEM_RESULT_IDX_COLLECTION].DT_ATUALIZACAO_NREC  := DT_ATUALIZACAO_W;
            ANZICS_ITEM_RESULT_ROW[ITEM_RESULT_IDX_COLLECTION].NM_USUARIO           := NM_USUARIO_W;
            ANZICS_ITEM_RESULT_ROW[ITEM_RESULT_IDX_COLLECTION].NM_USUARIO_NREC      := NM_USUARIO_W;
          END LOOP ANZICS_ITEM_RESULT_LOOP;
        END LOOP ANZICS_ITEM_LOOP;
      END LOOP ANZICS_GROUP_LOOP;

      IF (ANZICS_GROUP_ROW.FIRST IS NOT NULL AND ANZICS_GROUP_ROW.FIRST::text <> '') THEN
        FORALL GROUP_IDX IN ANZICS_GROUP_ROW.FIRST .. ANZICS_GROUP_ROW.LAST
        INSERT INTO ANZICS_GROUP VALUES ANZICS_GROUP_ROW(GROUP_IDX);

        IF (ANZICS_ITEM_ROW.FIRST IS NOT NULL AND ANZICS_ITEM_ROW.FIRST::text <> '') THEN
            FORALL ITEM_IDX IN ANZICS_ITEM_ROW.FIRST .. ANZICS_ITEM_ROW.LAST
            INSERT INTO ANZICS_ITEM VALUES ANZICS_ITEM_ROW(ITEM_IDX);

          IF (ANZICS_ITEM_RULE_ROW.FIRST IS NOT NULL AND ANZICS_ITEM_RULE_ROW.FIRST::text <> '') THEN
              FORALL ITEM_RULE_IDX IN ANZICS_ITEM_RULE_ROW.FIRST .. ANZICS_ITEM_RULE_ROW.LAST
              INSERT INTO ANZICS_ITEM_RULE VALUES ANZICS_ITEM_RULE_ROW(ITEM_RULE_IDX);
          END IF;

          IF (ANZICS_ITEM_RESULT_ROW.FIRST IS NOT NULL AND ANZICS_ITEM_RESULT_ROW.FIRST::text <> '') THEN
              FORALL ITEM_RESULT_IDX IN ANZICS_ITEM_RESULT_ROW.FIRST .. ANZICS_ITEM_RESULT_ROW.LAST
              INSERT INTO ANZICS_ITEM_RESULT VALUES ANZICS_ITEM_RESULT_ROW(ITEM_RESULT_IDX);
          END IF;
        END IF;

        COMMIT;
      END IF;
    END IF;
  END;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicate_anzics ( NR_SEQUENCIA_VERSION_OLD_P ANZICS_VERSION.NR_SEQUENCIA%TYPE ) FROM PUBLIC;
