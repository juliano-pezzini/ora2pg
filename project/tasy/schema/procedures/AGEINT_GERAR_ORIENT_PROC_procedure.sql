-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_orient_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, nr_seq_tipo_classif_pac_p bigint, cd_paciente_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ageint_item_p bigint, ie_resumo_p text default 'S') AS $body$
DECLARE

 
ds_orientacao_w			text; --varchar2(32000) := ''; 
ds_orientacao_pac_w		varchar(6000) := '';
ds_orientacao_obs_w		varchar(32000)	:= '';
ds_orient_convenio_w	varchar(2000) := '';
ie_orientacao_w			varchar(01);
cd_plano_convenio_w		varchar(10);
cd_categoria_w			varchar(10);
qt_idade_w				bigint;
ds_orient_paciente_w	varchar(4000) := '';
nr_seq_classif_w		bigint;
cd_estabelecimento_w	smallint;
ds_orient_pac_preparo_w	varchar(4000);
ie_forma_orientacao_w	varchar(1);
ds_orientacao_externo_w	varchar(4000);
cd_medico_item_w		agenda_integrada_prof_item.cd_pessoa_fisica%type;
					
C01 CURSOR FOR 
	SELECT	ds_orientacao 
	from	proc_interno_conv_orient 
	where	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0) 
	and	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = '')) 
	and	((coalesce(cd_categoria, coalesce(cd_categoria_w,'0')) = coalesce(cd_categoria_w,'0')) or (coalesce(cd_categoria_w,'0') = '0')) 
	and	((coalesce(cd_plano, coalesce(cd_plano_convenio_w,'0')) = coalesce(cd_plano_convenio_w,'0')) or (coalesce(cd_plano_convenio_w,'0') = '0')) 
	and	qt_idade_w between coalesce(qt_idade_min, qt_idade_w) and coalesce(qt_idade_max, qt_idade_w) 
	and (coalesce(nr_seq_classif, coalesce(nr_seq_classif_w,0)) = coalesce(nr_seq_classif_w,0)) 
	order by	coalesce(nr_seq_proc_interno,0),	 
		coalesce(nr_seq_classif,0);
	
C02 CURSOR FOR	 
	SELECT	ds_orientacao_pac, 
		ds_orient_preparo 
	from	proc_interno_pac_orient 
	where	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0) 
	and	coalesce(ie_situacao,'A') = 'A' 
	and	qt_idade_w between coalesce(qt_idade_min, qt_idade_w) and coalesce(qt_idade_max, qt_idade_w) 
	and (coalesce(nr_seq_classif, coalesce(nr_seq_classif_w,0)) = coalesce(nr_seq_classif_w,0)) 
	and (coalesce(nr_seq_tipo_classif_pac, coalesce(nr_seq_tipo_classif_pac_p,0)) = coalesce(nr_seq_tipo_classif_pac_p,0)) 
	and (coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,1)) = coalesce(cd_estabelecimento_p,1)) 
	and (coalesce(cd_pessoa_fisica, coalesce(cd_medico_item_w,0)) = coalesce(cd_medico_item_w,0)) 
	order by	coalesce(nr_seq_proc_interno,0),	 
		coalesce(nr_seq_classif,0);

 

BEGIN 
 
--cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento; 
 
ie_forma_orientacao_w := Obter_Param_Usuario(869, 106, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_forma_orientacao_w);
 
