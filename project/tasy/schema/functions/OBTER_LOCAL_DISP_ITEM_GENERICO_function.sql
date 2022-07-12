-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_disp_item_generico ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_perfil_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


nr_regras_w			integer;
cd_material_w			integer;
cd_mat_generico_w		integer;
cd_mat_w			integer;
nr_sequencia_w			integer;
cd_local_estoque_w		integer;
cd_local_estoque_prescr_w	integer;
cd_loc_estoque_w		integer;
cd_grupo_material_w		smallint;
cd_subgrupo_w			smallint;
cd_classe_material_w		integer;
cd_setor_atendimento_w		integer;
cd_estabelecimento_w		smallint;
ie_dia_semana_w			varchar(1);
ie_via_aplicacao_w		varchar(10);
dt_liberacao_w			timestamp;
nr_seq_familia_w		bigint;
ie_urgencia_w			varchar(1);
ie_motivo_prescricao_w		varchar(10);
qt_total_dispensar_w		double precision;
ie_padronizado_w		varchar(1);
nr_atendimento_w		bigint;
cd_convenio_w			integer := 0;
ie_tipo_convenio_w		smallint := 0;
ie_feriado_w			varchar(01);
qt_feriado_w			bigint := 0;
ie_acm_sn_w			varchar(1);
ie_controlado_w			varchar(1);
ie_acm_w			varchar(1);
ie_se_necessario_w		varchar(1);
ie_prescr_emergencia_w		varchar(1);
cd_unidade_medida_w		varchar(30);
ie_local_estoque_kit_w		varchar(1);
ie_local_estoque_dil_w		varchar(1);
nr_seq_forma_chegada_w		bigint;
ie_tipo_hemodialise_w		varchar(60);
ie_tipo_atendimento_w		smallint;
nr_ordem_w			smallint;
ie_multidose_w			varchar(1);
cd_material_generico_w		integer;
ie_type_of_prescription_w   regra_local_dispensacao.ie_type_of_prescription%type := '##'; --JRS712
c01 CURSOR FOR
	SELECT	cd_mat_generico
	from (SELECT	cd_material_generico cd_mat_generico,
			1 ie_ordem
		from	material
		where	cd_material = cd_material_w
		
union

		select	cd_material cd_mat_generico,
			2 ie_ordem
		from	material
		where	cd_material_generico = cd_mat_generico_w
		and	cd_material <> cd_material_w
		order by 2 desc) alias0;

