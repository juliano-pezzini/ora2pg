-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_leite_deriv_lac ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_paciente_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_item_p protocolo_medic_leite.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_item_gerado_p INOUT bigint, nr_seq_conclusao_apae_p bigint default null, dt_inicio_p timestamp default null, ie_futuro_p text default 'N', nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null, ie_retrogrado_p text default 'N') AS $body$
DECLARE


nr_sequencia_w				cpoe_dieta.nr_sequencia%type;
ie_urgencia_w				cpoe_dieta.ie_urgencia%type;
qt_dose_w					cpoe_dieta.qt_dose_prod1%type;
cd_unidade_medida_w			cpoe_dieta.cd_unid_med_prod1%type;
cd_material_w				cpoe_dieta.cd_mat_prod1%type;
qt_volume_aux_w				cpoe_dieta.qt_volume%type;
nr_seq_solubilidade_w		cpoe_dieta.nr_seq_solubilidade%type;
hr_prim_horario_w			cpoe_dieta.hr_prim_horario%type;
ie_leite_materno_w			cpoe_dieta.ie_leite_materno%type;
ie_administracao_w			cpoe_dieta.ie_administracao%type;
ds_horarios_w				cpoe_dieta.ds_horarios%type;
ds_horarios_ww				cpoe_dieta.ds_horarios%type;
nr_ocorrencia_w				cpoe_dieta.nr_ocorrencia%type;
dt_inicio_w					cpoe_dieta.dt_inicio%type;
qt_volume_w					cpoe_dieta.qt_volume%type;
cd_intervalo_w				cpoe_dieta.cd_intervalo%type;
cd_intervalo_agora_w		cpoe_dieta.cd_intervalo%type;
ie_duracao_w				cpoe_dieta.ie_duracao%type := 'C';
ie_se_necessario_w			nutricao_leite_deriv.ie_se_necessario%type;
nr_seq_leite_deriv_w		nutricao_leite_deriv.nr_sequencia%type;
cd_mat_adic_w				nutricao_leite_deriv_adic.cd_material%type;
cd_unid_med_dose_adic_w		nutricao_leite_deriv_adic.cd_unidade_medida%type;
cd_setor_atendimento_w		setor_atendimento.cd_setor_atendimento%type;
qt_min_intervalo_w			intervalo_prescricao.qt_min_intervalo%type;
ds_sql_w					varchar(4000);
nr_seq_item_gerado_w		varchar(4000);
ds_prescricao_w				varchar(255);
nr_reg_adic_w				bigint;
dt_inicio_base_w			timestamp;
dt_fim_w					timestamp := null;


c01 CURSOR FOR
SELECT	nr_sequencia,
		cd_material,
		cd_unidade_medida,
		ie_se_necessario
from	nutricao_leite_deriv
where	nr_sequencia = nr_seq_item_p
and 	coalesce(ie_situacao,'A') = 'A';

c02 CURSOR FOR
SELECT	cd_material,
		cd_unidade_medida
from	nutricao_leite_deriv_adic
where	nr_seq_produto = nr_seq_leite_deriv_w;

	procedure adicionar_prod_adic_leite(
							nr_seq_dieta_cpoe_p		bigint,
							cd_material_p			bigint,
							qt_dose_p				bigint,
							qt_porcentagem_p		bigint,
							cd_unidade_medida_p		text,
							nr_reg_adic_p			bigint) is
	;
BEGIN
		ds_sql_w := ' update	cpoe_dieta '||
					' set		cd_mat_prod_adic'||nr_reg_adic_p||' = :cd_mat_prod_adic, '||
					' 			qt_porcentagem_adic'||nr_reg_adic_p||' = :qt_porcentagem_adic, '||
					' 			qt_dose_prod_adic'||nr_reg_adic_p||' = :qt_dose_prod_adic, '||
					' 			cd_unid_med_prod_adic'||nr_reg_adic_p||' = :cd_unid_med_prod_adic '||
					' where		nr_sequencia = :nr_seq_item_cpoe ' ||
					' and		nr_atendimento = :nr_atendimento ';
			
		
		EXECUTE ds_sql_w
		using	cd_material_p,
				qt_porcentagem_p,
				qt_dose_p,
				cd_unidade_medida_p,
				nr_seq_dieta_cpoe_p,
				nr_atendimento_p;
	end;

begin
dt_inicio_base_w	:= (trunc(clock_timestamp(),'hh') + 1/24);

