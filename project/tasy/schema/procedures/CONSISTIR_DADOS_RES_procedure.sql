-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_dados_res ( nr_atendimento_p bigint, nm_usuario_solic_p text, ds_retorno_p INOUT text) AS $body$
DECLARE



cd_estabelecimento_w	atendimento_paciente.cd_estabelecimento%type;
cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%type;
cd_medico_resp_w		varchar(255);
ds_medico_resp_w		varchar(255);
ie_medico_w				varchar(1);
ie_consentimento_w		varchar(1);
ds_retorno_w			varchar(4000) := '';
ie_conversao_w			varchar(4) := 'N';

-- Credenciais
ds_login_w					credenciais_integracao.ds_login%type;
ds_senha_w					credenciais_integracao.ds_senha%type;
ds_endereco_certificado_w	credenciais_integracao.ds_endereco_certificado%type;
ds_senha_certificado_w		credenciais_integracao.ds_senha_certificado%type;
ie_caminho_certificado_w	varchar(1);


--Estabelecimento
cd_cns_w				estabelecimento.cd_cns%type;
nm_fantasia_estab_w		estabelecimento.nm_fantasia_estab%type;
cd_cgc_w				estabelecimento.cd_cgc%type;

--Carteirinha
cd_usuario_convenio_w	atend_categoria_convenio.cd_usuario_convenio%type;
cd_convenio_w			atend_categoria_convenio.cd_convenio%type;


--Dados dos documentos do paciente
nr_identidade_w				pessoa_fisica.nr_identidade%type;
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
nr_seq_pais_w				pessoa_fisica.nr_seq_pais%type;
cd_codigo_pais_w			integer;


--Dados do paciente
nr_cpf_w					pessoa_fisica.nr_cpf%type;
dt_nascimento_w				pessoa_fisica.dt_nascimento%type;
nm_mae_w					varchar(255);
ie_sexo_w					pessoa_fisica.ie_sexo%type;
ie_estado_civil_w			pessoa_fisica.ie_estado_civil%type;
cd_nacionalidade_w			pessoa_fisica.cd_nacionalidade%type;
ie_grau_instrucao_w			pessoa_fisica.ie_grau_instrucao%type;
nr_seq_cor_pele_w			pessoa_fisica.nr_seq_cor_pele%type;
cd_tipo_logradouro_w		varchar(255);
ds_endereco_w				varchar(255);
nr_endereco_w				varchar(255);
sg_estado_w					varchar(255);
nr_municipio_ibge_nasc_1_w	varchar(255);
nr_municipio_ibge_nasc_2_w	varchar(255);


-- Contatos do paciente
ds_tel_cel_pf_w				varchar(255);
ds_email_w					compl_pessoa_fisica.ds_email%type;


-- Dados dos contatos emergenciais
nr_seq_parentesco_w			compl_pessoa_fisica.nr_seq_parentesco%type;
nm_contato_emergencia_w		varchar(255);

C01 CURSOR FOR
	SELECT	max(nr_ddi_celular || nr_ddd_celular || nr_telefone),
			max(ds_email),
			max(ds_endereco),
			max(nr_endereco),
			max(cd_municipio_ibge || calcula_digito('MODULO10',cd_municipio_ibge)),
			max(sg_estado),
			max(cd_tipo_logradouro),
			max(nr_seq_pais),
			max(nr_seq_parentesco),
			max(coalesce(obter_nome_pf(cd_pessoa_fisica_ref),nm_contato))
    from    compl_pessoa_fisica
    where   cd_pessoa_fisica = cd_pessoa_fisica_w
    and     ie_tipo_complemento not in (1,2,8)
	order by nm_contato, cd_pessoa_fisica_ref;


-- Dados do requisitante
cd_pf_usuario_w			varchar(10);
nr_cpf_solic_w			pessoa_fisica.nr_cpf%type;
nr_uf_crm_w				medico.uf_crm%type;
nr_crm_w				varchar(255);
nr_seq_conselho_w		pessoa_fisica.nr_seq_conselho%type;


			procedure gerar_situacao_res( 	ds_motivo_p				text,
											ds_mensagem_p			text,
											cd_funcao_p				bigint,
											ds_aba_p				text,
											cd_expressao_campo_p	bigint,
											nm_tabela_p				text,
											nm_atributo_p			text,
											nm_tabela_conv_p		text := null,
											nm_atributo_conver_p	text := null,
											ds_codigo_externo_p		text := null) is
			;