c02 CURSOR FOR
	SELECT	cd_local_estoque
	from	regra_local_dispensacao
	where	cd_estabelecimento					= cd_estabelecimento_w
	and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w)	= cd_setor_atendimento_w
	and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_w)		= cd_subgrupo_w
	and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
	and	((coalesce(obter_material_generico(cd_material), cd_mat_w)	= cd_mat_w) or (coalesce(obter_material_generico(cd_material), cd_mat_w)	= obter_material_generico(cd_mat_w)))
	and	coalesce(cd_perfil, cd_perfil_p)				= cd_perfil_p
	and	coalesce(cd_convenio, cd_convenio_w)				= cd_convenio_w
	and	coalesce(ie_motivo_prescricao, coalesce(ie_motivo_prescricao_w,'XPT'))	= coalesce(ie_motivo_prescricao_w,'XPT')
	and	((coalesce(ie_motivo_prescr_exc::text, '') = '') or (ie_motivo_prescr_exc <> ie_motivo_prescricao_w))
	and	coalesce(ie_tipo_convenio, ie_tipo_convenio_w)		= ie_tipo_convenio_w
	and	coalesce(nr_seq_forma_chegada, nr_seq_forma_chegada_w)	= nr_seq_forma_chegada_w
	and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)			= ie_tipo_atendimento_w
        and (coalesce(ie_type_of_prescription, ie_type_of_prescription_w) = ie_type_of_prescription_w OR coalesce(pkg_i18n.get_user_locale, 'pt_BR') <> 'ja_JP')  --JRS712
	and	((coalesce(ie_via_aplicacao::text, '') = '') or (ie_via_aplicacao = ie_via_aplicacao_w))
	and	((coalesce(ie_agora,'N') = ie_urgencia_w) or (coalesce(ie_agora,'N') = 'N'))
	and	((coalesce(ie_multidose,'N') = ie_multidose_w) or (coalesce(ie_multidose,'N') = 'N'))
	and	((coalesce(ie_nao_padronizado,'N') = 'N') or (coalesce(ie_padronizado_w,'S') = 'N'))
	and	((coalesce(ie_controlado,'A') = 'A') or (coalesce(ie_controlado, 'A') = ie_controlado_w))
	and	((coalesce(ie_prescr_emergencia,'N') = 'N') or (coalesce(ie_prescr_emergencia_w,'N') = 'S'))
	and	coalesce(cd_unidade_medida, cd_unidade_medida_w)	= cd_unidade_medida_w
	and	coalesce(ie_saldo_generico,'N') = 'S'
	and	((coalesce(ie_so_com_estoque,'N') = 'S') and (obter_saldo_disp_estoque(cd_estabelecimento_w,cd_mat_w,cd_local_estoque,clock_timestamp()) >= qt_total_dispensar_w))
	and	((coalesce(nr_seq_familia, nr_seq_familia_w)			= nr_seq_familia_w) or (coalesce(nr_seq_familia::text, '') = ''))
	and	((coalesce(ie_dia_semana::text, '') = '') or (ie_dia_semana = ie_dia_semana_w or ie_dia_semana = 9))
	and	obter_se_lib_prescr_horario(dt_hora_inicio, dt_hora_fim, dt_liberacao_w) = 'S'
	and	(((coalesce(ie_feriado,'N') = ie_feriado_w) and (coalesce(ie_feriado,'N') = 'S')) or
		((coalesce(ie_feriado,'N') = 'N') and (qt_feriado_w = 0)))
	and	(((coalesce(ie_somente_acmsn,'N') = 'G') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S') or (ie_urgencia_w = 'S'))) or
		 ((coalesce(ie_somente_acmsn,'N') = 'S') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S'))) or
		 ((coalesce(ie_somente_acmsn,'N') = 'A') and (ie_acm_w = 'S') and (ie_se_necessario_w = 'N')) or
		 ((coalesce(ie_somente_acmsn,'N') = 'C') and (ie_acm_w = 'N') and (ie_se_necessario_w = 'S')) or (coalesce(ie_somente_acmsn,'N') = 'N'))
	and	((coalesce(nr_seq_estrut_int::text, '') = '') or ((nr_seq_estrut_int IS NOT NULL AND nr_seq_estrut_int::text <> '') and consistir_se_mat_estrutura(nr_seq_estrut_int,cd_mat_w) = 'S'))
	and	((coalesce(ie_tipo_hemodialise::text, '') = '') or (ie_tipo_hemodialise = ie_tipo_hemodialise_w))
	and (coalesce(ie_considerar_padrao_est,'N') = 'N' or obter_se_mat_existe_padrao_loc(cd_material_w,cd_local_estoque) = 'S')
	and (coalesce(ie_considerar_generico,'N') = 'N' or obter_se_mat_existe_padrao_loc(cd_mat_w, cd_local_estoque) = 'S')
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
		coalesce(ie_nao_padronizado,'N'),
		coalesce(ie_feriado,'N');


BEGIN

ie_local_estoque_kit_w := obter_param_usuario(924, 673, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_local_estoque_kit_w);
ie_local_estoque_dil_w := obter_param_usuario(924, 741, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_local_estoque_dil_w);

select	a.nr_sequencia,
	a.cd_material,
	obter_material_generico(a.cd_material),
	coalesce(a.ie_urgencia,'N'),
	dividir(a.qt_total_dispensar,b.qt_conv_estoque_consumo),
	substr(obter_se_material_padronizado(k.cd_estabelecimento,a.cd_material),1,1),
	substr(obter_se_medic_controlado(a.cd_material),1,1),
	coalesce(a.ie_acm,'N'),
	coalesce(a.ie_se_necessario,'N'),
	a.cd_unidade_medida_dose,
	a.ie_via_aplicacao,
	b.ie_multidose
into STRICT	nr_sequencia_w,
	cd_material_w,
	cd_mat_generico_w,
	ie_urgencia_w,
	qt_total_dispensar_w,
	ie_padronizado_w,
	ie_controlado_w,
	ie_acm_w,
	ie_se_necessario_w,
	cd_unidade_medida_w,
	ie_via_aplicacao_w,
	ie_multidose_w
from	material b,
	prescr_material a,
	prescr_medica k
where	k.nr_prescricao = nr_prescricao_p
and	a.nr_sequencia = nr_seq_material_p
and	k.nr_prescricao = a.nr_prescricao
and	a.cd_material = b.cd_material;

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
select	cd_setor_atendimento,
	coalesce(cd_estabelecimento,1),
	coalesce(coalesce(dt_liberacao_medico, dt_liberacao), clock_timestamp()),
	coalesce(cd_local_estoque,0),
	coalesce(nr_atendimento,0),
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
where	nr_prescricao = nr_prescricao_p;

select  max(ie_tipo_hemodialise)
into STRICT	ie_tipo_hemodialise_w
from	prescr_solucao a,
	prescr_material b,
	hd_prescricao c
where 	b.nr_sequencia_solucao = a.nr_seq_solucao
and	a.nr_prescricao = b.nr_prescricao
and	a.nr_seq_dialise = c.nr_sequencia
and	b.nr_prescricao = nr_prescricao_p
and 	coalesce(ie_hemodialise,'N') = 'S';

if (nr_atendimento_w > 0) then
	
	select	coalesce(max(ie_tipo_convenio),0),
		coalesce(max(nr_seq_forma_chegada),0),
		coalesce(max(ie_tipo_atendimento),0)
	into STRICT	ie_tipo_convenio_w,
		nr_seq_forma_chegada_w,
		ie_tipo_atendimento_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;

	cd_convenio_w := coalesce(obter_convenio_atendimento(nr_atendimento_w),0);
	
end if;

ie_dia_semana_w := to_char(pkg_date_utils.get_WeekDay(dt_liberacao_w));

select	coalesce(CASE WHEN obter_se_feriado(cd_estabelecimento_w,dt_liberacao_w)=0 THEN 'N'  ELSE 'S' END ,'N')
into STRICT	ie_feriado_w
;

select	count(*)
into STRICT	nr_regras_w
from	regra_local_dispensacao
where	cd_estabelecimento = cd_estabelecimento_w;

if (nr_regras_w > 0) then
	begin
	
	open c01;
	loop
	fetch c01 into
		cd_mat_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		begin
		select	cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material,
			nr_seq_familia
		into STRICT	cd_grupo_material_w,
			cd_subgrupo_w,
			cd_classe_material_w,
			nr_seq_familia_w
		from	estrutura_material_v
		where 	cd_material = cd_mat_w;
		exception
			when others then
				cd_grupo_material_w := 0;
				cd_subgrupo_w := 0;
				cd_classe_material_w := 0;
				nr_seq_familia_w := 0;
		end;

		if (ie_feriado_w = 'S') then
			
			select	count(*)
			into STRICT	qt_feriado_w
			from	regra_local_dispensacao
			where	cd_estabelecimento					= cd_estabelecimento_w
			and	coalesce(cd_setor_atendimento, cd_setor_atendimento_w)	= cd_setor_atendimento_w
			and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
			and	coalesce(cd_subgrupo_material, cd_subgrupo_w)		= cd_subgrupo_w
			and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
			and	coalesce(cd_material, cd_mat_w)				= cd_mat_w
			and	coalesce(cd_perfil, cd_perfil_p)				= cd_perfil_p
			and	coalesce(cd_convenio, cd_convenio_w)				= cd_convenio_w
			and	((coalesce(ie_via_aplicacao::text, '') = '') or (ie_via_aplicacao = ie_via_aplicacao_w))
			and	coalesce(ie_tipo_convenio, ie_tipo_convenio_w)		= ie_tipo_convenio_w	
                        and (coalesce(ie_type_of_prescription, ie_type_of_prescription_w) = ie_type_of_prescription_w OR coalesce(pkg_i18n.get_user_locale, 'pt_BR') <> 'ja_JP')  --JRS712
			and	coalesce(nr_seq_forma_chegada, nr_seq_forma_chegada_w)	= nr_seq_forma_chegada_w				
			and	((coalesce(ie_agora,'N') = ie_urgencia_w) or (coalesce(ie_agora,'N') = 'N'))
			and	coalesce(ie_motivo_prescricao, coalesce(ie_motivo_prescricao_w,'XPT')) = coalesce(ie_motivo_prescricao_w,'XPT')
			and	((coalesce(ie_motivo_prescr_exc::text, '') = '') or (ie_motivo_prescr_exc <> ie_motivo_prescricao_w))
			and	((coalesce(ie_nao_padronizado,'N') = 'N') or (coalesce(ie_padronizado_w,'S') = 'S'))
			and	((coalesce(ie_controlado,'A') = 'A') or (coalesce(ie_controlado, 'A') = ie_controlado_w))
			and	((coalesce(ie_so_com_estoque,'N') = 'N')  or (obter_saldo_disp_estoque(cd_estabelecimento_w,cd_mat_w,cd_local_estoque,clock_timestamp()) >= qt_total_dispensar_w))
			and	((coalesce(nr_seq_familia, nr_seq_familia_w)			= nr_seq_familia_w) or (coalesce(nr_seq_familia::text, '') = ''))
			and	((coalesce(ie_dia_semana::text, '') = '') or (ie_dia_semana = ie_dia_semana_w or ie_dia_semana = 9))
			and	obter_se_lib_prescr_horario(dt_hora_inicio, dt_hora_fim, dt_liberacao_w) = 'S'
			and	coalesce(ie_feriado,'N') = 'S'
			and	(((coalesce(ie_somente_acmsn,'N') = 'G') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S') or (ie_urgencia_w = 'S'))) or
				 ((coalesce(ie_somente_acmsn,'N') = 'S') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S'))) or
				 ((coalesce(ie_somente_acmsn,'N') = 'A') and (ie_acm_w = 'S') and (ie_se_necessario_w = 'N')) or
				 ((coalesce(ie_somente_acmsn,'N') = 'C') and (ie_acm_w = 'N') and (ie_se_necessario_w = 'S')) or (coalesce(ie_somente_acmsn,'N') = 'N'))
			and	((coalesce(nr_seq_estrut_int::text, '') = '') or ((nr_seq_estrut_int IS NOT NULL AND nr_seq_estrut_int::text <> '') and consistir_se_mat_estrutura(nr_seq_estrut_int,cd_mat_w) = 'S'))
			and	((coalesce(ie_tipo_hemodialise::text, '') = '') or (ie_tipo_hemodialise = ie_tipo_hemodialise_w))
			and (coalesce(ie_considerar_generico,'N') = 'N' or obter_se_mat_existe_padrao_loc(cd_mat_w, cd_local_estoque) = 'S');
		end if;
		
		open	c02;
		loop
		fetch	c02 into
			cd_local_estoque_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			cd_local_estoque_w := cd_local_estoque_w;
			end;
		end loop;
		close 	c02;
		
		end;
	end loop;
	close 	c01;

	end;
end if;

return	coalesce(cd_local_estoque_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_disp_item_generico ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;