select	max(ds_orientacao) 
into STRICT	ds_orientacao_w 
from	procedimento 
where	cd_procedimento = cd_procedimento_p 
and	ie_origem_proced = ie_origem_proced_p;
if (coalesce(nr_seq_proc_interno_p,0) > 0) then 
	select	max(ie_orientacao), 
		max(ds_orientacao_usuario), 
		max(DS_OBSERVACAO), 
		max(DS_ORIENTACAO_PAC), 
		max(DS_ORIENTACAO_EXTERNO) 
	into STRICT	ie_orientacao_w, 
		ds_orientacao_w, 
		ds_orientacao_pac_w, 
		ds_orientacao_obs_w, 
		ds_orientacao_externo_w 
	from	proc_interno 
	where	nr_sequencia = nr_seq_proc_interno_p;
	--Ra1ise_app1lication_er1ror(-20011,ds_orientacao_obs_w); 
	select	coalesce(max(cd_plano_convenio),'0'), 
		coalesce(max(cd_categoria),'0') 
	into STRICT	cd_plano_convenio_w, 
		cd_categoria_w 
	from	atend_categoria_convenio 
	where	nr_atendimento = nr_atendimento_p;
	 
	select	coalesce(max(campo_numerico(obter_idade_pf(cd_pessoa_fisica, clock_timestamp(), 'A'))),0) 
	into STRICT	qt_idade_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
	 
	if (cd_paciente_p IS NOT NULL AND cd_paciente_p::text <> '') then 
		select	(obter_idade(dt_nascimento, clock_timestamp(), 'A'))::numeric  
		into STRICT	qt_idade_w 
		from	pessoa_fisica 
		where	cd_pessoa_fisica = cd_paciente_p;
	end if;
 
	select	coalesce(max(nr_seq_classif),0) 
	into STRICT	nr_seq_classif_w 
	from	proc_interno 
	where	nr_sequencia = nr_seq_proc_interno_p;
	 
	ds_orient_convenio_w := '';
	ds_orient_paciente_w := '';
	 
	if (ie_resumo_p = 'S') then 
		open C01;
		loop 
		fetch C01 into	 
			ds_orient_convenio_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			ds_orient_convenio_w := ds_orient_convenio_w;
			end;
		end loop;
		close C01;
	end if;
	 
	/*busca o profissional do item*/
 
	select	max(cd_medico) 
	into STRICT	cd_medico_item_w 
	from 	agenda_integrada_item 
	where	nr_sequencia = nr_seq_ageint_item_p;
	 
	open C02;
	loop 
	fetch C02 into	 
		ds_orient_paciente_w, 
		ds_orient_pac_preparo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		ds_orient_paciente_w 	:= ds_orient_paciente_w;
		ds_orient_pac_preparo_w	:= ds_orient_pac_preparo_w;
		end;
	end loop;
	close C02;
	 
	if (ie_forma_orientacao_w	= 'S') then 
		if (ie_orientacao_w = 'C') then 
			ds_orientacao_w := ds_orient_convenio_w;
		elsif (ie_orientacao_w = 'A') and 
			((ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') or (ds_orient_convenio_w IS NOT NULL AND ds_orient_convenio_w::text <> '') or (ds_orient_paciente_w IS NOT NULL AND ds_orient_paciente_w::text <> '') or (ds_orientacao_pac_w IS NOT NULL AND ds_orientacao_pac_w::text <> '')) then 
			--(ds_orientacao_obs_w is not null))then 
			ds_orientacao_w := 	substr(ds_orientacao_w || chr(13) || chr(10) || 
						ds_orient_convenio_w || chr(13) || chr(10) || 
						ds_orient_paciente_w||chr(13)||chr(10)|| 
						ds_orientacao_pac_w,1,32000);--||chr(13)||chr(10)|| 
						--ds_orientacao_obs_w,1,4000); 
		elsif (ie_orientacao_w	= 'I') and
			((ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') or (ds_orientacao_pac_w IS NOT NULL AND ds_orientacao_pac_w::text <> '')) then 
			--(ds_orientacao_obs_w is not null)) 		then 
			ds_orientacao_w := 	substr(ds_orientacao_w || chr(13) || chr(10) || 
						ds_orientacao_pac_w,1,32000);--||chr(13)||chr(10)|| 
						--ds_orientacao_obs_w,1,4000); 
			
		end if;
	elsif (ie_forma_orientacao_w	= 'P') then 
		ds_orientacao_w	:= '';
		ds_orientacao_w	:= substr(ds_orientacao_w || chr(13) || chr(10) || 					 
						ds_orient_paciente_w||chr(13)||chr(10)|| 
					 ds_orientacao_w || chr(13) || chr(10) || 					 
						wheb_mensagem_pck.get_texto(791276) || ': '|| chr(13) || chr(10) || chr(13) || chr(10) || 
						ds_orient_pac_preparo_w,1,32000);
	elsif (ie_forma_orientacao_w	= 'T') then 
		ds_orientacao_w	:= substr(	ds_orientacao_w||chr(13)||chr(10)|| 
						ds_orientacao_obs_w,1,32000);
	elsif (ie_forma_orientacao_w	= 'I') then 
		if (ie_orientacao_w = 'C') then 
			ds_orientacao_w := ds_orient_convenio_w;
		elsif (ie_orientacao_w = 'A') and 
			((ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') or (ds_orient_convenio_w IS NOT NULL AND ds_orient_convenio_w::text <> '') or (ds_orient_paciente_w IS NOT NULL AND ds_orient_paciente_w::text <> '') or (ds_orient_pac_preparo_w IS NOT NULL AND ds_orient_pac_preparo_w::text <> '')) then 
			ds_orientacao_w := 	substr(ds_orientacao_w || chr(13) || chr(10) || 						 
						ds_orient_convenio_w || chr(13) || chr(10) || 
						ds_orient_paciente_w||chr(13)||chr(10)|| 
						ds_orient_pac_preparo_w,1,32000);
		elsif (ie_orientacao_w	= 'I') and 
			((ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') or (ds_orientacao_pac_w IS NOT NULL AND ds_orientacao_pac_w::text <> '')) then 
			ds_orientacao_w := 	substr(ds_orientacao_w || chr(13) || chr(10) || 						 
						ds_orientacao_pac_w,1,32000);
		end if;
	elsif (ie_forma_orientacao_w = 'E') then 
		ds_orientacao_w	:= substr(ds_orientacao_externo_w,1,4000);
	elsif (ie_forma_orientacao_w = 'R') then 
		ds_orientacao_w	:= substr(ds_orientacao_w,1,4000);		
	end if;
end if;
 
if (ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') then 
 
	insert into agenda_int_resumo_long( 
								nr_sequencia, 
								dt_atualizacao, 
								nm_usuario, 
								nr_seq_apres, 
								nr_seq_ageint, 
								ds_texto) 
								values ( 
								nextval('agenda_int_resumo_long_seq'), 
								clock_timestamp(), 
								nm_usuario_p, 
								9, 
								nr_seq_ageint_item_p, 
								ds_orientacao_w);
 
	commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_orient_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_convenio_p bigint, nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, nr_seq_tipo_classif_pac_p bigint, cd_paciente_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ageint_item_p bigint, ie_resumo_p text default 'S') FROM PUBLIC;

