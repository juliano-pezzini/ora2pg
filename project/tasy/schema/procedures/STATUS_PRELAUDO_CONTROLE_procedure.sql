-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE status_prelaudo_controle (ie_status_execucao_p text, nr_laudo_p bigint, nm_usuario_p text default null) AS $body$
DECLARE


nr_prescricao_w           bigint;
nr_sequencia_prescricao_w integer;
nr_status_auditoria_w     smallint;
ie_duvida_w               varchar(1);

ie_encaminhado_w          varchar(1);

BEGIN

  SELECT nr_prescricao,
         nr_seq_prescricao
  INTO STRICT   nr_prescricao_w,
         nr_sequencia_prescricao_w
  FROM   laudo_paciente
  WHERE  nr_sequencia = nr_laudo_p;

  SELECT coalesce(IE_DUVIDA, 'N')
  INTO STRICT   ie_duvida_w
  FROM   laudo_paciente
  WHERE  nr_sequencia = nr_laudo_p;

  IF (ie_status_execucao_p = '30') THEN
    IF (ie_duvida_w = 'S') THEN
    CALL gravar_auditoria_mmed(nr_prescricao_w,
                        nr_sequencia_prescricao_w,
                        nm_usuario_p,
                        32,
                        NULL);

  ELSE
    CALL gravar_auditoria_mmed(nr_prescricao_w,
                        nr_sequencia_prescricao_w,
                        nm_usuario_p,
                        33,
                        NULL);

  END IF;
  ELSIF (ie_status_execucao_p = '26') THEN
    IF (ie_duvida_w = 'S') THEN
    UPDATE laudo_paciente
      SET ie_duvida = 'N'
    WHERE  nr_sequencia = nr_laudo_p;
    END IF;
  CALL gravar_auditoria_mmed(nr_prescricao_w,
                        nr_sequencia_prescricao_w,
                        nm_usuario_p,
                        31,
                        NULL);
  END IF;

  SELECT coalesce(MAX(ie_encaminhado), 'N')
  INTO STRICT   ie_encaminhado_w
  FROM   laudo_paciente_compl
  WHERE  nr_seq_laudo = nr_laudo_p;

  IF (ie_encaminhado_w = 'N') THEN
    INSERT INTO laudo_paciente_compl(nr_sequencia,
                                   nr_seq_laudo,
                   dt_atualizacao,
                   nm_usuario,
                   dt_atualizacao_nrec,
                   nm_usuario_nrec,
                   ie_encaminhado)
  VALUES (nextval('laudo_paciente_compl_seq'),
         nr_laudo_p,
       clock_timestamp(),
       nm_usuario_p,
       clock_timestamp(),
       nm_usuario_p,
       'S');
  END IF;

  UPDATE prescr_procedimento a
  SET    a.ie_status_execucao = ie_status_execucao_p,
         a.nm_usuario = nm_usuario_p
  WHERE  a.nr_seq_interno IN (SELECT nr_seq_interno
                              FROM   prescr_procedimento b,
                                     procedimento_paciente c
                              WHERE  b.nr_sequencia  = c.nr_sequencia_prescricao
                              AND    b.nr_prescricao = c.nr_prescricao
                              AND    c.nr_laudo      = nr_laudo_p);

  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE status_prelaudo_controle (ie_status_execucao_p text, nr_laudo_p bigint, nm_usuario_p text default null) FROM PUBLIC;
