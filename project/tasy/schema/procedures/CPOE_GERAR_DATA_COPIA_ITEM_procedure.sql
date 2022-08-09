-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_data_copia_item ( nr_prescricao_p bigint, qt_horas_ant_p bigint, dt_referencia_p timestamp, ie_gpt_p text default 'N') AS $body$
DECLARE


nr_prescricao_w			prescr_medica.nr_prescricao%type;
nr_ult_prescricao_w		prescr_medica.nr_prescricao%type;

cd_intervalo_w			intervalo_prescricao.cd_intervalo%type;
ie_operacao_w			intervalo_prescricao.ie_operacao%type;
qt_operacao_w			intervalo_prescricao.qt_operacao%type;
ie_24_h_w				intervalo_prescricao.ie_24_h%type;
qt_horas_adic_w			double precision;

ds_horarios_w			cpoe_material.ds_horarios%type;
hr_prim_horario_w		cpoe_material.hr_prim_horario%type;

dt_horario_ref_w		timestamp;
dt_horario_ref_ant_w		timestamp;
dt_horario_ref_ww		timestamp;
dt_inicio_w				timestamp;
dt_prox_geracao_w		timestamp;
dt_inicio_prescr_w		prescr_medica.dt_inicio_prescr%type;

ie_tipo_item_w			char(1);
ds_dias_utilizacao_w	char(30);
nr_seq_item_w			numeric(30);
nr_seq_cpoe_w			numeric(30);
ie_evento_unico_w		char(1);
ie_continuo_w			varchar(15);
ie_calc_interv_dif_w 	varchar(1);
ie_acm_w				prescr_material.ie_acm%type;
ie_sn_w					prescr_material.ie_se_necessario%type;

ds_exception_w        	varchar(4000);

ie_operacao_interv_w    intervalo_prescricao.ie_operacao%type;
nr_horas_apos_copia_w   bigint;

c01 CURSOR FOR
SELECT	'P' ie_tipo_item,			   --Procedimento
		a.cd_intervalo,
		a.nr_seq_proc_cpoe nr_seq_cpoe,
		a.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		'N' ie_acm,
		'N' ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_proc_cpoe,'P', b.nr_atendimento, b.cd_pessoa_fisica) nr_ult_prescricao,
		b.dt_inicio_prescr
from	prescr_procedimento a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		(a.nr_seq_proc_cpoe IS NOT NULL AND a.nr_seq_proc_cpoe::text <> '')

union all

SELECT	'M' ie_tipo_item,				--Medicamento
		a.cd_intervalo,
		a.nr_seq_mat_cpoe nr_seq_cpoe,
		a.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		coalesce(a.ie_acm,'N') ie_acm,
		coalesce(a.ie_se_necessario,'N') ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_mat_cpoe,'M', b.nr_atendimento, b.cd_pessoa_fisica) nr_ult_prescricao,
		b.dt_inicio_prescr
from	prescr_material a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		(a.nr_seq_mat_cpoe IS NOT NULL AND a.nr_seq_mat_cpoe::text <> '')

union all

select	'E' ie_tipo_item,				--Enteral/Suplemento
		a.cd_intervalo,
		a.nr_seq_dieta_cpoe nr_seq_cpoe,
		a.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		'N' ie_acm,
		'N' ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_dieta_cpoe,'S', b.nr_atendimento, b.cd_pessoa_fisica) nr_ult_prescricao,
		b.dt_inicio_prescr
from	prescr_material a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		(a.nr_seq_dieta_cpoe IS NOT NULL AND a.nr_seq_dieta_cpoe::text <> '')

union all

select	'O' ie_tipo_item,				--Dieta Oral
		a.cd_intervalo,
		a.nr_seq_dieta_cpoe nr_seq_cpoe,
		a.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		'N' ie_acm,
		'N' ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_dieta_cpoe,'D', b.nr_atendimento, b.cd_pessoa_fisica) nr_ult_prescricao,
		b.dt_inicio_prescr
from	prescr_dieta a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		(a.nr_seq_dieta_cpoe IS NOT NULL AND a.nr_seq_dieta_cpoe::text <> '')

