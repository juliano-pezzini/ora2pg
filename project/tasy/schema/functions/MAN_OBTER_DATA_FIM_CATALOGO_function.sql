-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_data_fim_catalogo ( nr_seq_servico_p bigint, dt_inicio_p timestamp, nr_seq_grupo_planej_p bigint, nr_seq_grupo_trab_p bigint, nm_usuario_p text) RETURNS timestamp AS $body$
DECLARE



dt_final_w			timestamp;
qt_existe_w			bigint;
qt_hora_util_w			double precision;
ie_dia_semana_w			integer;
qt_hora_saldo_w			double precision;
hr_inicio_w			varchar(04);
hr_fim_w				varchar(04);
nr_seq_horario_w			bigint;
dt_inicio_w			timestamp;
dt_fim_w				timestamp;
qt_hora_ww			double precision;
ie_feriado_w			varchar(01);
cd_estabelecimento_w		smallint := wheb_usuario_pck.get_cd_estabelecimento;
ds_min_hora_w			varchar(02);


BEGIN

select	coalesce(qt_hora_util,0)
into STRICT	qt_hora_util_w
from	man_catalogo_servico
where	nr_sequencia = nr_seq_servico_p;

select	count(*)
into STRICT	qt_existe_w
from	man_horario_trabalho
where	substr(man_obter_se_hor_trab_lib(nr_sequencia, nr_seq_grupo_planej_p, nr_seq_grupo_trab_p,nm_usuario_p),1,1) = 'S';

/*Se não tem regra, faz a soma de horas e retorna a data*/

if (qt_existe_w = 0) then
	dt_final_w	:= coalesce(dt_inicio_p,clock_timestamp()) + (qt_hora_util_w / 24);
