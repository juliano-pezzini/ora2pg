-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gqa_atualiza_etapas_mentor (nr_atendimento_p bigint) AS $body$
DECLARE


  c_etapas_abertas CURSOR FOR
    SELECT e.nr_sequencia
          ,a.ie_tipo_acao
      FROM gqa_protocolo_pac       p
          ,gqa_protocolo_etapa_pac e
          ,gqa_acao                a
     WHERE p.nr_sequencia = e.nr_seq_prot_pac
       AND e.nr_seq_acao = a.nr_sequencia
       AND p.nr_atendimento = nr_atendimento_p
       AND p.ie_situacao = 'A'
       AND (p.dt_liberacao IS NOT NULL AND p.dt_liberacao::text <> '')
       AND coalesce(p.dt_inativacao::text, '') = ''
       AND coalesce(p.dt_termino::text, '') = ''
       AND coalesce(e.dt_cancelar_usuario::text, '') = ''
       AND coalesce(e.dt_fim::text, '') = '';

  prescr_executada_w varchar(1);
BEGIN
  FOR r1 IN c_etapas_abertas LOOP
    IF r1.ie_tipo_acao = 'EP' THEN
      prescr_executada_w := obter_se_prescricao_executada(r1.nr_sequencia);

      IF (prescr_executada_w = 'S') THEN
        CALL gqa_calc_resultado_acao(r1.nr_sequencia, NULL, NULL);
        CALL gqa_acao_etapa(r1.nr_sequencia, NULL, NULL, 'F');
      END IF;
    END IF;
  END LOOP;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gqa_atualiza_etapas_mentor (nr_atendimento_p bigint) FROM PUBLIC;