BEGIN


			ds_retorno_w := substr(ds_retorno_w || chr(10)||chr(10)|| upper(ds_motivo_p) || chr(10)||
							obter_desc_expressao(293478)||': '|| ds_mensagem_p ||chr(10)|| 	-- Motivo
							obter_desc_expressao(290509)||': '|| obter_desc_funcao(cd_funcao_p) ||chr(10)|| 	-- Função
							obter_desc_expressao(492083)||': '|| ds_aba_p || chr(10)|| 	-- Abas
							obter_desc_expressao(284485)||': '|| obter_desc_expressao(cd_expressao_campo_p)||chr(10)|| 	-- Campo
							obter_desc_expressao(299004)||': '|| nm_tabela_p ||chr(10)|| 	-- Tabela
							obter_desc_expressao(283919)||': '|| nm_atributo_p ||chr(10),1,4000); 	-- Atributo
		    if (nm_tabela_conv_p IS NOT NULL AND nm_tabela_conv_p::text <> '') then

				ds_retorno_w := substr(ds_retorno_w || obter_desc_expressao(294257)||': '|| nm_tabela_conv_p ||chr(10)|| 	--  Nome tabela
								obter_desc_expressao(294179)||': '|| nm_atributo_conver_p ||chr(10) || -- Nome atributo
								obter_desc_expressao(285409)||': '|| ds_codigo_externo_p ||chr(10),1,4000); -- Código interno
			end if;

			end;


begin

if (nr_atendimento_p > 0) then

	select   max(cd_estabelecimento) ,
			 max(cd_pessoa_fisica),
			 max(obter_medico_resp_atend(nr_atendimento,'C')),
			 max(obter_medico_resp_atend(nr_atendimento,'N')),
			 max(obter_se_usuario_medico(nm_usuario_solic_p))
	into STRICT	cd_estabelecimento_w,
			cd_pessoa_fisica_w,
			cd_medico_resp_w,
			ds_medico_resp_w,
			ie_medico_w
	from    atendimento_paciente
	where   nr_atendimento = nr_atendimento_p;



-- Dados da integração
	select 	 MAX(ds_login),
             MAX(ds_senha),
             MAX(ds_endereco_certificado),
             MAX(ds_senha_certificado)
	into STRICT	 ds_login_w,
			 ds_senha_w,
			 ds_endereco_certificado_w,
			 ds_senha_certificado_w
    from     credenciais_integracao
    where    ie_sistema = 'RESUnimed'
    and      (ds_senha IS NOT NULL AND ds_senha::text <> '');

	if (   coalesce(trim(both ds_login_w)::text, '') = '' ) then

		gerar_situacao_res('Credenciais para integração','Falta informar o usuário na credencial da integração',3001,
							obter_desc_expressao(298543)||' -> '||obter_desc_expressao(292128)||' -> '||obter_desc_expressao(334692),
							300907,'CREDENCIAIS_INTEGRACAO','DS_LOGIN');

	end if;

	if (   coalesce(trim(both ds_senha_w)::text, '') = '' ) then

		gerar_situacao_res('Credenciais para integração','Falta informar a senha na credencial da integração',3001,
							obter_desc_expressao(298543)||' -> '||obter_desc_expressao(292128)||' -> '||obter_desc_expressao(334692),
							298137,'CREDENCIAIS_INTEGRACAO','DS_SENHA');

	end if;

	if (   coalesce(trim(both ds_endereco_certificado_w)::text, '') = '' ) then

		gerar_situacao_res('Credenciais para integração','Falta informar o endereço do certificado na credencial da integração',3001,
							obter_desc_expressao(298543)||' -> '||obter_desc_expressao(292128)||' -> '||obter_desc_expressao(334692),
							284480,'CREDENCIAIS_INTEGRACAO','DS_ENDERECO_CERTIFICADO');

	else

		select 	 coalesce(max('S'),'N')
		into STRICT	 ie_caminho_certificado_w
		from     credenciais_integracao
		where    ie_sistema = 'RESUnimed'
		and      (ds_endereco_certificado IS NOT NULL AND ds_endereco_certificado::text <> '')
		and	 	ds_endereco_certificado like('%philipsCacerts');

		if (   ie_caminho_certificado_w = 'N') then

		gerar_situacao_res('Credenciais para integração','No endereço do certificado falta o arquivo \philipsCacerts. Obs: em servidor Linux é sensitive.',3001,
							obter_desc_expressao(298543)||' -> '||obter_desc_expressao(292128)||' -> '||obter_desc_expressao(334692),
							284480,'CREDENCIAIS_INTEGRACAO','DS_ENDERECO_CERTIFICADO');

		end if;


	end if;

	if (   coalesce(trim(both ds_senha_certificado_w)::text, '') = '' ) then

		gerar_situacao_res('Credenciais para integração','Falta informar a senha do certificado na credencial da integração',3001,
							obter_desc_expressao(298543)||' -> '||obter_desc_expressao(292128)||' -> '||obter_desc_expressao(334692),
							298141,'CREDENCIAIS_INTEGRACAO','DS_SENHA_CERTIFICADO');

	end if;

