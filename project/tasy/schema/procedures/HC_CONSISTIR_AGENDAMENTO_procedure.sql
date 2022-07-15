-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hc_consistir_agendamento ( cd_profissional_p text, dt_agenda_inicial_p timestamp, dt_agenda_final_p timestamp) AS $body$
DECLARE


ds_sql_w		varchar(100)	:='';
ie_retorno_func_hc_w	varchar(1);
ds_observacao_prof_hc_w	varchar(255);
nr_seq_incons_agen_w	bigint;
dt_agenda_w		timestamp;
cd_profissional_w	bigint;
nr_seq_paciente_hc_w	bigint;
nr_dia_semana_w		smallint;
ie_dispon_func_w	varchar(1);
nr_seq_escala_w		bigint;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
nr_minuto_duracao_w	bigint;

c01 CURSOR FOR  --busca todos os registros do agendamento.
	SELECT	c.dt_agenda,
		b.cd_pessoa_fisica,
		c.nr_seq_paciente_hc,
		c.nr_minuto_duracao
	from	hc_agenda_prof a,
		hc_profissional b,
		agenda_hc_paciente c,
		agenda_home_care d
	where	a.nr_seq_prof_hc = b.nr_sequencia
	and	a.nr_seq_agenda = c.nr_sequencia
	and	c.nr_seq_agenda = d.nr_sequencia
	and	PKG_DATE_UTILS.start_of(c.dt_agenda, 'dd', 0) between PKG_DATE_UTILS.start_of(dt_agenda_inicial_p, 'dd', 0) and PKG_DATE_UTILS.start_of(dt_agenda_final_p, 'dd', 0)
	||	ds_sql_w;

c02 CURSOR FOR
	SELECT	coalesce(d.nr_seq_escala,0)
	from	escala_horario_medico e,
		escala_horario_medico_lib d,
		escala_classif c,
		escala_grupo b,
		escala a
	where	c.nr_sequencia = b.nr_seq_classif
	and 	e.nr_sequencia = d.nr_seq_escala_horario
	and	b.nr_sequencia = a.nr_seq_grupo
	and	a.nr_sequencia = d.nr_seq_escala
	and	c.ie_tipo_escala = 'H'
	and	e.cd_pessoa_fisica = cd_profissional_w
	group by nr_seq_escala;


BEGIN

if (cd_profissional_p <> '') then
	ds_sql_w := ' and c.cd_pessoa_fisica = ' || cd_profissional_p;
end if;

--exclui registros da tabela hc_inconsistencia_agen
delete from hc_inconsistencia_agen
where  nr_seq_hc_paciente in (SELECT	c.nr_seq_paciente_hc
	   			from	hc_agenda_prof a,
					hc_profissional b,
					agenda_hc_paciente c
				where	a.nr_seq_prof_hc = b.nr_sequencia
				and	a.nr_seq_agenda = c.nr_sequencia
				and	PKG_DATE_UTILS.start_of(c.dt_agenda, 'dd', 0) between PKG_DATE_UTILS.start_of(dt_agenda_inicial_p, 'dd', 0) and PKG_DATE_UTILS.start_of(dt_agenda_final_p, 'dd', 0)
				|| 	ds_sql_w
				group by c.nr_seq_paciente_hc);
commit;

