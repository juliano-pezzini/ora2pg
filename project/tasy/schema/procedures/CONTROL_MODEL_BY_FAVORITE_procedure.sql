-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE control_model_by_favorite (nr_seq_pepo_favs_p text default null, nr_seq_modelo_secao_p bigint DEFAULT NULL, nm_usuario_p text  DEFAULT NULL) AS $body$
WITH RECURSIVE cte AS (
DECLARE

favorites CURSOR FOR
SELECT (regexp_substr(nr_seq_pepo_favs_p,'[^,]+', 1, level))::numeric  as nr_sequencia, row_number() OVER () as seq 
  (regexp_substr(nr_seq_pepo_favs_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_pepo_favs_p, '[^,]+', 1, level))::text <> '')
  UNION ALL
DECLARE

favorites CURSOR FOR 
SELECT (regexp_substr(nr_seq_pepo_favs_p,'[^,]+', 1, level))::numeric  as nr_sequencia, row_number() OVER () as seq 
  (regexp_substr(nr_seq_pepo_favs_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_pepo_favs_p, '[^,]+', 1, level))::text <> '')
 JOIN cte c ON ()

) SELECT * FROM cte
union

SELECT nr_sequencia, 0 as seq from pepo_modelo_secao_fav mf
where nr_sequencia not in (WITH RECURSIVE cte AS (

select (regexp_substr(coalesce(nr_seq_pepo_favs_p,'0'),'[^,]+', 1, level))::numeric   
  (regexp_substr(nr_seq_pepo_favs_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_pepo_favs_p, '[^,]+', 1, level))::text <> '')  UNION ALL

select (regexp_substr(coalesce(nr_seq_pepo_favs_p,'0'),'[^,]+', 1, level))::numeric   
  (regexp_substr(nr_seq_pepo_favs_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_pepo_favs_p, '[^,]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
)
and (exists (select 1 from pepo_modelo_secao_sv where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = mf.nr_sequencia) 
  or exists (select 1 from pepo_modelo_secao_agt_med where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = mf.nr_sequencia)
  or exists (select 1 from pepo_modelo_secao_perd_ga where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = mf.nr_sequencia)
  or exists (select 1 from pepo_modelo_secao_lab where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = mf.nr_sequencia)
  or exists (select 1 from pepo_modelo_secao_hemod where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = mf.nr_sequencia));
;

favoriteItem CURSOR( nr_seq_fav_p  pepo_modelo_secao_fav.nr_sequencia%type, cd_tipo_secao_p pepo_modelo_secao_fav.cd_tipo_secao%type) FOR
  SELECT mi.nr_seq_pepo_sv, mi.nr_seq_pepo_agent_med, mi.nr_seq_agent_anest_mat, mi.nr_seq_apresentacao, mi.nr_seq_tipo_perda_ganho, mi.nr_seq_lab_test, mi.nr_seq_hemod
    from pepo_modelo_secao_fav  mf, pepo_modelo_secao_fav_item mi
   where mf.nr_sequencia = mi.nr_seq_modelo_secao_fav  
	and mf.nr_sequencia = nr_seq_fav_p
	and mf.cd_tipo_secao = cd_tipo_secao_p;

														
														
v_maxOrderSV pepo_modelo_secao_sv.nr_seq_apresentacao%type;
v_maxOrderAG pepo_modelo_secao_agt_med.nr_seq_apresentacao%type;
v_maxOrderIO pepo_modelo_secao_perd_ga.nr_seq_apresentacao%type;
v_maxOrderEL pepo_modelo_secao_lab.nr_seq_apresentacao%type;
v_maxOrderBP pepo_modelo_secao_hemod.nr_seq_apresentacao%type;

type nr_seq_fav_w is table of pepo_modelo_secao_sv.nr_seq_fav%type index by integer;
a_nr_seq_fav_w nr_seq_fav_w;

type nr_ordem_apres_w is table of pepo_modelo_secao_sv.nr_seq_apresentacao%type index by integer;
a_ordem_apres_w nr_ordem_apres_w;

type nr_seq_pepo_sv_w 			is table of pepo_modelo_secao_fav_item.nr_seq_pepo_sv%type index by integer;
a_nr_seq_pepo_sv_w nr_seq_pepo_sv_w;

type nr_seq_pepo_agent_med_w 	is table of pepo_modelo_secao_fav_item.nr_seq_pepo_agent_med%type index by integer;
a_nr_seq_pepo_agent_med_w nr_seq_pepo_agent_med_w;

type nr_seq_agent_anest_mat_w 	is table of pepo_modelo_secao_fav_item.nr_seq_agent_anest_mat%type index by integer;
a_nr_seq_agent_anest_mat_w nr_seq_agent_anest_mat_w;

type nr_seq_apresentacao_w 		is table of pepo_modelo_secao_fav_item.nr_seq_apresentacao%type index by integer;
a_nr_seq_apresentacao_w nr_seq_apresentacao_w;

type nr_seq_tipo_perda_ganho_w 	is table of pepo_modelo_secao_fav_item.nr_seq_tipo_perda_ganho%type index by integer;
a_nr_seq_tipo_perda_ganho_w nr_seq_tipo_perda_ganho_w;

type nr_seq_lab_test_w 			is table of pepo_modelo_secao_fav_item.nr_seq_lab_test%type index by integer;
a_nr_seq_lab_test_w nr_seq_lab_test_w;

type nr_seq_hemod_w 			is table of pepo_modelo_secao_fav_item.nr_seq_hemod%type index by integer;
a_nr_seq_hemod_w nr_seq_hemod_w;
														
BEGIN

select coalesce(max(nr_seq_apresentacao),0) into STRICT v_maxOrderSV from pepo_modelo_secao_sv where nr_seq_modelo_secao = nr_seq_modelo_secao_p;
select coalesce(max(nr_seq_apresentacao),0) into STRICT v_maxOrderAG from pepo_modelo_secao_agt_med where nr_seq_modelo_secao = nr_seq_modelo_secao_p;
select coalesce(max(nr_seq_apresentacao),0) into STRICT v_maxOrderIO from pepo_modelo_secao_perd_ga where nr_seq_modelo_secao = nr_seq_modelo_secao_p;
select coalesce(max(nr_seq_apresentacao),0) into STRICT v_maxOrderEL from pepo_modelo_secao_lab where nr_seq_modelo_secao = nr_seq_modelo_secao_p;
select coalesce(max(nr_seq_apresentacao),0) into STRICT v_maxOrderBP from pepo_modelo_secao_hemod where nr_seq_modelo_secao = nr_seq_modelo_secao_p;

for r1 in favorites loop		
		
		open favoriteItem(r1.nr_sequencia, 'SV');
		fetch favoriteItem bulk collect into a_nr_seq_pepo_sv_w, a_nr_seq_pepo_agent_med_w, a_nr_seq_agent_anest_mat_w,
											 a_nr_seq_apresentacao_w, a_nr_seq_tipo_perda_ganho_w, a_nr_seq_lab_test_w, 
											 a_nr_seq_hemod_w limit 1000;
		close favoriteItem;
		
		forall i in a_nr_seq_pepo_sv_w.first..a_nr_seq_pepo_sv_w.last
		 merge into pepo_modelo_secao_sv a using(SELECT
          nr_seq_modelo_secao_p nr_seq_modelo_secao,
          a_nr_seq_pepo_sv_w(i) nr_seq_pepo_sv
          ) b on (
            a.nr_seq_modelo_secao = b.nr_seq_modelo_secao
            and a.nr_seq_pepo_sv = b.nr_seq_pepo_sv
          )
          when matched then update set nr_seq_fav = r1.nr_sequencia
          when not matched then insert(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_apresentacao,
								nr_seq_pepo_sv,
								nr_seq_modelo_secao,
								nr_seq_fav
								) values (
								nextval('pepo_modelo_secao_sv_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								v_maxOrderSV + a_nr_seq_apresentacao_w(i),
								a_nr_seq_pepo_sv_w(i),
								nr_seq_modelo_secao_p,
								r1.nr_sequencia
								);
								
		open favoriteItem(r1.nr_sequencia, 'AG');
		fetch favoriteItem bulk collect into a_nr_seq_pepo_sv_w, a_nr_seq_pepo_agent_med_w, a_nr_seq_agent_anest_mat_w,
											 a_nr_seq_apresentacao_w, a_nr_seq_tipo_perda_ganho_w, a_nr_seq_lab_test_w, 
											 a_nr_seq_hemod_w limit 1000;
		close favoriteItem;
		
		forall i in a_nr_seq_pepo_agent_med_w.first..a_nr_seq_pepo_agent_med_w.last
			merge into pepo_modelo_secao_agt_med a using(SELECT
			  nr_seq_modelo_secao_p nr_seq_modelo_secao,
			  a_nr_seq_agent_anest_mat_w(i) nr_seq_agent_anest_mat,
			  a_nr_seq_pepo_agent_med_w(i) nr_seq_pepo_agent_med
			  ) b on (
				a.nr_seq_modelo_secao = b.nr_seq_modelo_secao
				and a.nr_seq_agent_anest_mat = b.nr_seq_agent_anest_mat
				and a.nr_seq_pepo_agent_med = b.nr_seq_pepo_agent_med
			  )
			  when matched then update set nr_seq_fav = r1.nr_sequencia
			  when not matched then insert(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_apresentacao,
								nr_seq_pepo_agent_med,
								nr_seq_modelo_secao,
								nr_seq_agent_anest_mat, 
								nr_seq_fav
								) values (
								nextval('pepo_modelo_secao_agt_med_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								v_maxOrderAG + a_nr_seq_apresentacao_w(i),
								a_nr_seq_pepo_agent_med_w(i),
								nr_seq_modelo_secao_p,
								a_nr_seq_agent_anest_mat_w(i),
								r1.nr_sequencia
								);
		
		open favoriteItem(r1.nr_sequencia, 'BH');
		fetch favoriteItem bulk collect into a_nr_seq_pepo_sv_w, a_nr_seq_pepo_agent_med_w, a_nr_seq_agent_anest_mat_w,
											 a_nr_seq_apresentacao_w, a_nr_seq_tipo_perda_ganho_w, a_nr_seq_lab_test_w, 
											 a_nr_seq_hemod_w limit 1000;
		close favoriteItem;
		
		forall i in a_nr_seq_tipo_perda_ganho_w.first..a_nr_seq_tipo_perda_ganho_w.last
			merge into pepo_modelo_secao_perd_ga a using(SELECT
			  nr_seq_modelo_secao_p nr_seq_modelo_secao,
			  a_nr_seq_tipo_perda_ganho_w(i) nr_seq_tipo			  
			  ) b on (
				a.nr_seq_modelo_secao = b.nr_seq_modelo_secao
				and a.nr_seq_tipo = b.nr_seq_tipo
			)
			  when matched then update set nr_seq_fav = r1.nr_sequencia
			  when not matched then insert(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_apresentacao,
						nr_seq_tipo,
						nr_seq_modelo_secao,
						nr_seq_fav
						) values (
						nextval('pepo_modelo_secao_perd_ga_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						v_maxOrderIO + a_nr_seq_apresentacao_w(i),
						a_nr_seq_tipo_perda_ganho_w(i),
						nr_seq_modelo_secao_p,
						r1.nr_sequencia
						);
		
		open favoriteItem(r1.nr_sequencia, 'EL');
		fetch favoriteItem bulk collect into a_nr_seq_pepo_sv_w, a_nr_seq_pepo_agent_med_w, a_nr_seq_agent_anest_mat_w,
											 a_nr_seq_apresentacao_w, a_nr_seq_tipo_perda_ganho_w, a_nr_seq_lab_test_w, 
											 a_nr_seq_hemod_w limit 1000;
		close favoriteItem;
		
		forall i in a_nr_seq_lab_test_w.first..a_nr_seq_lab_test_w.last
			merge into pepo_modelo_secao_lab a using(SELECT
			  nr_seq_modelo_secao_p nr_seq_modelo_secao,
			  a_nr_seq_lab_test_w(i) nr_seq_lab_test			  
			  ) b on (
				a.nr_seq_modelo_secao = b.nr_seq_modelo_secao
				and a.nr_seq_lab_test = b.nr_seq_lab_test
			)
			  when matched then update set nr_seq_fav = r1.nr_sequencia
			  when not matched then insert(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_apresentacao,
							nr_seq_modelo_secao,
							nr_seq_fav,
							nr_seq_lab_test)
						values (
							nextval('pepo_modelo_secao_lab_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							v_maxOrderEL + a_nr_seq_apresentacao_w(i),
							nr_seq_modelo_secao_p,
							r1.nr_sequencia,
							a_nr_seq_lab_test_w(i)
							);
		open favoriteItem(r1.nr_sequencia, 'SH');
		fetch favoriteItem bulk collect into a_nr_seq_pepo_sv_w, a_nr_seq_pepo_agent_med_w, a_nr_seq_agent_anest_mat_w,
											 a_nr_seq_apresentacao_w, a_nr_seq_tipo_perda_ganho_w, a_nr_seq_lab_test_w, 
											 a_nr_seq_hemod_w limit 1000;
		close favoriteItem;

		forall i in a_nr_seq_hemod_w.first..a_nr_seq_hemod_w.last
			merge into pepo_modelo_secao_hemod a using(SELECT
			  nr_seq_modelo_secao_p nr_seq_modelo_secao,
			  a_nr_seq_hemod_w(i) nr_seq_hemod			  
			  ) b on (
				a.nr_seq_modelo_secao = b.nr_seq_modelo_secao
				and a.nr_seq_hemod = b.nr_seq_hemod
			)
			  when matched then update set nr_seq_fav = r1.nr_sequencia
			  when not matched then insert(	
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_apresentacao,
								nr_seq_modelo_secao,
								nr_seq_fav,
								nr_seq_hemod)
							values (
								nextval('pepo_modelo_secao_hemod_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								v_maxOrderBP + a_nr_seq_apresentacao_w(i),
								nr_seq_modelo_secao_p,
								r1.nr_sequencia,
								a_nr_seq_hemod_w(i)
							);
end loop;

	open favorites;
	fetch favorites bulk collect into a_nr_seq_fav_w, a_ordem_apres_w limit 1000;
	close favorites;
	
	forall i in a_nr_seq_fav_w.first..a_nr_seq_fav_w.last
		delete from pepo_modelo_secao_sv where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = a_nr_seq_fav_w(i) and a_ordem_apres_w(i) = 0;
	forall i in a_nr_seq_fav_w.first..a_nr_seq_fav_w.last
		delete from pepo_modelo_secao_agt_med where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = a_nr_seq_fav_w(i) and a_ordem_apres_w(i) = 0;
	forall i in a_nr_seq_fav_w.first..a_nr_seq_fav_w.last
		delete from pepo_modelo_secao_perd_ga where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = a_nr_seq_fav_w(i) and a_ordem_apres_w(i) = 0;
	forall i in a_nr_seq_fav_w.first..a_nr_seq_fav_w.last
		delete from pepo_modelo_secao_lab where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = a_nr_seq_fav_w(i) and a_ordem_apres_w(i) = 0;
	forall i in a_nr_seq_fav_w.first..a_nr_seq_fav_w.last
		delete from pepo_modelo_secao_hemod where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_fav = a_nr_seq_fav_w(i) and a_ordem_apres_w(i) = 0;
		
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE control_model_by_favorite (nr_seq_pepo_favs_p text default null, nr_seq_modelo_secao_p bigint DEFAULT NULL, nm_usuario_p text  DEFAULT NULL) FROM PUBLIC;

