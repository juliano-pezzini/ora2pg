-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_vl_infec_clin_top ( dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE


i			smallint;
j			smallint;
nr_abs_w		integer;
nr_abs_total_w		integer;
vl_perc_w		real;
dt_final_w		timestamp;


BEGIN

/*
create table w_vl_infec_clin_top (
	nr_abs			number(5),
	vl_perc			number(5,2),
	cd_clinica		number(5),
	cd_topografia		number(5),
	nm_usuario		varchar2(20) not null);

	*/
CALL EXEC_SQL_DINAMICO_BV('TASY','delete from w_vl_infec_clin_top where nm_usuario = :nm_usuario', 'nm_usuario=' ||

nm_usuario_p);


if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then

	dt_final_w	:= fim_dia(dt_final_p);

	for i in 1..14 loop
		begin

		--Busca o total da clínica para calcular o percentual abaixo.
		select	coalesce(sum(a.nr_ocor),0)
		into STRICT	nr_abs_total_w
		from	(SELECT	c.ie_ordem_ss ie_ordem_linha,
				d.ie_ordem_ss ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_topografia d,
				cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica    = c.cd_clinica
			and	b.cd_topografia = d.cd_topografia
			and	b.cd_topografia not in (2,6,7,11)
			and	(d.ie_ordem_ss IS NOT NULL AND d.ie_ordem_ss::text <> '')
			and	a.dt_alta_interno between dt_inicial_p and dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
			   	d.ie_ordem_ss
			
union all

			SELECT	c.ie_ordem_ss ie_ordem_linha,
				1 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica    = c.cd_clinica
			and not exists (select f.nr_ficha_ocorrencia
			         		from cih_cirurgia f
			         		where f.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           		  and f.cd_tipo_cirurgia = 1)
			and	b.cd_topografia = 7
			and	a.dt_alta_interno between dt_inicial_p and dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
			 	1
			
union all

			select	c.ie_ordem_ss ie_ordem_linha,
			       	1 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica    = c.cd_clinica
			and	exists (select f.nr_ficha_ocorrencia
			         		from cih_cirurgia f
			         		where f.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           		  and f.cd_tipo_cirurgia = 1)
			and	b.cd_topografia = 7
			and	coalesce(b.nr_seq_classif_top,0) <> 2
			and	a.dt_alta_interno between dt_inicial_p and  dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
			   	1
			
union all

			select	c.ie_ordem_ss ie_ordem_linha,
			   	3 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica = c.cd_clinica
			and 	not exists (select g.nr_ficha_ocorrencia
			         		from cih_proc_realizado g
			         		where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           		  and g.cd_procedimento = 6)
			and	a.dt_alta_interno between dt_inicial_p and dt_final_w
			and	b.cd_topografia = 6
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
			   	3
			
union all

			select	c.ie_ordem_ss ie_ordem_linha,
				5 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica = c.cd_clinica
			and 	not exists (select g.nr_ficha_ocorrencia
			         		from cih_proc_realizado g
			         		where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           		  and g.cd_procedimento = 18)
			and	b.cd_topografia = 2
			and	a.dt_alta_interno between dt_inicial_p and  dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
			   	5
			
union all

			select	c.ie_ordem_ss ie_ordem_linha,
				10 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica = c.cd_clinica
			and	not exists (select g.nr_ficha_ocorrencia
			         		from cih_proc_realizado g
			         		where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           		  and g.cd_procedimento = 5)
			and	b.cd_topografia = 11
			and	a.dt_alta_interno between dt_inicial_p and dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
				10
			
union all

			select	c.ie_ordem_ss ie_ordem_linha,
				12 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica = c.cd_clinica
			and	exists (select f.nr_ficha_ocorrencia
			         from cih_cirurgia f
			         where f.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           and f.cd_tipo_cirurgia = 1)
			and	b.cd_topografia = 7
			and	b.nr_seq_classif_top = 2
			and	a.dt_alta_interno between dt_inicial_p and dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
				12
			
union all

			select	c.ie_ordem_ss ie_ordem_linha,
				13 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica = c.cd_clinica
			and	exists (select g.nr_ficha_ocorrencia
			         from cih_proc_realizado g
			         where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           and g.cd_procedimento = 6)
			and	b.cd_topografia = 6
			and	a.dt_alta_interno between dt_inicial_p and  dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
				13
			
union all

			select	c.ie_ordem_ss ie_ordem_linha,
			   	14 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica = c.cd_clinica
			and	exists (select g.nr_ficha_ocorrencia
			         from cih_proc_realizado g
			         where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           and g.cd_procedimento = 5)
			and	b.cd_topografia = 11
			and	a.dt_alta_interno between dt_inicial_p and dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
				14
			
union all

			select	c.ie_ordem_ss ie_ordem_linha,
				15 ie_ordem_coluna,
				sum(b.nr_ih) nr_ocor
			from	cih_clinica c,
				cih_infeccao_v b,
				cih_ficha_ocorrencia_v a
			where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
			and	b.cd_clinica = c.cd_clinica
			and	exists (select g.nr_ficha_ocorrencia
			         from cih_proc_realizado g
			         where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
			           and g.cd_procedimento = 18)
			and	b.cd_topografia = 2
			and	a.dt_alta_interno between dt_inicial_p and dt_final_w
			and	((c.ie_ordem_ss = i) or (i = 14))
			group by
				c.ie_ordem_ss,
				15) a
		where	(a.ie_ordem_linha IS NOT NULL AND a.ie_ordem_linha::text <> '')
		and	((a.ie_ordem_linha = i) or (i = 14));


		for j in 1..17 loop
			begin

			if (nr_abs_total_w > 0) then

				select	coalesce(sum(a.nr_ocor),0)
				into STRICT	nr_abs_w
				from	(SELECT	c.ie_ordem_ss ie_ordem_linha,
						d.ie_ordem_ss ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_topografia d,
						cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica    = c.cd_clinica
					and	b.cd_topografia = d.cd_topografia
					and	b.cd_topografia not in (2,6,7,11)
					and	(d.ie_ordem_ss IS NOT NULL AND d.ie_ordem_ss::text <> '')
					and	a.dt_alta_interno between dt_inicial_p and dt_final_w
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						d.ie_ordem_ss
					
union all

					SELECT	c.ie_ordem_ss ie_ordem_linha,
						1 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica    = c.cd_clinica
					and not exists (select f.nr_ficha_ocorrencia
								from cih_cirurgia f
								where f.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
								  and f.cd_tipo_cirurgia = 1)
					and	a.dt_alta_interno between dt_inicial_p and dt_final_w
					and	b.cd_topografia = 7
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						1
					
union all

					select	c.ie_ordem_ss ie_ordem_linha,
						1 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica    = c.cd_clinica
					and	exists (select f.nr_ficha_ocorrencia
								from cih_cirurgia f
								where f.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
								  and f.cd_tipo_cirurgia = 1)
					and	a.dt_alta_interno between dt_inicial_p and  dt_final_w
					and	b.cd_topografia = 7
					and	coalesce(b.nr_seq_classif_top,0) <> 2
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						1
					
union all

					select	c.ie_ordem_ss ie_ordem_linha,
						3 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica = c.cd_clinica
					and 	not exists (select g.nr_ficha_ocorrencia
								from cih_proc_realizado g
								where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
								  and g.cd_procedimento = 6)
					and	a.dt_alta_interno between dt_inicial_p and dt_final_w
					and	b.cd_topografia = 6
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						3
					
union all

					select	c.ie_ordem_ss ie_ordem_linha,
						5 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica = c.cd_clinica
					and 	not exists (select g.nr_ficha_ocorrencia
								from cih_proc_realizado g
								where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
								  and g.cd_procedimento = 18)
					and	a.dt_alta_interno between dt_inicial_p and  dt_final_w
					and	b.cd_topografia = 2
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						5
					
union all

					select	c.ie_ordem_ss ie_ordem_linha,
						10 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica = c.cd_clinica
					and	not exists (select g.nr_ficha_ocorrencia
								from cih_proc_realizado g
								where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
								  and g.cd_procedimento = 5)
					and	a.dt_alta_interno between dt_inicial_p and dt_final_w
					and	b.cd_topografia = 11
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						10
					
union all

					select	c.ie_ordem_ss ie_ordem_linha,
						12 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica = c.cd_clinica
					and	exists (select f.nr_ficha_ocorrencia
						 from cih_cirurgia f
						 where f.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
						   and f.cd_tipo_cirurgia = 1)
					and	a.dt_alta_interno between dt_inicial_p and dt_final_w
					and	b.cd_topografia = 7
					and	b.nr_seq_classif_top = 2
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						12
					
union all

					select	c.ie_ordem_ss ie_ordem_linha,
						13 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica = c.cd_clinica
					and	exists (select g.nr_ficha_ocorrencia
						 from cih_proc_realizado g
						 where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
						   and g.cd_procedimento = 6)
					and	a.dt_alta_interno between dt_inicial_p and  dt_final_w
					and	b.cd_topografia = 6
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						13
					
union all

					select	c.ie_ordem_ss ie_ordem_linha,
						14 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica = c.cd_clinica
					and	exists (select g.nr_ficha_ocorrencia
						 from cih_proc_realizado g
						 where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
						   and g.cd_procedimento = 5)
					and	a.dt_alta_interno between dt_inicial_p and dt_final_w
					and	b.cd_topografia = 11
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						14
					
union all

					select	c.ie_ordem_ss ie_ordem_linha,
						15 ie_ordem_coluna,
						sum(b.nr_ih) nr_ocor
					from	cih_clinica c,
						cih_infeccao_v b,
						cih_ficha_ocorrencia_v a
					where	a.nr_ficha_ocorrencia = b.nr_ficha_ocorrencia
					and	b.cd_clinica = c.cd_clinica
					and	exists (select g.nr_ficha_ocorrencia
						 from cih_proc_realizado g
						 where g.nr_ficha_ocorrencia = a.nr_ficha_ocorrencia
						   and g.cd_procedimento = 18)
					and	a.dt_alta_interno between dt_inicial_p and dt_final_w
					and	b.cd_topografia = 2
					and	((c.ie_ordem_ss = i) or (i = 14))
					group by
						c.ie_ordem_ss,
						15) a
				where	(a.ie_ordem_linha IS NOT NULL AND a.ie_ordem_linha::text <> '')
				and	((a.ie_ordem_linha = i) or (i = 14))
				and	((a.ie_ordem_coluna = j) or (j = 17));
			else
				nr_abs_w := 0;
			end if;

			if (nr_abs_w > 0) then

				vl_perc_w := round((100 /nr_abs_total_w) * nr_abs_w,1);
			else
				vl_perc_w := 0;
			end if;

			insert into w_vl_infec_clin_top(
				nr_abs,
				vl_perc,
				cd_clinica,
				cd_topografia,
				nm_usuario)
			values (	nr_abs_w,
				vl_perc_w,
				i,
				j,
				nm_usuario_p);

			commit;
			end;
		end loop;

		end;
	end loop;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_vl_infec_clin_top ( dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;
