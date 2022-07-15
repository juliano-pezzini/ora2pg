-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_horarios_eliminados (cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, cd_intervalo_p text, ie_laboratorio_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, qt_minutos_p bigint, ds_lista_eliminados_p INOUT text, ie_reaprazar_seguintes_p text, nr_seq_horario_p bigint) AS $body$
DECLARE


ds_lista_eliminados_w	varchar(255);
dt_horario_w		varchar(20);
dt_validade_prescr_w	timestamp;
dt_inicio_prescr_w	timestamp;
ie_data_proc_w		varchar(15);
ie_data_lib_prescr_w	varchar(15);
ie_exibe_suspenso_w	varchar(15);
cd_setor_pac_w		bigint;
cd_funcao_origem_w 	prescr_medica.cd_funcao_origem%type;
dt_validade_cpoe_w	timestamp;
nr_seq_mat_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;
dt_hor_selecionado_w timestamp;

c01 CURSOR FOR
SELECT	to_char((c.dt_horario + (qt_minutos_p / 1440)),'dd/mm/yy hh24:mi') /* dietas orais */
from	prescr_dieta_hor c,
	prescr_medica a
where	c.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	coalesce(c.ie_situacao,'A') = 'A'
--and	nvl(c.ie_horario_especial,'N') = 'N'
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = ''
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_prescricao = nr_prescricao_p
and	a.dt_validade_prescr > clock_timestamp()
and	c.cd_refeicao = cd_item_p
and c.dt_horario >= dt_hor_selecionado_w
and	((((c.dt_horario + (qt_minutos_p / 1440)) >= dt_validade_prescr_w) and (qt_minutos_p > 0)) or
	 (((c.dt_horario + (qt_minutos_p / 1440)) < dt_inicio_prescr_w) and (qt_minutos_p < 0)))
and	ie_tipo_item_p = 'D'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	to_char((c.dt_horario + (qt_minutos_p / 1440)),'dd/mm/yy hh24:mi')
from	prescr_medica a,
	prescr_dieta b,
	prescr_dieta_hor c
where	c.nr_prescricao = a.nr_prescricao
and	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_dieta	= b.nr_sequencia
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = ''
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_prescricao = nr_prescricao_p
and	a.dt_validade_prescr > clock_timestamp()
and	to_char(b.cd_dieta) = cd_item_p
and	coalesce(c.cd_refeicao::text, '') = ''
and	((((c.dt_horario + (qt_minutos_p / 1440)) >= dt_validade_prescr_w) and (qt_minutos_p > 0)) or
	 (((c.dt_horario + (qt_minutos_p / 1440)) < dt_inicio_prescr_w) and (qt_minutos_p < 0)))
and	ie_tipo_item_p = 'D'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	to_char((c.dt_horario + (qt_minutos_p / 1440)),'dd/mm/yy hh24:mi') /* suplementos orais */
from	prescr_mat_hor c,
	prescr_material b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_material = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	b.ie_agrupador in (12)
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(c.ie_horario_especial,'N') = 'N'
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = ''
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_prescricao = nr_prescricao_p
and	a.dt_validade_prescr > clock_timestamp()
and	b.nr_sequencia = nr_seq_item_p
and	b.cd_material = cd_item_p
and	coalesce(b.cd_intervalo,'XPTO') = coalesce(cd_intervalo_p,'XPTO')
and c.dt_horario >= dt_hor_selecionado_w
and	((((c.dt_horario + (qt_minutos_p / 1440)) >= dt_validade_prescr_w) and (qt_minutos_p > 0)) or
	 (((c.dt_horario + (qt_minutos_p / 1440)) < dt_inicio_prescr_w) and (qt_minutos_p < 0)))
