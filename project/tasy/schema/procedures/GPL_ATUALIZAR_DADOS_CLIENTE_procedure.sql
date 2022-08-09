-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpl_atualizar_dados_cliente ( nm_usuario_p text, nr_versao_p text, cd_unimed_p text, cd_carteira_cliente_p text, nm_cliente_p text, dt_nascimento_p text, lg_sexo_p text, cd_cpf_p text, nr_identidade_p text, ds_orgao_emissor_ident_p text, cd_uf_emissor_p text, dt_emissao_identidade_p text, ds_nacionalidade_p text, cd_pis_pasep_p text, cd_cartao_nacional_saude_p text, cd_estado_civil_p text, nm_mae_p text, nm_pai_p text, ds_rua_p text, ds_bairro_p text, cd_cidade_ibge_p text, nm_cidade_p text, nr_cep_p text, cd_uf_p text, nr_telefone1_p text, nr_telefone2_p text, ds_alerta_p text, ds_observacao_p text, cd_pessoa_fisica_p INOUT text) AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);		
cd_pessoa_fisica_sexo_w		varchar(10);	
cd_nacionalidade_w		varchar(255);
nr_sequencia_w			integer;
qt_compl_w			bigint;
qt_compl_mae_w			bigint;
qt_compl_pai_w			bigint;
ie_permite_cpf_duplicado_w		varchar(255);
qt_registro_w			bigint;
nr_pis_pasep_w			varchar(255);
nr_cartao_nac_sus_w		varchar(255);
cd_cidade_ibge_w			varchar(255);	
cd_estabelecimento_w estabelecimento.cd_estabelecimento%type;
			

BEGIN

select wheb_usuario_pck.get_cd_estabelecimento
into STRICT cd_estabelecimento_w
;

select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	pf_codigo_externo
where	ie_tipo_codigo_externo		= 'GPL'
and	cd_usuario_convenio		= cd_carteira_cliente_p
and	cd_pessoa_fisica_externo 		= cd_unimed_p
and (coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w);


