-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_simulacao_contrato ( nr_seq_contrato_p bigint, nr_seq_grupo_contrato_p bigint, nr_seq_parametro_com_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ie_tipo_contratacao_w		varchar(2);
cd_pessoa_fisica_w		varchar(10);
nm_segurado_w			varchar(60);
ds_idade_w			varchar(3);
nr_seq_simulacao_w		bigint;
nr_seq_titular_w		bigint;
ie_tipo_benef_w			varchar(1);
nr_seq_plano_benef_w		bigint;
nr_seq_tabela_benef_w		bigint;
qt_beneficiario_w		integer	:= 0;
nr_seq_simulpreco_coletivo_w	bigint;
nm_estipulante_w		varchar(255);
nr_ddd_telefone_w		varchar(3);
nr_ddi_telefone_w		varchar(3);
dt_nascimento_w			timestamp;
nr_telefone_w			varchar(15);
sg_uf_w				pessoa_juridica.sg_estado%type;
cd_municipio_w			varchar(6);
ds_email_w			varchar(60);
nr_contrato_w			bigint;
nr_seq_simulcoletivo_w		bigint;
nr_seq_simulindividual_w	bigint;
nr_seq_parentesco_w		bigint;
nr_seq_parametro_com_w		bigint;
cd_cgc_w			pessoa_juridica.cd_cgc%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
nr_seq_grupo_contrato_w		pls_grupo_contrato.nr_sequencia%type;

C01 CURSOR FOR 
	SELECT	cd_pessoa_fisica, 
		coalesce(nr_seq_titular,0), 
		nr_seq_plano, 
		nr_seq_tabela, 
		nr_seq_parentesco 
	from	pls_segurado 
	where	nr_seq_contrato	= nr_seq_contrato_w 
	and	(nr_seq_plano IS NOT NULL AND nr_seq_plano::text <> '') 
	order by nr_sequencia;

C02 CURSOR FOR 
	SELECT	count(*) qt_beneficiario, 
		substr(obter_idade(dt_nascimento, clock_timestamp(), 'A'),1,3) ds_idade 
	from	pessoa_fisica	b, 
		pls_segurado 	a 
	where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
	and	a.nr_seq_contrato	= nr_seq_contrato_w 
	group by 
		obter_idade(dt_nascimento, clock_timestamp(), 'A') 
	
union all
 
	SELECT	count(*) qt_beneficiario, 
		substr(obter_idade(dt_nascimento, clock_timestamp(), 'A'),1,3) ds_idade 
	from	pessoa_fisica	b, 
		pls_segurado 	a, 
		pls_contrato_grupo c 
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica 
	and	a.nr_seq_contrato	= c.nr_seq_contrato 
	and	c.nr_seq_grupo 		= nr_seq_grupo_contrato_w 
	group by 
		obter_idade(dt_nascimento, clock_timestamp(), 'A');

C03 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_simulpreco_coletivo 
	where	nr_seq_simulacao	= nr_seq_simulacao_w 
	order by nr_sequencia;

C04 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_simulpreco_individual 
	where	nr_seq_simulacao	= nr_seq_simulacao_w 
	order by nr_sequencia;

C05 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_plano, 
		nr_seq_tabela 
	from	pls_sca_regra_contrato 
	where	nr_seq_contrato	= nr_seq_contrato_w 
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());

C06 CURSOR FOR 
	SELECT	nr_seq_bonificacao, 
		tx_bonificacao, 
		vl_bonificacao 
	from	pls_bonificacao_vinculo 
	where	nr_seq_contrato	= nr_seq_contrato_w 
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp()) 
	
union all
 
	SELECT	nr_seq_bonificacao, 
		tx_bonificacao, 
		vl_bonificacao 
	from	pls_bonificacao_vinculo 
	where	nr_seq_grupo_contrato	= nr_seq_grupo_contrato_w 
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());

BEGIN 
 
if (coalesce(nr_seq_contrato_p, 0) = 0) then 
	nr_seq_contrato_w	:= null;
else 
	nr_seq_contrato_w	:= nr_seq_contrato_p;
end if;
 
if (coalesce(nr_seq_grupo_contrato_p, 0) = 0) then 
	nr_seq_grupo_contrato_w	:= null;
else 
	nr_seq_grupo_contrato_w	:= nr_seq_grupo_contrato_p;
end if;
 
