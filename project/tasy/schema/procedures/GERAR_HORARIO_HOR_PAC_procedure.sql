-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_horario_hor_pac (nr_atendimento_p bigint, cd_pessoa_fisica_p text, cd_material_p bigint, ds_horarios_p text, cd_intervalo_p text, nr_seq_horario_p bigint, nr_prescricao_p bigint, nr_seq_item_p bigint, nm_usuario_p text, ie_tipo_item_p text , cd_procedimento_p bigint, nr_seq_proc_interno_p bigint, ie_origem_proced_p bigint, nr_seq_solucao_p bigint default null) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_prescricao_w		bigint;
nr_seq_item_cpoe_w	bigint;
nr_agrupamento_w	bigint;
cd_material_w		bigint;
ie_composto_w		varchar(1);
ds_horarios_w		varchar(255);
cd_funcao_origem_w	prescr_medica.cd_funcao_origem%type;
ie_via_aplicacao_w	prescr_material.ie_via_aplicacao%type;
qt_dose_w			prescr_material.qt_dose%type;
ie_via_aplicacao_ww	prescr_material.ie_via_aplicacao%type;
qt_dose_ww			prescr_material.qt_dose%type;
ie_agrupador_w		prescr_material.ie_agrupador%type;
hr_prim_horario_w	prescr_material.hr_prim_horario%type;
hr_prim_horario_2w	varchar(10);
dt_atual_w			timestamp := trunc(clock_timestamp(),'hh');
dt_prim_hor_item_w	timestamp;
dt_primeiro_hor_w	timestamp;
nr_horas_copia_w	bigint := 0;
nr_seq_mat_cpoe_w	cpoe_material.nr_sequencia%type;

c01 CURSOR FOR
SELECT	cd_material,
		ie_via_aplicacao,
		coalesce(qt_dose,0)
from	prescr_material
where	nr_prescricao	= nr_prescricao_w
and		nr_agrupamento	= nr_agrupamento_w
and		ie_agrupador	= ie_agrupador_w
and		cd_material	<> cd_material_p;

	procedure consiste_aprazamento is
	;