if (coalesce(cd_pessoa_fisica_w::text, '') = '') then
	select	max(b.cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	pf_codigo_externo b,
		pessoa_fisica a
	where	b.cd_pessoa_fisica		= a.cd_pessoa_fisica
	and	b.ie_tipo_codigo_externo	= 'GPL'
	and	b.cd_pessoa_fisica_externo	= cd_unimed_p
	and (coalesce(b.cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w)
	and	upper(a.nm_pessoa_fisica)	= upper(nm_cliente_p)
	and	trunc(a.dt_nascimento, 'dd')	= trunc(to_date(dt_nascimento_p, 'yyyy-mm-dd'), 'dd')
	and	upper(a.ie_sexo)		= upper(lg_sexo_p)
	and	((a.nr_cpf			= trim(both cd_cpf_p)) or (coalesce(trim(both cd_cpf_p)::text, '') = ''));				
end if;

if (coalesce(cd_pessoa_fisica_w::text, '') = '') then
	select	max(a.cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	pessoa_fisica a
	where	upper(a.nm_pessoa_fisica)	= upper(nm_cliente_p)
	and	trunc(a.dt_nascimento, 'dd')	= trunc(to_date(dt_nascimento_p, 'yyyy-mm-dd'), 'dd')
	and	upper(a.ie_sexo)		= upper(lg_sexo_p)
	and	((a.nr_cpf			= trim(both cd_cpf_p)) or (coalesce(trim(both a.nr_cpf)::text, '') = ''));				
end if;

if (coalesce(cd_pessoa_fisica_w::text, '') = '') then

	select	max(a.cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_sexo_w
	from	pessoa_fisica a
	where	upper(a.nm_pessoa_fisica)	= upper(nm_cliente_p)
	and	trunc(a.dt_nascimento, 'dd')	= trunc(to_date(dt_nascimento_p, 'yyyy-mm-dd'), 'dd')
	and	upper(a.ie_sexo)		<> upper(lg_sexo_p)
	and	((a.nr_cpf			= trim(both cd_cpf_p)) or (coalesce(trim(both a.nr_cpf)::text, '') = ''));		

	if (cd_pessoa_fisica_sexo_w IS NOT NULL AND cd_pessoa_fisica_sexo_w::text <> '') then	
		CALL wheb_mensagem_pck.exibir_mensagem_abort(249686,'CD_PESSOA_FISICA_SEXO=' || cd_pessoa_fisica_sexo_w);
	end if;	

	ie_permite_cpf_duplicado_w := obter_param_usuario(5, 30, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_permite_cpf_duplicado_w);
	if (coalesce(ie_permite_cpf_duplicado_w,'N') = 'N') and (cd_cpf_p IS NOT NULL AND cd_cpf_p::text <> '') then	
		select	count(*)
		into STRICT	qt_registro_w
		from	pessoa_fisica
		where	nr_cpf = trim(both cd_cpf_p);
		
		if (qt_registro_w > 0) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(249687);
		end if;
	end if;

	select	nextval('pessoa_fisica_seq')
	into STRICT	cd_pessoa_fisica_w
	;
	
	select	max(nr_pis_pasep),
		max(nr_cartao_nac_sus)
	into STRICT	nr_pis_pasep_w,
		nr_cartao_nac_sus_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	insert into pessoa_fisica(
		cd_pessoa_fisica,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nm_pessoa_fisica,
		dt_nascimento,
		ie_sexo,
		nr_cpf,
		nr_identidade,
		ie_tipo_pessoa,
		ds_orgao_emissor_ci,
		nr_pis_pasep,
		nr_cartao_nac_sus,
		ie_estado_civil,
		ds_observacao)
	values (cd_pessoa_fisica_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_cliente_p,
		to_date(dt_nascimento_p, 'yyyy-mm-dd'),
		lg_sexo_p,
		substr(cd_cpf_p,1,11),
		substr(nr_identidade_p,1,15),
		1,
		substr(ds_orgao_emissor_ident_p,1,40),
		coalesce(cd_pis_pasep_p,nr_pis_pasep_w),
		coalesce(cd_cartao_nacional_saude_p,nr_cartao_nac_sus_w),
		--nvl(to_number(cd_estado_civil_p),0),
		coalesce(CASE WHEN (cd_estado_civil_p)::numeric =5 THEN 3 WHEN (cd_estado_civil_p)::numeric =3 THEN 5 WHEN (cd_estado_civil_p)::numeric =4 THEN 6  ELSE (cd_estado_civil_p)::numeric  END ,0),
		substr(ds_observacao_p,1,2000));
	
	CALL gera_pf_codigo_externo_gpl(cd_pessoa_fisica_w,cd_unimed_p,cd_carteira_cliente_p,nm_usuario_p);	
	
else

	update	pessoa_fisica set
		nm_pessoa_fisica		= substr(nm_cliente_p,1,60),
		dt_nascimento		= to_date(dt_nascimento_p,'yyyy-mm-dd'),
		ie_sexo			= substr(lg_sexo_p,1,1),
		nr_cpf			= substr(cd_cpf_p,1,11),
		nr_identidade		= substr(nr_identidade_p,1,15),
		ds_orgao_emissor_ci	= substr(ds_orgao_emissor_ident_p,1,40),
		dt_emissao_ci		= to_date(dt_emissao_identidade_p,'yyyy-mm-dd'),
		nr_pis_pasep		= coalesce(cd_pis_pasep_p,nr_pis_pasep),
		nr_cartao_nac_sus		= coalesce(cd_cartao_nacional_saude_p,nr_cartao_nac_sus),
   		ie_estado_civil		= coalesce((cd_estado_civil_p)::numeric ,0),
		ds_observacao		= substr(ds_observacao_p,1,2000)
	where	cd_pessoa_fisica		= cd_pessoa_fisica_w;
	
	CALL gera_pf_codigo_externo_gpl(cd_pessoa_fisica_w,cd_unimed_p,cd_carteira_cliente_p,nm_usuario_p);	

end if;

if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then

	if (nm_mae_p IS NOT NULL AND nm_mae_p::text <> '') then

		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
		
		select	count(*)
		into STRICT	qt_compl_mae_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica 		= cd_pessoa_fisica_w
		and	ie_tipo_complemento 	= 5;
		
		if (qt_compl_mae_w > 0) then			
			update	compl_pessoa_fisica
			set	nm_contato		= substr(nm_mae_p,1,60)
			where	cd_pessoa_fisica 		= cd_pessoa_fisica_w
			and	ie_tipo_complemento 	= 5;			
		else		
			insert into compl_pessoa_fisica(nr_sequencia,
				cd_pessoa_fisica,
				ie_tipo_complemento,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nm_usuario,
				dt_atualizacao,
				nm_contato)
			values (nr_sequencia_w,
				cd_pessoa_fisica_w,
				5,
				'GPL',
				clock_timestamp(),
				'GPL',
				clock_timestamp(),
				substr(nm_mae_p,1,60));				
		end if;
	end if;

	if (nm_pai_p IS NOT NULL AND nm_pai_p::text <> '') then

		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

		select	count(*)
		into STRICT	qt_compl_pai_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica 		= cd_pessoa_fisica_w
		and	ie_tipo_complemento 	= 4;
		
		if (qt_compl_pai_w > 0) then			
			update	compl_pessoa_fisica
			set	nm_contato		= substr(nm_pai_p,1,60)
			where	cd_pessoa_fisica 		= cd_pessoa_fisica_w
			and	ie_tipo_complemento 	= 4;			
		else		
			insert into compl_pessoa_fisica(nr_sequencia,
				cd_pessoa_fisica,
				ie_tipo_complemento,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nm_usuario,
				dt_atualizacao,
				nm_contato)
			values (nr_sequencia_w,
				cd_pessoa_fisica_w,
				4,
				'GPL',
				clock_timestamp(),
				'GPL',
				clock_timestamp(),
				substr(nm_pai_p,1,60));	
		end if;
	end if;
	
end if;
	
select	count(*)
into STRICT	qt_compl_w
from	compl_pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_w
and	ie_tipo_complemento = 1;
	
select	max(cd_municipio_ibge)
into STRICT	cd_cidade_ibge_w
from	sus_municipio
where	cd_municipio_ibge = cd_cidade_ibge_p;
	
if (qt_compl_w > 0) then
	
	if (cd_cidade_ibge_w IS NOT NULL AND cd_cidade_ibge_w::text <> '') and (coalesce(cd_cidade_ibge_p,0) <> 0) then -- afstringari 244117
		update compl_pessoa_fisica set
			ds_endereco 		= substr(ds_rua_p,1,40),
			ds_bairro 			= substr(ds_bairro_p,1,40),
			cd_municipio_ibge 		= substr(cd_cidade_ibge_p,1,6),
			ds_municipio 		= substr(nm_cidade_p,1,40),
			cd_cep 			= substr(nr_cep_p,1,15),
			sg_estado 		= substr(cd_uf_p,1,2),
			nr_telefone 		= substr(nr_telefone1_p,1,15)
		where	cd_pessoa_fisica 		= cd_pessoa_fisica_w
		and	ie_tipo_complemento		= 1;		
	else
		update compl_pessoa_fisica set
			ds_endereco 		= substr(ds_rua_p,1,40),
			ds_bairro 			= substr(ds_bairro_p,1,40),
			ds_municipio 		= substr(nm_cidade_p,1,40),
			cd_cep 			= substr(nr_cep_p,1,15),
			sg_estado 		= substr(cd_uf_p,1,2),
			nr_telefone 		= substr(nr_telefone1_p,1,15)
		where	cd_pessoa_fisica 		= cd_pessoa_fisica_w
		and	ie_tipo_complemento		= 1;				
	end if;

else	
	/* afstringari 244117
	if	((ds_rua_p is not null) or (ds_bairro_p is not null) or (cd_cidade_ibge_p is not null) or  
		(nm_cidade_p is not null) or (nr_cep_p is not null) or (cd_uf_p is not null) or (nr_telefone1_p is not null)) then */
		
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;		
		
		if (cd_cidade_ibge_w IS NOT NULL AND cd_cidade_ibge_w::text <> '') and (coalesce(cd_cidade_ibge_p,0) <> 0) then -- afstringari 244117
			insert into compl_pessoa_fisica(nr_sequencia,
				cd_pessoa_fisica,
				ie_tipo_complemento,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nm_usuario,
				dt_atualizacao,
				ds_endereco,
				ds_bairro,
				cd_municipio_ibge,
				ds_municipio,
				cd_cep,
				sg_estado,
				nr_telefone)
			values (nr_sequencia_w,
				cd_pessoa_fisica_w,
				1,
				'GPL',
				clock_timestamp(),
				'GPL',
				clock_timestamp(),
				substr(ds_rua_p,1,40),
				substr(ds_bairro_p,1,40),
				substr(cd_cidade_ibge_p,1,6),
				substr(nm_cidade_p,1,40),
				substr(nr_cep_p,1,15),
				substr(cd_uf_p,1,2),
				substr(nr_telefone1_p,1,15));
		else
			insert into compl_pessoa_fisica(nr_sequencia,
				cd_pessoa_fisica,
				ie_tipo_complemento,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nm_usuario,
				dt_atualizacao,
				ds_endereco,
				ds_bairro,				
				ds_municipio,
				cd_cep,
				sg_estado,
				nr_telefone)
			values (nr_sequencia_w,
				cd_pessoa_fisica_w,
				1,
				'GPL',
				clock_timestamp(),
				'GPL',
				clock_timestamp(),
				substr(ds_rua_p,1,40),
				substr(ds_bairro_p,1,40),
				substr(nm_cidade_p,1,40),
				substr(nr_cep_p,1,15),
				substr(cd_uf_p,1,2),
				substr(nr_telefone1_p,1,15));		
		end if;

	--end if;
	
end if;

commit;

cd_pessoa_fisica_p	:= cd_pessoa_fisica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpl_atualizar_dados_cliente ( nm_usuario_p text, nr_versao_p text, cd_unimed_p text, cd_carteira_cliente_p text, nm_cliente_p text, dt_nascimento_p text, lg_sexo_p text, cd_cpf_p text, nr_identidade_p text, ds_orgao_emissor_ident_p text, cd_uf_emissor_p text, dt_emissao_identidade_p text, ds_nacionalidade_p text, cd_pis_pasep_p text, cd_cartao_nacional_saude_p text, cd_estado_civil_p text, nm_mae_p text, nm_pai_p text, ds_rua_p text, ds_bairro_p text, cd_cidade_ibge_p text, nm_cidade_p text, nr_cep_p text, cd_uf_p text, nr_telefone1_p text, nr_telefone2_p text, ds_alerta_p text, ds_observacao_p text, cd_pessoa_fisica_p INOUT text) FROM PUBLIC;