union all

select	'R' ie_tipo_item,				--Recomendacao
		a.cd_intervalo,
		a.nr_seq_rec_cpoe nr_seq_cpoe,
		a.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		'N' ie_acm,
		'N' ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_rec_cpoe,'R', b.nr_atendimento, b.cd_pessoa_fisica) nr_ult_prescricao,
		b.dt_inicio_prescr
from	prescr_recomendacao a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		(a.nr_seq_rec_cpoe IS NOT NULL AND a.nr_seq_rec_cpoe::text <> '')

union all

select	'G' ie_tipo_item,				--Gasoterapia
		a.cd_intervalo,
		a.nr_seq_gas_cpoe nr_seq_cpoe,
		a.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		'N' ie_acm,
		'N' ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_gas_cpoe,'O', b.nr_atendimento, b.cd_pessoa_fisica) nr_ult_prescricao,
		b.dt_inicio_prescr
from	prescr_gasoterapia a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		(a.nr_seq_gas_cpoe IS NOT NULL AND a.nr_seq_gas_cpoe::text <> '')

union all

select	'J' ie_tipo_item,				--Jejum
		null cd_intervalo,
		a.nr_seq_dieta_cpoe nr_seq_cpoe,
		a.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		'N' ie_acm,
		'N' ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_dieta_cpoe,'J', b.nr_atendimento, b.cd_pessoa_fisica) nr_ult_prescricao,
		b.dt_inicio_prescr
from	rep_jejum a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		(a.nr_seq_dieta_cpoe IS NOT NULL AND a.nr_seq_dieta_cpoe::text <> '')

union all

select	'D' ie_tipo_item,				--Dialise
		null cd_intervalo,
		a.nr_seq_dialise_cpoe nr_seq_cpoe,
		a.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		'N' ie_acm,
		'N' ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_dialise_cpoe,'DI', b.nr_atendimento, b.cd_pessoa_fisica) nr_ult_prescricao,
		b.dt_inicio_prescr
from	hd_prescricao a,
		prescr_medica b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_prescricao = nr_prescricao_p
and		(a.nr_seq_dialise_cpoe IS NOT NULL AND a.nr_seq_dialise_cpoe::text <> '')

union all

select	'A' ie_tipo_item,				--NPT Adulta
		a.cd_intervalo,
		a.nr_seq_npt_cpoe nr_seq_cpoe,
		b.nr_sequencia nr_seq_item,
		a.nr_prescricao,
		'N' ie_acm,
		'N' ie_sn,
		OBTER_PRESCR_ITEM_CPOE(a.nr_seq_npt_cpoe,'NPTA', c.nr_atendimento, c.cd_pessoa_fisica) nr_ult_prescricao,
		c.dt_inicio_prescr
FROM prescr_medica c, nut_pac a
LEFT OUTER JOIN prescr_material b ON (a.nr_sequencia = b.nr_seq_nut_pac)
WHERE a.nr_prescricao = c.nr_prescricao and a.nr_prescricao = nr_prescricao_p  and (a.nr_seq_npt_cpoe IS NOT NULL AND a.nr_seq_npt_cpoe::text <> '') order by nr_seq_cpoe;

	procedure Atualiza_qt_dias_adic is
	;
