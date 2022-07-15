-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_envio_email_material ( nr_sequencia_p bigint, cd_material_p bigint, ie_tipo_mensagem_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_alteracoes_p text) AS $body$
DECLARE

 
cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
ds_comunic_solic_w		varchar(500);
nr_seq_classif_w			bigint;
cd_setor_dest_w			bigint;
nm_usuario_dest_w			varchar(255);
cd_grupo_mat_w			bigint;
cd_subgrupo_mat_w	 	bigint;
cd_classe_mat_w			bigint;
cd_mat_w			bigint;
nr_regras_w			bigint;
cd_setor_w			varchar(100);
dt_atendimento_w			varchar(50);
nm_pessoa_fisica_w		varchar(100);
ds_convenio_w			varchar(100);
qt_material_w			double precision;
ds_fornecedor_w			varchar(80);
ds_assunto_w			varchar(255);
ds_mensagem_padrao_w		varchar(2000);
cd_material_w			bigint;
ds_email_destino_w			varchar(2000);
nr_atendimento_w			bigint;
nr_interno_conta_w			bigint;
ds_material_w			varchar(200);
ds_familia_mat_w			varchar(255);
nr_seq_familia_w			bigint;
ds_alteracoes_w			varchar(500);
qt_existe_format_w			bigint;
ie_classif_custo_w       material_estab.ie_classif_custo%type;

/*Macros disponiveis 
CONTA 
ATENDIMENTO 
DATALANCAMENTO 
PACIENTE 
CONVENIO 
QUANTIDADE 
FORNECEDOR 
FAMILIA MATERIAL 
ALTERACOES 
*/
 
 
 
 
c01 CURSOR FOR 
	SELECT	ds_email_destino, 
		cd_grupo_material, 
		cd_subgrupo_material, 
		cd_classe_material, 
		cd_material, 
		ds_assunto, 
		ds_mensagem_padrao 
	from	regra_envio_email_material 
	where	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w 
	and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w 
	and	coalesce(cd_classe_material, cd_classe_material_w)		= cd_classe_material_w 
	and	coalesce(cd_material, cd_material_w)			= cd_material_w 
	and	((coalesce(nr_seq_familia::text, '') = '') or (coalesce(nr_seq_familia, nr_seq_familia_w) = nr_seq_familia_w)) 
	and	coalesce(ie_tipo_mensagem,ie_tipo_mensagem_p) 		= ie_tipo_mensagem_p 
	and (coalesce(cd_estabelecimento::text, '') = '' or cd_estabelecimento = cd_estabelecimento_p) 
	order by 	coalesce(cd_grupo_material, 0), 
		coalesce(cd_subgrupo_material, 0), 
		coalesce(cd_classe_material, 0), 
		coalesce(cd_material, 0), 
		coalesce(ie_tipo_mensagem,0);

 
 

BEGIN 
 
ds_alteracoes_w	:= substr(ds_alteracoes_p,1,500);
 
select	position('{\ul{\b' in ds_alteracoes_w) 
into STRICT	qt_existe_format_w
;
 
if (qt_existe_Format_w > 0) then 
	ds_alteracoes_w	:= substr(replace(ds_alteracoes_w,'{\ul{\b',''),1,500);
	ds_alteracoes_w	:= substr(replace(ds_alteracoes_w,'}}',''),1,500);
	ds_alteracoes_w	:= substr(replace(ds_alteracoes_w,'{\par}',''),1,500);
end if;
 
if (ie_tipo_mensagem_p = 1) or (coalesce(cd_material_p,0) > 0) then 
	begin 
 
	if (ie_tipo_mensagem_p = 1) then 
		begin 
		select	to_char(dt_atendimento,'dd/mm/yyyy hh24:mi:ss'), 
			substr(obter_dados_atendimento(nr_atendimento, 'NP'),1,100), 
			substr(obter_nome_convenio(cd_convenio),1,100), 
			qt_material, 
			substr(obter_nome_pf_pj(null,cd_cgc_fornecedor),1,80), 
			cd_material, 
			nr_atendimento, 
			nr_interno_conta, 
			substr(obter_desc_material(cd_material),1,200) ds_material 
		into STRICT	dt_atendimento_w, 
			nm_pessoa_fisica_w, 
			ds_convenio_w, 
			qt_material_w, 
			ds_fornecedor_w, 
			cd_material_w, 
			nr_atendimento_w, 
			nr_interno_conta_w, 
			ds_material_w 
		from	material_atend_paciente 
		where	nr_sequencia = nr_sequencia_p;
		exception when no_data_found then 
			dt_atendimento_w	:= '';
			nm_pessoa_fisica_w	:= '';
			ds_convenio_w		:= '';
			qt_material_w		:= '';
			ds_fornecedor_w		:= '';			
 
		end;
 
	elsif (ie_tipo_mensagem_p in (2,3,4,5,7,8)) then 
		begin 
		cd_material_w	:= cd_material_p;
		ds_material_w	:= substr(obter_desc_material(cd_material_w),1,200);
		end;
	end if;
 
 
	select	max(cd_grupo_material), 
		max(cd_subgrupo_material), 
		max(cd_classe_material), 
		max(nr_seq_familia) 
	into STRICT	cd_grupo_material_w, 
		cd_subgrupo_material_w, 
		cd_classe_material_w, 
		nr_seq_familia_w 
	from	estrutura_material_v 
	where 	cd_material = cd_material_w;
 
	if (nr_seq_familia_w > 0) then 
		select	substr(OBTER_DESC_FAMILIA_MAT(nr_seq_familia_w),1,255) 
		into STRICT	ds_familia_mat_w 
		;
	end if;
 
	select	count(*) 
	into STRICT	nr_regras_w 
	from 	regra_envio_email_material;
 
	if (nr_regras_w > 0) then 
		open	c01;
		loop 
		fetch	c01 into 
			ds_email_destino_w, 
			cd_grupo_mat_w, 
			cd_subgrupo_mat_w, 
			cd_classe_mat_w, 
			cd_mat_w, 
			ds_assunto_w, 
			ds_mensagem_padrao_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		 
			select	coalesce(max(ie_classif_custo),'B') 
			into STRICT	ie_classif_custo_w 
			from	material_estab 
			where	cd_estabelecimento = cd_estabelecimento_p 
			and	cd_material = cd_material_w;
			 
			if (ie_classif_custo_w = 'A') or (ie_tipo_mensagem_p <> 6) then 
		 
			begin 
 
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@CONTA',nr_interno_conta_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@ATENDIMENTO',nr_atendimento_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@DATALANCAMENTO',dt_atendimento_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@PACIENTE',nm_pessoa_fisica_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@CONVENIO',ds_convenio_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@QUANTIDADE',qt_material_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@FORNECEDOR',ds_fornecedor_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@DESCMAT',ds_material_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@CODMAT',cd_material_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@DESCFAMILIAMAT',ds_familia_mat_w),1,2000);
			ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w,'@ALTERACOES',ds_alteracoes_w),1,2000);
			 
			if (coalesce(ds_email_destino_w,'X') <> 'X') then 
 
				CALL enviar_email(	ds_assunto_w, 
						ds_mensagem_padrao_w, 
						null, 
						ds_email_destino_w, 
						nm_usuario_p, 
						'M');
			end if;
			end;
			 
			end if;
		end loop;
		close 	c01;
	end if;
 
	commit;
 
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_envio_email_material ( nr_sequencia_p bigint, cd_material_p bigint, ie_tipo_mensagem_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_alteracoes_p text) FROM PUBLIC;

