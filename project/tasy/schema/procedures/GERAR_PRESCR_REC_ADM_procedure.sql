-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_rec_adm ( nr_seq_mat_hor_p bigint, nm_usuario_p text, ie_acao_p text) AS $body$
DECLARE


			
cd_material_w		prescr_material.cd_material%type;

prescr_medica_w		prescr_medica%rowtype;
prescr_recomendacao_w	prescr_recomendacao%rowtype;
dt_prim_horario_w	timestamp;
ds_erro_w		varchar(4000);
dt_atual_w		timestamp	:= clock_timestamp();
cd_recomendacao_w	prescr_recomendacao.cd_recomendacao%type;
ds_recomendacao_w	prescr_recomendacao.ds_recomendacao%type;
qt_hora_aplicacao_w	prescr_material.qt_hora_aplicacao%type;
qt_min_aplicacao_w	prescr_material.qt_min_aplicacao%type;
dt_fim_horario_w	prescr_mat_hor.dt_fim_horario%type;
ds_observacao_w		prescr_recomendacao.ds_observacao%type;

ds_sql_w		varchar(4000);
quebra_w		varchar(10) := chr(13)||chr(10);


C01 CURSOR FOR
	SELECT	nr_prescricao
	from	prescr_recomendacao
	where	nr_seq_mat_hor = nr_seq_mat_hor_p
	and	coalesce(dt_suspensao::text, '') = '';

BEGIN
begin


