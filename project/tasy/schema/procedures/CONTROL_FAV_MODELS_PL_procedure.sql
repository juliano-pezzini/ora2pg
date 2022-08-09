-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE control_fav_models_pl (nr_seq_modelo_fav_p bigint, ie_type_p text, nm_usuario_p text, nr_seq_fav_agents_p text default null, nr_seq_fav_material_p text default null, nr_seq_fav_sv_p text default null, nr_seq_fav_io_p text default null, nr_seq_fav_lab_p text default null, nr_seq_fav_hem_p text default null) AS $body$
WITH RECURSIVE cte AS (
DECLARE


ora2pg_rowcount int;
agenListList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_agents_p,'[^,]+', 1, level))::numeric  as nr_seq_pepo_agent_med, (regexp_substr(nr_seq_fav_material_p,'[^,]+', 1, level))::numeric  as nr_seq_agent_anest_mat, row_number() OVER () as seq
  (regexp_substr(nr_seq_fav_agents_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_agents_p, '[^,]+', 1, level))::text <> '')
  UNION ALL
DECLARE


agenListList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_agents_p,'[^,]+', 1, level))::numeric  as nr_seq_pepo_agent_med, (regexp_substr(nr_seq_fav_material_p,'[^,]+', 1, level))::numeric  as nr_seq_agent_anest_mat, row_number() OVER () as seq 
  (regexp_substr(nr_seq_fav_agents_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_agents_p, '[^,]+', 1, level))::text <> '')
 JOIN cte c ON ()

) SELECT * FROM cte
union

select nr_seq_pepo_agent_med, nr_seq_agent_anest_mat, 0 as seq from pepo_modelo_secao_fav_item
where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p and nr_seq_agent_anest_mat not in (WITH RECURSIVE cte AS (

select regexp_substr(nr_seq_fav_agents_p,'[^,]+', 1, level)  
  (regexp_substr(nr_seq_fav_agents_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_agents_p, '[^,]+', 1, level))::text <> '')
  UNION ALL

select regexp_substr(nr_seq_fav_agents_p,'[^,]+', 1, level) JOIN cte c ON ()

) SELECT * FROM cte;
)
order by seq;
;WITH RECURSIVE cte AS (


signsList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_sv_p,'[^,]+', 1, level))::numeric  as nr_seq_pepo_sv, row_number() OVER () as seq
  (regexp_substr(nr_seq_fav_sv_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_sv_p, '[^,]+', 1, level))::text <> '')
  UNION ALL


signsList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_sv_p,'[^,]+', 1, level))::numeric  as nr_seq_pepo_sv, row_number() OVER () as seq 
  (regexp_substr(nr_seq_fav_sv_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_sv_p, '[^,]+', 1, level))::text <> '')
 JOIN cte c ON ()

) SELECT * FROM cte
union

select nr_seq_pepo_sv, 0 as seq from pepo_modelo_secao_fav_item
where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p and nr_seq_pepo_sv not in (WITH RECURSIVE cte AS (

select regexp_substr(nr_seq_fav_sv_p,'[^,]+', 1, level)  
  (regexp_substr(nr_seq_fav_sv_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_sv_p, '[^,]+', 1, level))::text <> '')
  UNION ALL

select regexp_substr(nr_seq_fav_sv_p,'[^,]+', 1, level) JOIN cte c ON ()

) SELECT * FROM cte;
)
order by seq;
;WITH RECURSIVE cte AS (


intAndOutList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_io_p,'[^,]+', 1, level))::numeric  as nr_seq_tipo_perda_ganho, row_number() OVER () as seq
  (regexp_substr(nr_seq_fav_io_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_io_p, '[^,]+', 1, level))::text <> '')
  UNION ALL


intAndOutList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_io_p,'[^,]+', 1, level))::numeric  as nr_seq_tipo_perda_ganho, row_number() OVER () as seq 
  (regexp_substr(nr_seq_fav_io_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_io_p, '[^,]+', 1, level))::text <> '')
 JOIN cte c ON ()

) SELECT * FROM cte
union

select nr_seq_tipo_perda_ganho, 0 as seq from pepo_modelo_secao_fav_item
where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p and nr_seq_tipo_perda_ganho not in (WITH RECURSIVE cte AS (

select regexp_substr(nr_seq_fav_io_p,'[^,]+', 1, level)  
  (regexp_substr(nr_seq_fav_io_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_io_p, '[^,]+', 1, level))::text <> '')
  UNION ALL

select regexp_substr(nr_seq_fav_io_p,'[^,]+', 1, level) JOIN cte c ON ()

) SELECT * FROM cte;
)
order by seq;
;WITH RECURSIVE cte AS (


labTestList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_lab_p,'[^,]+', 1, level))::numeric  as nr_seq_lab_test, row_number() OVER () as seq
  (regexp_substr(nr_seq_fav_lab_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_lab_p, '[^,]+', 1, level))::text <> '')
  UNION ALL