and	ie_tipo_item_p = 'S'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	to_char((c.dt_horario + (qt_minutos_p / 1440)),'dd/mm/yy hh24:mi') /* medicamentos */
from	prescr_mat_hor c,
	prescr_material b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_material = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	b.ie_agrupador in (1)
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(c.ie_horario_especial,'N') = 'N'
and	coalesce(c.ie_adep,'S') = 'S'
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = ''
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_prescricao = nr_prescricao_p
and	a.dt_validade_prescr > clock_timestamp()
and	b.nr_sequencia = nr_seq_item_p
and	b.cd_material = cd_item_p
and	coalesce(b.cd_intervalo,'XPTO') = coalesce(cd_intervalo_p,'XPTO')
and c.dt_horario >= dt_hor_selecionado_w
and	((((c.dt_horario + (qt_minutos_p / 1440)) >= dt_validade_prescr_w) and (qt_minutos_p > 0)) or
	 (((c.dt_horario + (qt_minutos_p / 1440)) < dt_inicio_prescr_w) and (qt_minutos_p < 0)))
and	ie_tipo_item_p = 'M'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	to_char((c.dt_horario + (qt_minutos_p / 1440)),'dd/mm/yy hh24:mi') /* materiais */
from	prescr_mat_hor c,
	prescr_material b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_material = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	b.ie_agrupador in (2)
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(c.ie_horario_especial,'N') = 'N'
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = ''
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_prescricao = nr_prescricao_p
and	a.dt_validade_prescr > clock_timestamp()
and	b.nr_sequencia = nr_seq_item_p
and	b.cd_material = cd_item_p
and	coalesce(b.cd_intervalo,'XPTO') = coalesce(cd_intervalo_p,'XPTO')
and c.dt_horario >= dt_hor_selecionado_w
and	((((c.dt_horario + (qt_minutos_p / 1440)) >= dt_validade_prescr_w) and (qt_minutos_p > 0)) or
	 (((c.dt_horario + (qt_minutos_p / 1440)) < dt_inicio_prescr_w) and (qt_minutos_p < 0)))
and	ie_tipo_item_p = 'MAT'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	to_char((c.dt_horario + (qt_minutos_p / 1440)),'dd/mm/yy hh24:mi') /* procedimentos e controles de glicemia */
from	prescr_proc_hor c,
	prescr_procedimento b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_procedimento = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	(obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_proc_w) IS NOT NULL AND (obter_data_lib_proc_adep(a.dt_liberacao, a.dt_liberacao_medico, ie_data_proc_w))::text <> '')
and	obter_se_exibir_adep_suspensos(b.dt_suspensao, ie_exibe_suspenso_w) = 'S'
and	obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	((coalesce(b.nr_seq_exame::text, '') = '' and ie_laboratorio_p = 'N') or ((b.nr_seq_exame IS NOT NULL AND b.nr_seq_exame::text <> '') and ie_laboratorio_p = 'S'))
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(c.ie_horario_especial,'N') = 'N'
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = ''
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_prescricao = nr_prescricao_p
and	a.dt_validade_prescr > clock_timestamp()
and	b.nr_sequencia = nr_seq_item_p
and	b.cd_procedimento = cd_item_p
and	coalesce(b.cd_intervalo,'XPTO') = coalesce(cd_intervalo_p,'XPTO')
and c.dt_horario >= dt_hor_selecionado_w
and	((((c.dt_horario + (qt_minutos_p / 1440)) >= dt_validade_prescr_w) and (qt_minutos_p > 0)) or
	 (((c.dt_horario + (qt_minutos_p / 1440)) < dt_inicio_prescr_w) and (qt_minutos_p < 0)))
and	(((coalesce(ie_reaprazar_seguintes_p,'N') = 'N') and (c.nr_sequencia = nr_seq_horario_p)) or (coalesce(ie_reaprazar_seguintes_p,'N') = 'S'))
and	ie_tipo_item_p in ('P','G','C')
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	to_char((c.dt_horario + (qt_minutos_p / 1440)),'dd/mm/yy hh24:mi') /* recomendações */
from	prescr_rec_hor c,
	prescr_recomendacao b,
	prescr_medica a
