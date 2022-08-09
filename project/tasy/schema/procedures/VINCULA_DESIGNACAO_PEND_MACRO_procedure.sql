-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincula_designacao_pend_macro ( nr_seq_macroscopia_p bigint, nr_seq_amostra_princ_p bigint, nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE

  nr_seq_macroscopia_w bigint;
  C01 CURSOR FOR
    SELECT m.nr_sequencia
    FROM prescr_proc_macroscopia m,
      prescr_proc_peca p
    WHERE p.nr_prescricao      = nr_prescricao_p
    AND p.nr_seq_amostra_princ = nr_seq_amostra_princ_p
    AND m.nr_seq_peca          = p.nr_sequencia
    AND (m.dt_liberacao IS NOT NULL AND m.dt_liberacao::text <> '')
    AND (m.dt_inativacao IS NOT NULL AND m.dt_inativacao::text <> '')
    AND EXISTS (SELECT 1
      FROM tipo_amostra t
      WHERE t.ie_tipo_exame <> 5
      AND t.nr_sequencia     = p.nr_seq_tipo
      )
  ORDER BY m.nr_sequencia;

BEGIN
  OPEN C01;
  LOOP
    FETCH C01 INTO nr_seq_macroscopia_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
    BEGIN
      UPDATE prescr_proc_macro_desig
      SET nr_seq_macroscopia   = nr_seq_macroscopia_p,
        dt_atualizacao         = clock_timestamp(),
        nm_usuario             = nm_usuario_p
      WHERE nr_seq_macroscopia       = nr_seq_macroscopia_w
      AND nr_seq_amostra_princ = nr_seq_amostra_princ_p;
    END;
  END LOOP;
  CLOSE C01;
  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincula_designacao_pend_macro ( nr_seq_macroscopia_p bigint, nr_seq_amostra_princ_p bigint, nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