labTestList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_lab_p,'[^,]+', 1, level))::numeric  as nr_seq_lab_test, row_number() OVER () as seq 
  (regexp_substr(nr_seq_fav_lab_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_lab_p, '[^,]+', 1, level))::text <> '')
 JOIN cte c ON ()

) SELECT * FROM cte
union

select nr_seq_lab_test, 0 as seq from pepo_modelo_secao_fav_item
where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p and nr_seq_lab_test not in (WITH RECURSIVE cte AS (

select regexp_substr(nr_seq_fav_lab_p,'[^,]+', 1, level)  
  (regexp_substr(nr_seq_fav_lab_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_lab_p, '[^,]+', 1, level))::text <> '')
  UNION ALL

select regexp_substr(nr_seq_fav_lab_p,'[^,]+', 1, level) JOIN cte c ON ()

) SELECT * FROM cte;
)
order by seq;
;WITH RECURSIVE cte AS (


bloodProdList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_hem_p,'[^,]+', 1, level))::numeric  as nr_seq_hemod, row_number() OVER () as seq
  (regexp_substr(nr_seq_fav_hem_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_hem_p, '[^,]+', 1, level))::text <> '')
  UNION ALL


bloodProdList CURSOR FOR
SELECT (regexp_substr(nr_seq_fav_hem_p,'[^,]+', 1, level))::numeric  as nr_seq_hemod, row_number() OVER () as seq 
  (regexp_substr(nr_seq_fav_hem_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_hem_p, '[^,]+', 1, level))::text <> '')
 JOIN cte c ON ()

) SELECT * FROM cte
union

select nr_seq_hemod, 0 as seq from pepo_modelo_secao_fav_item
where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p and nr_seq_hemod not in (WITH RECURSIVE cte AS (

select regexp_substr(nr_seq_fav_hem_p,'[^,]+', 1, level)  
  (regexp_substr(nr_seq_fav_hem_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_fav_hem_p, '[^,]+', 1, level))::text <> '')
  UNION ALL

select regexp_substr(nr_seq_fav_hem_p,'[^,]+', 1, level) JOIN cte c ON ()

) SELECT * FROM cte;
)
order by seq;
;

type nr_seq_apres_w is table of pepo_modelo_secao_fav_item.nr_seq_apresentacao%type index by integer;
type nr_seq_hemod_w is table of pepo_modelo_secao_fav_item.nr_seq_hemod%type index by integer;

array_nr_seq_apres nr_seq_apres_w;
array_nr_seq_hemod nr_seq_hemod_w;
BEGIN
if (ie_type_p = 'AG') then
	if (coalesce(nr_seq_fav_agents_p::text, '') = '') then
		delete
		  from pepo_modelo_secao_fav_item
		 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p;
	else

		for r1 in agenListList loop
			if (r1.seq = 0) then
			delete
			  from pepo_modelo_secao_fav_item
			 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
			   and nr_seq_agent_anest_mat = r1.nr_seq_agent_anest_mat
			   and nr_seq_pepo_agent_med = r1.nr_seq_pepo_agent_med;
		else
			begin
				update pepo_modelo_secao_fav_item
				   set nr_seq_apresentacao = r1.seq
				 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
				   and nr_seq_agent_anest_mat = r1.nr_seq_agent_anest_mat
				   and nr_seq_pepo_agent_med = r1.nr_seq_pepo_agent_med;
				GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;