BEGIN
		qt_horas_adic_w	:= 24;
		ie_calc_interv_dif_w := 'S';

		if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
			select	max(ie_operacao),
					max(qt_operacao),
					max(coalesce(ie_24_h,'N'))
			into STRICT	ie_operacao_w,
					qt_operacao_w,
					ie_24_h_w
			from	intervalo_prescricao
			where	cd_intervalo = cd_intervalo_w;

			if (ie_operacao_w = 'H') then
				if (qt_operacao_w > 24) then
					qt_horas_adic_w := qt_operacao_w;
					ie_calc_interv_dif_w := 'N';
				elsif (qt_operacao_w > 12) and (qt_operacao_w < 24) and
					  ((ie_tipo_item_w = 'E' AND ie_continuo_w <> 'C') or (ie_tipo_item_w <> 'E')) then
					qt_horas_adic_w := qt_operacao_w + qt_operacao_w;
					ie_calc_interv_dif_w := 'N';
				end if;
			end if;
		end if;
	end;

	procedure Atualiza_dt_horario_ref is
	begin
		Atualiza_qt_dias_adic;

		dt_horario_ref_ant_w := dt_horario_ref_w;
		if (coalesce(dt_horario_ref_w::text, '') = '') then
			dt_horario_ref_w := dt_referencia_p;
		end if;

		if (coalesce(ds_horarios_w::text, '') = '') then
			ds_horarios_w := to_char(dt_horario_ref_w, 'hh24:mi');
		end if;

		if (ie_operacao_w = 'D') then
			dt_horario_ref_w := trunc(obter_proxima_dose_medic(dt_horario_ref_w,cd_intervalo_w, ds_horarios_w, 'S') - ( qt_horas_ant_p/24),'hh24');
		elsif (ie_tipo_item_w = 'M') and (ie_calc_interv_dif_w = 'S') then
			dt_horario_ref_w := trunc(cpoe_obter_proxima_dose_medic(dt_horario_ref_w, nr_seq_cpoe_w, ds_horarios_w) - (qt_horas_ant_p / 24), 'hh24');
		elsif (ie_tipo_item_w = 'P') and (ie_calc_interv_dif_w = 'S') then
			dt_horario_ref_w := trunc(cpoe_obter_proxima_data_proced(dt_horario_ref_w, nr_seq_cpoe_w, ds_horarios_w) - (qt_horas_ant_p / 24), 'hh24');
		elsif (ie_tipo_item_w = 'D') and (ie_calc_interv_dif_w = 'S') then
			dt_horario_ref_w := trunc(cpoe_obter_proxima_data('D', dt_horario_ref_w, nr_seq_cpoe_w, ds_horarios_w) - (qt_horas_ant_p / 24), 'hh24');
		else
			dt_horario_ref_w := trunc(dt_horario_ref_w + ((qt_horas_adic_w - qt_horas_ant_p)/24),'hh24');
		end if;

		if (ie_tipo_item_w in ('M','E')) then
			CALL gravar_log_cpoe(SUBSTR('CPOE_GERAR_DATA_COPIA_ITEM ATUALIZANDO '
				|| ' - nr_prescricao_p: ' || nr_prescricao_p
				|| ' - qt_horas_ant_p: ' || qt_horas_ant_p
				|| ' - dt_referencia_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_referencia_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)
				|| ' - ie_tipo_item_w: ' || ie_tipo_item_w
				|| ' - nr_seq_cpoe_w: ' || nr_seq_cpoe_w
				|| ' - nr_seq_item_w: ' || nr_seq_item_w
				|| ' - nr_prescricao_w: ' || nr_prescricao_w
				|| ' - dt_horario_ref_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_horario_ref_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)
				|| ' - cd_intervalo_w: ' || cd_intervalo_w
				|| ' - ie_operacao_w: ' || ie_operacao_w
				|| ' - qt_operacao_w: ' || qt_operacao_w
				|| ' - ie_24_h_w: ' || ie_24_h_w
				|| ' - ie_calc_interv_dif_w: ' || ie_calc_interv_dif_w
				|| ' - qt_horas_adic_w: '||qt_horas_adic_w
				|| ' - ds_horarios_w: '||ds_horarios_w
				|| ' - dt_horario_ref_ant_w: '||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_horario_ref_ant_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)
				, 1, 2000));
		end if;

		if (dt_horario_ref_w <= dt_referencia_p) then
			dt_horario_ref_w := dt_horario_ref_w + 1;
		end if;
	end;

	procedure Atualizar_cpoe( nm_tabela_p varchar2 ) is
		ds_sql_w	varchar2(4000);
		ds_sql_atb_w	varchar2(255);
	begin
		Atualiza_dt_horario_ref;

		if (nm_tabela_p = 'cpoe_material') then
			ds_sql_atb_w := ' and	((a.dt_fim is null) or (nvl(a.dt_fim_cih, a.dt_fim) > :dt_horario)) ';
		else
			ds_sql_atb_w := ' and	((a.dt_fim is null) or (a.dt_fim > :dt_horario)) ';
		end if;

		ds_sql_w	:=
			' update	' || nm_tabela_p || ' a ' ||
			' set		a.dt_prox_geracao = :dt_horario ' ||
			' where		a.nr_sequencia = :nr_sequencia ' ||
			ds_sql_atb_w;

		EXECUTE
			ds_sql_w
		using
			dt_horario_ref_w,
			nr_seq_cpoe_w,
			dt_referencia_p;
	end;