open c01;
loop
fetch c01 into	nr_seq_leite_deriv_w,
				cd_material_w,
				cd_unidade_medida_w,
				ie_se_necessario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	hr_prim_horario_w := null;
	cd_intervalo_w	:= null;
	nr_ocorrencia_w := 0;
	ie_administracao_w := 'P';
	if (ie_se_necessario_w = 'S') then
		ie_administracao_w := 'N';
	end if;

	if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
		hr_prim_horario_w	:= coalesce(substr(cpoe_obter_primeiro_horario( nr_atendimento_p, cd_intervalo_w, null, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_paciente_p ),1,5), hr_prim_horario_w);
	end if;

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		cd_setor_atendimento_w	:= obter_setor_atendimento(nr_atendimento_p);
	end if;

	if (coalesce(obter_se_marca_agora(cpoe_obter_setor_atend_prescr(nr_atendimento_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p)),'N') = 'S') then
		cd_intervalo_agora_w := cpoe_busca_intervalo_agora(nr_atendimento_p,'8',cd_estabelecimento_p,cd_perfil_p, nm_usuario_p);

		if (cd_intervalo_agora_w IS NOT NULL AND cd_intervalo_agora_w::text <> '') then
			cd_intervalo_w := cd_intervalo_agora_w;
			ie_urgencia_w  := '0';
			hr_prim_horario_w :=  to_char(clock_timestamp(),'hh24:mi');			
		end if;
		
	end if;	

	select	max(qt_min_intervalo)
	into STRICT	qt_min_intervalo_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_w;

	if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
		dt_inicio_w := to_date(to_char(dt_inicio_base_w,'dd/mm/yyyy') || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi');
	elsif (coalesce(ie_urgencia_w::text, '') = '') then
		dt_inicio_w := dt_inicio_base_w;
		hr_prim_horario_w :=  to_char(dt_inicio_base_w,'hh24:mi');			
	end if;

	if (dt_inicio_w < dt_inicio_base_w) and (coalesce(ie_urgencia_w::text, '') = '') then
		dt_inicio_w := dt_inicio_w + 1;
	end if;
	
	nr_seq_solubilidade_w	:= cpoe_get_default_solubility(cd_material_w);
	ie_leite_materno_w		:= obter_se_mat_leite_mae(cd_material_w);
	
	if (ie_futuro_p = 'S') or (ie_retrogrado_p = 'S') then
		dt_inicio_w := dt_inicio_p;
		dt_fim_w := (dt_inicio_w + 1) - 1/1440;
		ie_duracao_w := 'P';
		ie_urgencia_w := null;
		hr_prim_horario_w :=  to_char(dt_inicio_w,'hh24:mi');	
	end if;
	
	SELECT * FROM cpoe_calcular_horario_prescr(	nr_atendimento_p, cd_intervalo_w, cd_material_w, dt_inicio_w, 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_ww, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_ww;
									
	ds_horarios_w := ds_horarios_w||ds_horarios_ww;
	
	if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
		ds_horarios_w := cpoe_padroniza_horario(ds_horarios_w);
	end if;
	
	select	nextval('cpoe_dieta_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert into cpoe_dieta(
			nr_sequencia,
			nr_atendimento,
			ie_tipo_dieta,
			ie_leite_materno,
			cd_intervalo,
			ie_administracao,
			dt_inicio,
			hr_prim_horario,
			ds_horarios,
			nr_ocorrencia,
			ie_acm,
			ie_se_necessario,
			ie_duracao,
			dt_fim,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_atualizacao_nrec,
			cd_perfil_ativo,
			cd_pessoa_fisica,
			cd_funcao_origem,
			nr_seq_solubilidade,
			cd_mat_prod1,
			qt_dose_prod1,
			cd_unid_med_prod1,
			qt_volume,
			nr_seq_conclusao_apae,
			ie_futuro,
      ie_retrogrado,
			nr_seq_cpoe_order_unit)
		values (
			nr_sequencia_w,
			nr_atendimento_p,
			'L',
			ie_leite_materno_w,
			cd_intervalo_w,
			ie_administracao_w,
			dt_inicio_w,
			hr_prim_horario_w,
			ds_horarios_w,
			nr_ocorrencia_w,
			'N',
			ie_se_necessario_w,
			ie_duracao_w,
			dt_fim_w,
			nm_usuario_p,
			nm_usuario_p,
			clock_timestamp(),
			clock_timestamp(),
			cd_perfil_p,
			cd_paciente_p,
			2314 ,
			nr_seq_solubilidade_w,
			cd_material_w,
			qt_dose_w,
			cd_unidade_medida_w,
			qt_volume_w,
			nr_seq_conclusao_apae_p,
			ie_futuro_p,
      ie_retrogrado_p,
			nr_seq_cpoe_order_unit_p);
			
	nr_reg_adic_w := 1;
	open c02;
	loop
	fetch c02 into cd_mat_adic_w,
	               cd_unid_med_dose_adic_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		adicionar_prod_adic_leite( nr_sequencia_w, cd_mat_adic_w, null, null, cd_unid_med_dose_adic_w, nr_reg_adic_w);
		nr_reg_adic_w := nr_reg_adic_w +1;
		if (nr_reg_adic_w = 5) then
			exit;
		end if;
		end;
	end loop;
	close c02;
	end;
end loop;
close c01;

commit;

nr_seq_item_gerado_p := nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_leite_deriv_lac ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_paciente_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_item_p protocolo_medic_leite.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_item_gerado_p INOUT bigint, nr_seq_conclusao_apae_p bigint default null, dt_inicio_p timestamp default null, ie_futuro_p text default 'N', nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null, ie_retrogrado_p text default 'N') FROM PUBLIC;
