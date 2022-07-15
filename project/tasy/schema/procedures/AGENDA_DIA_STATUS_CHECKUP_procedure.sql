-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_dia_status_checkup ( dt_inicial_p timestamp, dt_fim_p timestamp, setor_atend_p bigint, estab_p bigint, nm_usuario_p text, ie_Status_p INOUT text, qt_agendados_p INOUT bigint, qt_livres_p INOUT bigint) AS $body$
DECLARE


/*
L - Existem Livres
F - Feriado
B - Bloqueado
N - Não tem Agenda Dia
X - Todos horários Livres
T - Todos Horarios Lotados
D - Sabados e Domingos
R - Contém regra
*/
qt_agenda_w       		bigint;
qt_reg_agendado_w		bigint := 0;
qt_reg_livre_w			bigint := 0;
qt_reg_w			bigint := 0;
i				smallint  := 0;
ie_permite_agend_feriado_w	varchar(10);
ie_Status_w			varchar(32000) := '';
ie_Status_dia_w			varchar(32000) := 'N';
hr_agenda_w       		timestamp;
dt_prev_hr_w      		timestamp;
ie_bloqueio_w			varchar(10);
ie_dia_semana_w			varchar(10);
ie_bloqueio_dia_w		varchar(10);
ie_feriado_w			varchar(1)  := 'N';
dt_previsto_w			timestamp;

C01 CURSOR FOR
	SELECT 	a.hr_referencia,
		a.qt_agendamento
	from	checkup_regra_agendamento a
	where	cd_estabelecimento	= coalesce(estab_p,a.cd_estabelecimento)
	and	((((coalesce(ie_dia_semana,ie_dia_semana_w)	= ie_dia_semana_w) or
		 (ie_dia_semana	= 9 AND ie_dia_semana_w between 2 and 6)))
		 or exists (	SELECT	1 from checkup_regra_dia b where b.cd_estabelecimento = coalesce(estab_p,b.cd_estabelecimento)and trunc(dt_referencia)	= trunc(dt_previsto_w)))
	order by 1;


BEGIN