if ora2pg_rowcount = 0 then
					insert into
					pepo_modelo_secao_fav_item(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_apresentacao,
							nr_seq_pepo_agent_med,
							nr_seq_modelo_secao_fav,
							nr_seq_agent_anest_mat,
							ie_tipo
							) values (
							nextval('pepo_modelo_secao_fav_item_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							r1.seq,
							r1.nr_seq_pepo_agent_med,
							nr_seq_modelo_fav_p,
							r1.nr_seq_agent_anest_mat,
							null
							);
				end if;
			end;
		end if;
		end loop;
	end if;
elsif (ie_type_p = 'SV') then
	if (coalesce(nr_seq_fav_sv_p::text, '') = '') then
		delete
		  from pepo_modelo_secao_fav_item
		 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p;
	else	
		for r1 in signsList loop

			if (r1.seq = 0) then
				delete
				  from pepo_modelo_secao_fav_item
				 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
				   and nr_seq_pepo_sv = r1.nr_seq_pepo_sv;
			else
				begin
					update pepo_modelo_secao_fav_item
					   set nr_seq_apresentacao = r1.seq
					 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
				   and nr_seq_pepo_sv = r1.nr_seq_pepo_sv;
					GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;
if ora2pg_rowcount = 0 then
						insert into
						pepo_modelo_secao_fav_item(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_apresentacao,
								nr_seq_pepo_sv,
								nr_seq_modelo_secao_fav,
								ie_tipo
								) values (
								nextval('pepo_modelo_secao_fav_item_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								r1.seq,
								r1.nr_seq_pepo_sv,
								nr_seq_modelo_fav_p,
								null
								);
					end if;
				end;
			end if;
		end loop;
	end if;
elsif (ie_type_p = 'IO') then
	if (coalesce(nr_seq_fav_io_p::text, '') = '') then
		delete
		  from pepo_modelo_secao_fav_item
		 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p;
	else
		for r1 in intAndOutList loop
			if (r1.seq = 0) then
				delete
				  from pepo_modelo_secao_fav_item
				 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
				   and nr_seq_tipo_perda_ganho = r1.nr_seq_tipo_perda_ganho;
			else
				begin
					update pepo_modelo_secao_fav_item
					   set nr_seq_apresentacao = r1.seq
					 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
				   and nr_seq_tipo_perda_ganho = r1.nr_seq_tipo_perda_ganho;
					GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;
if ora2pg_rowcount = 0 then
						insert into
						pepo_modelo_secao_fav_item(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_apresentacao,
								nr_seq_pepo_sv,
								nr_seq_modelo_secao_fav,
								ie_tipo,
								nr_seq_tipo_perda_ganho
								) values (
								nextval('pepo_modelo_secao_fav_item_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								r1.seq,
								null,
								nr_seq_modelo_fav_p,
								null,
								r1.nr_seq_tipo_perda_ganho
								);
					end if;
				end;
			end if;
		end loop;
	end if;
elsif (ie_type_p = 'EL') then
	
	if (coalesce(nr_seq_fav_lab_p::text, '') = '') then
		delete
		  from pepo_modelo_secao_fav_item
		 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p;
	else
		for r1 in labTestList loop
			if (r1.seq = 0) then
				delete
				  from pepo_modelo_secao_fav_item
				 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
				   and nr_seq_lab_test = r1.nr_seq_lab_test;
			else
				begin
					update pepo_modelo_secao_fav_item
					   set nr_seq_apresentacao = r1.seq
					 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
					 and nr_seq_lab_test = r1.nr_seq_lab_test;
					GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;
if ora2pg_rowcount = 0 then
						insert into
						pepo_modelo_secao_fav_item(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_apresentacao,
								nr_seq_pepo_sv,
								nr_seq_modelo_secao_fav,
								ie_tipo,
								nr_seq_tipo_perda_ganho,
								nr_seq_lab_test
								) values (
								nextval('pepo_modelo_secao_fav_item_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								r1.seq,
								null,
								nr_seq_modelo_fav_p,
								null,
								null,
								r1.nr_seq_lab_test
								);					
					end if;
				end;
			end if;
		end loop;
	end if;
elsif (ie_type_p = 'SH') then
	if (coalesce(nr_seq_fav_hem_p::text, '') = '') then
		delete
		  from pepo_modelo_secao_fav_item
		 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p;
	else
	
		open bloodProdList;
		fetch bloodProdList bulk collect into array_nr_seq_hemod, array_nr_seq_apres limit 1000;
		close bloodProdList;
	
		forall i in array_nr_seq_hemod.first..array_nr_seq_hemod.last
		merge into pepo_modelo_secao_fav_item a using(SELECT
          nr_seq_modelo_fav_p nr_seq_modelo_secao_fav,
          array_nr_seq_hemod(i) nr_seq_hemod
          ) b on (
            a.nr_seq_modelo_secao_fav = b.nr_seq_modelo_secao_fav
            and a.nr_seq_hemod = b.nr_seq_hemod
          )
          when matched then update set nr_seq_apresentacao = array_nr_seq_apres(i)
          when not matched then insert(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_apresentacao,
								nr_seq_pepo_sv,
								nr_seq_modelo_secao_fav,
								ie_tipo,
								nr_seq_tipo_perda_ganho,
								nr_seq_hemod
								) values (
								nextval('pepo_modelo_secao_fav_item_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								array_nr_seq_apres(i),
								null,
								nr_seq_modelo_fav_p,
								null,
								null,
								array_nr_seq_hemod(i)
								);	
			commit;
			
			forall i in array_nr_seq_hemod.first..array_nr_seq_hemod.last
			delete
			  from pepo_modelo_secao_fav_item
			 where nr_seq_modelo_secao_fav = nr_seq_modelo_fav_p
			   and nr_seq_hemod = array_nr_seq_hemod(i)
			   and array_nr_seq_apres(i) = 0;
			commit;
	end if;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE control_fav_models_pl (nr_seq_modelo_fav_p bigint, ie_type_p text, nm_usuario_p text, nr_seq_fav_agents_p text default null, nr_seq_fav_material_p text default null, nr_seq_fav_sv_p text default null, nr_seq_fav_io_p text default null, nr_seq_fav_lab_p text default null, nr_seq_fav_hem_p text default null) FROM PUBLIC;
