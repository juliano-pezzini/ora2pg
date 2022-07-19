-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_atualizar_guia_desp (nr_seq_protocolo_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_cgc_estab_w			varchar(40);
cd_cgc_prestador_w		varchar(40);
cd_autorizacao_w		varchar(40);
nr_sequencia_w			bigint;
ie_tiss_tipo_guia_desp_w	varchar(40);
ie_tiss_tipo_guia_desp_ant_w	varchar(40);
ie_desp_tiss_internado_w	varchar(40);
ie_tipo_classe_w		varchar(40);
nr_interno_conta_w		bigint;
cd_setor_atendimento_w		bigint;

cont_spsadt_w			bigint;
cont_ri_w			bigint;
ie_tipo_atendimento_w		bigint;
cd_estabelecimento_w		bigint;
cd_convenio_w			bigint;
ie_tiss_tipo_despesa_w		varchar(5);
cd_medico_exec_tiss_w		varchar(40);
ie_tiss_tipo_guia_princ_w	varchar(40);
ie_guia_desp_proc_princ_w	varchar(255);
cd_categoria_conv_w		varchar(10);
cd_procedimento_w		procedimento_paciente.cd_procedimento%type;
ie_origem_proced_w		procedimento_paciente.ie_origem_proced%type;
cd_area_procedimento_w	especialidade_proc.cd_area_procedimento%type;
cd_especialidade_w		grupo_proc.cd_especialidade%type;
cd_grupo_proc_w			procedimento.cd_grupo_proc%type;
cd_material_w			material_atend_paciente.cd_material%type;
cd_grupo_material_w		grupo_material.cd_grupo_material%type;
cd_subgrupo_material_w	subgrupo_material.cd_subgrupo_material%type;
cd_classe_material_w	classe_material.cd_classe_material%type;

c01 CURSOR FOR
SELECT	b.nr_sequencia,
	coalesce(b.nr_doc_convenio, 'Nao Informada') nr_doc_convenio,
	coalesce(b.cd_cgc_prestador_tiss, b.cd_cgc_prestador) cd_cgc_prestador,
	a.nr_interno_conta,
	coalesce(a.IE_TIPO_ATEND_CONTA, c.ie_tipo_atendimento),
	b.ie_tiss_tipo_despesa,
	coalesce(b.cd_medico_exec_tiss,b.cd_medico_honor_tiss),
	b.cd_setor_atendimento,
	a.cd_categoria_parametro,
	b.ie_tiss_tipo_guia_desp,
	b.cd_procedimento,
	b.ie_origem_proced
from	atendimento_paciente c,
	procedimento_paciente b,
	conta_paciente a
where	b.ie_tiss_tipo_guia	= '7'
and	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_atendimento	= c.nr_atendimento
and	a.nr_seq_protocolo	= nr_seq_protocolo_p

union

SELECT	b.nr_sequencia,
	coalesce(b.nr_doc_convenio, 'Nao Informada') nr_doc_convenio,
	coalesce(b.cd_cgc_prestador_tiss, b.cd_cgc_prestador) cd_cgc_prestador,
	a.nr_interno_conta,
	coalesce(a.IE_TIPO_ATEND_CONTA, c.ie_tipo_atendimento),
	b.ie_tiss_tipo_despesa,
	coalesce(b.cd_medico_exec_tiss,b.cd_medico_honor_tiss),
	b.cd_setor_atendimento,
	a.cd_categoria_parametro,
	b.ie_tiss_tipo_guia_desp,
	b.cd_procedimento,
	b.ie_origem_proced
from	atendimento_paciente c,
	procedimento_paciente b,
	conta_paciente a
where	b.ie_tiss_tipo_guia	= '7'
and	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_atendimento	= c.nr_atendimento
and	a.nr_interno_conta	= nr_interno_conta_p
order 	by nr_doc_convenio,
	cd_cgc_prestador;

c02 CURSOR FOR
SELECT	b.nr_sequencia,
	coalesce(b.nr_doc_convenio, 'Nao Informada') nr_doc_convenio,
	coalesce(b.cd_cgc_prestador_tiss, b.cd_cgc_prestador) cd_cgc_prestador,
	a.nr_interno_conta,
	coalesce(a.IE_TIPO_ATEND_CONTA, c.ie_tipo_atendimento),
	f.ie_tipo_classe,
	b.ie_tiss_tipo_despesa,
	b.cd_medico_exec_tiss,
	b.cd_setor_atendimento,
	a.cd_categoria_parametro,
	b.ie_tiss_tipo_guia_desp,
	b.cd_material
from	classe_material f,
	material e,
	atendimento_paciente c,
	material_atend_paciente b,
	conta_paciente a
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_atendimento	= c.nr_atendimento
and	e.cd_material		= b.cd_material
and	e.cd_classe_material	= f.cd_classe_material
and	a.nr_seq_protocolo	= nr_seq_protocolo_p

union

SELECT	b.nr_sequencia,
	coalesce(b.nr_doc_convenio, 'Nao Informada') nr_doc_convenio,
	coalesce(b.cd_cgc_prestador_tiss, b.cd_cgc_prestador) cd_cgc_prestador,
	a.nr_interno_conta,
	coalesce(a.IE_TIPO_ATEND_CONTA, c.ie_tipo_atendimento),
	f.ie_tipo_classe,
	b.ie_tiss_tipo_despesa,
	b.cd_medico_exec_tiss,
	b.cd_setor_atendimento,
	a.cd_categoria_parametro,
	b.ie_tiss_tipo_guia_desp,
	b.cd_material
from	classe_material f,
	material e,
	atendimento_paciente c,
	material_atend_paciente b,
	conta_paciente a
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_atendimento	= c.nr_atendimento
and	e.cd_material		= b.cd_material
and	e.cd_classe_material	= f.cd_classe_material
and	a.nr_interno_conta	= nr_interno_conta_p
order 	by nr_doc_convenio,
	cd_cgc_prestador;


BEGIN

if (coalesce(nr_seq_protocolo_p,0) > 0) then
	select	b.cd_cgc,
		b.cd_estabelecimento,
		a.cd_convenio
	into STRICT	cd_cgc_estab_w,
		cd_estabelecimento_w,
		cd_convenio_w
	from	estabelecimento b,
		protocolo_convenio a
	where	a.cd_estabelecimento	= b.cd_estabelecimento
	and	a.nr_seq_protocolo	= nr_seq_protocolo_p;
elsif (coalesce(nr_interno_conta_p,0) > 0) then
	select	b.cd_cgc,
		b.cd_estabelecimento,
		a.cd_convenio_parametro
	into STRICT	cd_cgc_estab_w,
		cd_estabelecimento_w,
		cd_convenio_w
	from	estabelecimento b,
		conta_paciente a
	where	a.cd_estabelecimento	= b.cd_estabelecimento
	and	a.nr_interno_conta	= nr_interno_conta_p;
end if;

select	coalesce(max(ie_desp_tiss_internado),'4'),
	coalesce(max(ie_guia_desp_proc_princ),'N')
into STRICT	ie_desp_tiss_internado_w,
	ie_guia_desp_proc_princ_w
from	tiss_parametros_convenio
where	cd_estabelecimento	= cd_estabelecimento_w
and	cd_convenio		= cd_convenio_w;

select	max(ie_tiss_tipo_guia)
into STRICT	ie_tiss_tipo_guia_princ_w
from	procedimento_paciente
where	nr_interno_conta	= nr_interno_conta_p
and	ie_proc_princ_atend	= 'S'
and	coalesce(cd_motivo_exc_conta::text, '') = '';

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	cd_autorizacao_w,
	cd_cgc_prestador_w,
	nr_interno_conta_w,
	ie_tipo_atendimento_w,
	ie_tiss_tipo_despesa_w,
	cd_medico_exec_tiss_w,
	cd_setor_atendimento_w,
	cd_categoria_conv_w,
	ie_tiss_tipo_guia_desp_ant_w,
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (coalesce(cd_cgc_prestador_w::text, '') = '') then
		cd_cgc_prestador_w 	:= cd_cgc_estab_w;
	end if;

	-- Verificar se existe algum procedimento que a despesa deve ser vinculada
	cont_spsadt_w := 0;
	
	if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') and (cd_autorizacao_w IS NOT NULL AND cd_autorizacao_w::text <> '') and (cd_cgc_prestador_w IS NOT NULL AND cd_cgc_prestador_w::text <> '') then
	
		begin	
		select	1
		into STRICT	cont_spsadt_w
		from	tiss_conta_proc
		where	nr_interno_conta		= nr_interno_conta_w
		and	cd_autorizacao			= cd_autorizacao_w
		and	ie_tiss_tipo_guia		= '4'
		and	cd_cgc_prestador		= cd_cgc_prestador_w  LIMIT 1;
		exception
		when others then
			cont_spsadt_w	:= 0;
		end;
		
	end if;

	ie_tiss_tipo_guia_desp_w		:= null;
	if (cd_cgc_prestador_w <> cd_cgc_estab_w) and (cont_spsadt_w > 0) then
		ie_tiss_tipo_guia_desp_w	:= '4';
	else
		cont_ri_w	:= 0;
		
		if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') and (cd_autorizacao_w IS NOT NULL AND cd_autorizacao_w::text <> '') and (cd_cgc_prestador_w IS NOT NULL AND cd_cgc_prestador_w::text <> '') then
	
			begin
			select	1
			into STRICT	cont_ri_w
			from	tiss_conta_proc
			where	nr_interno_conta	= nr_interno_conta_w
			and	cd_autorizacao		= cd_autorizacao_w
			and	cd_cgc_prestador	= cd_cgc_prestador_w
			and	ie_tiss_tipo_guia	= '5'  LIMIT 1;
			exception
			when others then
				cont_ri_w		:= 0;
			end;
		end if;
		
		if (cont_ri_w > 0) then
			ie_tiss_tipo_guia_desp_w	:= '5';
		else
			if (ie_tipo_atendimento_w <> 1) then
				ie_tiss_tipo_guia_desp_w	:= '4';
			else
				ie_tiss_tipo_guia_desp_w	:= ie_desp_tiss_internado_w;
			end if;
		end if;
	end if;
	
	select	max(cd_area_procedimento),
			max(cd_especialidade),
			max(cd_grupo_proc)
	into STRICT	cd_area_procedimento_w,
			cd_especialidade_w,
			cd_grupo_proc_w
	from	estrutura_procedimento_v
	where	cd_procedimento	= cd_procedimento_w
	and		ie_origem_proced = ie_origem_proced_w;

	ie_tiss_tipo_guia_desp_w := TISS_OBTER_REGRA_GUIA_OPME(cd_estabelecimento_w, cd_cgc_prestador_w, cd_convenio_w, ie_tipo_atendimento_w, ie_tiss_tipo_despesa_w, cd_medico_exec_tiss_w, ie_tiss_tipo_guia_desp_w, ie_tiss_tipo_guia_desp_w, cd_setor_atendimento_w, cd_categoria_conv_w, null, null, null, null, cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, cd_procedimento_w);
	
	if (coalesce(ie_guia_desp_proc_princ_w,'N') = 'S') then /*lhalves OS 395680 em 16/12/2011*/
		ie_tiss_tipo_guia_desp_w	:= coalesce(ie_tiss_tipo_guia_princ_w,ie_tiss_tipo_guia_desp_w);
	end if;
	
	
	if (coalesce(ie_tiss_tipo_guia_desp_ant_w,'XPTO')	<> coalesce(ie_tiss_tipo_guia_desp_w,'XPTO')) then

		update	procedimento_paciente
		set	ie_tiss_tipo_guia_desp	= ie_tiss_tipo_guia_desp_w
		where	nr_sequencia		= nr_sequencia_w;
		
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
			commit;
		end if;
	end if;

	

end loop;
close c01;


open c02;
loop
fetch c02 into
	nr_sequencia_w,
	cd_autorizacao_w,
	cd_cgc_prestador_w,
	nr_interno_conta_w,
	ie_tipo_atendimento_w,
	ie_tipo_classe_w,
	ie_tiss_tipo_despesa_w,
	cd_medico_exec_tiss_w,
	cd_setor_atendimento_w,
	cd_categoria_conv_w,
	ie_tiss_tipo_guia_desp_ant_w,
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	if (coalesce(cd_cgc_prestador_w::text, '') = '') then
		cd_cgc_prestador_w 	:= cd_cgc_estab_w;
	end if;

	-- Verificar se existe algum procedimento que a despesa deve ser vinculada
	cont_spsadt_w := 0;
	
	if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') and (cd_autorizacao_w IS NOT NULL AND cd_autorizacao_w::text <> '') and (cd_cgc_prestador_w IS NOT NULL AND cd_cgc_prestador_w::text <> '') then
	
		begin
		select	1
		into STRICT	cont_spsadt_w
		from	tiss_conta_proc
		where	nr_interno_conta		= nr_interno_conta_w
		and	cd_autorizacao			= cd_autorizacao_w
		and	ie_tiss_tipo_guia		= '4'
		and	cd_cgc_prestador		= cd_cgc_prestador_w  LIMIT 1;
		exception
		when others then
			cont_spsadt_w	:= 0;
		end;
	end if;	

	ie_tiss_tipo_guia_desp_w		:= null;
	if (cd_cgc_prestador_w <> cd_cgc_estab_w) and (cont_spsadt_w > 0) then
		ie_tiss_tipo_guia_desp_w	:= '4';
	else
		cont_ri_w	:= 0;
	
		if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') and (cd_autorizacao_w IS NOT NULL AND cd_autorizacao_w::text <> '') and (cd_cgc_prestador_w IS NOT NULL AND cd_cgc_prestador_w::text <> '') then
	
			begin
			select	1
			into STRICT	cont_ri_w
			from	tiss_conta_proc
			where	nr_interno_conta	= nr_interno_conta_w
			and	cd_autorizacao		= cd_autorizacao_w
			and	cd_cgc_prestador	= cd_cgc_prestador_w
			and	ie_tiss_tipo_guia	= '5'  LIMIT 1;
			exception
			when others then
				cont_ri_w		:= 0;
			end;
			
		end if;


		if (cont_ri_w > 0) then
			ie_tiss_tipo_guia_desp_w	:= '5';
		else
			if (ie_tipo_atendimento_w <> 1) then
				ie_tiss_tipo_guia_desp_w	:= '4';
			else
				ie_tiss_tipo_guia_desp_w	:= ie_desp_tiss_internado_w;
			end if;
		end if;
	end if;	
	
	select	max(cd_grupo_material),
			max(cd_subgrupo_material),
			max(cd_classe_material)
	into STRICT	cd_grupo_material_w,
			cd_subgrupo_material_w,
			cd_classe_material_w
	from	estrutura_material_v
	where 	cd_material = cd_material_w;
	
	/*lhalves OS196744 19/03/2010 - Alterado para que a regra seja aplicada tambem para Mat/med*/

	ie_tiss_tipo_guia_desp_w := TISS_OBTER_REGRA_GUIA_OPME(cd_estabelecimento_w, cd_cgc_prestador_w, cd_convenio_w, ie_tipo_atendimento_w, ie_tiss_tipo_despesa_w, cd_medico_exec_tiss_w, ie_tiss_tipo_guia_desp_w, ie_tiss_tipo_guia_desp_w, cd_setor_atendimento_w, cd_categoria_conv_w, cd_grupo_material_w, cd_subgrupo_material_w, cd_classe_material_w, cd_material_w, null, null, null, null);
	
	if (coalesce(ie_guia_desp_proc_princ_w,'N') = 'S') then	/*lhalves OS 395680 em 16/12/2011*/
			
		ie_tiss_tipo_guia_desp_w	:= coalesce(ie_tiss_tipo_guia_princ_w,ie_tiss_tipo_guia_desp_w);				
	end if;

	if (coalesce(ie_tiss_tipo_guia_desp_ant_w,'XPTO')	<> coalesce(ie_tiss_tipo_guia_desp_w,'XPTO')) then
	
		update	material_atend_paciente
		set	ie_tiss_tipo_guia_desp	= ie_tiss_tipo_guia_desp_w
		where	nr_sequencia		= nr_sequencia_w;
	
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
			commit;
		end if;
	end if;


end loop;
close c02;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
	commit;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_atualizar_guia_desp (nr_seq_protocolo_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