begin

for r_c01_w in c01
loop
	ie_tipo_item_w := r_c01_w.ie_tipo_item;
	cd_intervalo_w := r_c01_w.cd_intervalo;
	nr_seq_cpoe_w := r_c01_w.nr_seq_cpoe;
	nr_seq_item_w := r_c01_w.nr_seq_item;
	nr_prescricao_w := r_c01_w.nr_prescricao;
	ie_acm_w := r_c01_w.ie_acm;
	ie_sn_w := r_c01_w.ie_sn;
	nr_ult_prescricao_w := r_c01_w.nr_ult_prescricao;
	dt_inicio_prescr_w := r_c01_w.dt_inicio_prescr;

	if (ie_gpt_p = 'S') and (nr_ult_prescricao_w <> nr_prescricao_p) then
	    exit;
	end if;

	ie_continuo_w := null;
	dt_horario_ref_w := null;
	dt_prox_geracao_w := null;
	ds_horarios_w := null;

	if (ie_tipo_item_w = 'M') then

		select	min(dt_horario)
		into STRICT	dt_horario_ref_w
		from	prescr_mat_hor
		where	nr_seq_material = nr_seq_item_w
		and 	(dt_lib_horario IS NOT NULL AND dt_lib_horario::text <> '')
		and		nr_prescricao = nr_prescricao_w;

		if (ie_acm_w = 'S' or ie_sn_w = 'S') then
			begin
				if (coalesce(dt_horario_ref_w::text, '') = '') then
					dt_horario_ref_w := dt_referencia_p;
				end if;

				select	max(dt_inicio),
						max(hr_prim_horario)
				into STRICT	dt_inicio_w,
						hr_prim_horario_w
				from	cpoe_material
				where	nr_sequencia = nr_seq_cpoe_w;

				if ((dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '') and (to_char(dt_inicio_w, 'hh24'))::numeric  > 0) then
					dt_horario_ref_w := trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_horario_ref_w, coalesce(to_char(dt_inicio_w,'hh24:mi'), '00:00')), 'hh24');
				elsif ((hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and (to_char(cpoe_obter_data_hora_form(dt_inicio_w, hr_prim_horario_w), 'hh24'))::numeric  > 0) then
					dt_horario_ref_w := trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_horario_ref_w, coalesce(to_char(cpoe_obter_data_hora_form(dt_inicio_w, hr_prim_horario_w),'hh24:mi'), '00:00')), 'hh24');
				end if;
			exception
				when others then
				CALL gravar_log_cpoe(SUBSTR('CPOE_GERAR_DATA_COPIA_ITEM EXCEPTION '
					|| ' - nr_prescricao_p: ' || nr_prescricao_p
					|| ' - qt_horas_ant_p: ' || qt_horas_ant_p
					|| ' - dt_referencia_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_referencia_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)
					|| ' - ie_tipo_item_w: ' || ie_tipo_item_w
					|| ' - nr_seq_cpoe_w: ' || nr_seq_cpoe_w
					|| ' - nr_seq_item_w: ' || nr_seq_item_w
					|| ' - nr_prescricao_w: ' || nr_prescricao_w
					|| ' - dt_horario_ref_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_horario_ref_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)
					|| ' - dt_inicio_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_inicio_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)
					|| ' - hr_prim_horario_w: ' || hr_prim_horario_w
					|| ' - cd_intervalo_w: ' || cd_intervalo_w
					, 1, 2000));
			end;
		elsif (coalesce(dt_horario_ref_w::text, '') = '') then
			select	cpoe_obter_data_hora_form(max(dt_inicio), max(hr_Prim_horario)),
					max(ds_horarios)
			into STRICT	dt_horario_ref_w,
					ds_horarios_w
			from	cpoe_material
			where	nr_sequencia = nr_seq_cpoe_w
			and		ie_administracao = 'P'
			and		(hr_Prim_horario IS NOT NULL AND hr_Prim_horario::text <> '')
			and		(cd_intervalo IS NOT NULL AND cd_intervalo::text <> '');

			if (dt_horario_ref_w < clock_timestamp()) then
				dt_horario_ref_w := null;
			end if;

			if ((coalesce(dt_horario_ref_w::text, '') = '') and (dt_inicio_prescr_w IS NOT NULL AND dt_inicio_prescr_w::text <> '') and (coalesce(cd_intervalo_w::text, '') = '')) then

				select	cpoe_obter_data_hora_form(max(dt_inicio), max(hr_Prim_horario))
				into STRICT	dt_inicio_w
				from	cpoe_material
				where	nr_sequencia = nr_seq_cpoe_w;

				if ((dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '') and (dt_inicio_w > dt_inicio_prescr_w) and (round(24 * (dt_inicio_prescr_w - dt_inicio_w), 1) < 24)) then
					dt_horario_ref_w := dt_inicio_w;

					if (dt_horario_ref_w < clock_timestamp()) then
						dt_horario_ref_w := null;
					end if;
				end if;
			end if;
		end if;

		CALL gravar_log_cpoe(SUBSTR('CPOE_GERAR_DATA_COPIA_ITEM '
			|| ' - nr_prescricao_p: ' || nr_prescricao_p
			|| ' - qt_horas_ant_p: ' || qt_horas_ant_p
			|| ' - dt_referencia_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_referencia_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)
			|| ' - ie_tipo_item_w: ' || ie_tipo_item_w
			|| ' - nr_seq_cpoe_w: ' || nr_seq_cpoe_w
			|| ' - nr_seq_item_w: ' || nr_seq_item_w
			|| ' - nr_prescricao_w: ' || nr_prescricao_w
			|| ' - dt_horario_ref_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_horario_ref_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)
			|| ' - cd_intervalo_w: ' || cd_intervalo_w
			|| ' - ds_horarios_w: '|| ds_horarios_w
			, 1, 2000));

		Atualizar_cpoe('cpoe_material');

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao),
				coalesce(max(ie_evento_unico),'N')
		into STRICT	dt_prox_geracao_w,
				ie_evento_unico_w
		from	cpoe_material
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') and (ie_evento_unico_w = 'N') then
			CALL gravar_log_tasy(10009,
							'Medicamento - dt_prox_geracao e null:
											   nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
											   ||' nr_seq_item_w : '	  	 || nr_seq_item_w
											   ||' nr_prescricao_w : '	  	 || nr_prescricao_w,
							null);
        elsif (dt_prox_geracao_w IS NOT NULL AND dt_prox_geracao_w::text <> '') then
            select  max(a.ie_operacao)
            into STRICT    ie_operacao_interv_w
            from    intervalo_prescricao a
            where   a.cd_intervalo = cd_intervalo_w;

            if (ie_operacao_interv_w = 'D') then
                nr_horas_apos_copia_w := get_qt_hours_after_copy_cpoe(cd_perfil_p => wheb_usuario_pck.get_cd_perfil,
                                                                        nm_usuario_p => wheb_usuario_pck.get_nm_usuario,
                                                                        cd_estabelecimento_p => wheb_usuario_pck.get_cd_estabelecimento);
                update  prescr_material a
                set     a.dt_proxima_dose = dt_prox_geracao_w + (nr_horas_apos_copia_w / 24)
                where   a.nr_seq_mat_cpoe = nr_seq_cpoe_w
                and     a.nr_prescricao = nr_prescricao_w;
            end if;
		end if;

	elsif (ie_tipo_item_w = 'O') then

		select	min(dt_horario)
		into STRICT	dt_horario_ref_w
		from	prescr_dieta_hor
		where	nr_seq_dieta = nr_seq_item_w
		and		nr_prescricao = nr_prescricao_w;

		if (coalesce(dt_horario_ref_w::text, '') = '') then

			select	cpoe_obter_data_hora_form(max(dt_inicio), max(hr_Prim_horario))
			into STRICT	dt_horario_ref_w
			from	cpoe_dieta
			where	nr_sequencia = nr_seq_cpoe_w
			and		ie_administracao = 'P'
			and		(hr_Prim_horario IS NOT NULL AND hr_Prim_horario::text <> '')
			and		(cd_intervalo IS NOT NULL AND cd_intervalo::text <> '');

			if (dt_horario_ref_w < clock_timestamp()) then
				dt_horario_ref_w := null;
			end if;

		end if;

		Atualizar_cpoe('cpoe_dieta');

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao),
				coalesce(max(coalesce(ie_dose_unica,ie_evento_unico)),'N')
		into STRICT	dt_prox_geracao_w,
				ie_evento_unico_w
		from	cpoe_dieta
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') and (ie_evento_unico_w = 'N') then
			CALL gravar_log_tasy(10009,
							'Dieta Oral- dt_prox_geracao e null:
											   nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
											   ||' nr_seq_item_w : '	  	 || nr_seq_item_w
											   ||' nr_prescricao_w : '	  	 || nr_prescricao_w,

							null);
		end if;

	elsif (ie_tipo_item_w = 'E') then

		select	min(dt_horario)
		into STRICT	dt_horario_ref_w
		from	prescr_mat_hor
		where	nr_seq_material = nr_seq_item_w
		and		nr_prescricao = nr_prescricao_w;

		if (coalesce(dt_horario_ref_w::text, '') = '') then

			select	cpoe_obter_data_hora_form(max(dt_inicio), max(hr_Prim_horario)),
					max(ie_continuo)
			into STRICT	dt_horario_ref_w,
					ie_continuo_w
			from	cpoe_dieta
			where	nr_sequencia = nr_seq_cpoe_w
			and		ie_administracao = 'P'
			and		(hr_Prim_horario IS NOT NULL AND hr_Prim_horario::text <> '')
			and		(cd_intervalo IS NOT NULL AND cd_intervalo::text <> '');

			if (dt_horario_ref_w < clock_timestamp()) then
				dt_horario_ref_w := null;
			end if;

		end if;

		Atualizar_cpoe('cpoe_dieta');

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao),
				coalesce(max(coalesce(ie_dose_unica,ie_evento_unico)),'N')
		into STRICT	dt_prox_geracao_w,
				ie_evento_unico_w
		from	cpoe_dieta
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') and (ie_evento_unico_w = 'N') then
			CALL gravar_log_tasy(10009,
							'Dieta Enteral - dt_prox_geracao e null:
											   nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
											   ||' nr_seq_item_w : '	  	 || nr_seq_item_w
											   ||' nr_prescricao_w : '	  	 || nr_prescricao_w,

							null);
		end if;

	elsif (ie_tipo_item_w = 'J') then
		cd_intervalo_w	:= null;

		select	trunc(coalesce(max(dt_fim),max(dt_referencia_p + ((24 - qt_horas_ant_p)/24))),'hh24')
		into STRICT	dt_horario_ref_w
		from	rep_jejum
		where	nr_sequencia = nr_seq_item_w
		and		nr_prescricao = nr_prescricao_w;

		update	cpoe_dieta
		set		dt_prox_geracao = dt_horario_ref_w - qt_horas_ant_p/24
		where	nr_sequencia = nr_seq_cpoe_w
		and		((coalesce(dt_fim::text, '') = '') or (dt_fim > (dt_horario_ref_w - qt_horas_ant_p/24)));

		commit;

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao),
				coalesce(max(ie_evento_unico),'N')
		into STRICT	dt_prox_geracao_w,
				ie_evento_unico_w
		from	cpoe_dieta
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') and (ie_evento_unico_w = 'N') then
			CALL gravar_log_tasy(10009,
							'Dieta Jejum - dt_prox_geracao e null:
											   nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
											   ||' nr_seq_item_w : '	  	 || nr_seq_item_w
											   ||' nr_prescricao_w : '	  	 || nr_prescricao_w
											   ||' dt_referencia_p : '	  	 || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_referencia_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),null);
		end if;

	elsif (ie_tipo_item_w = 'P') then

		select	min(dt_horario)
		into STRICT	dt_horario_ref_w
		from	prescr_proc_hor
		where	nr_seq_procedimento = nr_seq_item_w
		and		nr_prescricao = nr_prescricao_w;

		if (coalesce(dt_horario_ref_w::text, '') = '') then

			select	cpoe_obter_data_hora_form(max(dt_inicio), max(hr_Prim_horario))
			into STRICT	dt_horario_ref_w
			from	cpoe_procedimento
			where	nr_sequencia = nr_seq_cpoe_w
			and		ie_administracao = 'P'
			and		(hr_Prim_horario IS NOT NULL AND hr_Prim_horario::text <> '')
			and		(cd_intervalo IS NOT NULL AND cd_intervalo::text <> '');

			if (dt_horario_ref_w < clock_timestamp()) then
				dt_horario_ref_w := null;
			end if;

		end if;

		Atualizar_cpoe('cpoe_procedimento');

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao),
				coalesce(max(ie_evento_unico),'N')
		into STRICT	dt_prox_geracao_w,
				ie_evento_unico_w
		from	cpoe_procedimento
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') and (ie_evento_unico_w = 'N') then
			CALL gravar_log_tasy(10009,
							'Procedimento - dt_prox_geracao e null:
											   nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
											   ||' nr_seq_item_w : '	  	 || nr_seq_item_w
											   ||' nr_prescricao_w : '	  	 || nr_prescricao_w,
							null);
		end if;

	elsif (ie_tipo_item_w = 'G') then

		select	min(dt_horario)
		into STRICT	dt_horario_ref_w
		from	prescr_gasoterapia_hor
		where	nr_seq_gasoterapia = nr_seq_item_w
		and		nr_prescricao = nr_prescricao_w;

		Atualizar_cpoe('cpoe_gasoterapia');

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao)
		into STRICT	dt_prox_geracao_w
		from	cpoe_gasoterapia
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') then
			CALL gravar_log_tasy(10009,
							'Gasoterapia - dt_prox_geracao e null:
											   nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
											   ||' nr_seq_item_w : '	  	 || nr_seq_item_w
											   ||' nr_prescricao_w : '	  	 || nr_prescricao_w,
							null);
		end if;

	elsif (ie_tipo_item_w = 'R') then
		select	min(dt_horario)
		into STRICT	dt_horario_ref_w
		from	prescr_rec_hor
		where	nr_seq_recomendacao = nr_seq_item_w
		and		nr_prescricao = nr_prescricao_w;

		if (coalesce(dt_horario_ref_w::text, '') = '') then

			select	cpoe_obter_data_hora_form(max(dt_inicio), max(hr_Prim_horario))
			into STRICT	dt_horario_ref_w
			from	cpoe_recomendacao
			where	nr_sequencia = nr_seq_cpoe_w
			and		ie_administracao = 'P'
			and		(hr_Prim_horario IS NOT NULL AND hr_Prim_horario::text <> '')
			and		(cd_intervalo IS NOT NULL AND cd_intervalo::text <> '');

			if (dt_horario_ref_w < clock_timestamp()) then
				dt_horario_ref_w := null;
			end if;

		end if;

		Atualizar_cpoe('cpoe_recomendacao');

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao),
				coalesce(max(ie_evento_unico),'N')
		into STRICT	dt_prox_geracao_w,
				ie_evento_unico_w
		from	cpoe_recomendacao
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') and (ie_evento_unico_w = 'N') then
			CALL gravar_log_tasy(10009,
							'Recomendacao - dt_prox_geracao e null:
											   nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
											   ||' nr_seq_item_w : '	  	 || nr_seq_item_w
											   ||' nr_prescricao_w : '	  	 || nr_prescricao_w,
							null);
		end if;

	elsif (ie_tipo_item_w = 'D') then
		cd_intervalo_w	:= null;

		select	trunc(max(dt_inicio_dialise) + ((24 - qt_horas_ant_p)/24),'hh24')
		into STRICT	dt_horario_ref_w
		from	hd_prescricao
		where	nr_sequencia = nr_seq_item_w
		and		nr_prescricao = nr_prescricao_w;

		update	cpoe_dialise
		set		dt_prox_geracao = dt_horario_ref_w
		where	nr_sequencia = nr_seq_cpoe_w
		and		((coalesce(dt_fim::text, '') = '') or (dt_fim > dt_horario_ref_w));

		commit;

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao),
				coalesce(max(ie_evento_unico),'N')
		into STRICT	dt_prox_geracao_w,
				ie_evento_unico_w
		from	cpoe_dialise
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') and (ie_evento_unico_w = 'N') then
			CALL gravar_log_tasy(10009,
							'Dialise - dt_prox_geracao e null:
											   nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
											   ||' nr_seq_item_w : '	  	 || nr_seq_item_w
											   ||' nr_prescricao_w : '	  	 || nr_prescricao_w
											   ||' dt_referencia_p : '	  	 || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_referencia_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),null);
		end if;

	elsif (ie_tipo_item_w = 'A') then
		dt_horario_ref_w := null;

		if (coalesce(nr_seq_item_w, 0) > 0) then
			select	min(dt_horario)
			into STRICT	dt_horario_ref_w
			from	prescr_mat_hor
			where	nr_seq_material = nr_seq_item_w
			and		nr_prescricao = nr_prescricao_w;
		end if;

		if (coalesce(dt_horario_ref_w::text, '') = '') then

			select	cpoe_obter_data_hora_form(max(dt_inicio), max(hr_Prim_horario))
			into STRICT	dt_horario_ref_w
			from	cpoe_dieta
			where	nr_sequencia = nr_seq_cpoe_w
			and		ie_administracao = 'P'
			and		(hr_Prim_horario IS NOT NULL AND hr_Prim_horario::text <> '')
			and		(cd_intervalo IS NOT NULL AND cd_intervalo::text <> '');

			if (dt_horario_ref_w < clock_timestamp()) then
				dt_horario_ref_w := null;
			end if;

		end if;

		Atualizar_cpoe('cpoe_dieta');

		--Gerar Log	quando nao tem dt_prox_geracao
		select	max(dt_prox_geracao),
				coalesce(max(coalesce(ie_dose_unica,ie_evento_unico)),'N')
		into STRICT	dt_prox_geracao_w,
				ie_evento_unico_w
		from	cpoe_dieta
		where	nr_sequencia = nr_seq_cpoe_w;

		if (coalesce(dt_prox_geracao_w::text, '') = '') and (ie_evento_unico_w = 'N') then
			CALL gravar_log_tasy(10009,
							'NPT Adulta - dt_prox_geracao e null:
								               nr_seq_cpoe_w : '  	 		 || nr_seq_cpoe_w
								               ||' nr_seq_item_w : '	  	 || nr_seq_item_w
								               ||' nr_prescricao_w : '	  	 || nr_prescricao_w,
							null);
		end if;

	end if;

end loop;

commit;

exception when others then
	rollback;

	ds_exception_w  := to_char(sqlerrm);

	CALL gravar_log_cpoe(substr('CPOE_GERAR_DATA_COPIA_ITEM EXCEPTION -'
		|| chr(13) || 'nr_prescricao_p: ' || nr_prescricao_p
		|| chr(13) || 'qt_horas_ant_p: ' || qt_horas_ant_p
		|| chr(13) || 'dt_referencia_p: '|| to_char(dt_referencia_p, 'dd/mm/yyyy hh24:mi:ss')
		|| chr(13) || 'ie_gpt_p: ' || ie_gpt_p
		|| chr(13) || obter_desc_expressao(504115) || ds_exception_w,1,2000)
	);

	commit;

	raise;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_data_copia_item ( nr_prescricao_p bigint, qt_horas_ant_p bigint, dt_referencia_p timestamp, ie_gpt_p text default 'N') FROM PUBLIC;
