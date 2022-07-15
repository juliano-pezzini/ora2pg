-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_termino_sne ( nm_usuario_p text, nr_atendimento_p bigint, dt_alteracao_p timestamp, ie_consistir_dt_p text default 'N', ie_horario_invalido_p INOUT text DEFAULT NULL, nr_prescr_p prescr_medica.nr_prescricao%type default null, nr_seq_sol_p prescr_material.nr_sequencia%type default null) AS $body$
DECLARE


	nr_sequencia_w				prescr_material.nr_sequencia%type;
	nr_prescricao_w				prescr_material.nr_prescricao%type;
	dt_horario_w				prescr_mat_hor.dt_horario%type;
	nr_prescricao_finalizada_w	prescr_material.nr_prescricao%type;
	ds_mensagem_w				varchar(255);
	ie_horario_invalido_w		varchar(1);
	dt_evento_ref_w				timestamp;
	dt_inicio_w					timestamp;
	qt_volume_parcial_w			bigint;
	qt_volume_total_w			bigint;
	qt_vol_infundido_w			bigint;
	ie_data_lib_prescr_w		varchar(1);

c01 CURSOR FOR
	SELECT	x.nr_sequencia,
			a.nr_prescricao,
			c.dt_horario,
			obter_volume_parcial_sol(x.nr_prescricao,x.nr_sequencia,2),
			obter_volume_total_sne(x.cd_intervalo,obter_conversao_ml(x.cd_material,x.qt_dose,x.cd_unidade_medida_dose),x.nr_ocorrencia)
	from	prescr_material x,
			prescr_medica a,
			prescr_mat_hor c
	where	x.nr_prescricao = a.nr_prescricao
	and		c.nr_prescricao = a.nr_prescricao
  and   ((coalesce(nr_prescr_p::text, '') = '' or coalesce(nr_seq_sol_p::text, '') = '') or (a.nr_prescricao <> nr_prescr_p
      or (a.nr_prescricao = nr_prescr_p  and x.nr_sequencia <> nr_seq_sol_p)))
	and		a.nr_atendimento = nr_atendimento_p
	and		a.dt_validade_prescr between dt_inicio_w and clock_timestamp() + interval '2 days'
	and		((obter_se_prescr_lib_adep(coalesce(a.dt_liberacao_medico,x.dt_lib_material), coalesce(a.dt_liberacao,x.dt_lib_material), coalesce(a.dt_liberacao_farmacia,x.dt_lib_material), ie_data_lib_prescr_w, a.ie_lib_farm) = 'S') or (coalesce(a.ie_prescr_nutricao, 'N') = 'S'))
	and		x.ie_agrupador = 8
	and		substr(obter_status_solucao_prescr(2,a.nr_prescricao,x.nr_sequencia),1,3) in ('I','R')
	and		x.dt_status between dt_inicio_w and clock_timestamp()
	and		coalesce(a.ie_recem_nato,'N') = 'N'
	and		x.ie_status <> 'T'
	and		((coalesce(x.dt_suspensao::text, '') = '') and (coalesce(x.ie_horario_susp,'N') <> 'S'))
	and		a.dt_inicio_prescr between dt_inicio_w and clock_timestamp()
	order by a.nr_prescricao,
		c.dt_horario desc;


BEGIN
	nr_prescricao_finalizada_w := 0;
	ie_horario_invalido_w := 'N';
	ie_horario_invalido_p := 'N';

	dt_inicio_w	:= pkg_date_utils.start_of(clock_timestamp() - interval '5 days', 'DAY');
	ie_data_lib_prescr_w := Wheb_assist_pck.obterParametroFuncao(1113,115, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);

	open C01;
	loop
	fetch C01 into
		nr_sequencia_w,
		nr_prescricao_w,
		dt_horario_w,
		qt_volume_parcial_w,
		qt_volume_total_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_consistir_dt_p = 'S') then
			select	max(dt_atualizacao)
			into STRICT	dt_evento_ref_w
			from	prescr_solucao_evento
			where	nr_prescricao	= nr_prescricao_w
			and		nr_seq_material	= nr_sequencia_w
			and		ie_tipo_solucao	= 2
			and		ie_alteracao	in (1,3,35)
			and		ie_evento_valido	= 'S';

			if ((dt_evento_ref_w IS NOT NULL AND dt_evento_ref_w::text <> '') and dt_evento_ref_w >= dt_alteracao_p) then
				ie_horario_invalido_w := 'S';
				ie_horario_invalido_p := 'S';
			else
				ie_horario_invalido_w := 'N';
			end if;
		end if;

		if(	((ie_consistir_dt_p = 'N' or coalesce(ie_consistir_dt_p::text, '') = '')
			or (ie_consistir_dt_p = 'S' and ie_horario_invalido_w = 'N'))
			and nr_prescricao_finalizada_w <> nr_prescricao_w) then

			qt_vol_infundido_w := qt_volume_total_w - qt_volume_parcial_w;
			Gerar_alteracao_solucao_prescr(
				cd_estabelecimento_p	=> obter_estabelecimento_ativo,
				ds_observacao_p			=> null,
				dt_alteracao_p			=> (coalesce(dt_alteracao_p,clock_timestamp()) - 1/86400),
				dt_horario_p			=> dt_horario_w,
				ie_tipo_solucao_p		=> 2,
				ie_alteracao_p			=> 4,
				ie_forma_infusao_p		=> null,
				ie_tipo_dosagem_p		=> 'mlh',
				ie_bomba_infusao_p		=> null,
				nm_usuario_p			=> nm_usuario_p,
				nr_atendimento_p		=> nr_atendimento_p,
				nr_prescricao_p			=> nr_prescricao_w,
				nr_seq_solucao_p		=> nr_sequencia_w,
				nr_seq_dispositivo_p	=> null,
				nr_seq_motivo_p			=> null,
				nr_etapa_evento_p		=> null,
				qt_vol_fase_p			=> qt_vol_infundido_w,
				qt_vel_infusao_p		=> 0,
				qt_vol_infundido_p		=> qt_vol_infundido_w,
				qt_vol_desprezado_p		=> 0,
				qt_vol_parcial_p		=> 0,
				ds_msg_p				=> ds_mensagem_w);

			nr_prescricao_finalizada_w := nr_prescricao_w;
		end if;
		end;
	end loop;
	close C01;

	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_termino_sne ( nm_usuario_p text, nr_atendimento_p bigint, dt_alteracao_p timestamp, ie_consistir_dt_p text default 'N', ie_horario_invalido_p INOUT text DEFAULT NULL, nr_prescr_p prescr_medica.nr_prescricao%type default null, nr_seq_sol_p prescr_material.nr_sequencia%type default null) FROM PUBLIC;