-- Dados do estabelecimento
	select  max(cd_cns),
			max(nm_fantasia_estab),
			max(cd_cgc)
	into STRICT	cd_cns_w,
			nm_fantasia_estab_w,
			cd_cgc_w
	from    estabelecimento
	where   cd_estabelecimento = cd_estabelecimento_w;

	if (   coalesce(trim(both cd_cns_w)::text, '') = '' ) then

		gerar_situacao_res('Estabelecimento','O estabelecimento não possui o código de CNS informado',911,
							obter_desc_expressao(289182)||' -> '||obter_desc_expressao(289496),
							285253,'ESTABELECIMENTO','CD_CNS');

	end if;

	if (   coalesce(trim(both nm_fantasia_estab_w)::text, '') = '' ) then

		gerar_situacao_res('Estabelecimento','O estabelecimento não possui o nome fantasia informado',911,
							obter_desc_expressao(289182)||' -> '||obter_desc_expressao(289496),
							294219,'ESTABELECIMENTO','NM_FANTASIA_ESTAB');

	end if;

	if (   coalesce(trim(both cd_cgc_w)::text, '') = '' ) then

		gerar_situacao_res('Estabelecimento','O estabelecimento não possui o CNPJ informado',911,
							obter_desc_expressao(289182)||' -> '||obter_desc_expressao(289496),
							285188,'ESTABELECIMENTO','CD_CGC');

	end if;

