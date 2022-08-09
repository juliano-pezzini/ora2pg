-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gqa_liberar_campo_etapa ( nr_seq_etapa_p gqa_protocolo_etapa_pac.nr_sequencia%type, forcar text ) AS $body$
DECLARE


nm_usuario_w              gqa_protocolo_pac.nm_usuario%type;

nr_seq_score_flex_ii_w    gqa_protocolo_etapa_pac.nr_seq_score_flex_ii%type;
nr_seq_avaliacao_w        gqa_protocolo_etapa_pac.nr_seq_avaliacao%type;
nr_seq_evolucao_w         gqa_protocolo_etapa_pac.nr_seq_evolucao%type;
nr_seq_etapa_w            gqa_protocolo_etapa_pac.nr_seq_etapa%type;
nr_seq_acao_w             gqa_protocolo_etapa_pac.nr_seq_acao%type;

ie_tipo_acao_w            gqa_acao.ie_tipo_acao%type;
ie_permite_alterar_w      gqa_pendencia_regra.ie_permite_alterar%type;


BEGIN
  select obter_usuario_ativo into STRICT nm_usuario_w;

  select
          nr_seq_etapa,
          nr_seq_acao,
          nr_seq_score_flex_ii,
          nr_seq_avaliacao,
          nr_seq_evolucao
  into STRICT
          nr_seq_etapa_w,
          nr_seq_acao_w,
          nr_seq_score_flex_ii_w,
          nr_seq_avaliacao_w,
          nr_seq_evolucao_w
  from gqa_protocolo_etapa_pac
  where nr_sequencia = nr_seq_etapa_p;

  select ie_permite_alterar into STRICT ie_permite_alterar_w from gqa_pendencia_regra where nr_sequencia = nr_seq_etapa_w;

  if (ie_permite_alterar_w = 'N' or forcar = 'S') then
    select ie_tipo_acao into STRICT ie_tipo_acao_w from gqa_acao where nr_sequencia = nr_seq_acao_w;

    if (ie_tipo_acao_w = 'ES') then
      update escala_eif_ii set dt_liberacao = clock_timestamp() where nr_sequencia = nr_seq_score_flex_ii_w and coalesce(dt_liberacao::text, '') = '';
    elsif (ie_tipo_acao_w = 'AV') then
      update med_avaliacao_paciente set dt_liberacao = clock_timestamp(), nm_usuario_lib = nm_usuario_w where nr_sequencia = nr_seq_avaliacao_w and coalesce(dt_liberacao::text, '') = '';
    elsif (ie_tipo_acao_w = 'NC') then
      update evolucao_paciente set dt_liberacao = clock_timestamp() where cd_evolucao = nr_seq_evolucao_w and coalesce(dt_liberacao::text, '') = '';
    end if;
  end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gqa_liberar_campo_etapa ( nr_seq_etapa_p gqa_protocolo_etapa_pac.nr_sequencia%type, forcar text ) FROM PUBLIC;
