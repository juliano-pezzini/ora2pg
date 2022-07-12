-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_material_insert ON prescr_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_material_insert() RETURNS trigger AS $BODY$
DECLARE
	
qt_min_aplicacao_w		bigint;
qt_hora_aplicacao_w			smallint;
ie_lib_auto_w				varchar(1);
ie_medic_paciente_w			varchar(1);
ie_alto_risco_w				varchar(1);
dt_liberacao_w				timestamp;
ds_origem_w					varchar(1800);
ds_module_log_w				varchar(255);
ie_log_incl_excl_w			varchar(01) := 'N';
nr_atendimento_w			bigint;
cd_setor_atend_w			integer;
dt_entrada_unid_w			timestamp;
nr_cirurgia_w				bigint;
hr_prim_hor_prescr_w		varchar(5);
hr_prim_hor_medic_w			varchar(5);
qt_dias_lib_padrao_w		integer;
ie_adiciona_dia_w			varchar(1);
ie_tipo_item_w				varchar(20);
cd_unidade_medida_consumo_w	varchar(30);
cd_pessoa_fisica_w			varchar(10);
cd_funcao_ativa_w			integer;
ie_gera_lote_pac_w			varchar(1);
ie_padronizado_w			varchar(1);
qt_dia_terapeutico_w		material.qt_dia_terapeutico%type;
qt_dia_profilatico_w		material.qt_dia_profilatico%type;
cd_funcao_origem_w			funcao.cd_funcao%type;
cd_setor_atendimento_w		prescr_medica.cd_setor_atendimento%type;
qt_count_dose_cpoe_w		bigint;
ds_stack_w					varchar(2000);
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
BEGIN

BEGIN

if (NEW.nr_seq_mat_cpoe is not null) then

	select	count(*)
	into STRICT	qt_count_dose_cpoe_w
	from	cpoe_material a
	where	a.nr_sequencia = NEW.nr_seq_mat_cpoe
	and		((NEW.cd_material = a.cd_material and NEW.qt_dose <> a.qt_dose)
			or (NEW.cd_material = a.cd_mat_comp1 and NEW.qt_dose <> a.qt_dose_comp1)
			or (NEW.cd_material = a.cd_mat_comp2 and NEW.qt_dose <> a.qt_dose_comp2)
			or (NEW.cd_material = a.cd_mat_comp3 and NEW.qt_dose <> a.qt_dose_comp3)
			or (NEW.cd_material = a.cd_mat_dil and NEW.qt_dose <> a.qt_dose_dil)
			or (NEW.cd_material = a.cd_mat_red and NEW.qt_dose <> a.qt_dose_red));

	if (qt_count_dose_cpoe_w > 0) then
		
		ds_stack_w	:= substr(dbms_utility.format_call_stack,1,2000);
			
		CALL gravar_log_tasy(10007,
					' DOSE ALTERADA_NA REP '|| ds_stack_w
					|| ' nr_sequencia: '|| NEW.nr_sequencia
					|| ' :new.nr_prescricao: '||NEW.nr_prescricao
					|| ' :new.nr_seq_mat_cpoe: '||NEW.nr_seq_mat_cpoe
					|| ' :new.cd_material: '||NEW.cd_material
					|| ' :new.qt_dose: '||NEW.qt_dose,
					NEW.nm_usuario);
	end if;
	
end if;


ie_medic_paciente_w	:= coalesce(obter_valor_param_usuario(-124, 25, obter_perfil_ativo, NEW.nm_usuario, 0),'S');
ie_gera_lote_pac_w	:= coalesce(obter_valor_param_usuario(924, 389, obter_perfil_ativo, NEW.nm_usuario, 0),'S');
exception
when others then
	ie_log_incl_excl_w	:= 'N';
	ie_gera_lote_pac_w	:= 'N';
end;

cd_funcao_ativa_w	:= obter_funcao_ativa;

if (ie_medic_paciente_w = 'N') then
	NEW.ie_medicacao_paciente := 'N';
end if;