-- Dados da carteirinha do paciente
	select  max(cd_usuario_convenio),
			max(cd_convenio)
	into STRICT	cd_usuario_convenio_w,
			cd_convenio_w
    from    atend_categoria_convenio
    where   nr_atendimento = nr_atendimento_p;

	Select 	coalesce(max('S'),'N')
	into STRICT	ie_conversao_w
	from	conversao_meio_externo
	where	nm_tabela = 'ATEND_CATEGORIA_CONVENIO'
	and		nm_atributo = 'CD_CONVENIO'
	and		upper(cd_interno) =  upper(cd_convenio_w)
	and		trim(both cd_externo) = 'RESUNIMED'
	and		ie_sistema_externo = 'TERUNIMED16';

	if (   coalesce(trim(both cd_usuario_convenio_w)::text, '') = ''  ) then

		gerar_situacao_res('Carteirinha','O convênio do paciente não faz parte do envio para o RES',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','ATEND_CATEGORIA_CONVENIO','CD_CONVENIO',upper(cd_convenio_w));

	end if;

	if (   coalesce(trim(both cd_usuario_convenio_w)::text, '') = ''  ) then

		gerar_situacao_res('Carteirinha','O paciente não possui o código do beneficiário informado',916,
							obter_desc_expressao(302642)||' -> '||obter_desc_expressao(282915) ||' -> '||obter_desc_expressao(303209),
							586257,'ATEND_CATEGORIA_CONVENIO','CD_USUARIO_CONVENIO');

	end if;

-- Dados do consentimento do paciente
	SELECT  coalesce(MAX('S'),'N')
	into STRICT	ie_consentimento_w
	FROM    pep_pac_ci A,
			pep_pac_ci_anexo B
	WHERE   A.NR_SEQUENCIA = B.NR_SEQ_PAC_CI
	AND     A.CD_PESSOA_FISICA = cd_pessoa_fisica_w
	AND     (A.DT_LIBERACAO IS NOT NULL AND A.DT_LIBERACAO::text <> '')
	AND     coalesce(A.DT_INATIVACAO::text, '') = ''
	AND     A.IE_TIPO_CONSENTIMENTO = 'L';

	if (   ie_consentimento_w = 'N' ) then

		gerar_situacao_res('Consentimento','O paciente não possui anexo de consentimento',5,
							obter_desc_expressao(285718)||' -> '||obter_desc_expressao(307906),283764,'PEP_PAC_CI_ANEXO','DS_ARQUIVO');

	end if;

-- Documentos do paciente
	select  max(nr_identidade),
			max(ds_orgao_emissor_ci||sg_emissora_ci),
			max(nr_seq_pais)
	into STRICT	nr_identidade_w,
			ds_orgao_emissor_ci_w,
			nr_seq_pais_w
    from    pessoa_fisica a
    where   a.cd_pessoa_fisica = cd_pessoa_fisica_w;

	if (   coalesce(trim(both nr_identidade_w)::text, '') = ''  ) then

		gerar_situacao_res('Documentos do paciente','O paciente não possui o código de identidade informado',5,
							obter_desc_expressao(320845),
							645768,'PESSOA_FISICA','NR_IDENTIDADE');

	end if;

	if (   coalesce(trim(both ds_orgao_emissor_ci_w)::text, '') = ''  ) then

		gerar_situacao_res('Documentos do paciente','O paciente não possui o orgão emissor da identidade informado',5,
							obter_desc_expressao(320845),
							294884,'PESSOA_FISICA','DS_ORGAO_EMISSOR_CI');

	end if;


	if (   coalesce(trim(both nr_seq_pais_w)::text, '') = ''  ) then

		gerar_situacao_res('Documentos do paciente','O paciente não possui o país informado',5,
							obter_desc_expressao(320845),
							295224,'PESSOA_FISICA','NR_SEQ_PAIS');

	else

		Select  (cd_codigo_pais)::numeric
		into STRICT	cd_codigo_pais_w
		from	pais
		where	nr_sequencia = nr_seq_pais_w;


		Select 	coalesce(max('S'),'N')
		into STRICT	ie_conversao_w
		from	conversao_meio_externo
		where	nm_tabela = 'PAIS'
		and		nm_atributo = 'NR_SEQUENCIA'
		and		upper(cd_interno) =  upper(cd_codigo_pais_w)
		and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
		and		ie_sistema_externo = 'TERUNIMED16';

		if (ie_conversao_w = 'N') then

			gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o país',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PAIS','NR_SEQUENCIA',upper(cd_codigo_pais_w));


		end if;


	end if;

