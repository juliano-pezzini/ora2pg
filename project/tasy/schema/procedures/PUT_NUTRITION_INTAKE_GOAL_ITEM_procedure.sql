-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE put_nutrition_intake_goal_item ( nr_atendimento_p bigint, dt_meta_p timestamp, str_arr_nutrient_keys_p text, str_arr_goal_types_p text, str_arr_goal_min_values_p text, str_arr_goal_max_values_p text ) AS $body$
DECLARE


nr_sequencia_w bigint;
min_goal_w bigint;
max_goal_w bigint;

keys_count_w integer;
keys_array_w dbms_utility.lname_array;

types_count_w integer;
goal_types_array_w dbms_utility.lname_array;

min_count_w integer;
min_array_w dbms_utility.lname_array;

max_count_w integer;
max_array_w dbms_utility.lname_array;

BEGIN

   dbms_utility.comma_to_table( list   => str_arr_nutrient_keys_p,
      tablen => keys_count_w,
      tab    => keys_array_w
   );

   dbms_utility.comma_to_table( list   => str_arr_goal_types_p,
      tablen => types_count_w, 
      tab    => goal_types_array_w
   );

   dbms_utility.comma_to_table( list   => regexp_replace(str_arr_goal_min_values_p,'(^|,)','\1x'), --necessary to number type arrays
      tablen => min_count_w,
      tab    => min_array_w
   );

   dbms_utility.comma_to_table( list   => regexp_replace(str_arr_goal_max_values_p,'(^|,)','\1x'), --necessary to number type arrays
      tablen => max_count_w,
      tab    => max_array_w
   );

  DELETE FROM nutrition_intake_goal_item nim
  WHERE  NR_SEQ_GOAL IN (SELECT NR_SEQUENCIA FROM NUTRITION_INTAKE_GOALS where nr_atendimento = nr_atendimento_p);
  COMMIT;

  INSERT INTO nutrition_intake_goals(
    NR_SEQUENCIA,
    DT_ATUALIZACAO_NREC,
    DT_META,
    NM_USUARIO_NREC,
    NR_ATENDIMENTO
  )
  VALUES (
    nextval('nutrition_intake_goals_seq'),
    clock_timestamp(),
    dt_meta_p,
    wheb_usuario_pck.get_nm_usuario,
    nr_atendimento_p
  ) returning nr_sequencia into nr_sequencia_w;
  commit;

  for i in 1 .. keys_count_w
   loop
      min_goal_w := cast(replace(min_array_w(i), 'x', '') as bigint);
      max_goal_w := cast(replace(max_array_w(i), 'x', '') as bigint);

     
      --dbms_output.put_line('IE_TIPO_META: '||goal_types_array_w(i)||' IE_TIPO_NUTRIENTE: '||keys_array_w(i)||' NR_SEQ_GOAL: '||nr_sequencia_w||' max_goal_val: ' || max_goal_w || ' min_goal_val: ' || min_goal_w); 
        INSERT INTO nutrition_intake_goal_item(
          IE_TIPO_META,
          IE_TIPO_NUTRIENTE,
          NR_SEQ_GOAL,
          QT_META_MIN,
          QT_META_MAX
        )
        VALUES (
          goal_types_array_w(i),
          keys_array_w(i),
          nr_sequencia_w,
          min_goal_w,
          max_goal_w
        );

  end loop;

      
  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE put_nutrition_intake_goal_item ( nr_atendimento_p bigint, dt_meta_p timestamp, str_arr_nutrient_keys_p text, str_arr_goal_types_p text, str_arr_goal_min_values_p text, str_arr_goal_max_values_p text ) FROM PUBLIC;