if (nr_seq_grupo_contrato_w IS NOT NULL AND nr_seq_grupo_contrato_w::text <> '') then 
	select	max(cd_cgc) 
	into STRICT	cd_cgc_w 
	from	pls_grupo_contrato 
	where	nr_sequencia = nr_seq_grupo_contrato_w;
	 
	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
		select	substr(obter_dados_pf_pj(null, cd_cgc_w,'N'),1,255), 
			substr(obter_dados_pf_pj(null, cd_cgc_w,'DDT'),1,3), 
			substr(obter_dados_pf_pj(null, cd_cgc_w,'DIT'),1,3), 
			substr(obter_dados_pf_pj(null, cd_cgc_w,'T'),1,15), 
			substr(obter_dados_pf_pj(null, cd_cgc_w,'UF'),1,2), 
			substr(obter_dados_pf_pj(null, cd_cgc_w,'CDM'),1,6), 
			substr(obter_dados_pf_pj(null, cd_cgc_w,'M'),1,60) 
		into STRICT	nm_estipulante_w, 
			nr_ddd_telefone_w, 
			nr_ddi_telefone_w, 
			nr_telefone_w, 
			sg_uf_w, 
			cd_municipio_w, 
			ds_email_w 
		;
	else 
		nm_estipulante_w	:= null;
		nr_ddd_telefone_w	:= null;
		nr_ddi_telefone_w	:= null;
		nr_telefone_w		:= null;
		dt_nascimento_w		:= null;
		sg_uf_w			:= null;
		cd_municipio_w		:= null;
		ds_email_w		:= null;
	end if;
 
	ie_tipo_contratacao_w := 'CE';
else 
	select	max(ie_tipo_contratacao) 
	into STRICT	ie_tipo_contratacao_w 
	from	pls_contrato_plano	a, 
		pls_plano b 
	where	b.nr_sequencia		= a.nr_seq_plano 
	and	a.nr_seq_contrato	= nr_seq_contrato_w;
	 
	select	substr(obter_dados_pf_pj(cd_pf_estipulante, cd_cgc_estipulante,'N'),1,255), 
		substr(obter_dados_pf_pj(cd_pf_estipulante, cd_cgc_estipulante,'DDT'),1,3), 
		substr(obter_dados_pf_pj(cd_pf_estipulante, cd_cgc_estipulante,'DIT'),1,3), 
		substr(obter_dados_pf_pj(cd_pf_estipulante, cd_cgc_estipulante,'T'),1,15), 
		substr(obter_dados_pf(cd_pf_estipulante,'DN'),1,10), 
		substr(obter_dados_pf_pj(cd_pf_estipulante, cd_cgc_estipulante,'UF'),1,2), 
		substr(obter_dados_pf_pj(cd_pf_estipulante, cd_cgc_estipulante,'CDM'),1,6), 
		substr(obter_dados_pf_pj(cd_pf_estipulante, cd_cgc_estipulante,'M'),1,60), 
		nr_contrato 
	into STRICT	nm_estipulante_w, 
		nr_ddd_telefone_w, 
		nr_ddi_telefone_w, 
		nr_telefone_w, 
		dt_nascimento_w, 
		sg_uf_w, 
		cd_municipio_w, 
		ds_email_w, 
		nr_contrato_w 
	from	pls_contrato 
	where	nr_sequencia	= nr_seq_contrato_w;
end if;
 
if (coalesce(nr_seq_parametro_com_p,0) > 0) then 
	nr_seq_parametro_com_w	:= nr_seq_parametro_com_p;
else 
	nr_seq_parametro_com_w	:= null;
end if;
 
select	nextval('pls_simulacao_preco_seq') 
into STRICT	nr_seq_simulacao_w
;
 
insert into pls_simulacao_preco(nr_sequencia, 
	cd_estabelecimento, 
	ie_tipo_contratacao, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	vl_simulacao, 
	nr_seq_contrato, 
	dt_simulacao, 
	nm_pessoa, 
	dt_nascimento, 
	nr_ddi, 
	nr_ddd, 
	nr_telefone, 
	cd_municipio_ibge, 
	sg_estado, 
	ds_email, 
	nr_contrato, 
	nr_seq_parametro_com, 
	nr_seq_grupo_contrato) 
values (	nr_seq_simulacao_w, 
	cd_estabelecimento_p, 
	ie_tipo_contratacao_w, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	0, 
	nr_seq_contrato_w, 
	clock_timestamp(), 
	nm_estipulante_w, 
	dt_nascimento_w, 
	nr_ddi_telefone_w, 
	nr_ddd_telefone_w, 
	nr_telefone_w, 
	cd_municipio_w, 
	sg_uf_w, 
	ds_email_w, 
	nr_contrato_w, 
	nr_seq_parametro_com_w, 
	nr_seq_grupo_contrato_w);
 
for r_c05_w in C05 loop 
	begin 
	insert into pls_sca_vinculo(	nr_sequencia, nr_seq_simulacao, nr_seq_plano, nr_seq_tabela, 
			dt_atualizacao, dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec) 
		values (	nextval('pls_sca_vinculo_seq'), nr_seq_simulacao_w, r_c05_w.nr_seq_plano, r_c05_w.nr_seq_tabela, 
			clock_timestamp(), clock_timestamp(), nm_usuario_p, nm_usuario_p);
	end;
end loop;
 
