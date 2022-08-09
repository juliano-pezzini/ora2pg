-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_convenio_atendimento ( nr_atendimento_p bigint, cd_convenio_agenda_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, dt_entrada_p timestamp, cd_convenio_p bigint, cd_categoria_p text, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp, cd_usuario_convenio_p text, cd_empresa_p bigint, nr_doc_convenio_p text, nr_doc_conv_regra_p text, cd_tipo_acomodacao_p bigint, cd_tipo_acomodacao_regra_p bigint, cd_municipio_convenio_p bigint, cd_convenio_glosa_p bigint, cd_categoria_glosa_p text, dt_validade_carteira_p timestamp, nr_acompanhante_p bigint, cd_plano_convenio_p text, cd_dependente_p bigint, nr_seq_origem_p bigint, cd_senha_p text, ie_tipo_guia_p text, ds_observacao_p text, qt_dia_internacao_p bigint, qt_dia_internacao_pp bigint, dt_ultimo_pagto_p timestamp, ie_tipo_atendimento_p bigint, IE_REP_COD_USUARIO_p text, cd_complemento_p text, cd_plano_padrao_p text, ie_gerar_cep_cadastro_p text, ds_procedure_validacao_p text, cd_estabelecimento_p bigint, ie_tipo_acomodacao_p text, ie_opcao_p text, cd_plano_eup_p text, ie_situacao_plano_p text, ds_erro_p text, ie_Bloquear_Atend_p text, ie_gerar_data_validade_p text, ie_tipo_atend_lib_categ_p text, ie_gera_guia_regra_p text, ie_tipo_guia_regra_p text, ie_tipo_guia_atend_p text, qt_dieta_acomp_p bigint, ie_lib_dieta_p text, ie_exige_cpf_p text, ie_calcula_dt_vigencia_p text, qt_idade_p bigint, cd_pessoa_responsavel_p text, cd_pf_menor_p text, ie_clinica_p bigint, ie_atualiza_dias_internacao_p text, ie_aplica_digito_padrao_p text, ds_digitos_padrao_p text, cd_convenio_old_p bigint, nr_seq_regra_acomp_p bigint, ie_padrao_dados_conv_p text, ie_tipo_conveniado_p bigint default null, ie_autoriza_envio_convenio_p atend_categoria_convenio.ie_autoriza_envio_convenio%type DEFAULT NULL, nr_seq_interno_p INOUT bigint DEFAULT NULL, ie_regime_internacao_p atend_categoria_convenio.ie_regime_internacao%TYPE default null, nr_seq_abrangencia_p atend_categoria_convenio.nr_seq_abrangencia%TYPE default null, nr_seq_tipo_lib_guia_p atend_categoria_convenio.nr_seq_tipo_lib_guia%TYPE default null, nr_doc_conv_principal_p atend_categoria_convenio.nr_doc_conv_principal%TYPE default null, cd_senha_provisoria_p atend_categoria_convenio.cd_senha_provisoria%TYPE default null, ie_cod_usuario_mae_resp_p atend_categoria_convenio.ie_cod_usuario_mae_resp%TYPE default null, cd_plano_glosa_p atend_categoria_convenio.cd_plano_glosa%TYPE default null, cd_usuario_conv_glosa_p atend_categoria_convenio.cd_usuario_conv_glosa%TYPE default null, cd_complemento_glosa_p atend_categoria_convenio.cd_complemento_glosa%TYPE default null, dt_validade_cart_glosa_p atend_categoria_convenio.dt_validade_cart_glosa%TYPE default null, nr_seq_lib_dieta_conv_p atend_categoria_convenio.nr_seq_lib_dieta_conv%TYPE default null, nr_seq_interno_anterior_p atend_categoria_convenio.nr_seq_lib_dieta_conv%TYPE default null, nr_prioridade_p atend_categoria_convenio.nr_prioridade%type default null, nr_seq_categoria_iva_p atend_categoria_convenio.nr_seq_categoria_iva%type default null) AS $body$
DECLARE

