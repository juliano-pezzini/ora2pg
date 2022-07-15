-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_pedido_exame ( nr_seq_pedido_p bigint, nr_seq_exame_p bigint, ie_lado_p text, nm_usuario_p text, ds_frase_p text , qt_exame_p bigint default null, ds_justificativa_p text default null, dt_execucao_p timestamp DEFAULT NULL, cd_topografia_p bigint default null, nr_seq_dente_p text default null) AS $body$
DECLARE


nr_atendimento_w	bigint;				
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;	
nr_proc_interno_w	bigint;	
nr_seq_exame_w		bigint;
cd_convenio_w		bigint;
cd_convenio_proc_w	bigint;
cd_categoria_w		varchar(10);
cd_categoria_proc_w	varchar(10);
ie_tipo_atendimento_w	smallint;	
ds_erro_w		varchar(4000);	
cd_setor_atendimento_w	bigint;
nr_seq_proc_interno_aux_w	bigint;
ds_frase_w			varchar(255);
nr_seq_pedido_exame_w	bigint;
ie_obter_guia_w		varchar(10) := 'N';
cd_plano_convenio_w		varchar(10);
cd_plano_convenio_proc_w	varchar(10);
nr_seq_proc_int_adic_w	bigint;
qt_idade_w				bigint;
nr_seq_proc_prescr_w	bigint;
nr_seq_topografia_w		bigint;
ie_aguardando_variavel_w  parametro_medico.ie_duplicar_exame_bilateral%type := 'N';
	
C01 CURSOR FOR
	SELECT	nr_seq_proc_int_adic,
		cd_plano_convenio,
		cd_convenio,
		nr_sequencia
	from	proc_int_proc_prescr a
	where	a.nr_seq_proc_interno	= nr_proc_interno_w
	and 	coalesce(a.cd_convenio,cd_convenio_proc_w) = cd_convenio_proc_w
	and		((coalesce(a.cd_estabelecimento::text, '') = '') or (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento))
	and	coalesce(a.ie_situacao,'A')	= 'A'
	and		((coalesce(cd_perfil::text, '') = '') or (cd_perfil = obter_perfil_ativo))
	and	((coalesce(a.cd_edicao_amb::text, '') = '') or ((a.cd_procedimento IS NOT NULL AND a.cd_procedimento::text <> '') and (obter_se_proc_edicao2(a.cd_procedimento, a.ie_origem_proced, a.cd_edicao_amb) = 'S')))
	and 	((coalesce(a.cd_convenio_excluir::text, '') = '') or (a.cd_convenio_excluir <> cd_convenio_proc_w))
	and	((coalesce(a.cd_categoria_convenio::text, '') = '') or (a.cd_categoria_convenio = cd_categoria_proc_w))
	and	((a.cd_plano_convenio	= cd_plano_convenio_proc_w) or (coalesce(a.cd_plano_convenio::text, '') = ''))
	and	((coalesce(a.cd_medico_prescritor::text, '') = '') or (a.cd_medico_prescritor = obter_Pessoa_fisica_usuario(nm_usuario_p,'C')))
	and	((coalesce(a.cd_medico_excluir::text, '') = '') or (a.cd_medico_excluir <> obter_Pessoa_fisica_usuario(nm_usuario_p,'C')))
	and	(((coalesce(qt_idade_w::text, '') = '') or (coalesce(a.qt_idade_min::text, '') = '' and coalesce(a.qt_idade_max::text, '') = '')) or
		((qt_idade_w IS NOT NULL AND qt_idade_w::text <> '') and (qt_idade_w between coalesce(a.qt_idade_min,qt_idade_w) and
		coalesce(a.qt_idade_max,qt_idade_w))))
	and	coalesce(ie_somente_agenda_int,'N') = 'N';


BEGIN

ie_obter_guia_w := obter_param_usuario(281, 1275, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_obter_guia_w);

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	pedido_exame_externo
where	nr_sequencia	= nr_seq_pedido_p;

select
	coalesce(max(ie_duplicar_exame_bilateral), 'N') 
