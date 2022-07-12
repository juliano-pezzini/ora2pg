-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pde.process_table (NM_TABELA_P text) AS $body$
DECLARE

      COUNT_COLS_W   bigint;
      IE_IS_FATHER_W varchar(1);
      IE_IS_CHILD_W  varchar(1);

  X RECORD;

BEGIN
      SELECT COUNT(*)
        INTO STRICT COUNT_COLS_W
        FROM USER_TAB_COLS
       WHERE UPPER(TABLE_NAME) = NM_TABELA_P
         AND (UPPER(COLUMN_NAME) = 'NR_ATENDIMENTO' OR
              UPPER(COLUMN_NAME) = 'NR_PRESCRICAO' OR
              UPPER(COLUMN_NAME) = 'CD_PESSOA_FISICA');

      IF (COUNT_COLS_W > 0) THEN
        SELECT (CASE WHEN (MAX(PA.NM_TABELA) IS NOT NULL AND (MAX(PA.NM_TABELA))::text <> '') THEN 'S' ELSE 'N' END)
          INTO STRICT IE_IS_FATHER_W
          FROM PDE_ATTRIBUTE PA
         WHERE PA.NR_SEQ_PDE_MAIN = NR_SEQ_PDE_MAIN_P
           AND coalesce(PA.IE_SITUACAO, 'A') = 'A'
           AND PA.NM_TABELA_FK = NM_TABELA_P
           AND (PA.NM_FK_TABELA_FK IS NOT NULL AND PA.NM_FK_TABELA_FK::text <> '')
           AND (PA.NM_TABELA IS NOT NULL AND PA.NM_TABELA::text <> '')
           AND (PA.NM_ATRIBUTO IS NOT NULL AND PA.NM_ATRIBUTO::text <> '');

        SELECT (CASE WHEN (MAX(PA.NM_TABELA) IS NOT NULL AND (MAX(PA.NM_TABELA))::text <> '') THEN 'S' ELSE 'N' END)
          INTO STRICT IE_IS_CHILD_W
          FROM PDE_ATTRIBUTE PA
         WHERE PA.NR_SEQ_PDE_MAIN = NR_SEQ_PDE_MAIN_P
           AND coalesce(PA.IE_SITUACAO, 'A') = 'A'
           AND PA.NM_TABELA = NM_TABELA_P
           AND (PA.NM_ATRIBUTO IS NOT NULL AND PA.NM_ATRIBUTO::text <> '')
           AND (PA.NM_TABELA_FK IS NOT NULL AND PA.NM_TABELA_FK::text <> '')
           AND (PA.NM_FK_TABELA_FK IS NOT NULL AND PA.NM_FK_TABELA_FK::text <> '');

        PRC_BUILD_TRG_DINAMIC(NM_TABELA_P, IE_IS_FATHER_W, IE_IS_CHILD_W);
      END IF;
    END;

  BEGIN
    FOR X IN (SELECT DISTINCT PA.NM_TABELA
                FROM PDE_ATTRIBUTE PA
               WHERE PA.NR_SEQ_PDE_MAIN = NR_SEQ_PDE_MAIN_P
                 AND coalesce(PA.IE_SITUACAO, 'A') = 'A'
                 AND (PA.NM_TABELA IS NOT NULL AND PA.NM_TABELA::text <> '')
                 AND (PA.NM_ATRIBUTO IS NOT NULL AND PA.NM_ATRIBUTO::text <> '')) LOOP
      CALL pde.process_table(X.NM_TABELA);
    END LOOP;

    CALL pde.drop_invalid_triggers();

    UPDATE PDE_MAIN PM
       SET PM.IE_STATUS = 'M'
     WHERE PM.NR_SEQUENCIA = NR_SEQ_PDE_MAIN_P;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        CALL PDE.GRAVA_LOG_ERRO('CREATE.TRIGGERS.ERROR',
                           'NR_SEQ_PDE_MAIN_P: ' || NR_SEQ_PDE_MAIN_P,
                           SQLSTATE,
                           SQLERRM);

        UPDATE PDE_MAIN PM
           SET PM.IE_STATUS = 'E'
         WHERE PM.NR_SEQUENCIA = NR_SEQ_PDE_MAIN_P;

        COMMIT;
      END;
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pde.process_table (NM_TABELA_P text) FROM PUBLIC;