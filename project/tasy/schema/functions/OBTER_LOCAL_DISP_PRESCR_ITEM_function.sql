-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_disp_prescr_item ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_perfil_p bigint, ie_diluente_p text, ie_setor_atendimento_p text, ie_setor_lote_p text, nm_usuario_p text, ie_origem_lote_p text default null) RETURNS bigint AS $body$
DECLARE


nr_regras_w			integer;
cd_material_w			integer;
nr_sequencia_w			integer;
cd_local_estoque_w		integer;
cd_local_estoque_prescr_w	integer;
cd_loc_estoque_w		integer;
cd_grupo_material_w		smallint;
cd_subgrupo_w			smallint;
cd_classe_material_w		integer;
cd_setor_atendimento_w		integer;
cd_setor_atual_w		integer;
cd_estabelecimento_w		smallint;
ie_dia_semana_w			varchar(01);
dt_liberacao_w			timestamp;
nr_seq_familia_w		bigint;
ie_urgencia_w			varchar(1);
ie_motivo_prescricao_w		varchar(10);
qt_total_dispensar_w		double precision;
ie_padronizado_w		varchar(1);
nr_atendimento_w		bigint;
cd_convenio_w			integer;
ie_tipo_convenio_w		smallint;
ie_local_estoque_kit_w		varchar(1);
ie_local_estoque_dil_w		varchar(1);
ie_feriado_w			varchar(01);
qt_feriado_w			bigint := 0;
ie_controlado_w			varchar(1);
ie_acm_sn_w			varchar(1);
ie_acm_w			varchar(1);
ie_se_necessario_w		varchar(1);
cd_unidade_medida_w		varchar(30);
nr_seq_forma_chegada_w		bigint;
nr_seq_kit_w			bigint;
nr_sequencia_diluicao_w		bigint;
ie_tipo_atendimento_w		smallint;
ie_prescr_emergencia_w		varchar(1);
qt_mat_principal_w		integer;
ie_tipo_material_w		varchar(3);
ie_via_aplicacao_w		varchar(10);
ie_multidose_w			varchar(1);
ie_tipo_hemodialise_w		varchar(60);
cd_material_generico_w		integer;
ie_termolabil_w			material.ie_termolabil%type;
ie_setor_old_swisslog_w		varchar(1) := 'N';
ie_setor_new_swisslog_w		varchar(1) := 'N';
ie_gerar_lote_manipulacao_w	material_diluicao.ie_gerar_lote_manipulacao%type;
nr_seq_mat_diluicao_w	prescr_material.nr_seq_mat_diluicao%type;
ie_setor_atual_w		varchar(01);

ie_type_of_prescription_w   regra_local_dispensacao.ie_type_of_prescription%type := '##'; --JRS712
c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_material,
		coalesce(a.ie_urgencia,'N'),
		dividir(a.qt_total_dispensar,b.qt_conv_estoque_consumo),
		substr(obter_se_material_padronizado(k.cd_estabelecimento,a.cd_material),1,1),
		substr(obter_se_medic_controlado(a.cd_material),1,1),
		coalesce(a.ie_acm, 'N'),
		coalesce(a.ie_se_necessario,'N'),
		a.cd_unidade_medida_dose,
		a.nr_seq_kit,
		a.nr_sequencia_diluicao,
		b.ie_tipo_material,
		a.ie_via_aplicacao,
		b.ie_multidose,
		b.cd_material_generico,
		b.ie_termolabil
	from	material b,
		prescr_material a,
		prescr_medica k
	where	k.nr_prescricao		= nr_prescricao_p
	and	((coalesce(nr_seq_material_p,0) = 0) or (a.nr_sequencia	   = nr_seq_material_p) or
		 (a.nr_sequencia_diluicao  = nr_seq_material_p AND ie_diluente_p	= 'S'))
	and	k.nr_prescricao		= a.nr_prescricao
	and	a.cd_material		= b.cd_material;

