-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION search_panorama_content.get_escala_acuidade (cd_setor_atendimento_p bigint, nr_atendimento_p bigint, ie_escala_acuidade_p text default null, nr_seq_score_flex_p text default null) RETURNS varchar AS $body$
DECLARE

risco_severidade CURSOR FOR
SELECT * from table(SEARCH_PANORAMA_CONTENT.get_severidade_algoritimo_pan(cd_setor_atendimento_p,nr_atendimento_p, ie_escala_acuidade_p, nr_seq_score_flex_p));

ie_risco_severidade_w varchar(255);
BEGIN

  for r1 in risco_severidade loop
    if (coalesce(ie_risco_severidade_w::text, '') = '') then
        ie_risco_severidade_w :=SUBSTR(r1.ie_severidade,1,1) || r1.ie_escala_acuidade;
    end if;
  end loop;

  return ie_risco_severidade_w;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION search_panorama_content.get_escala_acuidade (cd_setor_atendimento_p bigint, nr_atendimento_p bigint, ie_escala_acuidade_p text default null, nr_seq_score_flex_p text default null) FROM PUBLIC;