if (ie_acao_p	= 'A') then
	begin
	select	b.cd_material,
		coalesce(b.qt_min_aplicacao,0),
		coalesce(b.qt_hora_aplicacao,0),
		coalesce(c.dt_fim_horario,clock_timestamp())
	into STRICT	cd_material_w,
		qt_min_aplicacao_w,
		qt_hora_aplicacao_w,
		dt_fim_horario_w
	from	prescr_medica a,
		prescr_material b,
		prescr_mat_hor c
	where	a.nr_prescricao = b.nr_prescricao
	and	b.nr_prescricao = c.nr_prescricao
	and	b.nr_sequencia = c.nr_seq_material
	and	c.nr_sequencia	= nr_seq_mat_hor_p;

	select	max(cd_recomendacao)
	into STRICT	cd_recomendacao_w
	from	adep_regra_recomendacao
	where	cd_material = cd_material_w;
	
	select	a.*
	into STRICT	prescr_medica_w
	from	prescr_medica a,
		prescr_material b,
		prescr_mat_hor c
	where	a.nr_prescricao = b.nr_prescricao
	and	b.nr_prescricao = c.nr_prescricao
	and	b.nr_sequencia = c.nr_seq_material
	and	c.nr_sequencia	= nr_seq_mat_hor_p;

	exception
	when others then
		 null;
	end;

	if (prescr_medica_w.nr_atendimento IS NOT NULL AND prescr_medica_w.nr_atendimento::text <> '') and (cd_recomendacao_w IS NOT NULL AND cd_recomendacao_w::text <> '') then
		dt_prim_horario_w	:= dt_fim_horario_w;
		
		if (qt_hora_aplicacao_w	> 0) then
			dt_prim_horario_w	:= dt_prim_horario_w + qt_hora_aplicacao_w/24;
		end if;
		
		if (qt_min_aplicacao_w	> 0) then
			dt_prim_horario_w	:= dt_prim_horario_w + 1/(60/qt_min_aplicacao_w)/24;
		end if;
		
		select	nextval('prescr_medica_seq')
		into STRICT	prescr_medica_w.nr_prescricao
		;
		
		prescr_medica_w.dt_prescricao		:= dt_atual_w;
		prescr_medica_w.dt_atualizacao		:= dt_atual_w;
		prescr_medica_w.nm_usuario		:= nm_usuario_p;
		prescr_medica_w.cd_prescritor		:= obter_codigo_usuario(nm_usuario_p);
		--prescr_medica_w.cd_medico		:= obter_codigo_usuario(nm_usuario_p);
		prescr_medica_w.dt_liberacao		:= null;
		prescr_medica_w.dt_liberacao_farmacia	:= null;
		prescr_medica_w.dt_liberacao_medico	:= null;
		prescr_medica_w.dt_validade_prescr	:= null;
		prescr_medica_w.dt_inicio_prescr	:= null;
		prescr_medica_w.nr_horas_validade	:= 24;
		prescr_medica_w.ie_emergencia		:= 'N';
		prescr_medica_w.nm_maquina		:= null;
		prescr_medica_w.ds_utc			:= null;
		prescr_medica_w.ds_utc_atualizacao	:= null;
		prescr_medica_w.dt_entrega		:= null;
		prescr_medica_w.NM_USUARIO_LIB_ENF	:= null;
		prescr_medica_w.DT_PRESCRICAO_ORIGINAL	:= null;
		prescr_medica_w.ie_lib_farm		:= 'N';
		prescr_medica_w.ie_lib_farm		:= 'N';
		prescr_medica_w.dt_primeiro_horario	:= dt_prim_horario_w;
		prescr_medica_w.ds_itens_prescr		:= null;
		prescr_medica_w.cd_perfil_ativo		:= obter_perfil_ativo;
		
		insert into prescr_medica values (prescr_medica_w.*);		
		
		select	max(ds_complemento)
		into STRICT	ds_recomendacao_w
		from	tipo_recomendacao
		where	cd_tipo_recomendacao = cd_recomendacao_w;
		
		prescr_recomendacao_w.nr_prescricao		:= prescr_medica_w.nr_prescricao;
		prescr_recomendacao_w.nr_sequencia		:= 1;
		prescr_recomendacao_w.cd_recomendacao		:= cd_recomendacao_w;
		prescr_recomendacao_w.ds_recomendacao		:= ds_recomendacao_w;
		prescr_recomendacao_w.hr_prim_horario		:= to_char( dt_prim_horario_w ,'hh24:mi');
		prescr_recomendacao_w.ds_horarios		:= prescr_recomendacao_w.hr_prim_horario;
		prescr_recomendacao_w.dt_atualizacao		:= dt_atual_w;
		prescr_recomendacao_w.nm_usuario		:= nm_usuario_p;
		prescr_recomendacao_w.ie_destino_rec		:= 'E';
		prescr_recomendacao_w.nr_ocorrencia		:= 1;
		prescr_recomendacao_w.ie_se_necessario		:= 'N';
		prescr_recomendacao_w.ie_acm			:= 'N';
		prescr_recomendacao_w.ie_urgencia		:= 'N';
		prescr_recomendacao_w.nr_seq_mat_hor		:= nr_seq_mat_hor_p;
		
		ds_observacao_w					:=	obter_desc_expressao(330076) ||' ' || obter_desc_material(cd_material_w) ||quebra_w||
									obter_desc_expressao(283600) ||': '|| PKG_DATE_FORMATERS.to_varchar(dt_fim_horario_w,'short',obter_estabelecimento_ativo,nm_usuario_p)||quebra_w||
									obter_desc_expressao(316967) ||': '|| PKG_DATE_FORMATERS.to_varchar(dt_prim_horario_w,'short',obter_estabelecimento_ativo,nm_usuario_p);
									
					
		prescr_recomendacao_w.nr_seq_mat_hor		:= nr_seq_mat_hor_p;
		prescr_recomendacao_w.ds_observacao		:= ds_observacao_w;
		insert into prescr_recomendacao values (prescr_recomendacao_w.*);
		
		
		ds_sql_w	:= 'begin liberar_prescricao(:nr_prescricao, :nr_atendimento,''S'', :cd_perfil,:nm_usuario,''S'',:ds_erro); end; ';
		
		
		EXECUTE ds_sql_w using prescr_medica_w.nr_prescricao,prescr_medica_w.nr_atendimento,obter_perfil_ativo,nm_usuario_p, out ds_erro_w;

		--sorry for that
		update	prescr_rec_hor
		set	dt_lib_horario = clock_timestamp()
		where	nr_prescricao = prescr_medica_w.nr_prescricao
		and	coalesce(dt_lib_horario::text, '') = '';
		
	end if;
elsif (ie_acao_p	= 'S') then
	
	
	for r_c01 in c01 loop
		begin
		CALL Suspender_Prescricao( 	r_c01.nr_prescricao,
					null,
					null,
					nm_usuario_p,
					'N');
		end;
	end loop;

end if;

exception
when others then
	null;
end;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_rec_adm ( nr_seq_mat_hor_p bigint, nm_usuario_p text, ie_acao_p text) FROM PUBLIC;