if (coalesce(NEW.qt_material,0) > coalesce(NEW.qt_original,0)) then
	NEW.qt_original := NEW.qt_material;
end if;

select	max(dt_liberacao),
	max(to_char(dt_primeiro_horario,'hh24:mi')),
	max(nr_atendimento),
	max(cd_pessoa_fisica),
	max(cd_setor_atendimento)
into STRICT	dt_liberacao_w,
	hr_prim_hor_prescr_w,
	nr_atendimento_w,
	cd_pessoa_fisica_w,
	cd_setor_atendimento_w
from	prescr_medica
where	nr_prescricao	= NEW.nr_prescricao;

cd_funcao_origem_w	:= Obter_dados_prescricao(NEW.nr_prescricao, 'CFO');

if (NEW.nr_seq_interno is null) then
	select	nextval('prescr_material_seq')
	into STRICT	NEW.nr_seq_interno
	;
end if;

if (NEW.cd_intervalo is not null) and (cd_funcao_origem_w <> 2314) then
	BEGIN
	hr_prim_hor_medic_w	:= obter_primeiro_horario(NEW.cd_intervalo, NEW.nr_prescricao, NEW.cd_material, NEW.ie_via_aplicacao);
	
	if (NEW.qt_dia_prim_hor = 1) and (hr_prim_hor_medic_w >= hr_prim_hor_prescr_w ) then
		BEGIN
		NEW.qt_dia_prim_hor := 0;
		end;
	end if;
	
	end;
end if;

select	coalesce(max(ie_alto_risco),'N'),
		coalesce(max(obter_dados_material_estab(cd_material,wheb_usuario_pck.get_cd_estabelecimento,'UMS')),NEW.cd_unidade_medida),
		coalesce(max(qt_min_aplicacao),0),
		coalesce(max(qt_dia_terapeutico),0),
		coalesce(max(qt_dia_profilatico),0),
		coalesce(max(obter_se_material_padronizado(wheb_usuario_pck.get_cd_estabelecimento,cd_material)),'N')
into STRICT	ie_alto_risco_w,
		cd_unidade_medida_consumo_w,
		qt_min_aplicacao_w,
		qt_dia_terapeutico_w,
		qt_dia_profilatico_w,
		ie_padronizado_w
from	material
where	cd_material	= NEW.cd_material;

if (NEW.qt_atendido is null) then
	NEW.qt_atendido := 0;
end if;	

if (NEW.qt_min_aplicacao is null) and (NEW.qt_hora_aplicacao is null) and (NEW.ie_agrupador = 1) then
	
	if (qt_min_aplicacao_w > 0) then
		if (qt_min_aplicacao_w < 60) then
			NEW.qt_min_aplicacao	:= qt_min_aplicacao_w;
		elsif (qt_min_aplicacao_w = 60) then
			NEW.qt_hora_aplicacao	:= 1;
		else
			NEW.qt_hora_aplicacao	:= trunc(dividir(qt_min_aplicacao_w,60));		
			NEW.qt_min_aplicacao	:= (qt_min_aplicacao_w - (NEW.qt_hora_aplicacao * 60));
		if (NEW.qt_min_aplicacao = 0) then
			NEW.qt_min_aplicacao	:= null;
		end if;
		end if;
	end if;
end if;

NEW.cd_unidade_medida	:= cd_unidade_medida_consumo_w;

NEW.ie_alto_risco	:= ie_alto_risco_w;

ie_lib_auto_w	:= Obter_se_lib_aut_antimic(NEW.cd_material, obter_perfil_ativo, wheb_usuario_pck.get_cd_estabelecimento, NEW.nm_usuario, NEW.cd_intervalo, cd_setor_atendimento_w, NEW.ie_objetivo);