ie_tipo_convenio_w		smallint;
cd_pessoa_fisica_w		varchar(10);
dt_entrada_w			timestamp;
cd_localidade_w		integer;
cd_convenio_w			integer := null;
cd_categoria_w		varchar(10);
dt_inicio_vigencia_w		timestamp;
dt_final_vigencia_w		timestamp;
cd_usuario_convenio_w	varchar(30);
cd_empresa_w			bigint;
nr_doc_convenio_w		varchar(20);
nr_doc_conv_regra_w		varchar(20);
cd_tipo_acomodacao_w		smallint;
cd_tipo_acomodacao_regra_w	smallint;
cd_municipio_convenio_w	integer;
cd_convenio_glosa_w		integer;
cd_categoria_glosa_w		varchar(10);
dt_validade_carteira_w	timestamp;
nr_acompanhante_w		smallint;
cd_plano_convenio_w		varchar(10);
cd_dependente_w		smallint;
nr_seq_interno_w		bigint;
nr_seq_origem_w		bigint;
cd_senha_w			varchar(20);
ie_tipo_guia_w		varchar(2);
ds_observacao_w		varchar(255);
qt_dia_internacao_w		smallint;
qt_dia_internacao_ww		smallint;
dt_ultimo_pagto_w		timestamp;
ds_parametro_w		varchar(255);
ie_tipo_atendimento_w	smallint;
IE_REP_COD_USUARIO_w		varchar(10);
cd_complemento_w		varchar(30);
cd_plano_padrao_w		varchar(10);
ie_gerar_cep_cadastro_w		varchar(05) 	:= 'N';
ds_procedure_validacao_w	varchar(255)	:= null;
cd_estabelecimento_w		smallint;
cd_estabelecimento_ww		smallint;
ie_tipo_acomodacao_w		varchar(10);
ie_opcao_w			varchar(10);
cd_plano_eup_w			varchar(10);
ie_situacao_plano_w		varchar(01);
ds_erro_w			varchar(255);
ie_Bloquear_Atend_w		varchar(1);
ie_gerar_data_validade_w	varchar(1);
ie_grava_localidade_w		varchar(1);
ie_tipo_atend_lib_categ_w	varchar(1);
ie_gera_guia_regra_w		varchar(1);
ie_tipo_guia_regra_w		varchar(1);
ie_tipo_guia_atend_w		varchar(5);
qt_dieta_acomp_w		smallint;
ie_lib_dieta_w			varchar(15);
ie_exige_cpf_w			varchar(1);
ie_exige_cpf_paciente_w		varchar(1);
ie_calcula_dt_vigencia_w	varchar(1);
qt_idade_w			smallint;
cd_pessoa_responsavel_w		varchar(10);
cd_pf_menor_w			varchar(10);
nr_cpf_w			varchar(11);
ie_clinica_w			integer;
ie_atualiza_dias_internacao_w	varchar(1);
ie_aplica_digito_padrao_w	varchar(1);
ds_digitos_padrao_w		varchar(30);
cd_convenio_old_w		bigint;
nr_seq_regra_acomp_w		bigint;
ie_padrao_dados_conv_w	varchar(2);
nr_seq_episodio_w 		bigint;
ie_tipo_conveniado_w		atend_categoria_convenio.ie_tipo_conveniado%type;
ds_pais_usuario_w	varchar(15);
ie_vigente_w	varchar(4);
nr_prioridade_w			atend_categoria_convenio.nr_prioridade%type;
ie_regime_internacao_w      atend_categoria_convenio.ie_regime_internacao%TYPE := NULL;
nr_seq_abrangencia_w        atend_categoria_convenio.nr_seq_abrangencia%TYPE := NULL;
nr_seq_tipo_lib_guia_w      atend_categoria_convenio.nr_seq_tipo_lib_guia%TYPE := NULL;
nr_doc_conv_principal_w     atend_categoria_convenio.nr_doc_conv_principal%TYPE := NULL;
cd_senha_provisoria_w       atend_categoria_convenio.cd_senha_provisoria%TYPE := NULL;
ie_cod_usuario_mae_resp_w   atend_categoria_convenio.ie_cod_usuario_mae_resp%TYPE := NULL;
cd_plano_glosa_w            atend_categoria_convenio.cd_plano_glosa%TYPE := NULL;
cd_usuario_conv_glosa_w     atend_categoria_convenio.cd_usuario_conv_glosa%TYPE := NULL;
cd_complemento_glosa_w      atend_categoria_convenio.cd_complemento_glosa%TYPE := NULL;
dt_validade_cart_glosa_w    atend_categoria_convenio.dt_validade_cart_glosa%TYPE := NULL;
nr_seq_lib_dieta_conv_w     atend_categoria_convenio.nr_seq_lib_dieta_conv%TYPE := NULL;
nr_sequencia_pes_taxa_w     pessoa_fisica_taxa.nr_sequencia%TYPE := NULL;
nr_seq_justificativa_w		pessoa_fisica_taxa.nr_seq_justificativa%type;
pessoa_fisica_taxa_w  	    pessoa_fisica_taxa%rowtype;
cd_pessoa_titular_w			atend_categoria_convenio.cd_pessoa_titular%type;
ekvk_cd_pessoa_fisica_w atend_categoria_convenio.ekvk_cd_pessoa_fisica%type;
ekvk_nm_pais_w          atend_categoria_convenio.ekvk_nm_pais%type;
ekvk_nr_cartao_w        atend_categoria_convenio.ekvk_nr_cartao%type;
ekvk_nr_conv_w          atend_categoria_convenio.ekvk_nr_conv%type;
ekvk_sg_conv_w          atend_categoria_convenio.ekvk_sg_conv%type;
ekvk_nr_seq_tipo_doc_w  atend_categoria_convenio.ekvk_nr_seq_tipo_doc%type;
ekvk_dt_inicio_w        atend_categoria_convenio.ekvk_dt_inicio%type;
ekvk_dt_fim_w           atend_categoria_convenio.ekvk_dt_fim%type;
nr_seq_nivel_filiacao_w atend_categoria_convenio.nr_seq_nivel_filiacao%type;
dt_afiliacao_w          atend_categoria_convenio.dt_afiliacao%type;
nr_seq_categoria_iva_w atend_categoria_convenio.nr_seq_categoria_iva%type;


