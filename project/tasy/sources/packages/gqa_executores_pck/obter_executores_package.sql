-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION gqa_executores_pck.obter_executores (nr_sequencia_p bigint) RETURNS SETOF GQA_EXECUTORES_TABLE AS $body$
DECLARE


    c_executores IS CURSOR
      WITH executores AS (SELECT b.nr_sequencia
                                ,b.nr_seq_acao
                                ,d.ie_pessoa_destino
                                ,d.nr_seq_equipe
                                ,d.cd_especialidade
                                ,d.cd_pf_destino
                                ,d.cd_perfil
                                ,a.nm_usuario_liberacao
                                ,a.nr_atendimento
                                ,e.cd_medico_resp
                            FROM gqa_protocolo_pac       a
                                ,gqa_protocolo_etapa_pac b
                                ,gqa_acao                c
                                ,gqa_acao_regra_prof     d
                                ,atendimento_paciente    e
                           WHERE a.nr_sequencia = b.nr_seq_prot_pac
                             AND b.nr_seq_acao = c.nr_sequencia
                             AND c.nr_sequencia = d.nr_seq_acao
                             AND a.nr_atendimento = e.nr_atendimento
                             AND b.nr_sequencia = nr_sequencia_p)
       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(t.cd_medico_resp) nm_pessoa
             ,NULL nm_usuario
             ,t.cd_medico_resp cd_pessoa_fisica
         FROM executores t
        WHERE t.ie_pessoa_destino = '1'

UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_medico_auxiliar_atend(t.nr_atendimento
                                         ,'N')
             ,NULL
             ,NULL
         FROM executores t
        WHERE t.ie_pessoa_destino = '2'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(obter_pf_usuario(t.nm_usuario_liberacao
                                            ,'C'))
             ,t.nm_usuario_liberacao
             ,NULL
         FROM executores t
        WHERE t.ie_pessoa_destino = '3'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(a.cd_pessoa_fisica)
             ,NULL
             ,a.cd_pessoa_fisica
         FROM atend_profissional a
             ,executores         t
        WHERE a.nr_atendimento = t.nr_atendimento
          AND t.ie_pessoa_destino = '4'
          AND ((a.ie_profissional = 'E') OR (is_copy_base_locale('es_MX') = 'S' AND
              a.ie_profissional = '6'))
          AND a.nr_sequencia =
              (SELECT MAX(x.nr_sequencia)
                 FROM atend_profissional x
                WHERE x.nr_atendimento = a.nr_atendimento
                  AND x.ie_profissional = 'E')
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_enfermeiro_resp(t.nr_atendimento, 'N')
             ,NULL
             ,NULL
         FROM executores t
        WHERE t.ie_pessoa_destino = '5'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(t.cd_pf_destino)
             ,NULL
             ,t.cd_pf_destino
         FROM executores t
        WHERE t.ie_pessoa_destino = '6'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(obter_pessoa_escala_gqa(t.nr_atendimento))
             ,NULL
             ,NULL
         FROM executores t
        WHERE t.ie_pessoa_destino = '7'
          AND obter_se_medico(obter_pessoa_escala_gqa(t.nr_atendimento)
                             ,'M') = 'S'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(obter_pessoa_escala_gqa(t.nr_atendimento))
             ,NULL
             ,NULL
         FROM executores t
        WHERE t.ie_pessoa_destino = '8'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(a.cd_pessoa_fisica)
             ,NULL
             ,a.cd_pessoa_fisica
         FROM pf_equipe_partic a
             ,executores       t
        WHERE a.nr_seq_equipe = t.nr_seq_equipe
          AND t.ie_pessoa_destino = '9'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(a.cd_pessoa_fisica)
             ,NULL
             ,a.cd_pessoa_fisica
         FROM pf_equipe  a
             ,executores t
        WHERE a.nr_sequencia = t.nr_seq_equipe
          AND t.ie_pessoa_destino = '9'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(a.cd_pessoa_fisica)
             ,NULL
             ,a.cd_pessoa_fisica
         FROM medico_especialidade a
             ,executores           t
        WHERE a.cd_especialidade = t.cd_especialidade
          AND t.ie_pessoa_destino = '10'
       
UNION

       SELECT t.nr_sequencia
             ,t.nr_seq_acao
             ,t.ie_pessoa_destino
             ,obter_nome_pf(obter_pf_usuario(a.nm_usuario, 'C'))
             ,a.nm_usuario
             ,NULL
         FROM usuario_perfil a
             ,executores     t
        WHERE a.cd_perfil = t.cd_perfil
          AND t.ie_pessoa_destino = '11';


BEGIN
    FOR r_executores IN c_executores LOOP
      RETURN NEXT r_executores;
    END LOOP;

    RETURN;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gqa_executores_pck.obter_executores (nr_sequencia_p bigint) FROM PUBLIC;