if (ie_lib_auto_w = 'S') then
	select	coalesce(max(qt_dias_lib_padrao),0)
	into STRICT	qt_dias_lib_padrao_w
	from	parametro_medico
	where   cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
		
	if (qt_dias_lib_padrao_w > 0) then
		if (NEW.ie_objetivo	in ('F','P','C')) and (qt_dia_profilatico_w	> 0) and (qt_dias_lib_padrao_w	> qt_dia_profilatico_w) then
			NEW.qt_dias_liberado	:= qt_dia_profilatico_w;			
		elsif (NEW.ie_objetivo	in ('T','D','E')) and (qt_dia_terapeutico_w	> 0) and (qt_dias_lib_padrao_w	> qt_dia_terapeutico_w) then
			NEW.qt_dias_liberado	:= qt_dia_terapeutico_w;			 			
		else	
			if (coalesce(NEW.qt_total_dias_lib,0) < qt_dias_lib_padrao_w) then
				NEW.qt_dias_liberado	:= qt_dias_lib_padrao_w;
			end if;
		end if;
	else
		NEW.qt_dias_liberado	:= NEW.qt_dias_solicitado;		
	end if;
	
	if (NEW.qt_total_dias_lib is null) then
		NEW.qt_total_dias_lib	:= NEW.qt_dias_liberado;
	elsif (qt_dias_lib_padrao_w = 0) then
		NEW.qt_total_dias_lib	:= NEW.qt_total_dias_lib + coalesce(NEW.qt_dias_solicitado,0);
	end if;
	
	if (NEW.qt_total_dias_lib = 0) then
		NEW.qt_total_dias_lib := null;
	end if;
	
	if (NEW.qt_dias_liberado = 0) then
		NEW.qt_dias_liberado	:= null;
	end if;
	
	if (cd_funcao_origem_w = 2314) and (NEW.qt_dias_liberado is not null) then
		CALL cpoe_atualizar_dias_liberados(NEW.nm_usuario, NEW.nr_seq_mat_cpoe, NEW.nr_prescricao, NEW.qt_dias_liberado, NEW.dt_inicio_medic);
	end if;	
	
	if (cd_funcao_origem_w = 2314) and (coalesce(ie_padronizado_w,'N') = 'N') and (NEW.qt_total_dias_lib is not null) then
		CALL cpoe_update_nao_padronizados(NEW.nm_usuario, NEW.nr_seq_mat_cpoe, NEW.nr_prescricao, NEW.qt_total_dias_lib);
	end if;	
end if;

/* Virgilio 12/01/2009 OS123312 */


if (ie_gera_lote_pac_w = 'N') and (coalesce(NEW.ie_medicacao_paciente,'N') = 'S') then
	NEW.ie_regra_disp := 'N';
end if;

if	((cd_funcao_ativa_w = 900) or (cd_funcao_ativa_w = -2009)) then
	BEGIN
	
	ie_log_incl_excl_w	:= coalesce(obter_valor_param_usuario(900, 205, obter_perfil_ativo, NEW.nm_usuario, 0),'N');
	if (ie_log_incl_excl_w = 'S')  then
	
		select	substr(max(module||' - ' || machine||' - ' || program|| ' - ' || osuser|| ' - ' || terminal),1,255)			
		into STRICT	ds_module_log_w		
		from	v$session
		where	audsid = (SELECT userenv('sessionid') );
		
		select	max(nr_cirurgia)
		into STRICT	nr_cirurgia_w
		from	cirurgia
		where	nr_prescricao = NEW.nr_prescricao;
		
		if (nr_cirurgia_w is null) then
			select	nr_cirurgia
			into STRICT	nr_cirurgia_w
			from	prescr_medica
			where	nr_prescricao = NEW.nr_prescricao;
		end if;
		
		if (nr_cirurgia_w is not null) then
			Select	cd_setor_atendimento,
					dt_entrada_unidade
			into STRICT	cd_setor_atend_w,
					dt_entrada_unid_w
			from	cirurgia
			where  	nr_cirurgia = nr_cirurgia_w;
		end if;
	
	if (cd_funcao_ativa_w <> -2009) or
		((NEW.ie_status_cirurgia <> 'CB') or (NEW.ie_nao_requisitado = 'S')) then	
		insert	into mat_atend_pac_log(
			nr_sequencia,
			nr_seq_mat,
			dt_atualizacao,	
			nm_usuario,
			ds_module,
			nr_atendimento,
			cd_material,
			ie_acao,
			qt_material,
			cd_perfil,
			cd_funcao,
			cd_setor_atendimento,
			dt_entrada_unidade,
			nr_prescricao,
			cd_local_estoque,
			nr_seq_kit_estoque,
			cd_material_kit,
			nr_cirurgia)
		values (nextval('mat_atend_pac_log_seq'),
			NEW.nr_sequencia,
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			ds_module_log_w,
			nr_atendimento_w,
			NEW.cd_material,
			'I',
			NEW.qt_material,
			obter_perfil_ativo,
			cd_funcao_ativa_w,
			cd_setor_atend_w,
			dt_entrada_unid_w,
			NEW.nr_prescricao,
			NEW.cd_local_estoque,
			NEW.nr_seq_kit_estoque,
			NEW.cd_kit_material,
			nr_cirurgia_w);
		end if;
	end if;	
	end;
