-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION put_nutrition_intake_goal ( nr_atendimento_p bigint, dt_meta_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w nutrition_intake_goals.nr_sequencia%type;


BEGIN

  insert into nutrition_intake_goals(
	nr_sequencia,
    dt_atualizacao_nrec,
    dt_meta,
    nm_usuario_nrec,
    nr_atendimento)
  values (
	nextval('nutrition_intake_goals_seq'),
    clock_timestamp(),
    dt_meta_p,
    wheb_usuario_pck.get_nm_usuario,
    nr_atendimento_p)
  returning nr_sequencia into nr_sequencia_w;

  commit;
  return nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION put_nutrition_intake_goal ( nr_atendimento_p bigint, dt_meta_p timestamp) FROM PUBLIC;