into STRICT ie_aguardando_variavel_w
from parametro_medico 
where ie_duplicar_exame_bilateral = 'S'
and cd_estabelecimento = obter_estabelecimento_ativo;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	
	select	max(nr_proc_interno),
		max(nr_seq_exame)
	into STRICT	nr_proc_interno_w,
		nr_seq_exame_w
	from	med_exame_padrao
	where	nr_sequencia	= nr_seq_exame_p;
	
	
	
	if (nr_proc_interno_w IS NOT NULL AND nr_proc_interno_w::text <> '') then
		SELECT * FROM Obter_Proc_Tab_Interno(nr_proc_interno_w, null, nr_atendimento_w, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	elsif (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
		
		select	MAX(cd_convenio),
			MAX(cd_categoria),
			MAX(ie_tipo_Atendimento),
			MAX(cd_plano_convenio)
		into STRICT	cd_convenio_w,
			cd_categoria_w,
			ie_tipo_atendimento_w,
			cd_plano_convenio_w
		from	atendimento_paciente_v
		where	nr_atendimento	= nr_atendimento_w;
		
		SELECT * FROM Obter_Exame_Lab_Convenio(	nr_seq_exame_w, cd_convenio_w, cd_categoria_w, ie_tipo_atendimento_w, wheb_usuario_pck.get_cd_estabelecimento, null, null, null, cd_plano_convenio_w, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_interno_aux_w) INTO STRICT cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_interno_aux_w;
						
		if (coalesce(cd_procedimento_w,0)	= 0) then
			cd_procedimento_w	:= null;
			ie_origem_proced_w	:= null;
		end if;
		
		
	end if;
	
	select	MAX(cd_convenio),
			MAX(cd_categoria),
			MAX(cd_plano_convenio),
			max(obter_idade_pf(cd_pessoa_fisica, clock_timestamp(), 'A'))
	into STRICT	cd_convenio_proc_w,
			cd_categoria_proc_w,
			cd_plano_convenio_proc_w,
			qt_idade_w
	from	atendimento_paciente_v
	where	nr_atendimento	= nr_atendimento_w;

	
end if;

select	nextval('pedido_exame_externo_item_seq')
into STRICT	nr_seq_pedido_exame_w
;

nr_seq_topografia_w := cd_topografia_p;
if (cd_topografia_p = 0) then
	nr_seq_topografia_w := null;
end if;

ds_frase_w	:= substr(ds_frase_p,1,255);
insert into pedido_exame_externo_item(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_pedido,
	nr_seq_exame,
	qt_exame,
	nr_seq_apresent,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_lado,
	ds_justificativa,
	cd_procedimento,
	ie_origem_proced,
	nr_seq_exame_lab,
	nr_proc_interno,
	dt_execucao,
	nr_seq_grupo_exame,
	cd_material_exame,
	nr_seq_topografia,
	nr_seq_dente)
SELECT	nr_seq_pedido_exame_w,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_pedido_p,
	nr_sequencia,
	coalesce(coalesce(qt_exame_p,qt_exame),1),
	1,
	clock_timestamp(),
	nm_usuario_p,
	CASE WHEN ie_aguardando_variavel_w='S' THEN  CASE WHEN ie_lado_p='A' THEN  'E'  ELSE ie_lado_p END   ELSE ie_lado_p END ,
	substr(coalesce(ds_justificativa_p,coalesce(ds_frase_w,ds_justificativa)),1,255),
	coalesce(cd_procedimento_w,cd_procedimento),
	CASE WHEN coalesce(cd_procedimento_w::text, '') = '' THEN ie_origem_proced  ELSE ie_origem_proced_w END ,
	nr_seq_exame,
	nr_proc_interno,
	dt_execucao_p,
	nr_seq_grupo,
	cd_material_exame,
	nr_seq_topografia_w,
	nr_seq_dente_p
from	med_exame_padrao
where	nr_sequencia	= nr_seq_exame_p;

if ie_aguardando_variavel_w = 'S' and ie_lado_p = 'A' then
	insert into pedido_exame_externo_item(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_pedido,
		nr_seq_exame,
		qt_exame,
		nr_seq_apresent,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_lado,
		ds_justificativa,
		cd_procedimento,
		ie_origem_proced,
		nr_seq_exame_lab,
		nr_proc_interno,
		dt_execucao,
		nr_seq_grupo_exame,
		cd_material_exame,
		nr_seq_topografia,
		nr_seq_dente)
	SELECT	
		nextval('pedido_exame_externo_item_seq'),
		dt_atualizacao,
		nm_usuario,
		nr_seq_pedido,
		nr_seq_exame,
		qt_exame,
		nr_seq_apresent,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		'D',
		ds_justificativa,
		cd_procedimento,
		ie_origem_proced,
		nr_seq_exame_lab,
		nr_proc_interno,
		dt_execucao,
		nr_seq_grupo_exame,
		cd_material_exame,
		nr_seq_topografia,
		nr_seq_dente
	from	pedido_exame_externo_item
	where	nr_sequencia = nr_seq_pedido_exame_w
	and     ie_lado = 'E';
end if;

	
if (ie_obter_guia_w = 'S') then
  CALL TISS_DEFINE_GUIA_EXAME_ITEM(nm_usuario_p,nr_seq_pedido_p,nr_seq_pedido_exame_w);
end if;

open C01;
loop
fetch C01 into	
	nr_seq_proc_int_adic_w,
	cd_plano_convenio_w,
	cd_convenio_w,
	nr_seq_proc_prescr_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	SELECT * FROM Obter_Proc_Tab_Interno(nr_seq_proc_int_adic_w, null, nr_atendimento_w, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	
	select	nextval('pedido_exame_externo_item_seq')
	into STRICT	nr_seq_pedido_exame_w
	;
	
	insert into pedido_exame_externo_item(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_pedido,
		nr_seq_exame,
		qt_exame,
		nr_seq_apresent,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_lado,
		cd_procedimento,
		ie_origem_proced,
		nr_proc_interno,
		dt_execucao,
		nr_seq_grupo_exame,
		nr_seq_topografia,
		nr_seq_dente)
	SELECT	nr_seq_pedido_exame_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_pedido_p,
			a.nr_sequencia,
			b.qt_proc_adic,
			1,
			clock_timestamp(),
			nm_usuario_p,
			CASE WHEN ie_aguardando_variavel_w='S' THEN  CASE WHEN ie_lado_p='A' THEN  'E'  ELSE ie_lado_p END   ELSE ie_lado_p END ,
			coalesce(cd_procedimento_w,b.cd_procedimento),
			CASE WHEN coalesce(cd_procedimento_w::text, '') = '' THEN b.ie_origem_proced  ELSE ie_origem_proced_w END ,
			nr_seq_proc_int_adic_w,
			dt_execucao_p,
			a.nr_seq_grupo,
			nr_seq_topografia_w,
			nr_seq_dente_p
	from	med_exame_padrao a,
			proc_int_proc_prescr b
	where	a.nr_proc_interno = b.nr_seq_proc_interno
	and		a.nr_sequencia	= nr_seq_exame_p
	and	b.nr_sequencia = nr_seq_proc_prescr_w;
	
	if ie_aguardando_variavel_w = 'S' and ie_lado_p = 'A' then
		insert into pedido_exame_externo_item(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_pedido,
			nr_seq_exame,
			qt_exame,
			nr_seq_apresent,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_lado,
			cd_procedimento,
			ie_origem_proced,
			nr_proc_interno,
			dt_execucao,
			nr_seq_grupo_exame,
			nr_seq_topografia,
			nr_seq_dente)
		SELECT	
			nextval('pedido_exame_externo_item_seq'),
			dt_atualizacao,
			nm_usuario,
			nr_seq_pedido,
			nr_seq_exame,
			qt_exame,
			nr_seq_apresent,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			'D',
			cd_procedimento,
			ie_origem_proced,
			nr_proc_interno,
			dt_execucao,
			nr_seq_grupo_exame,
			nr_seq_topografia,
			nr_seq_dente
		from pedido_exame_externo_item
		where nr_sequencia = nr_seq_pedido_exame_w
		and   ie_lado = 'E';
	end if;
	
	if (ie_obter_guia_w = 'S') then
		CALL TISS_DEFINE_GUIA_EXAME_ITEM(nm_usuario_p,nr_seq_pedido_p,nr_seq_pedido_exame_w);
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
-- REVOKE ALL ON PROCEDURE inserir_pedido_exame ( nr_seq_pedido_p bigint, nr_seq_exame_p bigint, ie_lado_p text, nm_usuario_p text, ds_frase_p text , qt_exame_p bigint default null, ds_justificativa_p text default null, dt_execucao_p timestamp DEFAULT NULL, cd_topografia_p bigint default null, nr_seq_dente_p text default null) FROM PUBLIC;

