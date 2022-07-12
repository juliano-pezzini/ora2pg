-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION search_panorama_content.get_delta_value (cd_setor_atendimento_p bigint, nr_atendimento_p bigint, ie_escala_acuidade_p text default null, nr_seq_score_flex_p text default null) RETURNS bigint AS $body$
DECLARE

risco_severidade CURSOR FOR
SELECT * from table(SEARCH_PANORAMA_CONTENT.get_severidade_algoritimo_pan(cd_setor_atendimento_p,nr_atendimento_p, ie_escala_acuidade_p, nr_seq_score_flex_p));

nr_delta_w double precision;
BEGIN

  for r1 in risco_severidade loop
    nr_delta_w := r1.nr_delta;
  end loop;

  return nr_delta_w;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION search_panorama_content.get_delta_value (cd_setor_atendimento_p bigint, nr_atendimento_p bigint, ie_escala_acuidade_p text default null, nr_seq_score_flex_p text default null) FROM PUBLIC;