BEGIN
	--dt_atual_w := to_date('26/04/2017 01:00','dd/mm/yyyy hh24:mi:ss');
	nr_horas_copia_w := get_qt_hours_after_copy_cpoe( obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo);
	
	hr_prim_horario_2w := obter_prim_dshorarios(ds_horarios_w);	
	
	dt_primeiro_hor_w := to_date(to_char(dt_atual_w,'dd/mm/yyyy')||hr_prim_horario_2w,'dd/mm/yyyy hh24:mi');
	dt_prim_hor_item_w := to_date(to_char(dt_atual_w,'dd/mm/yyyy')||hr_prim_horario_w,'dd/mm/yyyy hh24:mi');
	
	
	if (dt_prim_hor_item_w > dt_primeiro_hor_w) then
	
		if (dt_primeiro_hor_w < dt_atual_w) then
			dt_primeiro_hor_w := trunc(dt_primeiro_hor_w,'hh') + 1;
		end if;
		--Wheb_mensagem_pck.exibir_mensagem_abort('dt_atual_w= '||to_char(dt_atual_w,'dd/mm/yyyy hh24:mi')||' - dt_prim_hor_item_w= '||to_char(dt_prim_hor_item_w,'dd/mm/yyyy hh24:mi')||' - dt_primeiro_hor_w= '||to_char(dt_primeiro_hor_w,'dd/mm/yyyy hh24:mi'));
		if (dt_atual_w >= (dt_primeiro_hor_w - nr_horas_copia_w/24)) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(803632, 'HR_PRIM_HORARIO=' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR((dt_atual_w + (nr_horas_copia_w + 1)/24), 'shortTime', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| ';NR_HORAS=' || nr_horas_copia_w);
			/*Wheb_mensagem_pck.exibir_mensagem_abort('O primeiro horario possivel para o item e: ' || to_char(dt_primeiro_hor_w + 1/24,'hh24:mi') ||'. '||chr(10)||
													'Devido as regras de copia do item para os proximos dias, o primeiro horario do mesmo nao pode ser inferior a '||nr_horas_copia_w||' horas em relacao ao horario atual. '||chr(10)||
													'Favor rever os horarios informados.');*/
		end if;	
	end if;	
	end;

begin
ds_horarios_w	:= substr(ds_horarios_p, 1, 255);

if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
	
	if (coalesce(ie_tipo_item_p,'M') in ('M', 'S', 'SNE', 'IAH')) then
		if (coalesce(nr_seq_horario_p,0) > 0) then
			select	max(b.nr_prescricao),
					max(b.nr_agrupamento),
					max(b.ie_agrupador),
					max(b.ie_via_aplicacao),
					max(b.qt_dose),
					max(coalesce(b.nr_seq_mat_cpoe,nr_seq_dieta_cpoe))
			into STRICT	nr_prescricao_w,
					nr_agrupamento_w,
					ie_agrupador_w,
					ie_via_aplicacao_w,
					qt_dose_w,
					nr_seq_item_cpoe_w
			from	prescr_mat_hor c,
					prescr_material b
			where	c.nr_prescricao		= b.nr_prescricao
			and		c.nr_seq_material	= b.nr_sequencia
			and		c.nr_sequencia		= nr_seq_horario_p
			and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S';
		else
			select	max(b.nr_prescricao),
					max(b.nr_agrupamento),
					max(b.ie_agrupador),
					max(b.ie_via_aplicacao),
					max(b.qt_dose),
					max(coalesce(b.nr_seq_mat_cpoe,nr_seq_dieta_cpoe))
			into STRICT	nr_prescricao_w,
					nr_agrupamento_w,
					ie_agrupador_w,
					ie_via_aplicacao_w,
					qt_dose_w,
					nr_seq_item_cpoe_w
			from	prescr_material b
			where	b.nr_prescricao		= nr_prescricao_p
			and		b.nr_sequencia		= nr_seq_item_p;
		end if;
		
		select	max(cd_funcao_origem)
		into STRICT	cd_funcao_origem_w
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_p;
		
		if ((coalesce(nr_seq_item_cpoe_w,0) > 0) and (cd_funcao_origem_w = 2314)) then
			select	max(hr_prim_horario)
			into STRICT	hr_prim_horario_w
			from	cpoe_material_vig_v
			where	nr_sequencia = nr_seq_item_cpoe_w;
		
			consiste_aprazamento;
		end if;
		
		
		if (coalesce(ie_tipo_item_p,'M') = 'M') then
			nr_seq_mat_cpoe_w := nr_seq_item_cpoe_w;
		end if;

		ie_composto_w	:= 'N';
			
		open c01;
		loop
		fetch c01 into
			cd_material_w,
			ie_via_aplicacao_ww,
			qt_dose_ww;
		EXIT WHEN NOT FOUND; /* apply on c01 */

			update	rep_horario_hor_pac
			set		dt_cancelamento	= clock_timestamp()
			where	nr_atendimento	= nr_atendimento_p
			and		cd_material	= cd_material_w
			and		ie_composto	= 'S'
			and		coalesce(dt_cancelamento::text, '') = ''
			and		coalesce(qt_dose, qt_dose_ww) = qt_dose_ww
			and		((ie_via_aplicacao = ie_via_aplicacao_ww) or (coalesce(ie_via_aplicacao_ww::text, '') = ''));

			select	nextval('rep_horario_hor_pac_seq')
			into STRICT	nr_sequencia_w
			;

			insert into rep_horario_hor_pac(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_material,
				dt_definicao,
				nr_atendimento,
				ds_horario,
				cd_pessoa_fisica,
				dt_cancelamento,
				cd_intervalo,
				ie_composto,
				ie_tipo_item,
				ie_via_aplicacao,
				qt_dose)
			values (nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_material_w,
				clock_timestamp(),
				nr_atendimento_p,
				ds_horarios_w,
				cd_pessoa_fisica_p,
				null,
				cd_intervalo_p,
				'S',
				ie_tipo_item_p,
				ie_via_aplicacao_ww,
				qt_dose_ww);
				
			ie_composto_w	:= 'S';
				
		end loop;
		close c01;

		update	rep_horario_hor_pac
		set	dt_cancelamento	= clock_timestamp()
		where	nr_atendimento	= nr_atendimento_p
		and	cd_material	= cd_material_p
		and	coalesce(ie_composto, ie_composto_w)	= ie_composto_w
		and	coalesce(dt_cancelamento::text, '') = ''
		and	coalesce(qt_dose, qt_dose_ww) = qt_dose_ww
		and	((ie_via_aplicacao = ie_via_aplicacao_ww) or (coalesce(ie_via_aplicacao_ww::text, '') = ''));

		select	nextval('rep_horario_hor_pac_seq')
		into STRICT	nr_sequencia_w
		;

		insert into rep_horario_hor_pac(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_material,
			dt_definicao,
			nr_atendimento,
			ds_horario,
			cd_pessoa_fisica,
			dt_cancelamento,
			cd_intervalo,
			ie_composto,
			qt_dose,
			ie_via_aplicacao)
		values (nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_p,
			clock_timestamp(),
			nr_atendimento_p,
			ds_horarios_w,
			cd_pessoa_fisica_p,
			null,
			cd_intervalo_p,
			ie_composto_w,
			qt_dose_w,
			ie_via_aplicacao_w);
			
	elsif (ie_tipo_item_p = 'P' or ie_tipo_item_p = 'L') then
		
		if (coalesce(nr_seq_horario_p,0) > 0) then
			select	max(b.nr_prescricao),
				max(b.nr_agrupamento),
				max(b.nr_seq_proc_cpoe)
			into STRICT	nr_prescricao_w,
				nr_agrupamento_w,
				nr_seq_item_cpoe_w
			from	prescr_proc_hor c,
					prescr_procedimento b
			where	c.nr_prescricao		    = b.nr_prescricao
			and		c.nr_seq_procedimento	= b.nr_sequencia
			and		c.nr_sequencia			= nr_seq_horario_p
			and		Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S';
		else
			select	max(b.nr_prescricao),
			max(b.nr_agrupamento),
			max(b.nr_seq_proc_cpoe)
			into STRICT	nr_prescricao_w,
				nr_agrupamento_w,
				nr_seq_item_cpoe_w
			from	prescr_procedimento b
			where	b.nr_prescricao		= nr_prescricao_p
			and		b.nr_sequencia		= nr_seq_item_p;
		end if;
		
		update	rep_horario_hor_pac
		set		dt_cancelamento	= clock_timestamp()
		where	nr_atendimento	= nr_atendimento_p
		and		cd_procedimento	= cd_procedimento_p
		and		coalesce(dt_cancelamento::text, '') = '';

		select	nextval('rep_horario_hor_pac_seq')
		into STRICT	nr_sequencia_w
		;
		
		----
		
		
		if ((coalesce(nr_seq_item_cpoe_w,0) > 0) and (cd_funcao_origem_w = 2314)) then
			
			select	max(hr_prim_horario)
			into STRICT	hr_prim_horario_w
			from	cpoe_procedimento
			where	nr_sequencia = nr_seq_item_cpoe_w;
			
		
			consiste_aprazamento;
		end if;

		insert into rep_horario_hor_pac(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_material,
			dt_definicao,
			nr_atendimento,
			ds_horario,
			cd_pessoa_fisica,
			dt_cancelamento,
			cd_intervalo,
			cd_procedimento,	
			ie_tipo_item,
			nr_seq_proc_interno,
			ie_origem_proced)
		values (nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			null,
			clock_timestamp(),
			nr_atendimento_p,
			ds_horarios_w,
			cd_pessoa_fisica_p,
			null,
			cd_intervalo_p,
			cd_procedimento_p,
			ie_tipo_item_p,
			nr_seq_proc_interno_p,
			ie_origem_proced_p);
			
		
			
	elsif (ie_tipo_item_p = 'SOL') then
		
		update	rep_horario_hor_pac
		set		dt_cancelamento	= clock_timestamp()
		where	nr_atendimento	= nr_atendimento_p
		and		nr_seq_solucao	= nr_seq_solucao_p
		and		coalesce(dt_cancelamento::text, '') = '';

		select	nextval('rep_horario_hor_pac_seq')
		into STRICT	nr_sequencia_w
		;

		insert into rep_horario_hor_pac(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,			
			dt_definicao,
			nr_atendimento,
			ds_horario,
			cd_pessoa_fisica,
			dt_cancelamento,
			cd_intervalo,			
			ie_tipo_item,
			nr_seq_solucao,
			nr_prescricao)
		values (nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,			
			clock_timestamp(),
			nr_atendimento_p,
			ds_horarios_w,
			cd_pessoa_fisica_p,
			null,
			cd_intervalo_p,			
			ie_tipo_item_p,
			nr_seq_solucao_p,
			nr_prescricao_p);
	end if;	
	
	CALL cpoe_ajustar_horarios_padroes(nr_atendimento_p, cd_material_p, nr_seq_proc_interno_p, cd_intervalo_p, ds_horarios_w, nm_usuario_p, nr_seq_solucao_p, nr_prescricao_p, nr_seq_mat_cpoe_w);
	
	commit;
	
end if;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_horario_hor_pac (nr_atendimento_p bigint, cd_pessoa_fisica_p text, cd_material_p bigint, ds_horarios_p text, cd_intervalo_p text, nr_seq_horario_p bigint, nr_prescricao_p bigint, nr_seq_item_p bigint, nm_usuario_p text, ie_tipo_item_p text , cd_procedimento_p bigint, nr_seq_proc_interno_p bigint, ie_origem_proced_p bigint, nr_seq_solucao_p bigint default null) FROM PUBLIC;