if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_fim_p IS NOT NULL AND dt_fim_p::text <> '')  then

	dt_previsto_w 	:= TRUNC(dt_inicial_p);
	ie_permite_agend_feriado_w := Obter_Valor_Param_Usuario(996, 25, Obter_Perfil_Ativo, nm_usuario_p, 0);

	WHILE(dt_previsto_w	<= TRUNC(dt_fim_p)) LOOP

		ie_dia_semana_w		:= pkg_date_utils.get_WeekDay(dt_previsto_w);

		begin
		select 'S'
		into STRICT	ie_bloqueio_w
		from	CHECKUP_bloqueio
		where	trunc(dt_previsto_w) between dt_inicial and dt_final
		and	((cd_Estabelecimento = estab_p) or (coalesce(cd_estabelecimento::text, '') = ''))
		and	coalesce(ie_dia_semana::text, '') = '';
		exception
			when others then
				ie_bloqueio_w := 'N';
		end;

		begin
		select 'S'
		into STRICT	ie_bloqueio_dia_w
		from	CHECKUP_bloqueio
		where	trunc(dt_previsto_w) between dt_inicial and dt_final
		and	((ie_dia_semana = ie_dia_semana_w) or (ie_dia_semana = 9))
		and	((cd_Estabelecimento = estab_p) or (coalesce(cd_estabelecimento::text, '') = ''))
		and	(ie_dia_semana IS NOT NULL AND ie_dia_semana::text <> '');
		exception
			when others then
				ie_bloqueio_dia_w := 'N';
		end;

		if	(ie_bloqueio_w	= 'N' AND ie_bloqueio_dia_w	= 'N') then

			ie_feriado_w := 'N';
			ie_Status_dia_w := 'N';
			i	:= 0;

			open C01;
			loop
			fetch 	C01 into
				hr_agenda_w,
				qt_agenda_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				dt_prev_hr_w := to_date(to_char(dt_previsto_w,'dd/mm/yyyy') ||' '|| to_char(hr_agenda_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
				If ( ie_permite_agend_feriado_w = 'N')
				And (obter_se_feriado(wheb_usuario_pck.get_cd_estabelecimento,dt_prev_hr_w) > 0) then
					ie_feriado_w := 'S';
				End if;

				i := i + qt_agenda_w;
				ie_Status_dia_w := 'R';
				end;
			end loop;
			close C01;

			select	count(*)
			into STRICT   	qt_reg_w
			from   	checkup a
			where  	a.dt_previsto	between trunc(dt_previsto_w) and fim_dia(dt_previsto_w)
			and    	((a.cd_setor_atendimento = coalesce(setor_atend_p,a.cd_setor_atendimento)) or (coalesce(setor_atend_p::text, '') = ''))
			and	((a.cd_Estabelecimento = coalesce(estab_p,a.cd_Estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''))
			and	coalesce(a.DT_CANCELAMENTO::text, '') = '';

			select	count(*)
			into STRICT   	qt_reg_agendado_w
			from   	checkup a
			where  	a.dt_previsto	between trunc(dt_previsto_w) and fim_dia(dt_previsto_w)
			and    	((a.cd_setor_atendimento = coalesce(setor_atend_p,a.cd_setor_atendimento)) or (coalesce(setor_atend_p::text, '') = ''))
			and	((a.cd_Estabelecimento = coalesce(estab_p,a.cd_Estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''))
			and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
			and	coalesce(a.DT_CANCELAMENTO::text, '') = '';

			select	count(*)
			into STRICT   	qt_reg_livre_w
			from   	checkup a
			where  	a.dt_previsto	between trunc(dt_previsto_w) and fim_dia(dt_previsto_w)
			and    	((a.cd_setor_atendimento = coalesce(setor_atend_p,a.cd_setor_atendimento)) or (coalesce(setor_atend_p::text, '') = ''))
			and	((a.cd_Estabelecimento = coalesce(estab_p,a.cd_Estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''))
			and	coalesce(a.cd_pessoa_fisica::text, '') = ''
			and	coalesce(a.DT_CANCELAMENTO::text, '') = '';

			if ( qt_reg_w > 0 ) and ( ie_Status_dia_w = 'R') then

				If ( qt_reg_w = qt_reg_livre_w) or ( i = qt_reg_livre_w) then

					ie_Status_dia_w := 'X';

				elsif ( qt_reg_w = qt_reg_agendado_w) or ( i = qt_reg_agendado_w)then

					ie_Status_dia_w := 'T';

				elsif ( qt_reg_livre_w > 0) then

					ie_Status_dia_w := 'L';

				elsif ( ie_feriado_w = 'S') then

					ie_Status_dia_w := 'F';

				elsif (pkg_date_utils.is_business_day(dt_previsto_w) = 0) then

					ie_Status_dia_w := 'D';

				end if;
			else

			if ( ie_feriado_w = 'S') then

				ie_Status_dia_w := 'F';

			elsif (pkg_date_utils.is_business_day(dt_previsto_w) = 0) then

				ie_Status_dia_w := 'D';

			end if;

			if (ie_Status_dia_w = 'R') then
				ie_Status_dia_w := 'X';
			end if;

			end if;

		else
			ie_Status_dia_w := 'B';
		end if;

	ie_Status_w := ie_Status_w || ie_Status_dia_w;
	dt_previsto_w := dt_previsto_w + 1;

	end loop;
END IF;

ie_status_p := ie_status_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_dia_status_checkup ( dt_inicial_p timestamp, dt_fim_p timestamp, setor_atend_p bigint, estab_p bigint, nm_usuario_p text, ie_Status_p INOUT text, qt_agendados_p INOUT bigint, qt_livres_p INOUT bigint) FROM PUBLIC;

