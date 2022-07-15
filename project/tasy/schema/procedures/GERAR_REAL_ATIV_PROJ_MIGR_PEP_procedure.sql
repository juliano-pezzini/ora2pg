-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_real_ativ_proj_migr_pep ( nr_seq_projeto_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cronograma_w	bigint;
nr_seq_atividade_w	bigint;
nr_seq_atividade_ww	bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_superior
from	proj_cron_etapa
where	nr_seq_cronograma = nr_seq_cronograma_w
and	ie_fase = 'N'
and	ie_tipo_obj_proj_migr not in ('T','MI','WDLG','WSCB','O')
order by
	nr_sequencia;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_superior
from	proj_cron_etapa a
where	a.nr_seq_cronograma = nr_seq_cronograma_w
and	a.ie_fase = 'S'
and	ie_tipo_obj_proj_migr not in ('T','MI','WDLG','WSCB','O')
and	not exists (
		SELECT	1
		from	proj_cron_etapa x
		where	x.nr_seq_cronograma = nr_seq_cronograma_w
		and	x.nr_seq_superior = a.nr_sequencia)
order by
	nr_sequencia;


BEGIN
if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_cronograma_w
	from	proj_cronograma
	where	nr_seq_proj = nr_seq_projeto_p;

	if (nr_seq_cronograma_w > 0) then
		begin
		open c01;
		loop
		fetch c01 into	nr_seq_atividade_w,
				nr_seq_atividade_ww;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			update	proj_cron_etapa
			set	pr_etapa = 90,
				qt_hora_real = obter_valor_perc(qt_hora_prev,90)
			where	nr_sequencia = nr_seq_atividade_w;

			CALL atualizar_horas_etapa_cron(nr_seq_atividade_w);
			CALL atualizar_horas_etapa_cron(nr_seq_atividade_ww);
			end;
		end loop;
		close c01;

		open c02;
		loop
		fetch c02 into	nr_seq_atividade_w,
				nr_seq_atividade_ww;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			update	proj_cron_etapa
			set	pr_etapa = 100,
				qt_hora_real = qt_hora_prev
			where	nr_sequencia = nr_seq_atividade_w;

			CALL atualizar_horas_etapa_cron(nr_seq_atividade_w);
			CALL atualizar_horas_etapa_cron(nr_seq_atividade_ww);
			end;
		end loop;
		close c02;

		CALL atualizar_total_horas_cron(nr_seq_cronograma_w);
		CALL proj_desenv_atual_perc_cron(nr_seq_cronograma_w, nm_usuario_p);
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_real_ativ_proj_migr_pep ( nr_seq_projeto_p bigint, nm_usuario_p text) FROM PUBLIC;