c02 CURSOR FOR
	SELECT	cd_local_estoque
	from	regra_local_dispensacao
	where	cd_estabelecimento					= cd_estabelecimento_w
	and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w)	= cd_setor_atendimento_w
	and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_w)		= cd_subgrupo_w
	and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
	and	coalesce(cd_material, cd_material_w)				= cd_material_w
	and	coalesce(cd_perfil, cd_perfil_p)				= cd_perfil_p
	and	coalesce(cd_convenio, cd_convenio_w)				= cd_convenio_w
	and	coalesce(ie_motivo_prescricao, coalesce(ie_motivo_prescricao_w,'XPT'))	= coalesce(ie_motivo_prescricao_w,'XPT')
	and	((coalesce(ie_motivo_prescr_exc::text, '') = '') or (ie_motivo_prescr_exc <> ie_motivo_prescricao_w))
	and	coalesce(ie_tipo_convenio, ie_tipo_convenio_w)		= ie_tipo_convenio_w
	and	coalesce(nr_seq_forma_chegada, nr_seq_forma_chegada_w)	= nr_seq_forma_chegada_w
	and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)			= ie_tipo_atendimento_w
	and	coalesce(ie_tipo_material,ie_tipo_material_w) = ie_tipo_material_w
	and	((coalesce(ie_via_aplicacao::text, '') = '') or (ie_via_aplicacao = ie_via_aplicacao_w))
	and (coalesce(ie_type_of_prescription, ie_type_of_prescription_w) = ie_type_of_prescription_w OR coalesce(pkg_i18n.get_user_locale, 'pt_BR') <> 'ja_JP')  --JRS712
	and	((coalesce(ie_agora,'N') = ie_urgencia_w) or (coalesce(ie_agora,'N') = 'N'))
	and	((coalesce(ie_multidose,'N') = ie_multidose_w) or (coalesce(ie_multidose,'N') = 'N'))
	and	((coalesce(ie_nao_padronizado,'N') = 'N') or (coalesce(ie_padronizado_w,'S') = 'N'))
	and	((coalesce(ie_controlado,'A') = 'A') or (coalesce(ie_controlado, 'A') = ie_controlado_w))
	and	((coalesce(ie_prescr_emergencia,'N') = 'N') or (coalesce(ie_prescr_emergencia_w,'N') = 'S'))
	and	coalesce(cd_unidade_medida, cd_unidade_medida_w)	= cd_unidade_medida_w
	and	((coalesce(ie_so_com_estoque,'N') = 'N')  or (obter_saldo_disp_estoque(cd_estabelecimento_w,cd_material_w,cd_local_estoque,clock_timestamp()) >= qt_total_dispensar_w))
	and	((coalesce(nr_seq_familia, nr_seq_familia_w)			= nr_seq_familia_w) or (coalesce(nr_seq_familia::text, '') = ''))
	and	((coalesce(ie_dia_semana::text, '') = '') or (ie_dia_semana = ie_dia_semana_w or ie_dia_semana = 9))
	and	obter_se_lib_prescr_horario(dt_hora_inicio, dt_hora_fim, dt_liberacao_w) = 'S'
	and	(((coalesce(ie_feriado,'N') = ie_feriado_w) and (coalesce(ie_feriado,'N') = 'S')) or
		((coalesce(ie_feriado,'N') = 'N') and (qt_feriado_w = 0)))
	and	(((coalesce(ie_somente_acmsn,'N') = 'G') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S') or (ie_urgencia_w = 'S'))) or
		 ((coalesce(ie_somente_acmsn,'N') = 'S') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S'))) or
		 ((coalesce(ie_somente_acmsn,'N') = 'A') and (ie_acm_w = 'S') and (ie_se_necessario_w = 'N')) or
		 ((coalesce(ie_somente_acmsn,'N') = 'C') and (ie_acm_w = 'N') and (ie_se_necessario_w = 'S')) or (coalesce(ie_somente_acmsn,'N') = 'N'))
	and	((coalesce(nr_seq_estrut_int::text, '') = '') or ((nr_seq_estrut_int IS NOT NULL AND nr_seq_estrut_int::text <> '') and consistir_se_mat_contr_estrut(nr_seq_estrut_int,cd_material_w) = 'S'))
	and	((coalesce(ie_tipo_hemodialise::text, '') = '') or (ie_tipo_hemodialise = ie_tipo_hemodialise_w))
	and	(( coalesce(ie_considerar_padrao_est,'N') = 'N' or (obter_se_mat_existe_padrao_loc(cd_material_w,cd_local_estoque) = 'S' or (coalesce(ie_considerar_controlador,'N') = 'S' and obter_se_mat_existe_padrao_loc((SELECT x.cd_material_estoque from material x where x.cd_material = cd_material_w), cd_local_estoque) = 'S') or
		(coalesce(ie_considerar_generico,'N') = 'S'
		and ((coalesce(ie_considerar_generico_assosc,'N') = 'S' and obter_associados_generico(cd_material_generico_w, cd_local_estoque) = 'S') or (coalesce(ie_considerar_generico_assosc,'N') = 'N' and obter_se_mat_existe_padrao_loc(cd_material_generico_w, cd_local_estoque) = 'S'))))))
	and (coalesce(ie_medic_termolabil,'N') = 'N' or (coalesce(ie_medic_termolabil,'N') = 'S' and ie_termolabil_w = 'S'))
	and 	((coalesce(ie_medic_alto_custo,'N') = 'N') or obter_se_mat_alto_custo(cd_material_w, cd_estabelecimento_w) = 'S')
	and	((coalesce(ie_gerar_lote_manipulacao, 'A') = 'A') or (coalesce(ie_gerar_lote_manipulacao,'S') = coalesce(ie_gerar_lote_manipulacao_w, 'S')))
	order by coalesce(nr_seq_prioridade,999) desc,
		coalesce(cd_perfil,0),
		coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(nr_seq_familia,0),
		coalesce(ie_via_aplicacao,'A'),
		coalesce(cd_setor_atendimento,0),
		coalesce(ie_agora,'N'),
		coalesce(ie_feriado,'N');

c03 CURSOR FOR
	SELECT	cd_local_estoque
	from	regra_local_dispensacao
	where	cd_estabelecimento					= cd_estabelecimento_w
	and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w)	= cd_setor_atendimento_w
	and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_w)		= cd_subgrupo_w
	and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
	and	coalesce(cd_material, cd_material_w)				= cd_material_w
	and	coalesce(cd_perfil, cd_perfil_p)				= cd_perfil_p
	and	coalesce(cd_convenio, cd_convenio_w)				= cd_convenio_w
	and	coalesce(ie_motivo_prescricao, ie_motivo_prescricao_w, 'XPT')	= coalesce(ie_motivo_prescricao_w,'XPT')
	and	((coalesce(ie_motivo_prescr_exc::text, '') = '') or (ie_motivo_prescr_exc <> ie_motivo_prescricao_w))
	and	coalesce(ie_tipo_convenio, ie_tipo_convenio_w)		= ie_tipo_convenio_w
	and (coalesce(ie_type_of_prescription, ie_type_of_prescription_w) = ie_type_of_prescription_w OR coalesce(pkg_i18n.get_user_locale, 'pt_BR') <> 'ja_JP')  --JRS712
	and	coalesce(nr_seq_forma_chegada, nr_seq_forma_chegada_w)	= nr_seq_forma_chegada_w
	and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)			= ie_tipo_atendimento_w
	and	((coalesce(ie_via_aplicacao::text, '') = '') or (ie_via_aplicacao = ie_via_aplicacao_w))
	and	((coalesce(ie_agora,'N') = ie_urgencia_w) or (coalesce(ie_agora,'N') = 'N'))
	and	((coalesce(ie_multidose,'N') = ie_multidose_w) or (coalesce(ie_multidose,'N') = 'N'))
	and	((coalesce(ie_nao_padronizado,'N') = 'N') or (coalesce(ie_padronizado_w,'S') = 'N'))
	and	coalesce(ie_saldo_generico,'N') = 'S'
	and	((coalesce(ie_controlado,'A') = 'A') or (coalesce(ie_controlado, 'A') = ie_controlado_w))
	and	((coalesce(ie_prescr_emergencia,'N') = 'N') or (coalesce(ie_prescr_emergencia_w,'N') = 'S'))
	and	coalesce(cd_unidade_medida, cd_unidade_medida_w)	= cd_unidade_medida_w
	and	((coalesce(ie_so_com_estoque,'N') = 'S')  and (obter_saldo_disp_estoque(cd_estabelecimento_w,cd_material_w,cd_local_estoque,clock_timestamp()) >= qt_total_dispensar_w))
	and	((coalesce(nr_seq_familia, nr_seq_familia_w)			= nr_seq_familia_w) or (coalesce(nr_seq_familia::text, '') = ''))
	and	((coalesce(ie_dia_semana::text, '') = '') or (ie_dia_semana = ie_dia_semana_w or ie_dia_semana = 9))
	and	obter_se_lib_prescr_horario(dt_hora_inicio, dt_hora_fim, dt_liberacao_w) = 'S'
	and	(((coalesce(ie_feriado,'N') = ie_feriado_w) and (coalesce(ie_feriado,'N') = 'S')) or
		((coalesce(ie_feriado,'N') = 'N') and (qt_feriado_w = 0)))
	and	(((coalesce(ie_somente_acmsn,'N') = 'G') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S') or (ie_urgencia_w = 'S'))) or
		 ((coalesce(ie_somente_acmsn,'N') = 'S') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S'))) or
		 ((coalesce(ie_somente_acmsn,'N') = 'A') and (ie_acm_w = 'S') and (ie_se_necessario_w = 'N')) or
		 ((coalesce(ie_somente_acmsn,'N') = 'C') and (ie_acm_w = 'N') and (ie_se_necessario_w = 'S')) or (coalesce(ie_somente_acmsn,'N') = 'N'))
	and	((coalesce(nr_seq_estrut_int::text, '') = '') or ((nr_seq_estrut_int IS NOT NULL AND nr_seq_estrut_int::text <> '') and consistir_se_mat_contr_estrut(nr_seq_estrut_int,cd_material_w) = 'S'))
	and	((coalesce(ie_tipo_hemodialise::text, '') = '') or (ie_tipo_hemodialise = ie_tipo_hemodialise_w))
	and (coalesce(ie_considerar_padrao_est,'N') = 'N' or obter_se_mat_existe_padrao_loc(cd_material_w,cd_local_estoque) = 'S')
	and (coalesce(ie_considerar_generico,'N') = 'N' or obter_se_mat_existe_padrao_loc((SELECT x.cd_material_generico from material x where x.cd_material = cd_material_w), cd_local_estoque) = 'S')
	and (coalesce(ie_medic_termolabil,'N') = 'N' or (coalesce(ie_medic_termolabil,'N') = 'S' and ie_termolabil_w = 'S'))
	and 	((coalesce(ie_medic_alto_custo,'N') = 'N') or obter_se_mat_alto_custo(cd_material_w, cd_estabelecimento_w) = 'S')
	order by coalesce(nr_seq_prioridade,999) desc,
		coalesce(cd_perfil,0),
		coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(nr_seq_familia,0),
		coalesce(ie_via_aplicacao,'A'),
		coalesce(cd_setor_atendimento,0),
		coalesce(ie_agora,'N'),
		coalesce(ie_feriado,'N');


BEGIN

select	cd_setor_atendimento,
	coalesce(cd_estabelecimento, 1),
	coalesce(coalesce(dt_liberacao_medico, dt_liberacao), clock_timestamp()),
	coalesce(cd_local_estoque, 0),
	coalesce(nr_atendimento, 0),
	ie_motivo_prescricao,
	ie_prescr_emergencia
into STRICT	cd_setor_atendimento_w,
	cd_estabelecimento_w,
	dt_liberacao_w,
	cd_local_estoque_prescr_w,
	nr_atendimento_w,
	ie_motivo_prescricao_w,
	ie_prescr_emergencia_w
from	prescr_medica
where	nr_prescricao		= nr_prescricao_p;

ie_setor_atual_w := obter_Param_Usuario(924, 799, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_setor_atual_w);

if (ie_setor_atual_w = 'S') then
	cd_local_estoque_prescr_w	:= null;
	cd_setor_atendimento_w		:= obter_setor_atendimento(nr_atendimento_w);
elsif (ie_setor_atual_w = 'R') then
	cd_local_estoque_prescr_w	:= null;
	cd_setor_atendimento_w		:= Obter_Setor_Atendimento_lib(nr_atendimento_w);
elsif (ie_setor_atual_w = 'I') then
	cd_local_estoque_prescr_w := null;
	cd_setor_atendimento_w := obter_setor_atepacu(obter_atepacu_paciente(nr_atendimento_w,'IA'),0);
elsif (ie_setor_atual_w = 'N') and (ie_setor_atendimento_p = 'S') and (ie_setor_lote_p = 'S') and (nr_atendimento_w > 0) then
	cd_local_estoque_prescr_w	:= null;
	cd_setor_atendimento_w		:= obter_setor_atendimento(nr_atendimento_w);
end if;

ie_local_estoque_kit_w := obter_param_usuario(924, 673, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_local_estoque_kit_w);
ie_local_estoque_dil_w := obter_param_usuario(924, 741, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_local_estoque_dil_w);

if (nr_atendimento_w > 0) then
	select	coalesce(max(ie_tipo_convenio), 0),
		coalesce(max(nr_seq_forma_chegada), 0),
		coalesce(max(ie_tipo_atendimento),0)
	into STRICT	ie_tipo_convenio_w,
		nr_seq_forma_chegada_w,
		ie_tipo_atendimento_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;

	if (ie_tipo_convenio_w = 0) then
		ie_tipo_convenio_w	:= null;
	end if;

	cd_convenio_w	:= obter_convenio_atendimento(nr_atendimento_w);
end if;

ie_dia_semana_w := to_char(pkg_date_utils.get_WeekDay(dt_liberacao_w));

select	coalesce(CASE WHEN obter_se_feriado(cd_estabelecimento_w, dt_liberacao_w)=0 THEN 'N'  ELSE 'S' END ,'N')
into STRICT	ie_feriado_w
;

begin
select	max(cd_local_estoque)
into STRICT	cd_loc_estoque_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_w;
exception
when others then
	cd_loc_estoque_w := null;
end;

select	count(*)
into STRICT	nr_regras_w
from	regra_local_dispensacao
where	cd_estabelecimento = cd_estabelecimento_w;

if (nr_regras_w	> 0) then
	begin
	select	max(ie_tipo_hemodialise)
	into STRICT	ie_tipo_hemodialise_w
	from	prescr_solucao a,
		prescr_material b,
		hd_prescricao c
	where	b.nr_sequencia_solucao = a.nr_seq_solucao
	and	a.nr_prescricao = b.nr_prescricao
	and	a.nr_seq_dialise = c.nr_sequencia
	and	b.nr_prescricao = nr_prescricao_p
	and	coalesce(ie_hemodialise,'N') = 'S';

	open c01;
	loop
	fetch c01 into
		nr_sequencia_w,
		cd_material_w,
		ie_urgencia_w,
		qt_total_dispensar_w,
		ie_padronizado_w,
		ie_controlado_w,
		ie_acm_w,
		ie_se_necessario_w,
		cd_unidade_medida_w,
		nr_seq_kit_w,
		nr_sequencia_diluicao_w,
		ie_tipo_material_w,
		ie_via_aplicacao_w,
		ie_multidose_w,
		cd_material_generico_w,
		ie_termolabil_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
        --JRS712 starts
        ie_type_of_prescription_w := '##';
        begin
          select coalesce(c.SI_TYPE_OF_PRESCRIPTION,'##') into STRICT ie_type_of_prescription_w
          from prescr_material a, cpoe_material b, cpoe_order_unit c 
            where b.NR_SEQ_CPOE_ORDER_UNIT = c.nr_sequencia 
              and b.nr_sequencia = a.nr_seq_mat_cpoe
              and a.nr_sequencia = nr_sequencia_w
              and a.nr_prescricao = nr_prescricao_p;
        exception
          when others then
            ie_type_of_prescription_w := '##';
        end;
        --JRS712 ends
		begin

		select	max(ie_gerar_lote_manipulacao)
		into STRICT	ie_gerar_lote_manipulacao_w
		from	material_diluicao b
		where	exists (
			SELECT	1
			from	prescr_material x
			where	x.nr_prescricao = nr_prescricao_p
			and		x.nr_sequencia_diluicao = nr_sequencia_w
			and		x.nr_seq_mat_diluicao = b.nr_sequencia);


		cd_local_estoque_w := 0;

		select	cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material,
			nr_seq_familia
		into STRICT	cd_grupo_material_w,
			cd_subgrupo_w,
			cd_classe_material_w,
			nr_seq_familia_w
		from	estrutura_material_v
		where 	cd_material = cd_material_w;

		if (ie_feriado_w = 'S') then
			/*anderson em 20/05/2009 - os142384 */

			select	count(*)
			into STRICT	qt_feriado_w
			from	regra_local_dispensacao
			where	cd_estabelecimento					= cd_estabelecimento_w
			and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))= coalesce(cd_setor_atendimento_w,0)
			and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
			and	coalesce(cd_subgrupo_material, cd_subgrupo_w)		= cd_subgrupo_w
			and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
			and	coalesce(cd_material, cd_material_w)				= cd_material_w
			and	coalesce(cd_perfil, cd_perfil_p)				= cd_perfil_p
			and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))			= coalesce(cd_convenio_w,0)
			and	coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0))	= coalesce(ie_tipo_convenio_w,0)
			and (coalesce(ie_type_of_prescription, ie_type_of_prescription_w) = ie_type_of_prescription_w OR coalesce(pkg_i18n.get_user_locale, 'pt_BR') <> 'ja_JP')  --JRS712
			and	coalesce(nr_seq_forma_chegada, nr_seq_forma_chegada_w)	= nr_seq_forma_chegada_w
			and	((coalesce(ie_agora,'N') = ie_urgencia_w) or (coalesce(ie_agora,'N') = 'N'))
			and	((coalesce(ie_nao_padronizado,'N') = 'N') or (coalesce(ie_padronizado_w,'S') = 'N'))
			and	coalesce(ie_motivo_prescricao, coalesce(ie_motivo_prescricao_w,'XPT'))	= coalesce(ie_motivo_prescricao_w,'XPT')
			and	((coalesce(ie_motivo_prescr_exc::text, '') = '') or (ie_motivo_prescr_exc <> ie_motivo_prescricao_w))
			and	((coalesce(ie_controlado,'A') = 'A') or (coalesce(ie_controlado, 'A') = ie_controlado_w))
			and	coalesce(cd_unidade_medida, cd_unidade_medida_w)	= cd_unidade_medida_w
			and	((coalesce(ie_so_com_estoque,'N') = 'N')  or (obter_saldo_disp_estoque(cd_estabelecimento_w,cd_material_w,cd_local_estoque,clock_timestamp()) >= qt_total_dispensar_w))
			and	((coalesce(nr_seq_familia, nr_seq_familia_w)			= nr_seq_familia_w) or (coalesce(nr_seq_familia::text, '') = ''))
			and	((coalesce(ie_dia_semana::text, '') = '') or (ie_dia_semana = ie_dia_semana_w or ie_dia_semana = 9))
			/*and	((dt_hora_inicio is null) or
				 (to_char(dt_hora_inicio,'hh24:mi:ss') < to_char(dt_liberacao_w,'hh24:mi:ss')))
			and	((dt_hora_fim is null) or
				 (to_char(dt_hora_fim,'hh24:mi:ss') > to_char(dt_liberacao_w,'hh24:mi:ss')))*/
			and	obter_se_lib_prescr_horario(dt_hora_inicio, dt_hora_fim, dt_liberacao_w) = 'S'
			and	coalesce(ie_feriado,'N') = 'S'
			/*and	nvl(ie_somente_acmsn,'N') = ie_acm_sn_w*/

			and	(((coalesce(ie_somente_acmsn,'N') = 'G') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S') or (ie_urgencia_w = 'S'))) or
				 ((coalesce(ie_somente_acmsn,'N') = 'S') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S'))) or
				 ((coalesce(ie_somente_acmsn,'N') = 'A') and (ie_acm_w = 'S') and (ie_se_necessario_w = 'N')) or
				 ((coalesce(ie_somente_acmsn,'N') = 'C') and (ie_acm_w = 'N') and (ie_se_necessario_w = 'S')) or (coalesce(ie_somente_acmsn,'N') = 'N'))
			and	((coalesce(nr_seq_estrut_int::text, '') = '') or ((nr_seq_estrut_int IS NOT NULL AND nr_seq_estrut_int::text <> '') and consistir_se_mat_estrutura(nr_seq_estrut_int,cd_material_w) = 'S'))
			and 	((coalesce(ie_medic_alto_custo,'N') = 'N') or obter_se_mat_alto_custo(cd_material_w, cd_estabelecimento_w) = 'S');
		end if;

		select	count(*)
		into STRICT	nr_regras_w
		from	regra_local_dispensacao
		where	cd_estabelecimento = cd_estabelecimento_w
		and	coalesce(ie_so_com_estoque,'N') = 'S'
		and	coalesce(ie_saldo_generico,'N') = 'S';

		if (nr_regras_w > 0) then

			open c03;
			loop
			fetch c03 into
				cd_local_estoque_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin

				cd_local_estoque_w := cd_local_estoque_w;

				end;
			end loop;
			close c03;

			select	count(*)
			into STRICT	qt_mat_principal_w
			from	prescr_material
			where	nr_prescricao = nr_prescricao_p
			and	nr_sequencia = nr_sequencia_w
			and	coalesce(nr_sequencia_diluicao::text, '') = ''
			and	coalesce(nr_seq_kit::text, '') = '';

			if (qt_mat_principal_w > 0) and (coalesce(cd_local_estoque_w,0) = 0) then
				cd_local_estoque_w := obter_local_disp_item_generico(nr_prescricao_p,nr_sequencia_w,cd_perfil_p,nm_usuario_p);
			end if;

		end if;

		if (coalesce(cd_local_estoque_w,0) = 0) then

			open	c02;
			loop
			fetch	c02 into
				cd_local_estoque_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */

				cd_local_estoque_w	:= cd_local_estoque_w;

			end loop;
			close 	c02;

		end if;

		if (coalesce(cd_local_estoque_w,0) = 0) then
			cd_local_estoque_w := cd_loc_estoque_w;
		end if;

		if (ie_local_estoque_dil_w = 'S') and (coalesce(nr_sequencia_diluicao_w,0) > 0) then
			select	max(cd_local_estoque)
			into STRICT	cd_local_estoque_w
			from	prescr_material
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia  	= nr_sequencia_diluicao_w;
		end if;

		if (ie_local_estoque_kit_w = 'S') and (coalesce(nr_seq_kit_w,0) > 0) then
			select	max(cd_local_estoque)
			into STRICT	cd_local_estoque_w
			from	prescr_material
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia  	= nr_seq_kit_w;
		end if;

		end;
	end loop;
	close 	c01;
	end;
end if;

if (coalesce(cd_local_estoque_w,0) = 0) then
	cd_local_estoque_w := cd_loc_estoque_w;
end if;

return cd_local_estoque_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_disp_prescr_item ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_perfil_p bigint, ie_diluente_p text, ie_setor_atendimento_p text, ie_setor_lote_p text, nm_usuario_p text, ie_origem_lote_p text default null) FROM PUBLIC;

