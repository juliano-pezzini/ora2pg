-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_gant_control_proj_exec ( nr_seq_gerencia_p bigint, dt_analise_p timestamp, ie_analise_p text, nm_usuario_p text) AS $body$
DECLARE


nr_semana_w		smallint;
dt_alocacao_w		timestamp;

nr_seq_projeto_w	bigint;
nr_seq_estagio_w	bigint := 12;

nr_seq_alocacao_w	bigint;

teste	bigint;

c01 CURSOR FOR
SELECT	p.nr_sequencia
from	proj_projeto p
where	coalesce(p.nr_seq_gerencia::text, '') = ''  --= nvl(nr_seq_gerencia_p, p.nr_seq_gerencia)
and	coalesce(dt_cancelamento::text, '') = ''
and	coalesce(ie_origem,'P') = 'P'	-- somente projeto
--and	ie_status = 'E'				-- somente execucao
-- and	p.IE_PLANEJ_ESTRATEG <> 'N'
and	(((ie_analise_p = 'S') and (pkg_date_utils.start_of(dt_alocacao_w,'DD',0) between coalesce(p.DT_INICIO_PREV,p.DT_PLANEJADA) and coalesce(p.DT_FIM_PREV,p.DT_PLANEJADA_TERM))) or
	 ((ie_analise_p = 'M') and (pkg_date_utils.start_of(dt_alocacao_w,'MONTH',0) between pkg_date_utils.start_of(coalesce(p.DT_INICIO_PREV,p.DT_PLANEJADA),'MONTH',0) and pkg_date_utils.get_datetime(pkg_date_utils.end_of(coalesce(p.DT_FIM_PREV,p.DT_PLANEJADA_TERM), 'MONTH'), coalesce(coalesce(p.DT_FIM_PREV, p.DT_PLANEJADA_TERM), PKG_DATE_UTILS.GET_TIME('00:00:00'))))))
and	not exists (
		SELECT	1
		from	w_alocacao_recurso w
		where	w.nr_seq_projeto = p.nr_sequencia)
group by
	p.nr_sequencia
order by
	p.nr_sequencia;

c02 CURSOR FOR
SELECT	p.nr_sequencia
from	proj_projeto p
where	coalesce(p.nr_seq_gerencia::text, '') = ''  -- = nvl(nr_seq_gerencia_p, p.nr_seq_gerencia)
and	coalesce(dt_cancelamento::text, '') = ''
and	coalesce(ie_origem,'P') = 'P' 	-- somente projeto
-- and	ie_status = 'E' 			-- somente execucao
-- and	p.IE_PLANEJ_ESTRATEG <> 'N'
and	(((ie_analise_p = 'S') and (pkg_date_utils.start_of(dt_alocacao_w,'DD',0) between coalesce(p.DT_INICIO_PREV,p.DT_PLANEJADA) and coalesce(p.DT_FIM_PREV,p.DT_PLANEJADA_TERM))) or
	 ((ie_analise_p = 'M') and (pkg_date_utils.start_of(dt_alocacao_w,'MONTH',0) between pkg_date_utils.start_of(coalesce(p.DT_INICIO_PREV,p.DT_PLANEJADA),'MONTH',0) and pkg_date_utils.get_datetime(pkg_date_utils.end_of(coalesce(p.DT_FIM_PREV, p.DT_PLANEJADA_TERM), 'MONTH'), coalesce(coalesce(p.DT_FIM_PREV, p.DT_PLANEJADA_TERM), PKG_DATE_UTILS.GET_TIME('00:00:00'))))))
group by 	p.nr_sequencia
order by
	p.nr_sequencia;


