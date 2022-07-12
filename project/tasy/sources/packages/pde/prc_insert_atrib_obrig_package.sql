-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pde.prc_insert_atrib_obrig (NR_SEQ_PDE_MAIN_P bigint, VL_GROUP_DOMAIN_P text, CD_EXP_TABLE_GROUP_W bigint, CD_EXP_TABLE_W bigint, NM_TABLE_P text, NM_ATRIBUTO_P text, NM_USER_P text, NR_SEQ_PARENT_P bigint DEFAULT NULL) AS $body$
DECLARE

    NR_NEW_SEQUENCE_W  bigint;
    ATRIBUTO_W         varchar(255);
    CD_EXP_ATTRIBUTE_W bigint;
    ONTOLOGIA_COD_W    bigint;
    NM_FK_TABELA_SUP_W ONTOLOGIA_TABELA.NM_FK_TABELA_SUP%TYPE;
    NM_TABELA_SUP_W    ONTOLOGIA_TABELA.NM_TABELA_SUP%TYPE;
    --VERIFICAR QUAIS ATRIBUTOS EXISTEM NA TABELA REF AO PDE_MAIN
  A RECORD;

BEGIN
    FOR A IN (SELECT DISTINCT NM_ATRIBUTO
                FROM TABELA_ATRIBUTO
               WHERE NM_TABELA = NM_TABLE_P
                 AND NM_ATRIBUTO IN ('NR_ATENDIMENTO', 'CD_PESSOA_FISICA',
                      'NR_PRESCRICAO', 'NR_SEQ_PRESCR')
               ORDER BY NM_ATRIBUTO) LOOP
      IF (A.NM_ATRIBUTO IS NOT NULL AND A.NM_ATRIBUTO::text <> '') AND NM_ATRIBUTO_P <> A.NM_ATRIBUTO THEN
        BEGIN
          SELECT DISTINCT NM_ATRIBUTO
            INTO STRICT ATRIBUTO_W
            FROM PDE_ATTRIBUTE
           WHERE NM_TABELA = NM_TABLE_P
             AND NM_ATRIBUTO = A.NM_ATRIBUTO
             AND NR_SEQ_PDE_MAIN = NR_SEQ_PDE_MAIN_P;

        EXCEPTION
          WHEN no_data_found THEN
            ATRIBUTO_W := NULL;
        END;
      END IF;

      --RESGATAR CODIGO ONTOLOGIA DO ATRIBUTO
      IF coalesce(ATRIBUTO_W::text, '') = '' AND
         NM_ATRIBUTO_P NOT IN ('NR_ATENDIMENTO', 'CD_PESSOA_FISICA',
          'NR_PRESCRICAO', 'NR_SEQ_PRESCR') THEN
        SELECT MAX(CD_VALOR_ONTOLOGIA)
          INTO STRICT ONTOLOGIA_COD_W
          FROM RES_CADASTRO_ONTOLOGIA_PHI
         WHERE NM_TABELA = NM_TABLE_P
           AND NM_ATRIBUTO = A.NM_ATRIBUTO;

        --PEGAR CODIGO DE EXPRESSAO DO ATRIBUTO
        SELECT MAX(CD_EXP_DESC)
          INTO STRICT CD_EXP_ATTRIBUTE_W
          FROM ONTOLOGIA_TABELA_ATRIBUTO
         WHERE NM_ATRIBUTO = A.NM_ATRIBUTO
           AND NM_TABELA = NM_TABLE_P;

        --PEGAR PROXIMA SEQUENCIA DE PDE_ATTRIBUTE
        SELECT nextval('pde_attribute_seq') INTO STRICT NR_NEW_SEQUENCE_W;

        IF coalesce(ATRIBUTO_W::text, '') = '' AND (ONTOLOGIA_COD_W IS NOT NULL AND ONTOLOGIA_COD_W::text <> '') AND
           (CD_EXP_ATTRIBUTE_W IS NOT NULL AND CD_EXP_ATTRIBUTE_W::text <> '') AND
           NM_ATRIBUTO_P NOT IN ('NR_ATENDIMENTO', 'CD_PESSOA_FISICA',
            'NR_PRESCRICAO', 'NR_SEQ_PRESCR') THEN
        
          IF (NM_TABLE_P IS NOT NULL AND NM_TABLE_P::text <> '') THEN
            SELECT MAX(NM_TABELA_SUP), MAX(NM_FK_TABELA_SUP)
              INTO STRICT NM_TABELA_SUP_W, NM_FK_TABELA_SUP_W
              FROM ONTOLOGIA_TABELA
             WHERE NM_TABELA = NM_TABLE_P;
          END IF;

          INSERT INTO PDE_ATTRIBUTE(NR_SEQUENCIA,
             NR_SEQUENCIA_SUP,
             NR_SEQ_PDE_MAIN,
             IE_GRUPO,
             NR_SEQ_ATRIB_GRUPO,
             NM_TABELA,
             NM_ATRIBUTO,
             CD_ONTOLOGIA,
             CD_EXP_TABELA_GRUPO,
             CD_EXP_ATRIBUTO_GRUPO,
             CD_EXP_TABELA,
             CD_EXP_ATRIBUTO,
             IE_SITUACAO,
             IE_DOMINIO,
             IE_ENVIAR,
             NM_TABELA_FK,
             NM_FK_TABELA_FK,
             NM_USUARIO_NREC,
             DT_ATUALIZACAO_NREC,
             NM_USUARIO,
             DT_ATUALIZACAO)
          VALUES (NR_NEW_SEQUENCE_W,
             NR_SEQ_PARENT_P,
             NR_SEQ_PDE_MAIN_P,
             VL_GROUP_DOMAIN_P,
             NULL,
             NM_TABLE_P,
             A.NM_ATRIBUTO,
             ONTOLOGIA_COD_W,
             CD_EXP_TABLE_GROUP_W,
             NULL,
             CD_EXP_TABLE_W,
             CD_EXP_ATTRIBUTE_W,
             'A',
             NULL,
             'N',
             NM_TABELA_SUP_W,
             NM_FK_TABELA_SUP_W,
             NM_USER_P,
             clock_timestamp(),
             NM_USER_P,
             clock_timestamp());
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      CALL PDE.GRAVA_LOG_ERRO('INSERT.ATRIB.OBRIG.ERROR',
                         'NR_SEQ_PDE_MAIN_P: ' || NR_SEQ_PDE_MAIN_P ||
                         ', VL_GROUP_DOMAIN_P: ' || VL_GROUP_DOMAIN_P ||
                         ', CD_EXP_TABLE_GROUP_W: ' || CD_EXP_TABLE_GROUP_W ||
                         ', CD_EXP_TABLE_W: ' || CD_EXP_TABLE_W ||
                         ', NM_TABLE_P: ' || NM_TABLE_P ||
                         ', NM_ATRIBUTO_P: ' || NM_ATRIBUTO_P ||
                         ', NM_USER_P: ' || NM_USER_P,
                         SQLSTATE,
                         SQLERRM);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pde.prc_insert_atrib_obrig (NR_SEQ_PDE_MAIN_P bigint, VL_GROUP_DOMAIN_P text, CD_EXP_TABLE_GROUP_W bigint, CD_EXP_TABLE_W bigint, NM_TABLE_P text, NM_ATRIBUTO_P text, NM_USER_P text, NR_SEQ_PARENT_P bigint DEFAULT NULL) FROM PUBLIC;