BEGIN
ds_pais_usuario_w := obter_sigla_pais_locale(nm_usuario_p);

cd_pessoa_fisica_w := cd_pessoa_fisica_p;
dt_entrada_w := dt_entrada_p;
cd_convenio_w := cd_convenio_p;
cd_categoria_w := cd_categoria_p;
cd_usuario_convenio_w := cd_usuario_convenio_p;
cd_empresa_w := cd_empresa_p;
nr_doc_convenio_w := nr_doc_convenio_p;
nr_doc_conv_regra_w := nr_doc_conv_regra_p;
cd_tipo_acomodacao_w := cd_tipo_acomodacao_p;
cd_tipo_acomodacao_regra_w := cd_tipo_acomodacao_regra_p;
cd_municipio_convenio_w := cd_municipio_convenio_p;
cd_convenio_glosa_w := cd_convenio_glosa_p;
cd_categoria_glosa_w := cd_categoria_glosa_p;
dt_validade_carteira_w := dt_validade_carteira_p;
nr_acompanhante_w := nr_acompanhante_p;
cd_plano_convenio_w := cd_plano_convenio_p;
cd_dependente_w := cd_dependente_p;
nr_seq_interno_w := nr_seq_interno_p;
nr_seq_origem_w := nr_seq_origem_p;
cd_senha_w := cd_senha_p;
ie_tipo_guia_w := ie_tipo_guia_p;
ds_observacao_w := ds_observacao_p;
qt_dia_internacao_w := qt_dia_internacao_p;
qt_dia_internacao_ww := qt_dia_internacao_pp;
dt_ultimo_pagto_w := dt_ultimo_pagto_p;
ie_tipo_atendimento_w := ie_tipo_atendimento_p;
IE_REP_COD_USUARIO_w := IE_REP_COD_USUARIO_p;
cd_complemento_w := cd_complemento_p;
cd_plano_padrao_w := cd_plano_padrao_p;
ie_gerar_cep_cadastro_w := ie_gerar_cep_cadastro_p;
ds_procedure_validacao_w := ds_procedure_validacao_p;
cd_estabelecimento_w := cd_estabelecimento_p;
ie_tipo_acomodacao_w := ie_tipo_acomodacao_p;
ie_opcao_w := ie_opcao_p;
cd_plano_eup_w := cd_plano_eup_p;
ie_situacao_plano_w := ie_situacao_plano_p;
ds_erro_w := ds_erro_p;
ie_Bloquear_Atend_w := ie_Bloquear_Atend_p;
ie_gerar_data_validade_w := ie_gerar_data_validade_p;
ie_tipo_atend_lib_categ_w := ie_tipo_atend_lib_categ_p;
ie_gera_guia_regra_w := ie_gera_guia_regra_p;
ie_tipo_guia_regra_w := ie_tipo_guia_regra_p;
ie_tipo_guia_atend_w := ie_tipo_guia_atend_p;
qt_dieta_acomp_w := qt_dieta_acomp_p;
ie_lib_dieta_w := ie_lib_dieta_p;
ie_exige_cpf_w := ie_exige_cpf_p;
ie_calcula_dt_vigencia_w := ie_calcula_dt_vigencia_p;
qt_idade_w := qt_idade_p;
cd_pessoa_responsavel_w := cd_pessoa_responsavel_p;
cd_pf_menor_w := cd_pf_menor_p;
ie_clinica_w := ie_clinica_p;
ie_atualiza_dias_internacao_w := ie_atualiza_dias_internacao_p;
ie_aplica_digito_padrao_w := ie_aplica_digito_padrao_p;
ds_digitos_padrao_w := ds_digitos_padrao_p;
cd_convenio_old_w := cd_convenio_old_p;
nr_seq_regra_acomp_w := nr_seq_regra_acomp_p;
ie_padrao_dados_conv_w := ie_padrao_dados_conv_p;
ie_tipo_conveniado_w := ie_tipo_conveniado_p;
--
IF (ds_pais_usuario_w in ('de_DE', 'de_AT')) THEN
    ie_regime_internacao_w := ie_regime_internacao_p;
    nr_seq_abrangencia_w := nr_seq_abrangencia_p;
    nr_seq_tipo_lib_guia_w := nr_seq_tipo_lib_guia_p;
    nr_doc_conv_principal_w := nr_doc_conv_principal_p;
    cd_senha_provisoria_w := cd_senha_provisoria_p;
    ie_cod_usuario_mae_resp_w := ie_cod_usuario_mae_resp_p;
    cd_plano_glosa_w := cd_plano_glosa_p;
    cd_usuario_conv_glosa_w := cd_usuario_conv_glosa_p;
    cd_complemento_glosa_w := cd_complemento_glosa_p;
    dt_validade_cart_glosa_w := dt_validade_cart_glosa_p;
    nr_seq_lib_dieta_conv_w := nr_seq_lib_dieta_conv_p;