BEGIN
if (dt_analise_p IS NOT NULL AND dt_analise_p::text <> '') and (ie_analise_p IS NOT NULL AND ie_analise_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	CALL exec_sql_dinamico(nm_usuario_p, 'truncate table w_alocacao_recurso');

	nr_semana_w	:= 0;
	dt_alocacao_w	:= obter_inicio_fim_semana(dt_analise_p,'I');

	while(nr_semana_w < 11) loop
		begin
		open c01;
		loop
		fetch c01 into nr_seq_projeto_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			insert into w_alocacao_recurso(
				nr_sequencia,
				nm_usuario,
				cd_pessoa_recurso,
				nr_seq_projeto,
				ds_semana_00,
				ds_semana_01,
				ds_semana_02,
				ds_semana_03,
				ds_semana_04,
				ds_semana_05,
				ds_semana_06,
				ds_semana_07,
				ds_semana_08,
				ds_semana_09,
				ds_semana_10)
			values (
				nextval('w_alocacao_recurso_seq'),
				nm_usuario_p,
				'0',
				nr_seq_projeto_w,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null);
			end;

		end loop;
		close c01;
		nr_semana_w	:= nr_semana_w + 1;
		if (ie_analise_p = 'S') then
			begin
			dt_alocacao_w := adicionar_semanas(dt_analise_p, nr_semana_w);
			end;
		elsif (ie_analise_p = 'M') then
			begin
			dt_alocacao_w := PKG_DATE_UTILS.ADD_MONTH(dt_analise_p, nr_semana_w,0);
			end;
		end if;
		end;
	end loop;

	nr_semana_w	:= 0;
	dt_alocacao_w	:= obter_inicio_fim_semana(dt_analise_p,'I');

	while(nr_semana_w < 11) loop
		begin
		open c02;
		loop
		fetch c02 into nr_seq_projeto_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_alocacao_w
			from	w_alocacao_recurso
			where	nr_seq_projeto = nr_seq_projeto_w;

			if (nr_seq_alocacao_w > 0) then
				begin
				update	w_alocacao_recurso
				set	ds_semana_00 = CASE WHEN nr_semana_w=0 THEN  'S'  ELSE ds_semana_00 END ,
					ds_semana_01 = CASE WHEN nr_semana_w=1 THEN  'S'  ELSE ds_semana_01 END ,
					ds_semana_02 = CASE WHEN nr_semana_w=2 THEN  'S'  ELSE ds_semana_02 END ,
					ds_semana_03 = CASE WHEN nr_semana_w=3 THEN  'S'  ELSE ds_semana_03 END ,
					ds_semana_04 = CASE WHEN nr_semana_w=4 THEN  'S'  ELSE ds_semana_04 END ,
					ds_semana_05 = CASE WHEN nr_semana_w=5 THEN  'S'  ELSE ds_semana_05 END ,
					ds_semana_06 = CASE WHEN nr_semana_w=6 THEN  'S'  ELSE ds_semana_06 END ,
					ds_semana_07 = CASE WHEN nr_semana_w=7 THEN  'S'  ELSE ds_semana_07 END ,
					ds_semana_08 = CASE WHEN nr_semana_w=8 THEN  'S'  ELSE ds_semana_08 END ,
					ds_semana_09 = CASE WHEN nr_semana_w=9 THEN  'S'  ELSE ds_semana_09 END ,
					ds_semana_10 = CASE WHEN nr_semana_w=10 THEN  'S'  ELSE ds_semana_10 END
				where	nr_sequencia = nr_seq_alocacao_w;
				end;
			end if;
			end;
		end loop;
		close c02;
		nr_semana_w	:= nr_semana_w + 1;
		if (ie_analise_p = 'S') then
			begin
			dt_alocacao_w := adicionar_semanas(dt_analise_p, nr_semana_w);
			end;
		elsif (ie_analise_p = 'M') then
			begin
			dt_alocacao_w := PKG_DATE_UTILS.ADD_MONTH(dt_analise_p, nr_semana_w,0);
			end;
		end if;
		end;
	end loop;
	end;
end if;

commit;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_gant_control_proj_exec ( nr_seq_gerencia_p bigint, dt_analise_p timestamp, ie_analise_p text, nm_usuario_p text) FROM PUBLIC;