end if;	

if (NEW.qt_dias_liberado = 0) and (coalesce(NEW.qt_dias_solicitado,0) = 0) then
	NEW.qt_dias_liberado	:= null;
end if;

if (NEW.qt_dia_prim_hor is null) then
	NEW.qt_dia_prim_hor	:= 0;
end if;

NEW.ds_stack	:= substr(dbms_utility.format_call_stack,1,2000);

NEW.dt_atualizacao_nrec	:= LOCALTIMESTAMP;
NEW.nm_usuario_nrec		:= NEW.nm_usuario;

if (NEW.ie_agrupador = 1)  then
	BEGIN
	ie_adiciona_dia_w	:= coalesce(obter_valor_param_usuario(7015, 86, obter_perfil_ativo, NEW.nm_usuario, 0),'N');	
	exception
	when others then
		ie_adiciona_dia_w	:= 'N';
	end;
	if (ie_adiciona_dia_w = 'S') then
		NEW.dt_inicio_medic 	:= (obter_datas_prescricao(NEW.nr_prescricao,'I') + 1);
		NEW.qt_dia_prim_hor	:= 1;
	end if;
end if;

if (NEW.cd_motivo_baixa is null) then
	NEW.cd_motivo_baixa := 0;
end if;

if (NEW.ie_suspenso is null) then
	NEW.ie_suspenso	:= 'N';
end if;

if (NEW.ie_agrupador = 1) then
	ie_tipo_item_w	:= 'M';
elsif (NEW.ie_agrupador = 2) then
	ie_tipo_item_w	:= 'MAT';
elsif (NEW.ie_agrupador = 8) then
	ie_tipo_item_w	:= 'SNE';
elsif (NEW.ie_agrupador = 4) then
	ie_tipo_item_w	:= 'SOL';
elsif (NEW.ie_agrupador = 12) then
	ie_tipo_item_w	:= 'S';
elsif (NEW.ie_agrupador = 16) then
	ie_tipo_item_w	:= 'LD';	
end if;

IF (coalesce(OLD.DS_OBSERVACAO,'XPTO') <> coalesce(NEW.DS_OBSERVACAO,'XPTO')) THEN
    CALL Gerar_log_prescr_mat(NEW.nr_prescricao
    ,NEW.nr_sequencia
    ,NEW.ie_agrupador
    ,null
    ,null
    ,'DS_OBSERVACAO('||coalesce(OLD.DS_OBSERVACAO,'<NULO>')||'/'||coalesce(NEW.DS_OBSERVACAO,'<NULO>')||')'
    ,coalesce(NEW.nm_usuario,wheb_usuario_pck.get_nm_usuario)
    ,'N');
END IF;

CALL Atualizar_plt_controle(NEW.nm_usuario, nr_atendimento_w, cd_pessoa_fisica_w, ie_tipo_item_w, 'S', NEW.nr_prescricao);
end;
end if;

  END;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_material_insert() FROM PUBLIC;

CREATE TRIGGER prescr_material_insert
	BEFORE INSERT ON prescr_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_material_insert();