END IF;

/* Ricardo 19/08/2004 - Inclui abaixo o teste do convenio da agenda, se o convenio nao for informado
			ou se for igual ao do atendimento anterior do paciente o sistema inclui os dados do
			atendimento anterior, se o convenio da agenda for diferente do convenio do atendimento
			anterior, o sistema apenas nao inclui nada */
if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') then
	ds_procedure_validacao_w := Obter_Regra_Valid_Usuario_Conv(cd_convenio_w, cd_categoria_w, ie_tipo_atendimento_w, ds_procedure_validacao_w);
end if;


if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') and (coalesce(ds_procedure_validacao_w::text, '') = '') and
	((cd_convenio_agenda_p = 0) or (coalesce(cd_convenio_agenda_p::text, '') = '') or
	 ((cd_convenio_agenda_p = cd_convenio_w) or ((ie_padrao_dados_conv_w = 'S') or (ie_padrao_dados_conv_w = 'C') or (ie_padrao_dados_conv_w = 'P') ))) then

	/* Edgar 13/02/2004 - Verificar se deve repetir o codigo do usuario do convenio */

	select	Obter_Valor_Conv_Estab(cd_convenio, cd_estabelecimento_w, 'IE_REP_COD_USUARIO') IE_REP_COD_USUARIO
	into STRICT	IE_REP_COD_USUARIO_w
	from	convenio
	where	cd_convenio	= cd_convenio_w;

	if (IE_REP_COD_USUARIO_w = 'N') then
		cd_usuario_convenio_w := '';
	end if;

	select	nextval('atend_categoria_convenio_seq')
	into STRICT	nr_seq_interno_w
	;

    select coalesce(max('S'), 'N')
    into STRICT ie_vigente_w

   where ((trunc(coalesce(dt_entrada_w, clock_timestamp())) between trunc(dt_inicio_vigencia_p) and trunc(dt_final_vigencia_p))
			or (trunc(coalesce(dt_entrada_w, clock_timestamp())) >= trunc(dt_inicio_vigencia_p) and coalesce(dt_final_vigencia_p::text, '') = ''));

    if (ds_pais_usuario_w in ('de_DE', 'de_AT') and ie_vigente_w = 'S') then
        dt_inicio_vigencia_w    := pkg_date_utils.get_Time(dt_inicio_vigencia_p, 0, 0, 1);
        dt_final_vigencia_w     := pkg_date_utils.get_Time(dt_final_vigencia_p, 23, 59, 59);
    else
        dt_inicio_vigencia_w	:= dt_entrada_w;
        dt_final_vigencia_w     := dt_final_vigencia_p;
        if (ie_calcula_dt_vigencia_w = 'R')	then
            dt_final_vigencia_w := dt_inicio_vigencia_w + coalesce(qt_dia_internacao_ww,0);
        end if;
    end if;

	if (ds_pais_usuario_w in ('de_DE', 'de_AT') and coalesce(nr_prioridade_p::text, '') = '') then

		select	max(OBTER_PRIOR_PADRAO_CONV_ATEND(nr_atendimento_p, cd_convenio_w))
		into STRICT	nr_prioridade_w
		;
	else
		nr_prioridade_w := nr_prioridade_p;
	end if;

	nr_doc_convenio_w := obter_guia_conv_atend(nr_atendimento_p, cd_convenio_w, cd_categoria_w, null, null, null, nr_doc_convenio_w);


	select	max(cd_plano_padrao)
	into STRICT	cd_plano_padrao_w
	from	categoria_convenio
	where	cd_convenio	= cd_convenio_w
	and	cd_categoria	= cd_categoria_w;

	if (ie_gerar_cep_cadastro_w = 'S') then
		begin

		select 	somente_numero(obter_compl_pf(cd_pessoa_fisica_w, 1, 'CEP'))
		into STRICT	cd_municipio_convenio_w
		;


		end;
	end if;

	/*if	(ie_opcao_w <> '0') then
		select	nvl(obter_empresa_paciente(cd_pessoa_fisica_w,to_number(ie_opcao_w)),cd_empresa_w)
		into	cd_empresa_w
		from	dual;
	end if;*/
	if (ie_opcao_w <> '0') and (ie_opcao_w <> 'C') then

		select	coalesce(obter_empresa_paciente(cd_pessoa_fisica_w,(ie_opcao_w)::numeric ),cd_empresa_w)
		into STRICT	cd_empresa_w
		;

	elsif (ie_opcao_w = 'C') then

		select	max(cd_empresa_referencia)
		into STRICT	cd_empresa_w
		from	pf_cartao_fidelidade
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;
	end if;


	if (coalesce(cd_tipo_acomodacao_w::text, '') = '') and (ie_tipo_acomodacao_w = 'S') then
		select	max(cd_tipo_acomodacao)
		into STRICT	cd_tipo_acomodacao_w
		from	categoria_convenio
		where	cd_convenio	= cd_convenio_w
		and	cd_categoria	= cd_categoria_w;
	end if;


	cd_plano_eup_w	:= coalesce(cd_plano_convenio_w,cd_plano_padrao_w);

	select	coalesce(max(ie_situacao),'A')
	into STRICT	ie_situacao_plano_w
	from	convenio_plano
	where	cd_convenio		= cd_convenio_w
	and	cd_plano		= cd_plano_eup_w;

	if (ie_situacao_plano_w	= 'I') then
		cd_plano_eup_w		:= null;
	end if;

	ds_erro_w:= '';
	ds_erro_w := consiste_debito_paciente(cd_pessoa_fisica_w, cd_convenio_w, cd_usuario_convenio_w, ie_tipo_atendimento_w, ie_clinica_w, null, cd_categoria_w, dt_entrada_w, ds_erro_w);
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') and (ie_Bloquear_Atend_w = 'S') then
		ds_erro_w	:=	substr(wheb_mensagem_pck.get_texto(795082, 'ITEM='||ds_erro_w),1,255);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190483,'DS_ERRO_W=' || DS_ERRO_W);
	end if;

	if (ie_gerar_data_validade_w = 'N') then
		dt_validade_carteira_w	:= null;
	end if;


	ie_tipo_atend_lib_categ_w:= Obter_Tipo_Atend_Lib_Categoria(cd_convenio_w, cd_categoria_w, ie_tipo_atendimento_w, cd_estabelecimento_w, dt_entrada_w);
	if (ie_tipo_atend_lib_categ_w = 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(190485);
	end if;



	select	coalesce(max(cd_convenio),0)
	into STRICT	cd_convenio_old_w
	from	atend_categoria_convenio
	where	nr_atendimento = nr_atendimento_p;

	if (ie_gera_guia_regra_w	= 'S')  and
		(cd_convenio_old_w > 0 AND cd_convenio_old_w <> cd_convenio_w) then
		begin
		nr_doc_conv_regra_w := obter_guia_conv_atend(nr_atendimento_p, cd_convenio_w, cd_categoria_w, ie_tipo_Atendimento_w, cd_estabelecimento_w, ie_tipo_guia_w, nr_doc_conv_regra_w);
		if (nr_doc_conv_regra_w IS NOT NULL AND nr_doc_conv_regra_w::text <> '') then
			nr_doc_convenio_w	:= nr_doc_conv_regra_w;
		end if;
		end;
	end if;


	if (coalesce(nr_acompanhante_w::text, '') = '') then
		SELECT * FROM obter_dados_dieta_categ_conv(cd_convenio_w, cd_categoria_w, cd_plano_eup_w, cd_pessoa_fisica_w, nr_acompanhante_w, qt_dieta_acomp_w, ie_lib_dieta_w, nr_seq_regra_acomp_w, nr_atendimento_p) INTO STRICT nr_acompanhante_w, qt_dieta_acomp_w, ie_lib_dieta_w, nr_seq_regra_acomp_w;
	end if;


	select	obter_acomod_perfil_regra(obter_perfil_ativo)
	into STRICT	cd_tipo_acomodacao_regra_w
	;


	if (cd_tipo_acomodacao_regra_w IS NOT NULL AND cd_tipo_acomodacao_regra_w::text <> '') then
		cd_tipo_acomodacao_w := cd_tipo_acomodacao_regra_w;
	end if;
	if (ie_tipo_guia_regra_w = 'S') then
		select 	max(a.ie_tipo_guia)
		into STRICT 	ie_tipo_guia_atend_w
		from	(
			SELECT	ie_tipo_guia
			from	tipo_guia_atend
			where 	ie_tipo_atendimento = (
							SELECT	ie_tipo_atendimento
							from	atendimento_paciente
							where	nr_atendimento = nr_atendimento_p)
			and		((cd_estabelecimento = (
							select	cd_estabelecimento
							from	atendimento_paciente
							where	nr_atendimento = nr_atendimento_p))
					or (coalesce(cd_estabelecimento::text, '') = ''))
			and		((ie_clinica = (
							select	coalesce(ie_clinica,0)
							from	atendimento_paciente
							where	nr_atendimento = nr_atendimento_p))
					or (coalesce(ie_clinica::text, '') = ''))
			order by  ie_guia_padrao desc) a LIMIT 1;
	end if;

	if ( ie_tipo_guia_atend_w <> '') or (ie_tipo_guia_atend_w IS NOT NULL AND ie_tipo_guia_atend_w::text <> '') then
		ie_tipo_guia_w := ie_tipo_guia_atend_w;
	end if;


	if (ie_exige_cpf_w = 'S') then
		begin
		cd_pf_menor_w := cd_pessoa_fisica_w;

		select 	Obter_Idade_PF(cd_pessoa_fisica_w, clock_timestamp(), 'A')
		into STRICT	qt_idade_w
		;

		if (qt_idade_w < 18) then
			begin

			select 	coalesce(a.cd_pessoa_responsavel,'')
			into STRICT	cd_pessoa_responsavel_w
			from 	atendimento_paciente a
			where 	a.nr_atendimento = nr_atendimento_p;

			cd_pf_menor_w := cd_pessoa_responsavel_w;
			end;
		end if;


		end;
	end if;

	if (ie_aplica_digito_padrao_w = 'S') then

		select	obter_prim_digitos_convenio(cd_convenio_w)
		into STRICT	ds_digitos_padrao_w
		;

		if (ds_digitos_padrao_w IS NOT NULL AND ds_digitos_padrao_w::text <> '') and (ds_digitos_padrao_w <> substr(cd_usuario_convenio_w,1,length(ds_digitos_padrao_w))) then
			cd_usuario_convenio_w := ds_digitos_padrao_w;
		end if;
	end if;


	if (coalesce(cd_tipo_acomodacao_w,0) > 0) then

		begin
			select	cd_tipo_acomodacao_w
			into STRICT	cd_tipo_acomodacao_w
			from	TIPO_ACOMODACAO
			where	ie_situacao = 'A'
			and	cd_tipo_acomodacao = cd_tipo_acomodacao_w  LIMIT 1;

		exception
		when others then
			cd_tipo_acomodacao_w := null;
		end;
	end if;

	if (coalesce(cd_categoria_w,'0') > '0') then

		begin
			select	cd_categoria
			into STRICT	cd_categoria_w
			from	categoria_convenio
			where	ie_situacao = 'A'
			and	cd_categoria = cd_categoria_w
			and	cd_convenio = cd_convenio_w  LIMIT 1;
		exception
		when others then
			select	max(cd_categoria)
			into STRICT	cd_categoria_w
			from	categoria_convenio
			where	ie_situacao = 'A'
			and		cd_convenio = cd_convenio_w;
		end;
	end if;

	if (coalesce(nr_seq_regra_acomp_w,0) = 0) then
		select	coalesce(max(vl_default),0)
		into STRICT	nr_seq_regra_acomp_w
		from	tabela_atrib_regra
		where	nm_tabela					= 'ATEND_CATEGORIA_CONVENIO'
		and	nm_atributo					= 'NR_SEQ_REGRA_ACOMP'
		and	coalesce(cd_estabelecimento,cd_estabelecimento_w)    = cd_estabelecimento_w
		and	coalesce(cd_perfil, obter_perfil_ativo)		= obter_perfil_ativo
		and	coalesce(nm_usuario_param, nm_usuario_p) 		= nm_usuario_p;
	end if;

	if (coalesce(ie_lib_dieta_w::text, '') = '') then
		select	coalesce(max(vl_default),'0')
		into STRICT	ie_lib_dieta_w
		from	tabela_atrib_regra
		where	nm_tabela					= 'ATEND_CATEGORIA_CONVENIO'
		and	nm_atributo					= 'IE_LIB_DIETA'
		and	coalesce(cd_estabelecimento,cd_estabelecimento_w)    = cd_estabelecimento_w
		and	coalesce(cd_perfil, obter_perfil_ativo)		= obter_perfil_ativo
		and	coalesce(nm_usuario_param, nm_usuario_p) 		= nm_usuario_p;
	end if;

	select  max(cd_pessoa_titular), MAX(ekvk_cd_pessoa_fisica),
    MAX(ekvk_nm_pais), MAX(ekvk_nr_cartao),
    MAX(ekvk_nr_conv), MAX(ekvk_sg_conv),
    MAX(ekvk_nr_seq_tipo_doc), MAX(ekvk_dt_inicio), MAX(ekvk_dt_fim)
	into STRICT	cd_pessoa_titular_w, ekvk_cd_pessoa_fisica_w,
    ekvk_nm_pais_w, ekvk_nr_cartao_w,
    ekvk_nr_conv_w, ekvk_sg_conv_w,
    ekvk_nr_seq_tipo_doc_w,
    ekvk_dt_inicio_w, ekvk_dt_fim_w
	from 	pessoa_titular_convenio
	where	cd_convenio = cd_convenio_w
	and cd_categoria = cd_categoria_w
	and cd_pessoa_fisica = cd_pessoa_fisica_w
	and	nr_prioridade = nr_prioridade_w;
	
	select 	max(a.nr_seq_nivel_filiacao),
            max(a.dt_afiliacao),
            coalesce(nr_seq_categoria_iva_p, max(a.nr_seq_categoria_iva))
    into STRICT   	nr_seq_nivel_filiacao_w,
            dt_afiliacao_w,
            nr_seq_categoria_iva_w
    from   	pessoa_titular_convenio a
    where  	a.cd_pessoa_fisica 	= cd_pessoa_fisica_p
    and    	cd_convenio             = cd_convenio_w
	and     cd_categoria            = cd_categoria_w;

	insert into atend_categoria_convenio(	nr_atendimento,
			cd_convenio,
			cd_categoria,
			dt_inicio_vigencia,
			dt_final_vigencia,
			dt_atualizacao,
			cd_usuario_convenio,
			cd_empresa,
			nm_usuario,
			nr_doc_convenio,
			cd_tipo_acomodacao,
			cd_municipio_convenio,
			cd_convenio_glosa,
			cd_categoria_glosa,
			dt_validade_carteira,
			nr_acompanhante,
			cd_plano_convenio,
			cd_dependente,
			nr_seq_interno,
			nr_seq_origem,
			cd_senha,
			ie_tipo_guia,
			ds_observacao,
			qt_dia_internacao,
			dt_ultimo_pagto,
			cd_complemento,
			NM_USUARIO_ORIGINAL,
			qt_dieta_acomp,
			ie_lib_dieta,
			nr_seq_regra_acomp,
			ie_tipo_conveniado,
			nr_prioridade,
			ie_autoriza_envio_convenio,
      ie_regime_internacao,
      nr_seq_abrangencia,
      nr_seq_tipo_lib_guia,
      nr_doc_conv_principal,
      cd_senha_provisoria,
      ie_cod_usuario_mae_resp,
      cd_plano_glosa,
      cd_usuario_conv_glosa,
      cd_complemento_glosa,
      dt_validade_cart_glosa,
      nr_seq_lib_dieta_conv,
			cd_pessoa_titular,
      ekvk_cd_pessoa_fisica,
      ekvk_nm_pais,
      ekvk_nr_cartao,
      ekvk_nr_conv,
      ekvk_sg_conv,
      ekvk_nr_seq_tipo_doc,
      ekvk_dt_inicio,
      ekvk_dt_fim,
      nr_seq_nivel_filiacao,
      dt_afiliacao,
      nr_seq_categoria_iva)
	values (		nr_atendimento_p,
			cd_convenio_w,
			cd_categoria_w,
			dt_inicio_vigencia_w,
			dt_final_vigencia_w,
			clock_timestamp(),
			cd_usuario_convenio_w,
			cd_empresa_w,
			nm_usuario_p,
			nr_doc_convenio_w,
			cd_tipo_acomodacao_w,
			cd_municipio_convenio_w,
			cd_convenio_glosa_w,
			cd_categoria_glosa_w,
			dt_validade_carteira_w,
			nr_acompanhante_w,
			cd_plano_eup_w,
			cd_dependente_w,
			nr_seq_interno_w,
			nr_seq_origem_w,
			cd_senha_w,
			ie_tipo_guia_w,
			ds_observacao_w,
			CASE WHEN ie_atualiza_dias_internacao_w='N' THEN null  ELSE qt_dia_internacao_ww END ,
			dt_ultimo_pagto_w,
			cd_complemento_w,
			nm_usuario_p,
			qt_dieta_acomp_w,
			CASE WHEN ie_lib_dieta_w='0' THEN null  ELSE ie_lib_dieta_w END ,
			CASE WHEN nr_seq_regra_acomp_w=0 THEN null  ELSE nr_seq_regra_acomp_w END ,
			ie_tipo_conveniado_w,
			nr_prioridade_w,
			ie_autoriza_envio_convenio_p,
      ie_regime_internacao_w,
      nr_seq_abrangencia_w,
      nr_seq_tipo_lib_guia_w,
      nr_doc_conv_principal_w,
      cd_senha_provisoria_w,
      ie_cod_usuario_mae_resp_w,
      cd_plano_glosa_w,
      cd_usuario_conv_glosa_w,
      cd_complemento_glosa_w,
      dt_validade_cart_glosa_w,
      nr_seq_lib_dieta_conv_w,
      cd_pessoa_titular_w,
      ekvk_cd_pessoa_fisica_w,
      ekvk_nm_pais_w,
      ekvk_nr_cartao_w,
      ekvk_nr_conv_w,
      ekvk_sg_conv_w,
      ekvk_nr_seq_tipo_doc_w,
      ekvk_dt_inicio_w,
      ekvk_dt_fim_w,
      nr_seq_nivel_filiacao_w,
      dt_afiliacao_w,
      nr_seq_categoria_iva_w);

    IF (ds_pais_usuario_w in ('de_DE', 'de_AT')) THEN
        BEGIN
            SELECT 	nr_sequencia
            INTO STRICT	nr_sequencia_pes_taxa_w
            FROM	pessoa_fisica_taxa
            WHERE	nr_seq_atecaco = nr_seq_interno_anterior_p;
        EXCEPTION
            WHEN OTHERS THEN
                nr_sequencia_pes_taxa_w := NULL;
        END;

        IF (nr_sequencia_pes_taxa_w IS NOT NULL AND nr_sequencia_pes_taxa_w::text <> '') THEN
            CALL replicar_pessoa_fisica_taxa(nr_sequencia_pes_taxa_w,
                                        NULL,
                                        nr_atendimento_p,
                                        NULL,
                                        NULL,
                                        'N');
        else

		select 	get_justification_under_aged(cd_pessoa_fisica_p, cd_convenio_p, nr_atendimento_p)
		into STRICT	nr_seq_justificativa_w
		;

		if (coalesce(nr_seq_justificativa_w, 0) > 0) then
			pessoa_fisica_taxa_w.qt_dias_pagamento          := 0;
			pessoa_fisica_taxa_w.nr_seq_justificativa       := nr_seq_justificativa_w;
			pessoa_fisica_taxa_w.nr_seq_atecaco             := nr_seq_interno_w;
			pessoa_fisica_taxa_w.nr_atendimento             := nr_atendimento_p;
			pessoa_fisica_taxa_w.nm_usuario_nrec            := nm_usuario_p;
			pessoa_fisica_taxa_w.nm_usuario                 := nm_usuario_p;
			pessoa_fisica_taxa_w.ie_obriga_pag_adicional    := 'N';
			pessoa_fisica_taxa_w.dt_pagamento               := null;
			pessoa_fisica_taxa_w.dt_atualizacao_nrec        := clock_timestamp();
			pessoa_fisica_taxa_w.dt_atualizacao             := clock_timestamp();
			pessoa_fisica_taxa_w.cd_pessoa_fisica           := cd_pessoa_fisica_p;

			select nextval('pessoa_fisica_taxa_seq')
			into STRICT	pessoa_fisica_taxa_w.nr_sequencia
			;

			insert into pessoa_fisica_taxa values (pessoa_fisica_taxa_w.*);
		end if;

        END IF;
    END IF;
    --
    nr_seq_interno_p		:= nr_seq_interno_w;
	commit;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_convenio_atendimento ( nr_atendimento_p bigint, cd_convenio_agenda_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, dt_entrada_p timestamp, cd_convenio_p bigint, cd_categoria_p text, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp, cd_usuario_convenio_p text, cd_empresa_p bigint, nr_doc_convenio_p text, nr_doc_conv_regra_p text, cd_tipo_acomodacao_p bigint, cd_tipo_acomodacao_regra_p bigint, cd_municipio_convenio_p bigint, cd_convenio_glosa_p bigint, cd_categoria_glosa_p text, dt_validade_carteira_p timestamp, nr_acompanhante_p bigint, cd_plano_convenio_p text, cd_dependente_p bigint, nr_seq_origem_p bigint, cd_senha_p text, ie_tipo_guia_p text, ds_observacao_p text, qt_dia_internacao_p bigint, qt_dia_internacao_pp bigint, dt_ultimo_pagto_p timestamp, ie_tipo_atendimento_p bigint, IE_REP_COD_USUARIO_p text, cd_complemento_p text, cd_plano_padrao_p text, ie_gerar_cep_cadastro_p text, ds_procedure_validacao_p text, cd_estabelecimento_p bigint, ie_tipo_acomodacao_p text, ie_opcao_p text, cd_plano_eup_p text, ie_situacao_plano_p text, ds_erro_p text, ie_Bloquear_Atend_p text, ie_gerar_data_validade_p text, ie_tipo_atend_lib_categ_p text, ie_gera_guia_regra_p text, ie_tipo_guia_regra_p text, ie_tipo_guia_atend_p text, qt_dieta_acomp_p bigint, ie_lib_dieta_p text, ie_exige_cpf_p text, ie_calcula_dt_vigencia_p text, qt_idade_p bigint, cd_pessoa_responsavel_p text, cd_pf_menor_p text, ie_clinica_p bigint, ie_atualiza_dias_internacao_p text, ie_aplica_digito_padrao_p text, ds_digitos_padrao_p text, cd_convenio_old_p bigint, nr_seq_regra_acomp_p bigint, ie_padrao_dados_conv_p text, ie_tipo_conveniado_p bigint default null, ie_autoriza_envio_convenio_p atend_categoria_convenio.ie_autoriza_envio_convenio%type DEFAULT NULL, nr_seq_interno_p INOUT bigint DEFAULT NULL, ie_regime_internacao_p atend_categoria_convenio.ie_regime_internacao%TYPE default null, nr_seq_abrangencia_p atend_categoria_convenio.nr_seq_abrangencia%TYPE default null, nr_seq_tipo_lib_guia_p atend_categoria_convenio.nr_seq_tipo_lib_guia%TYPE default null, nr_doc_conv_principal_p atend_categoria_convenio.nr_doc_conv_principal%TYPE default null, cd_senha_provisoria_p atend_categoria_convenio.cd_senha_provisoria%TYPE default null, ie_cod_usuario_mae_resp_p atend_categoria_convenio.ie_cod_usuario_mae_resp%TYPE default null, cd_plano_glosa_p atend_categoria_convenio.cd_plano_glosa%TYPE default null, cd_usuario_conv_glosa_p atend_categoria_convenio.cd_usuario_conv_glosa%TYPE default null, cd_complemento_glosa_p atend_categoria_convenio.cd_complemento_glosa%TYPE default null, dt_validade_cart_glosa_p atend_categoria_convenio.dt_validade_cart_glosa%TYPE default null, nr_seq_lib_dieta_conv_p atend_categoria_convenio.nr_seq_lib_dieta_conv%TYPE default null, nr_seq_interno_anterior_p atend_categoria_convenio.nr_seq_lib_dieta_conv%TYPE default null, nr_prioridade_p atend_categoria_convenio.nr_prioridade%type default null, nr_seq_categoria_iva_p atend_categoria_convenio.nr_seq_categoria_iva%type default null) FROM PUBLIC;