else
	begin
	qt_hora_saldo_w 	:= qt_hora_util_w;

	/*Pega qual dia da semana é, para buscar os horários do dia na tabela de regras*/

	select	Obter_Cod_Dia_Semana(dt_inicio_p)
	into STRICT	ie_dia_semana_w
	;

	select	max(nr_sequencia)
	into STRICT	nr_seq_horario_w
	from	man_horario_trabalho
	where	ie_dia_semana 			= ie_dia_semana_w
	and		substr(man_obter_se_hor_trab_lib(nr_sequencia, nr_seq_grupo_planej_p, nr_seq_grupo_trab_p,nm_usuario_p),1,1) = 'S';

	/*Se não existir regra para o dia em questão (por exemplo sabado e domingo), busca o próximo dia que tenha regra*/

	if (coalesce(nr_seq_horario_w,0) = 0) then
		while(coalesce(nr_seq_horario_w,0) = 0) loop
			begin
			ie_dia_semana_w := ie_dia_semana_w + 1;

			if (ie_dia_semana_w > 7) then
				ie_dia_semana_w := 1;
			end if;

			select	max(nr_sequencia)
			into STRICT	nr_seq_horario_w
			from	man_horario_trabalho
			where	ie_dia_semana = ie_dia_semana_w
			and		substr(man_obter_se_hor_trab_lib(nr_sequencia, nr_seq_grupo_planej_p, nr_seq_grupo_trab_p,nm_usuario_p),1,1) = 'S';
			end;
		end loop;
	end if;

	select	lpad(hr_inicio,4,0),
			lpad(hr_fim,4,0)
	into STRICT	hr_inicio_w,
	        hr_fim_w
	from	man_horario_trabalho
	where	nr_sequencia = nr_seq_horario_w;

	dt_inicio_w 	:= dt_inicio_p;

	/*Pega os minutos da data de início para colocar na data final*/

	select	substr(to_char(dt_inicio_w,'dd/mm/yyyy hh24:mi:ss'),15,2)
	into STRICT	ds_min_hora_w
	;

	dt_fim_w 	:= to_date(to_char(dt_inicio_p,'dd/mm/yyyy') || ' ' || substr(hr_fim_w,1,2) || ':' ||
					substr(hr_fim_w,3,2) || ':00','dd/mm/yyyy hh24:mi:ss');

	/*se a soma das horas ficar dentro da data atual válida*/

	if	(dt_fim_w >= (dt_inicio_p + dividir(qt_hora_util_w,24))) then
		begin
		dt_final_w	:= coalesce(dt_inicio_p,clock_timestamp()) + dividir(qt_hora_util_w,24);
		qt_hora_saldo_w	:= 0;
		end;
	/*se a data passar do fim dia, desconta as horas até o fim do dia e o saldo vai para o dia seguinte*/

	elsif (dt_inicio_p >= dt_inicio_w) and
		(dt_fim_w < (dt_inicio_p + dividir(qt_hora_util_w,24))) then
		begin
		select	dividir(obter_min_entre_datas(dt_inicio_w, dt_fim_w,1),60)
		into STRICT	qt_hora_ww
		;

		qt_hora_saldo_w := qt_hora_saldo_w - qt_hora_ww;
		end;
	end if;

	/*Vai adicionando os dias até fechar o saldo de horas pendentes*/

	while(qt_hora_saldo_w > 0) loop
		begin
		/*Pega qual dia da semana é, para buscar os horários do dia na tabela de regras*/

		dt_inicio_w := dt_inicio_w + 1;

		select	Obter_Cod_Dia_Semana(dt_inicio_w)
		into STRICT	ie_dia_semana_w
		;

		select	max(nr_sequencia)
		into STRICT	nr_seq_horario_w
		from	man_horario_trabalho
		where	ie_dia_semana = ie_dia_semana_w
		and	substr(man_obter_se_hor_trab_lib(nr_sequencia, nr_seq_grupo_planej_p, nr_seq_grupo_trab_p,nm_usuario_p),1,1) = 'S';

		select	substr(obter_se_feriado(cd_estabelecimento_w, dt_inicio_w),1,1)
		into STRICT	ie_feriado_w
		;

		/*Verifica se é feriado, se é, adiciona mais um dia*/

		if (coalesce(ie_feriado_w,'0') = '1') then
			nr_seq_horario_w	:= 0;
		end if;

		/*Se não existir regra para o dia em questão (por exemplo sabado e domingo), busca o próximo dia que tenha regra*/

		if (coalesce(nr_seq_horario_w,0) = 0) then
			begin
			while(coalesce(nr_seq_horario_w,0) = 0) loop
				begin
				ie_dia_semana_w := ie_dia_semana_w + 1;
				dt_inicio_w	:= dt_inicio_w + 1;

				if (ie_dia_semana_w > 7) then
					ie_dia_semana_w := 1;

					select	Obter_Cod_Dia_Semana(dt_inicio_w)
					into STRICT	ie_dia_semana_w
					;
				end if;

				select	max(nr_sequencia)
				into STRICT	nr_seq_horario_w
				from	man_horario_trabalho
				where	ie_dia_semana = ie_dia_semana_w
				and	substr(man_obter_se_hor_trab_lib(nr_sequencia, nr_seq_grupo_planej_p, nr_seq_grupo_trab_p,nm_usuario_p),1,1) = 'S';

				select	substr(obter_se_feriado(cd_estabelecimento_w, dt_inicio_w),1,1)
				into STRICT	ie_feriado_w
				;

				/*Verifica se é feriado, se é, adiciona mais um dia*/

				if (coalesce(ie_feriado_w,'0') = '1') then
					nr_seq_horario_w	:= 0;
				end if;

				end;
			end loop;
			end;
		end if;

		select	lpad(hr_inicio,4,0),
				lpad(hr_fim,4,0)
		into STRICT	hr_inicio_w,
		        hr_fim_w
		from	man_horario_trabalho
		where	nr_sequencia = nr_seq_horario_w;

		dt_inicio_w 	:= to_date(to_char(dt_inicio_w,'dd/mm/yyyy') || ' ' || substr(hr_inicio_w,1,2) || ':' ||
						substr(hr_inicio_w,3,2) || ':00','dd/mm/yyyy hh24:mi:ss');


		dt_fim_w 	:= to_date(to_char(dt_inicio_w,'dd/mm/yyyy') || ' ' || substr(hr_fim_w,1,2) || ':' ||
						substr(hr_fim_w,3,2) || ':00','dd/mm/yyyy hh24:mi:ss');

		select	dividir(obter_min_entre_datas(dt_inicio_w, dt_fim_w,1),60)
		into STRICT	qt_hora_ww
		;

		if	((qt_hora_saldo_w - qt_hora_ww) <= 0) then
			dt_final_w := dt_inicio_w + (qt_hora_saldo_w / 24);
		end if;

		qt_hora_saldo_w := qt_hora_saldo_w - qt_hora_ww;
		end;
	end loop;

	if (coalesce(dt_final_w::text, '') = '') then
		dt_final_w := dt_inicio_w + dividir(qt_hora_util_w,24);
	end if;
	end;
end if;

return	dt_final_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_data_fim_catalogo ( nr_seq_servico_p bigint, dt_inicio_p timestamp, nr_seq_grupo_planej_p bigint, nr_seq_grupo_trab_p bigint, nm_usuario_p text) FROM PUBLIC;
