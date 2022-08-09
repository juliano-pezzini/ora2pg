-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE iud_tipo_doc_ident_pessoa ( cd_pessoa_fisica_p PESSOA_FISICA.CD_PESSOA_FISICA%type, nm_usuario_p PESSOA_FISICA_AUX.NM_USUARIO%type, operation_type_p text, nr_seq_tipo_doc_ident_p PESSOA_FISICA_AUX.NR_SEQ_TIPO_DOC_IDENTIFICACAO%type default null, nr_salvo_conduto_p PESSOA_FISICA_AUX.NR_SALVO_CONDUTO%type default null, nr_cartao_diplomatico_p PESSOA_FISICA_AUX.NR_CARTAO_DIPLOMATICO%type default null, nr_adulto_sem_ident_p PESSOA_FISICA_AUX.NR_ADULTO_SEM_IDENTIFICACAO%type default null, nr_menor_sem_ident_p PESSOA_FISICA_AUX.NR_MENOR_SEM_IDENTIFICACAO%type default null) AS $body$
DECLARE

  dt_atual_s                  CONSTANT PESSOA_FISICA_AUX.DT_ATUALIZACAO%type := clock_timestamp();
  nr_seq_pessoa_fisica_aux_w  PESSOA_FISICA_AUX.NR_SEQUENCIA%type;
  nr_seq_pessoa_aux_w         PESSOA_FISICA_AUX.NR_SEQUENCIA%type;

BEGIN
  SELECT  MAX(NR_SEQUENCIA)
  INTO STRICT    nr_seq_pessoa_aux_w
  FROM    PESSOA_FISICA_AUX
  WHERE   CD_PESSOA_FISICA = cd_pessoa_fisica_p;
  IF (operation_type_p NOT IN ('DELETE')) THEN
    IF (coalesce(nr_seq_pessoa_aux_w::text, '') = '') THEN
      SELECT  nextval('pessoa_fisica_aux_seq')
      INTO STRICT    nr_seq_pessoa_fisica_aux_w
;

      INSERT INTO PESSOA_FISICA_AUX(
        NR_SEQUENCIA,
        DT_ATUALIZACAO,
        NM_USUARIO,
        DT_ATUALIZACAO_NREC,
        NM_USUARIO_NREC,
        CD_PESSOA_FISICA,
        NR_SEQ_TIPO_DOC_IDENTIFICACAO,
        NR_SALVO_CONDUTO,
        NR_CARTAO_DIPLOMATICO,
        NR_ADULTO_SEM_IDENTIFICACAO,
        NR_MENOR_SEM_IDENTIFICACAO
      ) VALUES (
        nr_seq_pessoa_fisica_aux_w,
        dt_atual_s,
        nm_usuario_p,
        dt_atual_s,
        nm_usuario_p,
        cd_pessoa_fisica_p,
        nr_seq_tipo_doc_ident_p,
        nr_salvo_conduto_p,
        nr_cartao_diplomatico_p,
        nr_adulto_sem_ident_p,
        nr_menor_sem_ident_p
      );
    ELSIF (nr_seq_pessoa_aux_w IS NOT NULL AND nr_seq_pessoa_aux_w::text <> '') THEN
      UPDATE PESSOA_FISICA_AUX a SET
        a.NR_SEQ_TIPO_DOC_IDENTIFICACAO = nr_seq_tipo_doc_ident_p,
        a.NR_SALVO_CONDUTO              = nr_salvo_conduto_p,
        a.NR_CARTAO_DIPLOMATICO         = nr_cartao_diplomatico_p,
        a.NR_ADULTO_SEM_IDENTIFICACAO   = nr_adulto_sem_ident_p,
        a.NR_MENOR_SEM_IDENTIFICACAO    = nr_menor_sem_ident_p,
        a.DT_ATUALIZACAO_NREC           = dt_atual_s,
        a.NM_USUARIO_NREC               = nm_usuario_p
      WHERE a.CD_PESSOA_FISICA          = cd_pessoa_fisica_p
      AND   a.NR_SEQUENCIA              = nr_seq_pessoa_aux_w;
    END IF;
  ELSIF (operation_type_p = 'DELETE') THEN
    DELETE FROM PESSOA_FISICA_AUX a
    WHERE       a.CD_PESSOA_FISICA  = cd_pessoa_fisica_p
    AND         a.NR_SEQUENCIA      = nr_seq_pessoa_aux_w;
  END IF;
  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE iud_tipo_doc_ident_pessoa ( cd_pessoa_fisica_p PESSOA_FISICA.CD_PESSOA_FISICA%type, nm_usuario_p PESSOA_FISICA_AUX.NM_USUARIO%type, operation_type_p text, nr_seq_tipo_doc_ident_p PESSOA_FISICA_AUX.NR_SEQ_TIPO_DOC_IDENTIFICACAO%type default null, nr_salvo_conduto_p PESSOA_FISICA_AUX.NR_SALVO_CONDUTO%type default null, nr_cartao_diplomatico_p PESSOA_FISICA_AUX.NR_CARTAO_DIPLOMATICO%type default null, nr_adulto_sem_ident_p PESSOA_FISICA_AUX.NR_ADULTO_SEM_IDENTIFICACAO%type default null, nr_menor_sem_ident_p PESSOA_FISICA_AUX.NR_MENOR_SEM_IDENTIFICACAO%type default null) FROM PUBLIC;