for r_c06_w in C06 loop 
	begin 
	insert into pls_bonificacao_vinculo(	nr_sequencia, nr_seq_simulacao, nr_seq_bonificacao, 
			tx_bonificacao, vl_bonificacao, dt_atualizacao, 
			dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec) 
		values (	nextval('pls_bonificacao_vinculo_seq'), nr_seq_simulacao_w, r_c06_w.nr_seq_bonificacao, 
			r_c06_w.tx_bonificacao, r_c06_w.vl_bonificacao, clock_timestamp(), 
			clock_timestamp(), nm_usuario_p, nm_usuario_p);
	end;
end loop;
 
if (ie_tipo_contratacao_w	= 'I') then 
	open C01;
	loop 
	fetch C01 into 
		cd_pessoa_fisica_w, 
		nr_seq_titular_w, 
		nr_seq_plano_benef_w, 
		nr_seq_tabela_benef_w, 
		nr_seq_parentesco_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		select	nm_pessoa_fisica, 
			substr(obter_idade(dt_nascimento, clock_timestamp(), 'A'),1,3), 
			dt_nascimento 
		into STRICT	nm_segurado_w, 
			ds_idade_w, 
			dt_nascimento_w 
		from	pessoa_fisica 
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
		 
		if (nr_seq_titular_w	= 0) then 
			ie_tipo_benef_w	:= 'T';
		else 
			ie_tipo_benef_w	:= 'D';
		end if;
		 
		insert into pls_simulpreco_individual(nr_sequencia, 
			nr_seq_simulacao, 
			qt_idade, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nm_beneficiario, 
			ie_tipo_benef, 
			vl_mensalidade, 
			nr_seq_produto, 
			nr_seq_tabela, 
			nr_seq_parentesco, 
			dt_nascimento, 
			cd_pessoa_fisica) 
		values (	nextval('pls_simulpreco_individual_seq'), 
			nr_seq_simulacao_w, 
			ds_idade_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nm_segurado_w, 
			ie_tipo_benef_w, 
			0, 
			nr_seq_plano_benef_w, 
			nr_seq_tabela_benef_w, 
			nr_seq_parentesco_w, 
			dt_nascimento_w, 
			cd_pessoa_fisica_w);
		end;
	end loop;
	close C01;
	CALL pls_recalcular_simulacao(nr_seq_simulacao_w, nm_usuario_p);
	--Gerar o resumo da simulação individual 
	open C04;
	loop 
	fetch C04 into 
		nr_seq_simulindividual_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin 
		CALL pls_gerar_resumo_simulacao(nr_seq_simulacao_w,nr_seq_simulindividual_w,'I','BS','I',cd_estabelecimento_p,nm_usuario_p);
		end;
	end loop;
	close C04;
 
elsif (ie_tipo_contratacao_w	<> 'I') then 
	CALL pls_gerar_simul_perfil_aut(nr_seq_simulacao_w, cd_estabelecimento_p, nm_usuario_p);
	CALL pls_gerar_faixa_etaria_simul(nr_seq_simulacao_w, nm_usuario_p);
	open C02;
	loop 
	fetch C02 into 
		qt_beneficiario_w, 
		ds_idade_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		select	max(a.nr_sequencia) 
		into STRICT	nr_seq_simulpreco_coletivo_w 
		from	pls_simulpreco_coletivo a, 
			pls_simulacao_perfil b, 
			pls_simul_regra_perfil c 
		where	b.nr_sequencia 		= a.nr_seq_simul_perfil 
		and	c.nr_sequencia		= b.nr_seq_regra_perfil 
		and	c.ie_contrato_existente = 'S' 
		and	a.nr_seq_simulacao	= nr_seq_simulacao_w 
		and	ds_idade_w between a.qt_idade_inicial and a.qt_idade_final;
		 
		if (coalesce(nr_seq_simulpreco_coletivo_w::text, '') = '') then 
			select	max(nr_sequencia) 
			into STRICT	nr_seq_simulpreco_coletivo_w 
			from	pls_simulpreco_coletivo 
			where	nr_seq_simulacao	= nr_seq_simulacao_w 
			and	ds_idade_w between qt_idade_inicial and qt_idade_final;
		end if;
		 
		if (nr_seq_simulpreco_coletivo_w IS NOT NULL AND nr_seq_simulpreco_coletivo_w::text <> '') then 
			update	pls_simulpreco_coletivo 
			set	qt_beneficiario	= coalesce(qt_beneficiario, 0) + qt_beneficiario_w 
			where	nr_sequencia	= nr_seq_simulpreco_coletivo_w;
		end if;
		end;
	end loop;
	close C02;
	--Gerar o resumo da simulação coletiva 
	open C03;
	loop 
	fetch C03 into 
		nr_seq_simulcoletivo_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		CALL pls_gerar_resumo_simulacao(nr_seq_simulacao_w,nr_seq_simulcoletivo_w,'I','BS','CA',cd_estabelecimento_p,nm_usuario_p);
		end;
	end loop;
	close C03;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_simulacao_contrato ( nr_seq_contrato_p bigint, nr_seq_grupo_contrato_p bigint, nr_seq_parametro_com_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

