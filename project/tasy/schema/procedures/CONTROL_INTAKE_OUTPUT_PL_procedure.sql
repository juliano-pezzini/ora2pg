-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE control_intake_output_pl (nr_seq_tipo_p text default null, nr_seq_modelo_secao_p bigint DEFAULT NULL, nm_usuario_p text  DEFAULT NULL) AS $body$
WITH RECURSIVE cte AS (
DECLARE


ora2pg_rowcount int;
inOutList CURSOR FOR
SELECT (regexp_substr(nr_seq_tipo_p,'[^,]+', 1, level))::numeric  as nr_seq_tipo, row_number() OVER () as seq
  (regexp_substr(nr_seq_tipo_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_tipo_p, '[^,]+', 1, level))::text <> '')
  UNION ALL
DECLARE


inOutList CURSOR FOR
SELECT (regexp_substr(nr_seq_tipo_p,'[^,]+', 1, level))::numeric  as nr_seq_tipo, row_number() OVER () as seq 
  (regexp_substr(nr_seq_tipo_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_tipo_p, '[^,]+', 1, level))::text <> '')
 JOIN cte c ON ()

) SELECT * FROM cte
union

select nr_seq_tipo, 0 as seq from pepo_modelo_secao_perd_ga
where nr_seq_modelo_secao = nr_seq_modelo_secao_p and nr_seq_tipo not in (WITH RECURSIVE cte AS (

select regexp_substr(nr_seq_tipo_p,'[^,]+', 1, level)  
  (regexp_substr(nr_seq_tipo_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_tipo_p, '[^,]+', 1, level))::text <> '')
  UNION ALL

select regexp_substr(nr_seq_tipo_p,'[^,]+', 1, level) JOIN cte c ON ()

) SELECT * FROM cte;
)
order by seq;
;

nr_sequencia_reorder_p bigint;
nr_order_p integer;

BEGIN

if (coalesce(nr_seq_tipo_p::text, '') = '') then
  delete
		  from pepo_modelo_secao_perd_ga
		 where nr_seq_modelo_secao = nr_seq_modelo_secao_p;
else


for r1 in inOutList loop

	if (r1.seq = 0) then
		delete
		  from pepo_modelo_secao_perd_ga
		 where nr_seq_modelo_secao = nr_seq_modelo_secao_p
		   and nr_seq_tipo = r1.nr_seq_tipo;
	else
		begin
			update pepo_modelo_secao_perd_ga
			   set nr_seq_apresentacao = r1.seq
		     where nr_seq_modelo_secao = nr_seq_modelo_secao_p
		   and nr_seq_tipo = r1.nr_seq_tipo;
			GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;
if ora2pg_rowcount = 0 then
				insert into
				pepo_modelo_secao_perd_ga(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_apresentacao,
						nr_seq_tipo,
						nr_seq_modelo_secao
						) values (
						nextval('pepo_modelo_secao_perd_ga_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						r1.seq,
						r1.nr_seq_tipo,
						nr_seq_modelo_secao_p
						);
			end if;
    end;
	end if;

end loop;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE control_intake_output_pl (nr_seq_tipo_p text default null, nr_seq_modelo_secao_p bigint DEFAULT NULL, nm_usuario_p text  DEFAULT NULL) FROM PUBLIC;