-- Dados do paciente
	select 	max(nr_cpf),
			max(dt_nascimento),
			max(coalesce(obter_nome_pf(cd_pessoa_mae),obter_compl_pf(cd_pessoa_fisica, 5,'N'))),
			max(ie_sexo),
			max(ie_estado_civil),
			max(cd_nacionalidade),
			max(ie_grau_instrucao),
			max(nr_seq_cor_pele),
			max(obter_compl_pf(cd_pessoa_fisica,1,'TLS')),
			max(obter_compl_pf(cd_pessoa_fisica,1,'EN')),
			max(obter_compl_pf(cd_pessoa_fisica,1,'NR')),
			max(obter_compl_pf(CD_PESSOA_FISICA,1,'UF')),
			max(cd_municipio_ibge || calcula_digito('MODULO10',cd_municipio_ibge)),
			MAX(obter_municipio_ibge(nr_cep_cidade_nasc) ||  calcula_digito('MODULO10', obter_municipio_ibge(nr_cep_cidade_nasc)))
	into STRICT	nr_cpf_w,
			dt_nascimento_w,
			nm_mae_w,
			ie_sexo_w,
			ie_estado_civil_w,
			cd_nacionalidade_w,
			ie_grau_instrucao_w,
			nr_seq_cor_pele_w,
			cd_tipo_logradouro_w,
			ds_endereco_w,
			nr_endereco_w,
			sg_estado_w,
			nr_municipio_ibge_nasc_1_w,
			nr_municipio_ibge_nasc_2_w
    from    pessoa_fisica
    where   cd_pessoa_fisica = cd_pessoa_fisica_w;


	if (   coalesce(trim(both nr_cpf_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o CPF informado',5,
							obter_desc_expressao(320845),
							338354,'PESSOA_FISICA','NR_CPF');

	end if;

	if (   coalesce(trim(both dt_nascimento_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui a data de nascimento informado',5,
							obter_desc_expressao(320845),
							303344,'PESSOA_FISICA','DT_NASCIMENTO');

	end if;

	if (   coalesce(trim(both nm_mae_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o nome da mãe informado',5,
							obter_desc_expressao(320845),
							292818,'PESSOA_FISICA','CD_PESSOA_MAE');

	end if;

	if (   coalesce(trim(both ie_sexo_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o sexo informado',5,
							obter_desc_expressao(320845),
							298476,'PESSOA_FISICA','IE_SEXO');

	else

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_conversao_w
		from	conversao_meio_externo
		where	nm_tabela = 'PESSOA_FISICA'
		and		nm_atributo = 'IE_SEXO'
		and		upper(cd_interno) =  upper(ie_sexo_w)
		and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
		and		ie_sistema_externo = 'TERUNIMED16';

		if (ie_conversao_w = 'N') then

			gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o sexo',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','IE_SEXO',upper(ie_sexo_w));


		end if;

	end if;

	if (   coalesce(trim(both ie_estado_civil_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o estado civil informado',5,
							obter_desc_expressao(320845),
							289528,'PESSOA_FISICA','IE_ESTADO_CIVIL');

	else

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_conversao_w
		from	conversao_meio_externo
		where	nm_tabela = 'PESSOA_FISICA'
		and		nm_atributo = 'IE_ESTADO_CIVIL'
		and		upper(cd_interno) =  upper(ie_estado_civil_w)
		and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
		and		ie_sistema_externo = 'TERUNIMED16';

		if (ie_conversao_w = 'N') then

			gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o estado civil',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','IE_ESTADO_CIVIL',upper(ie_estado_civil_w));


		end if;

	end if;

	if (   coalesce(trim(both cd_nacionalidade_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui a nacionalidade informado',5,
							obter_desc_expressao(320845),
							293906,'PESSOA_FISICA','CD_NACIONALIDADE');

	else

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_conversao_w
		from	conversao_meio_externo
		where	nm_tabela = 'PESSOA_FISICA'
		and		nm_atributo = 'CD_NACIONALIDADE'
		and		upper(cd_interno) =  upper(cd_nacionalidade_w)
		and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
		and		ie_sistema_externo = 'TERUNIMED16';

		if (ie_conversao_w = 'N') then

			gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para a nacionalidade',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','CD_NACIONALIDADE',upper(cd_nacionalidade_w));


		end if;

	end if;

	if (   coalesce(trim(both ie_grau_instrucao_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o grau de instrução informado',5,
							obter_desc_expressao(320845),
							290974,'PESSOA_FISICA','IE_GRAU_INSTRUCAO');

	else

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_conversao_w
		from	conversao_meio_externo
		where	nm_tabela = 'PESSOA_FISICA'
		and		nm_atributo = 'IE_GRAU_INSTRUCAO'
		and		upper(cd_interno) =  upper(ie_grau_instrucao_w)
		and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
		and		ie_sistema_externo = 'TERUNIMED16';

		if (ie_conversao_w = 'N') then

			gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o grau de instrução',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','IE_GRAU_INSTRUCAO',upper(ie_grau_instrucao_w));


		end if;

	end if;

	if (   coalesce(trim(both nr_seq_cor_pele_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui a cor da pele informado',5,
							obter_desc_expressao(320845),
							773409,'PESSOA_FISICA','NR_SEQ_COR_PELE');

	else

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_conversao_w
		from	conversao_meio_externo
		where	nm_tabela = 'PESSOA_FISICA'
		and		nm_atributo = 'NR_SEQ_COR_PELE'
		and		upper(cd_interno) =  upper(nr_seq_cor_pele_w)
		and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
		and		ie_sistema_externo = 'TERUNIMED16';

		if ( ie_conversao_w = 'N') then

			gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para a cor da pele',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','NR_SEQ_COR_PELE',upper(nr_seq_cor_pele_w));


		end if;

	end if;

	if (   coalesce(trim(both cd_tipo_logradouro_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o tipo de logradouro informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793)||' -> '||obter_desc_expressao(341795),
							299853,'COMPL_PESSOA_FISICA','CD_TIPO_LOGRADOURO');

	else

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_conversao_w
		from	conversao_meio_externo
		where	nm_tabela = 'PESSOA_FISICA'
		and		nm_atributo = 'CD_TIPO_LOGRADOURO'
		and		upper(cd_interno) =  upper(cd_tipo_logradouro_w)
		and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
		and		ie_sistema_externo = 'TERUNIMED16';

		if ( ie_conversao_w = 'N') then

			gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o tipo de logradouro',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','CD_TIPO_LOGRADOURO',upper(cd_tipo_logradouro_w));


		end if;

	end if;


	if (   coalesce(trim(both ds_endereco_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o endereço informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793)||' -> '||obter_desc_expressao(341795),
							289232,'COMPL_PESSOA_FISICA','DS_ENDERECO');

	end if;

	if (   coalesce(trim(both nr_endereco_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o número do endereço informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(878075)||' -> '||obter_desc_expressao(762140),
							294439,'COMPL_PESSOA_FISICA','NR_ENDERECO');

	end if;

	if (   coalesce(trim(both sg_estado_w)::text, '') = ''  ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o estado informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(878075)||' -> '||obter_desc_expressao(762140),
							289525,'COMPL_PESSOA_FISICA','SG_ESTADO');

	else

		Select 	coalesce(max('S'),'N')
		into STRICT	ie_conversao_w
		from	conversao_meio_externo
		where	nm_tabela = 'PESSOA_FISICA'
		and		nm_atributo = 'SG_ESTADO'
		and		upper(cd_interno) =  upper(sg_estado_w)
		and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
		and		ie_sistema_externo = 'TERUNIMED16';

		if ( ie_conversao_w = 'N') then

			gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o Estado ',6001,
							obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
							289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','SG_ESTADO',upper(sg_estado_w));

		end if;

	end if;

	if (   trim(both coalesce(nr_municipio_ibge_nasc_1_w,0)) > 0  and  coalesce(trim(both nr_municipio_ibge_nasc_2_w)::text, '') = '' ) then

		gerar_situacao_res('Dados do paciente','O paciente não possui o número IBGE do município informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(878075)||' -> '||obter_desc_expressao(762140),
							293668,'COMPL_PESSOA_FISICA','CD_MUNICIPIO_IBGE ou NR_CEP_CIDADE_NASC');
	end if;


-- Contatos do paciente
	select	max(a.nr_ddi_celular || a.nr_ddd_celular || a.nr_telefone_celular),
			max(b.ds_email)
	into STRICT	ds_tel_cel_pf_w,
			ds_email_w
    FROM pessoa_fisica a
LEFT OUTER JOIN compl_pessoa_fisica b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica = cd_pessoa_fisica_w;


	if (   coalesce(trim(both ds_tel_cel_pf_w)::text, '') = ''  ) then

		gerar_situacao_res('Contatos do paciente','O paciente não possui o telefone informado',5,
							obter_desc_expressao(320845),
							284755,'PESSOA_FISICA','NR_TELEFONE_CELULAR');

	end if;

	if (   coalesce(trim(both ds_email_w)::text, '') = ''  ) then

		gerar_situacao_res('Contatos do paciente','O paciente não possui o e-mail informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793)||' -> '||obter_desc_expressao(341795),
							289120,'COMPL_PESSOA_FISICA','DS_EMAIL');

	end if;

-- Contatos emergenciais
	open C01;
	loop
	fetch C01 into
			ds_tel_cel_pf_w,
			ds_email_w,
			ds_endereco_w,
			nr_endereco_w,
			nr_municipio_ibge_nasc_1_w,
			sg_estado_w,
			cd_tipo_logradouro_w,
			nr_seq_pais_w,
			nr_seq_parentesco_w,
			nm_contato_emergencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (   coalesce(trim(both ds_tel_cel_pf_w)::text, '') = ''  ) then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o telefone informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							299149,'COMPL_PESSOA_FISICA','NR_TELEFONE');

		end if;

		if (   coalesce(trim(both ds_email_w)::text, '') = ''  ) then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o e-mail informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							289120,'COMPL_PESSOA_FISICA','DS_EMAIL');

		end if;


		if (   coalesce(trim(both ds_endereco_w)::text, '') = ''  ) then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o endereço informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							289232,'COMPL_PESSOA_FISICA','DS_ENDERECO');
		end if;

		if (   coalesce(trim(both nr_endereco_w)::text, '') = ''  ) then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o número do endereço informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							294439,'COMPL_PESSOA_FISICA','NR_ENDERECO');
		end if;

		if (  coalesce(trim(both nr_municipio_ibge_nasc_1_w)::text, '') = '') then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o número IBGE do município informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							293668,'COMPL_PESSOA_FISICA','CD_MUNICIPIO_IBGE');

		end if;


		if (   coalesce(trim(both sg_estado_w)::text, '') = ''  ) then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o estado informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							289525,'COMPL_PESSOA_FISICA','SG_ESTADO');

		else

			Select 	coalesce(max('S'),'N')
			into STRICT	ie_conversao_w
			from	conversao_meio_externo
			where	nm_tabela = 'PESSOA_FISICA'
			and		nm_atributo = 'SG_ESTADO'
			and		upper(cd_interno) =  upper(sg_estado_w)
			and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
			and		ie_sistema_externo = 'TERUNIMED16';

			if ( ie_conversao_w = 'N') then

				gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o Estado ',6001,
								obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
								289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','SG_ESTADO',upper(sg_estado_w));

			end if;

		end if;

		if (   coalesce(trim(both cd_tipo_logradouro_w)::text, '') = ''  ) then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o tipo de logradouro informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							299853,'COMPL_PESSOA_FISICA','CD_TIPO_LOGRADOURO');

		else

			Select 	coalesce(max('S'),'N')
			into STRICT	ie_conversao_w
			from	conversao_meio_externo
			where	nm_tabela = 'PESSOA_FISICA'
			and		nm_atributo = 'CD_TIPO_LOGRADOURO'
			and		upper(cd_interno) =  upper(cd_tipo_logradouro_w)
			and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
			and		ie_sistema_externo = 'TERUNIMED16';

			if ( ie_conversao_w = 'N') then

				gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o tipo de logradouro',6001,
								obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
								289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','CD_TIPO_LOGRADOURO',upper(cd_tipo_logradouro_w));


			end if;

		end if;


		if (   coalesce(trim(both nr_seq_pais_w)::text, '') = ''  ) then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o país informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							295224,'COMPL_PESSOA_FISICA','NR_SEQ_PAIS');

		else

			Select  (cd_codigo_pais)::numeric
			into STRICT	cd_codigo_pais_w
			from	pais
			where	nr_sequencia = nr_seq_pais_w;


			Select 	coalesce(max('S'),'N')
			into STRICT	ie_conversao_w
			from	conversao_meio_externo
			where	nm_tabela = 'PAIS'
			and		nm_atributo = 'NR_SEQUENCIA'
			and		upper(cd_interno) =  upper(cd_codigo_pais_w)
			and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
			and		ie_sistema_externo = 'TERUNIMED16';

			if (ie_conversao_w = 'N') then

				gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o país',6001,
								obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
								289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PAIS','NR_SEQUENCIA',upper(cd_codigo_pais_w));


			end if;


		end if;


		if (  coalesce(trim(both nr_seq_parentesco_w)::text, '') = '') then

			gerar_situacao_res('Contatos emergenciais: '||nm_contato_emergencia_w,'O contato não possui o parentesco informado',5,
							obter_desc_expressao(320845)||' -> '||obter_desc_expressao(341793),
							295291,'COMPL_PESSOA_FISICA','NR_SEQ_PARENTESCO');

		else

				Select 	coalesce(max('S'),'N')
				into STRICT	ie_conversao_w
				from	conversao_meio_externo
				where	nm_tabela = 'PESSOA_FISICA'
				and		nm_atributo = 'NR_SEQ_PARENTESCO'
				and		upper(cd_interno) =  upper(nr_seq_parentesco_w)
				and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
				and		ie_sistema_externo = 'TERUNIMED16';

				if ( ie_conversao_w = 'N') then

					gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o parentesco',6001,
									obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
									289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','NR_SEQ_PARENTESCO',upper(nr_seq_parentesco_w));


				end if;

		end if;

		end;
	end loop;
	close C01;

-- Dados do requisitante
	Select 	max(cd_pessoa_fisica)
	into STRICT	cd_pf_usuario_w
	from	usuario
	where	nm_usuario = nm_usuario_solic_p;

	if (cd_pf_usuario_w IS NOT NULL AND cd_pf_usuario_w::text <> '') then

		if ( ie_medico_w = 'S') then

			SELECT 	max(b.nr_cpf),
					max(a.uf_crm),
					max(coalesce(a.nr_crm, b.ds_codigo_prof))
			into STRICT	nr_cpf_solic_w,
					nr_uf_crm_w,
					nr_crm_w
			FROm    medico a,
					pessoa_fisica b
			where   b.cd_pessoa_fisica = cd_pf_usuario_w
			and     a.cd_pessoa_fisica = b.cd_pessoa_fisica
			and		exists (SELECT 1 from medico d where d.cd_pessoa_fisica = b.cd_pessoa_fisica);

			if (   coalesce(trim(both nr_cpf_solic_w)::text, '') = ''  ) then

				gerar_situacao_res('Dados do usuário','O usuário médico não possui o CPF informado',4,
									obter_desc_expressao(293090)||' -> '||obter_desc_expressao(318327),
									294453,'PESSOA_FISICA','NR_CPF');

			end if;

			if (   coalesce(trim(both nr_uf_crm_w)::text, '') = ''  ) then

				gerar_situacao_res('Dados do usuário','O usuário médico não possui a unidade federativa do conselho informado',4,
									obter_desc_expressao(293090)||' -> '||obter_desc_expressao(318327)||' -> '||obter_desc_expressao(293090),
									300620,'MEDICO','UF_CRM');

			else

				Select 	coalesce(max('S'),'N')
				into STRICT	ie_conversao_w
				from	conversao_meio_externo
				where	nm_tabela = 'PESSOA_FISICA'
				and		nm_atributo = 'SG_ESTADO'
				and		upper(cd_interno) =  upper(nr_uf_crm_w)
				and		(trim(both cd_externo) IS NOT NULL AND (trim(both cd_externo))::text <> '')
				and		ie_sistema_externo = 'TERUNIMED16';

				if ( ie_conversao_w = 'N') then

					gerar_situacao_res('Conversão','Não existe ou falta completar o cadastro de conversão para o Estado ',6001,
									obter_desc_expressao(567723)||' -> '||obter_desc_expressao(487429)||' -> '||obter_desc_expressao(856023),
									289943,'CONVERSAO_MEIO_EXTERNO','CD_EXTERNO','PESSOA_FISICA','SG_ESTADO',upper(nr_uf_crm_w));

				end if;



			end if;

			if (   coalesce(trim(both nr_crm_w)::text, '') = ''  ) then

				gerar_situacao_res('Dados do usuário','O usuário médico não possui o CRM informado',4,
									obter_desc_expressao(293090)||' -> '||obter_desc_expressao(318327)||' -> '||obter_desc_expressao(293090),
									744344,'MEDICO','NR_CRM');

			end if;


		else


			select  max(nr_cpf),
					max(nr_seq_conselho)
			into STRICT	nr_cpf_solic_w,
					nr_seq_conselho_w
			from    pessoa_fisica b
			where   b.cd_pessoa_fisica = cd_pf_usuario_w
			and		not exists (SELECT 1 from medico d where d.cd_pessoa_fisica = b.cd_pessoa_fisica);

			if (   coalesce(trim(both nr_cpf_solic_w)::text, '') = ''  ) then

				gerar_situacao_res('Dados do usuário','O usuário não possui o CPF informado',4,
									obter_desc_expressao(293090)||' -> '||obter_desc_expressao(318327),
									294453,'PESSOA_FISICA','NR_CPF');

			end if;

			if (   coalesce(trim(both nr_seq_conselho_w)::text, '') = ''  ) then

				gerar_situacao_res('Dados do usuário','O usuário não possui o CPF informado',4,
									obter_desc_expressao(293090)||' -> '||obter_desc_expressao(318327),
									285713,'PESSOA_FISICA','NR_SEQ_CONSELHO');

			end if;



		end if;



	end if;


end if;

ds_retorno_p := ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_dados_res ( nr_atendimento_p bigint, nm_usuario_solic_p text, ds_retorno_p INOUT text) FROM PUBLIC;

