-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_guia_atendimento (nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_inicio_vigencia_p timestamp, ie_substituir_p text, nm_usuario_p text) AS $body$
DECLARE

 
 
nr_doc_convenio_w	varchar(20);
cd_senha_w		varchar(20);
ie_doc_convenio_w	varchar(3);
dt_final_vigencia_w	timestamp;
cd_estabelecimento_w	smallint;
ie_atualiza_autor_conta_w varchar(1) := 'N';


BEGIN 
 
if (coalesce(nr_atendimento_p,0) > 0) then 
 
	select	coalesce(max(cd_estabelecimento),1) 
	into STRICT	cd_estabelecimento_w 
	from	atendimento_paciente 
	where	nr_atendimento	= nr_atendimento_p;
 
	select	max(a.nr_doc_convenio), 
		max(a.cd_senha), 
		max(coalesce(a.dt_final_vigencia, clock_timestamp())), 
		max(Obter_Valor_Conv_Estab(b.cd_convenio, cd_estabelecimento_w, 'IE_DOC_CONVENIO')) 
	into STRICT	nr_doc_convenio_w, 
		cd_senha_w, 
		dt_final_vigencia_w, 
		ie_doc_convenio_w 
	from	convenio b, 
		atend_categoria_convenio a 
	where	a.nr_atendimento	= nr_atendimento_p 
	and	a.cd_convenio		= b.cd_convenio 
	and	a.cd_convenio		= cd_convenio_p 
	and	a.cd_categoria	= cd_categoria_p 
	and	a.dt_inicio_vigencia	= dt_inicio_vigencia_p;
 
	if (ie_doc_convenio_w = 'S') then 
		nr_doc_convenio_w := coalesce(cd_senha_w, nr_doc_convenio_w);
	elsif (ie_doc_convenio_w = 'N') then 
		nr_doc_convenio_w := null;
	end if;
 
	if (ie_doc_convenio_w <> 'A') then 
		cd_senha_w	:= null;
	end if;
 
 
	update	procedimento_paciente a 
	set	a.nr_doc_convenio	= nr_doc_convenio_w, 
		a.cd_senha		= CASE WHEN ie_doc_convenio_w='A' THEN  cd_senha_w  ELSE null END  
	where	a.nr_atendimento	= nr_atendimento_p 
	and	a.cd_convenio		= cd_convenio_p 
	and	a.cd_categoria		= cd_categoria_p 
	and	a.cd_situacao_glosa	not in (2,3) 
	and (coalesce(a.nr_doc_convenio::text, '') = '' or 'S' = ie_substituir_p) 
	and	exists (SELECT	b.nr_interno_conta 
			from	conta_paciente b 
			where	a.nr_interno_conta	= b.nr_interno_conta 
			and	b.ie_status_acerto	<> 2) 
	and	not exists (select c.nr_atendimento 
			from procedimento_autorizado c 
			where c.nr_atendimento 		= a.nr_atendimento 
			and c.cd_procedimento		= a.cd_procedimento 
			and c.ie_origem_proced		= a.ie_origem_proced) 
	and	a.dt_procedimento between dt_inicio_vigencia_p and dt_final_vigencia_w;
 
 
	update	material_atend_paciente a 
	set	a.nr_doc_convenio	= nr_doc_convenio_w, 
		a.cd_senha		= CASE WHEN ie_doc_convenio_w='A' THEN  cd_senha_w  ELSE null END  
	where	a.nr_atendimento	= nr_atendimento_p 
	and	a.cd_convenio		= cd_convenio_p 
	and	a.cd_categoria		= cd_categoria_p 
	and	a.cd_situacao_glosa	not in (2,3) 
	and (coalesce(a.nr_doc_convenio::text, '') = '' or 'S' = ie_substituir_p) 
	and	exists (SELECT	b.nr_interno_conta 
			from	conta_paciente b 
			where	a.nr_interno_conta	= b.nr_interno_conta 
			and	b.ie_status_acerto	<> 2) 
	and	not exists (select	c.nr_atendimento 
			from	material_autorizado c 
			where	c.nr_atendimento	= a.nr_atendimento 
			and	c.cd_material		= a.cd_material) 
	and	a.dt_atendimento between dt_inicio_vigencia_p and dt_final_vigencia_w;
 
	ie_atualiza_autor_conta_w := obter_param_usuario(916, 1045, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_autor_conta_w);
 
	if (coalesce(ie_atualiza_autor_conta_w,'N') = 'S') then 
		update	conta_paciente a 
		set	a.cd_autorizacao 	 = nr_doc_convenio_w  
		where	a.cd_convenio_parametro	 = cd_convenio_p 
		and	a.nr_atendimento 	 = nr_atendimento_p 
		and	a.ie_status_acerto	<> 2;
	end if;	
 
end if;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_guia_atendimento (nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_inicio_vigencia_p timestamp, ie_substituir_p text, nm_usuario_p text) FROM PUBLIC;