open c01;
loop
fetch c01 into
	dt_agenda_w,
	cd_profissional_w,
	nr_seq_paciente_hc_w,
	nr_minuto_duracao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_observacao_prof_hc_w := '';
	ie_dispon_func_w := 'N';

	open c02;
	loop
	fetch c02 into
		nr_seq_escala_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		--Profissional fora da Escala
		if (ie_dispon_func_w = 'N') then

			select 	PKG_DATE_UTILS.get_WeekDay(dt_agenda_w) --busca dia da semana;
			into STRICT	nr_dia_semana_w
			;

			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  --verifica escala.       N - não possui escala. / S - possui escala
			into STRICT	ie_dispon_func_w
			from	escala_horario_medico_lib
			where	nr_seq_escala = nr_seq_escala_w
			and	((ie_dia_semana = nr_dia_semana_w)
				or (ie_dia_semana = 0)--todos os dias
				or ((ie_dia_semana = 10) and (pkg_date_utils.IS_BUSINESS_DAY(dt_agenda_w)  = 0))--final de semana.   /   nr_dia_semana_w in (7,1)
				or ((ie_dia_semana = 9) and (pkg_date_utils.IS_BUSINESS_DAY(dt_agenda_w) = 1)))--dias de trabalho.    /  nr_dia_semana_w between 2 and 6
			and (coalesce(ie_feriado,'N') = 'N'
				or (ie_feriado = 'S' and obter_se_feriado(cd_estabelecimento_w,dt_agenda_w) > 0)
				or (ie_feriado = 'F' and obter_se_feriado(cd_estabelecimento_w,dt_agenda_w) = 0))
			and	dt_agenda_w between
				PKG_DATE_UTILS.get_Time(dt_agenda_w, hr_inicial_vinc, 0) and
				PKG_DATE_UTILS.get_Time(dt_agenda_w, hr_final_vinc, 0);

		end if;
		end;

	end loop;
	close c02;

	if (ie_dispon_func_w = 'N') then
		ds_observacao_prof_hc_w := wheb_mensagem_pck.get_texto(302045); --Profissional fora da Escala
		ie_retorno_func_hc_w := 'E';
	end if;

	--Profissional ausente
	if (ie_dispon_func_w = 'S') then

		select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END  -- S - não possui falta / N - possui falta.
		into STRICT	ie_dispon_func_w
		from   	ausencia_tasy
		where  	nm_usuario_ausente = Obter_Nome_Usuario_cod(cd_profissional_w)
		and    	dt_agenda_w between dt_inicio and dt_fim;

		if (ie_dispon_func_w = 'N') then
			ds_observacao_prof_hc_w := wheb_mensagem_pck.get_texto(302047); --Profissional ausente
			ie_retorno_func_hc_w := 'A';
		end if;

	end if;

	--Profissional alocado em outro paciente
	if (ie_dispon_func_w = 'S') then

		select 	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END  -- S - não alocado em outro paciente / N - Alocado em outro paciente.
			into STRICT	ie_dispon_func_w
			from   	hc_profissional a,
				hc_agenda_prof b,
				agenda_hc_paciente c
			where  	a.cd_pessoa_fisica = cd_profissional_w
			and	a.nr_sequencia = b.nr_seq_prof_hc
			and	b.nr_seq_agenda = c.nr_sequencia
			and	 (dt_agenda_w between c.dt_agenda  and (c.dt_agenda + (coalesce(c.NR_MINUTO_DURACAO,0)/1440))
				 or  ((dt_agenda_w + (nr_minuto_duracao_w/1440))   between c.dt_agenda  and (c.dt_agenda + (coalesce(c.NR_MINUTO_DURACAO,0)/1440))))
			--and	c.dt_agenda = dt_agenda_w
			and 	(SELECT	coalesce(count(*),0)
				from   	hc_profissional a,
					hc_agenda_prof b,
					agenda_hc_paciente c
				where  	a.cd_pessoa_fisica = cd_profissional_w
				and	a.nr_sequencia = b.nr_seq_prof_hc
				and	b.nr_seq_agenda = c.nr_sequencia
				--and	c.dt_agenda = dt_agenda_w
				and	 (dt_agenda_w between c.dt_agenda  and (c.dt_agenda + (coalesce(c.NR_MINUTO_DURACAO,0)/1440))
					or  ((dt_agenda_w + (nr_minuto_duracao_w/1440))   between c.dt_agenda  and (c.dt_agenda + (coalesce(c.NR_MINUTO_DURACAO,0)/1440)))))> 1;

		if (ie_dispon_func_w = 'N') then
			ds_observacao_prof_hc_w := wheb_mensagem_pck.get_texto(302048); --Profissional alocado em outro paciente
			ie_retorno_func_hc_w := 'H';
		end if;

	end if;

	if (ds_observacao_prof_hc_w IS NOT NULL AND ds_observacao_prof_hc_w::text <> '') then

		select	nextval('hc_inconsistencia_agen_seq')
		into STRICT	nr_seq_incons_agen_w
		;

		insert 	into hc_inconsistencia_agen(
			nr_sequencia,
			nr_seq_hc_paciente,
			dt_agenda,
			ds_observacao,
			ie_tipo,
			cd_pessoa_fisica
		) values (
			nr_seq_incons_agen_w,
			nr_seq_paciente_hc_w,
			dt_agenda_w,
			ds_observacao_prof_hc_w,
			ie_retorno_func_hc_w,
			cd_profissional_w
		);

	end if;
	end;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hc_consistir_agendamento ( cd_profissional_p text, dt_agenda_inicial_p timestamp, dt_agenda_final_p timestamp) FROM PUBLIC;