where	c.nr_prescricao = b.nr_prescricao
and	c.nr_seq_recomendacao = b.nr_sequencia
and	b.nr_prescricao = a.nr_prescricao
--and	a.dt_liberacao is not null
and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_w) = 'S'
and	obter_se_exibir_rep_adep_setor(cd_setor_pac_w,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(c.ie_horario_especial,'N') = 'N'
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = ''
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_prescricao = nr_prescricao_p
and	a.dt_validade_prescr > clock_timestamp()
and	b.nr_sequencia = nr_seq_item_p
and	coalesce(to_char(b.cd_recomendacao),b.ds_recomendacao) = cd_item_p
and	coalesce(b.cd_intervalo,'XPTO') = coalesce(cd_intervalo_p,'XPTO')
and c.dt_horario >= dt_hor_selecionado_w
and	((((c.dt_horario + (qt_minutos_p / 1440)) >= dt_validade_prescr_w) and (qt_minutos_p > 0)) or
	 (((c.dt_horario + (qt_minutos_p / 1440)) < dt_inicio_prescr_w) and (qt_minutos_p < 0)))
and	ie_tipo_item_p = 'R'
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'

union

select	to_char((c.dt_horario + (qt_minutos_p / 1440)),'dd/mm/yy hh24:mi') /* sae */
from	pe_prescr_proc_hor c,
	pe_prescr_proc b,
	pe_prescricao a
where	c.nr_seq_pe_proc = b.nr_sequencia
and	b.nr_seq_prescr = a.nr_sequencia
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	coalesce(b.ie_adep,'N') = 'S'
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(c.ie_horario_especial,'N') = 'N'
and	coalesce(c.dt_fim_horario::text, '') = ''
and	coalesce(c.dt_suspensao::text, '') = ''
and	a.nr_atendimento = nr_atendimento_p
and	a.nr_sequencia = nr_prescricao_p
and	a.dt_validade_prescr > clock_timestamp()
and	b.nr_sequencia = nr_seq_item_p
and	b.nr_seq_proc = cd_item_p
and	coalesce(b.cd_intervalo,'XPTO') = coalesce(cd_intervalo_p,'XPTO')
and c.dt_horario >= dt_hor_selecionado_w
and	((((c.dt_horario + (qt_minutos_p / 1440)) >= dt_validade_prescr_w) and (qt_minutos_p > 0)) or
	 (((c.dt_horario + (qt_minutos_p / 1440)) < dt_inicio_prescr_w) and (qt_minutos_p < 0)))
and	ie_tipo_item_p = 'E'
order by
	1;


BEGIN
ie_data_proc_w := obter_param_usuario(924, 223, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_data_proc_w);
ie_data_lib_prescr_w := obter_param_usuario(1113, 115, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_data_lib_prescr_w);
ie_exibe_suspenso_w := obter_param_usuario(1113, 117, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_exibe_suspenso_w);

cd_setor_pac_w	:= Obter_Unidade_Atendimento(nr_atendimento_p, 'IA', 'CS');

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and (cd_item_p IS NOT NULL AND cd_item_p::text <> '') and (ie_laboratorio_p IS NOT NULL AND ie_laboratorio_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	/* atualizar lista eliminados */

	ds_lista_eliminados_w := ds_lista_eliminados_p;

	/* obter validade prescrição */

	if (ie_tipo_item_p <> 'E') then
		select	dt_validade_prescr,
				dt_inicio_prescr,
				cd_funcao_origem
		into STRICT	dt_validade_prescr_w,
				dt_inicio_prescr_w,
				cd_funcao_origem_w
		from	prescr_medica
		where 	nr_prescricao = nr_prescricao_p;

		if	(ie_tipo_item_p = 'M' AND cd_funcao_origem_w = 2314) then

			select	coalesce(max(nr_seq_mat_cpoe),0)
			into STRICT	nr_seq_mat_cpoe_w
			from	prescr_material
			where	nr_prescricao = nr_prescricao_p
			and		nr_sequencia = nr_seq_item_p;

			select 	max(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  coalesce(a.dt_fim_cih,a.dt_fim)  ELSE coalesce(a.dt_suspensao,a.dt_fim) END )
			into STRICT	dt_validade_cpoe_w
			from	cpoe_material a
			where	nr_sequencia = nr_seq_mat_cpoe_w;

			if (dt_validade_cpoe_w IS NOT NULL AND dt_validade_cpoe_w::text <> '') and (dt_validade_cpoe_w < dt_validade_prescr_w) then
				dt_validade_prescr_w	:= dt_validade_cpoe_w;
			end if;

		end if;

	else
		select	dt_validade_prescr,
			dt_inicio_prescr
		into STRICT	dt_validade_prescr_w,
			dt_inicio_prescr_w
		from	pe_prescricao
		where	nr_sequencia = nr_prescricao_p;
	end if;

	if (ie_tipo_item_p = 'D') then
		select	max(dt_horario)
		into STRICT	dt_hor_selecionado_w
		from	prescr_dieta_hor
		where	nr_sequencia = nr_seq_horario_p;
	elsif (ie_tipo_item_p in ('S','M','MAT')) then
		select	max(dt_horario)
		into STRICT	dt_hor_selecionado_w
		from	prescr_mat_hor
		where	nr_sequencia = nr_seq_horario_p;
	elsif (ie_tipo_item_p in ('P','G','C')) then
		select	max(dt_horario)
		into STRICT	dt_hor_selecionado_w
		from	prescr_proc_hor
		where	nr_sequencia = nr_seq_horario_p;
	elsif (ie_tipo_item_p = 'R') then
		select	max(dt_horario)
		into STRICT	dt_hor_selecionado_w
		from	prescr_rec_hor
		where	nr_sequencia = nr_seq_horario_p;
	elsif (ie_tipo_item_p = 'E') then
		select	max(dt_horario)
		into STRICT	dt_hor_selecionado_w
		from	pe_prescr_proc_hor
		where	nr_sequencia = nr_seq_horario_p;
	end if;

	/* eliminar horários */

	open c01;
	loop
	fetch c01 into
		dt_horario_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (ie_tipo_item_p = 'D') then /* dietas orais*/
			/* inserir horário lista */

			if (coalesce(ds_lista_eliminados_w::text, '') = '') then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			elsif (coalesce(length(ds_lista_eliminados_w),0) <= 240) and (position(dt_horario_w in ds_lista_eliminados_w) = 0) then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			end if;

		elsif (ie_tipo_item_p in ('S','M','MAT')) then /* suplementos orais e medicamentos */
			/* inserir horário lista */

			if (coalesce(ds_lista_eliminados_w::text, '') = '') then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			elsif (coalesce(length(ds_lista_eliminados_w),0) <= 240) and (position(dt_horario_w in ds_lista_eliminados_w) = 0) then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			end if;

		elsif (ie_tipo_item_p in ('P','G','C')) then /* procedimentos e controles de glicemia */
			/* inserir horário lista */

			if (coalesce(ds_lista_eliminados_w::text, '') = '') then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			elsif (coalesce(length(ds_lista_eliminados_w),0) <= 240) and (position(dt_horario_w in ds_lista_eliminados_w) = 0) then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			end if;

		elsif (ie_tipo_item_p = 'R') then /* recomendações */
			/* inserir horário lista */

			if (coalesce(ds_lista_eliminados_w::text, '') = '') then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			elsif (coalesce(length(ds_lista_eliminados_w),0) <= 240) and (position(dt_horario_w in ds_lista_eliminados_w) = 0) then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			end if;

		elsif (ie_tipo_item_p = 'E') then /* sae */
			/* inserir horário lista */

			if (coalesce(ds_lista_eliminados_w::text, '') = '') then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			elsif (coalesce(length(ds_lista_eliminados_w),0) <= 240) and (position(dt_horario_w in ds_lista_eliminados_w) = 0) then
				ds_lista_eliminados_w := ds_lista_eliminados_w || dt_horario_w || ',';
			end if;
		end if;
		end;
	end loop;
	close c01;
end if;

ds_lista_eliminados_p := substr(ds_lista_eliminados_w,1,length(ds_lista_eliminados_w)-1);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_horarios_eliminados (cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, cd_intervalo_p text, ie_laboratorio_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, qt_minutos_p bigint, ds_lista_eliminados_p INOUT text, ie_reaprazar_seguintes_p text, nr_seq_horario_p bigint) FROM PUBLIC;

