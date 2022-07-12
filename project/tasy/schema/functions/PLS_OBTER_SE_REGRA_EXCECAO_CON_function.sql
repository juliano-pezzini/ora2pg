-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_excecao_con ( nr_seq_ocorrencia_p bigint, nr_seq_conta_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, dt_emissao_p timestamp,		--utilizar a dt_referencia_w
 ie_tipo_item_p bigint, nr_seq_prestador_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text, cd_estabelecimento_p text, nr_seq_plano_p bigint, ie_tipo_internado_con_p text, qt_idade_p bigint, qt_idade_meses_p bigint, nr_seq_prestador_exec_p bigint, nr_seq_prest_prot_p bigint, cd_pessoa_fisica_p text, nr_seq_contrato_p bigint, nr_seq_intercambio_p bigint, ie_tipo_segurado_p text, dt_nascimento_p timestamp, ie_pcmso_benef_p text, nr_seq_clinica_p bigint, nr_seq_tipo_acomod_conta_p bigint, cd_guia_p text, cd_guia_referencia_p text, ie_tipo_guia_conta_p text, nr_seq_tipo_atend_conta_p bigint, ie_carater_internacao_p text, nr_seq_protocolo_p bigint, nr_seq_tipo_acomodacao_p bigint, ie_origem_protocolo_conta_p text, cd_prestador_exec_p text, nr_seq_regra_pos_p pls_oc_regra_pos_estab.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE


qt_ocorrencia_w				bigint;
qt_dias_w				bigint;
ie_porte_anestesico_w			varchar(1);
nr_seq_estrutura_w			bigint;
ds_retorno_w				varchar(1) := 'N';
cd_procedimento_w			bigint;
ie_origem_proced_w			integer;
cd_procedimento_p_w			bigint;
ie_origem_proced_p_w			integer;
ie_estrutura_w				varchar(1);
ie_porte_w				varchar(1);
cd_medico_executor_regra_w		varchar(10);
ie_medico_exec_solic_w			varchar(1);
nr_seq_proc_espec_w			bigint;
ie_oc_medico_exec_w			varchar(1);
ie_espec_solic_proc_w			varchar(1);
nr_seq_grupo_prestador_w		bigint;
dt_nascimento_w				timestamp;
ie_grupo_prest_w			varchar(1);
nr_seq_prestador_w			bigint;
nr_seq_tipo_prestador_w			bigint;
nr_seq_classificacao_w			bigint;
nr_seq_classificacao_regra_w		bigint;
ie_tipo_prestador_w			varchar(1);
nr_seq_tipo_prestador_regra_w		bigint;
nr_seq_estrut_mat_w			bigint;
nr_seq_estrutura_mat_regra_w		bigint;
nr_seq_grupo_servico_regra_w		bigint;
nr_seq_grau_partic_regra_w		bigint;
nr_seq_grau_partic_w			bigint;
ie_grupo_servico_w			varchar(2);
nr_seq_clinica_regra_w			bigint;
nr_seq_clinica_w			bigint;
nr_seq_tipo_acomod_conta_w		bigint;
nr_seq_tipo_acomodacao_w		bigint;
ie_unid_tempo_idade_w			varchar(2);
qt_idade_min_w				smallint;
qt_idade_max_w				smallint;
qt_idade_w				varchar(5);
qt_idade_meses_w			integer;
nr_seq_grupo_material_regra_w		bigint;
ie_grupo_material_w			varchar(2);
nr_seq_grupo_contrato_w			bigint;
nr_seq_contrato_w			bigint;
nr_seq_intercambio_w			bigint;
qt_existe_grupo_w			integer;
cd_prestador_exec_w			varchar(30);
dt_inicio_vigencia_w			timestamp;
dt_fim_vigencia_w			timestamp;
ie_tipo_data_w				varchar(2);
dt_referencia_w				timestamp;
dt_max_proc_w				timestamp;
dt_max_mat_w				timestamp;
dt_max_item_w				timestamp;
dt_emissao_w				timestamp;
dt_procedimento_w			timestamp;
dt_material_w				timestamp;
ie_tipo_segurado_w			varchar(3);
ie_item_conta_autorizada_w		varchar(2);
dt_proc_mat_w				timestamp;
dt_validade_senha_w			timestamp;
cd_guia_w				varchar(20);
cd_guia_referencia_w			varchar(20);
ie_tipo_guia_w				varchar(10);
ie_tipo_guia_regra_w			varchar(10);
qt_autorizada_w				double precision;
qt_procedimento_w			double precision;
cd_procedimento_ww			bigint;
nr_seq_proc_w				bigint;
nr_seq_mat_con_w			bigint;
ie_origem_proced_ww			integer;
nr_seq_mat_w				bigint;
qt_mat_w				double precision;
qt_mat_autorizado_w			double precision;
ie_retorno_w				varchar(1);
nr_seq_prestador_pag_w			bigint;
nr_seq_tipo_atendimento_w		bigint;
nr_seq_tipo_atend_con_w			bigint;
ie_carater_internacao_con_w		varchar(1);
ie_tipo_internado_con_w			varchar(1);
ie_carater_internacao_w			varchar(1);
ie_tipo_internado_w			varchar(1);
nr_seq_grupo_produto_w			bigint;
nr_seq_plano_w				bigint;
ie_grupo_produto_w			varchar(1);
qt_prestador_proc_w			bigint;
nr_seq_prestador_regra_w		bigint;
cd_prestador_regra_w			varchar(30);
cd_pessoa_fisica_w			varchar(10);
ie_validacao_compl_prest_w		varchar(1)	:= 'S';
nr_seq_regra_w				bigint;
ie_pcmso_regra_w			varchar(1);
ie_pcmso_benef_w			varchar(1);
nr_seq_simultaneo_w			bigint;
ie_simultaneo_w				varchar(1);
ie_origem_protocolo_w			varchar(1);
ie_origem_protocolo_conta_w		varchar(1);
nr_seq_protocolo_w			bigint;
ie_internado_regra_w			varchar(1);
qt_guia_relacionada_inter_w		smallint;
nr_seq_material_p_w			bigint;
nr_seq_grupo_doenca_regra_w		bigint;
cd_doenca_cid_conta_w			varchar(50);
ie_grupo_doenca_w			varchar(1);


C00 CURSOR FOR
	SELECT	cd_procedimento_p,
		ie_origem_proced_p,
		null,
		nr_seq_proc_p,
		nr_seq_mat_p
	
	where	coalesce(cd_procedimento_p,0) > 0
	and	ie_tipo_item_p = 3
	
union all

	SELECT	null,
		null,
		nr_seq_material_p,
		nr_seq_proc_p,
		nr_seq_mat_p
	
	where	coalesce(nr_seq_material_p,0) > 0
	and	ie_tipo_item_p = 4
	
union all

	select	cd_procedimento,
		ie_origem_proced,
		null,
		nr_sequencia,
		null
	from	pls_conta_proc
	where	nr_seq_conta = nr_seq_conta_p
	and	ie_tipo_item_p = 8
	
union all

	select	null,
		null,
		nr_seq_material,
		null,
		nr_sequencia
	from	pls_conta_mat
	where	nr_seq_conta = nr_seq_conta_p
	and	ie_tipo_item_p = 8;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		ie_tipo_guia,
		qt_dias,
		ie_porte_anestesico,
		nr_seq_estrutura,
		cd_procedimento,
		ie_origem_proced,
		cd_medico_executor,
		ie_medico,
		nr_seq_proc_espec,
		nr_seq_grupo_prestador,
		nr_seq_classificacao,
		ie_tipo_prestador,
		nr_seq_tipo_prestador,
		nr_seq_grupo_servico,
		nr_seq_estrut_mat,--ASKONO
		nr_seq_grau_partic,
		nr_seq_clinica,
		ie_unid_tempo_idade,
		qt_idade_min,
		qt_idade_max,
		nr_seq_grupo_material,
		nr_seq_grupo_contrato,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		ie_item_conta_autorizada,
		coalesce(ie_tipo_data,'C'),
		nr_seq_prestador_pag,
		nr_seq_tipo_atendimento,
		ie_carater_internacao,
		ie_tipo_internado,
		nr_seq_grupo_produto,
		nr_seq_plano,
		nr_seq_prestador,
		cd_prestador_exec,
		coalesce(ie_pcmso, 'N'),
		nr_seq_simultaneo,
		ie_origem_protocolo,
		ie_internado /*,
		nr_seq_grupo_doenca*/
	from	pls_excecao_ocorrencia
	where	nr_seq_ocorrencia = nr_seq_ocorrencia_p
	and	ie_conta_medica	= 'S'
	and	ie_situacao	= 'A'
	and	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento	= cd_procedimento_p_w and ie_origem_proced = ie_origem_proced_p_w))
	and	((coalesce(nr_seq_clinica::text, '') = '') or (nr_seq_clinica = nr_seq_clinica_w )) /* askono - OS362819*/
	and	((coalesce(nr_seq_tipo_acomod_conta::text, '') = '') or (nr_seq_tipo_acomod_conta = nr_seq_tipo_acomod_conta_w ) )
	and	((coalesce(nr_seq_tipo_acomodacao::text, '') = '') or (nr_seq_tipo_acomodacao  = nr_seq_tipo_acomodacao_w ))
	and	((coalesce(ie_tipo_segurado::text, '') = '') or (ie_tipo_segurado = ie_tipo_segurado_w))
	and	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia = ie_tipo_guia_w))
	and	coalesce(nr_seq_regra_pos_p::text, '') = ''
	
union all

	SELECT	nr_sequencia,
		ie_tipo_guia,
		qt_dias,
		ie_porte_anestesico,
		nr_seq_estrutura,
		cd_procedimento,
		ie_origem_proced,
		cd_medico_executor,
		ie_medico,
		nr_seq_proc_espec,
		nr_seq_grupo_prestador,
		nr_seq_classificacao,
		ie_tipo_prestador,
		nr_seq_tipo_prestador,
		nr_seq_grupo_servico,
		nr_seq_estrut_mat,--ASKONO
		nr_seq_grau_partic,
		nr_seq_clinica,
		ie_unid_tempo_idade,
		qt_idade_min,
		qt_idade_max,
		nr_seq_grupo_material,
		nr_seq_grupo_contrato,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		ie_item_conta_autorizada,
		coalesce(ie_tipo_data,'C'),
		nr_seq_prestador_pag,
		nr_seq_tipo_atendimento,
		ie_carater_internacao,
		ie_tipo_internado,
		nr_seq_grupo_produto,
		nr_seq_plano,
		nr_seq_prestador,
		cd_prestador_exec,
		coalesce(ie_pcmso, 'N'),
		nr_seq_simultaneo,
		ie_origem_protocolo,
		ie_internado /*,
		nr_seq_grupo_doenca*/
	from	pls_excecao_ocorrencia
	where	nr_seq_ocorrencia = nr_seq_ocorrencia_p
	and	ie_conta_medica	= 'N'
	and	ie_situacao	= 'A'
	and	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento	= cd_procedimento_p_w and ie_origem_proced = ie_origem_proced_p_w))
	and	((coalesce(nr_seq_clinica::text, '') = '') or (nr_seq_clinica = nr_seq_clinica_w )) /* askono - OS362819*/
	and	((coalesce(nr_seq_tipo_acomod_conta::text, '') = '') or (nr_seq_tipo_acomod_conta = nr_seq_tipo_acomod_conta_w ) )
	and	((coalesce(nr_seq_tipo_acomodacao::text, '') = '') or (nr_seq_tipo_acomodacao  = nr_seq_tipo_acomodacao_w ))
	and	((coalesce(ie_tipo_segurado::text, '') = '') or (ie_tipo_segurado = ie_tipo_segurado_w))
	and	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia = ie_tipo_guia_w))
	and	((coalesce(nr_seq_regra_pos_p::text, '') = '') or (nr_seq_regra_pos = nr_seq_regra_pos_p));

C02 CURSOR FOR
	SELECT	a.nr_seq_prestador,
		b.nr_seq_tipo_prestador,
		b.nr_seq_classificacao
	from	pls_proc_participante a,
		pls_prestador b
	where	a.nr_seq_prestador	= b.nr_sequencia
	and	a.nr_seq_conta_proc	= nr_seq_proc_p;


BEGIN
nr_seq_clinica_w		:= nr_seq_clinica_p;
nr_seq_tipo_acomod_conta_w	:= nr_seq_tipo_acomod_conta_p;
cd_guia_w			:= cd_guia_p;
cd_guia_referencia_w		:= cd_guia_referencia_p;
ie_tipo_guia_w			:= ie_tipo_guia_conta_p;
nr_seq_tipo_atend_con_w		:= nr_seq_tipo_atend_conta_p;
ie_carater_internacao_con_w	:= ie_carater_internacao_p;
nr_seq_protocolo_w		:= nr_seq_protocolo_p;
ie_origem_protocolo_conta_w	:= ie_origem_protocolo_conta_p;
cd_prestador_exec_w		:= cd_prestador_exec_p;
ie_tipo_internado_con_w		:= ie_tipo_internado_con_p;
qt_idade_w			:= qt_idade_p;
qt_idade_meses_w		:= qt_idade_meses_p;
cd_pessoa_fisica_w		:= cd_pessoa_fisica_p;
nr_seq_contrato_w		:= nr_seq_contrato_p;
nr_seq_intercambio_w		:= nr_seq_intercambio_p;
ie_tipo_segurado_w		:= ie_tipo_segurado_p;
dt_nascimento_w			:= dt_nascimento_p;
ie_pcmso_benef_w		:= ie_pcmso_benef_p;
nr_seq_tipo_acomodacao_w	:= nr_seq_tipo_acomodacao_p;

/*Obter dados da autorização */

begin
if (ie_tipo_item_p	= 3)	then
	if (cd_guia_referencia_w IS NOT NULL AND cd_guia_referencia_w::text <> '') then
		select 	max(a.dt_validade_senha)
		into STRICT	dt_validade_senha_w
		from 	pls_guia_plano		a,
			pls_guia_plano_proc	b
		where 	a.nr_sequencia		= b.nr_seq_guia
		and 	b.cd_procedimento	= cd_procedimento_p
		and	b.ie_origem_proced	= ie_origem_proced_p
		and 	a.cd_guia		= cd_guia_referencia_w
		and 	ie_estagio 		in (5,6,10);
	elsif (cd_guia_w IS NOT NULL AND cd_guia_w::text <> '') then
		select 	max(a.dt_validade_senha)
		into STRICT	dt_validade_senha_w
		from 	pls_guia_plano		a,
			pls_guia_plano_proc	b
		where 	a.nr_sequencia		= b.nr_seq_guia
		and 	b.cd_procedimento	= cd_procedimento_p
		and	b.ie_origem_proced	= ie_origem_proced_p
		and 	a.cd_guia 		= cd_guia_w
		and 	ie_estagio 		in (5,6,10);
	else
		dt_validade_senha_w	:= null;
	end if;
end if;
if (ie_tipo_item_p = 4)	then
	if (cd_guia_w IS NOT NULL AND cd_guia_w::text <> '') then
		select 	max(a.dt_validade_senha)
		into STRICT	dt_validade_senha_w
		from 	pls_guia_plano		a,
			pls_guia_plano_mat	b
		where 	a.nr_sequencia		= b.nr_seq_guia
		and 	b.nr_seq_material	= nr_seq_material_p
		and 	a.cd_guia		= cd_guia_w;
	elsif (cd_guia_referencia_w IS NOT NULL AND cd_guia_referencia_w::text <> '') then
		select 	max(a.dt_validade_senha)
		into STRICT	dt_validade_senha_w
		from 	pls_guia_plano		a,
			pls_guia_plano_mat	b
		where 	a.nr_sequencia		= b.nr_seq_guia
		and 	b.nr_seq_material	= nr_seq_material_p
		and 	a.cd_guia 		= cd_guia_referencia_w;
	else
		dt_validade_senha_w	:= null;
	end if;
end if;
if (ie_tipo_item_p = 8)	then
	if (cd_guia_w IS NOT NULL AND cd_guia_w::text <> '') then
		select 	max(a.dt_validade_senha)
		into STRICT	dt_validade_senha_w
		from 	pls_guia_plano		a
		where 	a.cd_guia		= cd_guia_w;
	elsif (cd_guia_referencia_w IS NOT NULL AND cd_guia_referencia_w::text <> '') then
		select 	max(a.dt_validade_senha)
		into STRICT	dt_validade_senha_w
		from 	pls_guia_plano		a
		where 	a.cd_guia 		= cd_guia_referencia_w;
	else
		dt_validade_senha_w	:= null;
	end if;
end if;
end;

/*Obtendo dados do material*/

if (coalesce(nr_seq_material_p,0) <> 0) then
	select	max(nr_seq_estrut_mat)
	into STRICT	nr_seq_estrut_mat_w
	from	pls_material
	where	nr_sequencia	= nr_seq_material_p;
end if;
if (ie_tipo_item_p	= 3) then

	begin
	select	a.dt_procedimento,
		b.dt_atendimento_referencia,
		(coalesce(a.qt_procedimento_imp,0)),
		a.cd_procedimento,
		a.ie_origem_proced,
		obter_cid_doenca_procedimento(a.cd_procedimento,a.ie_origem_proced,'C')
	into STRICT	dt_procedimento_w,
		dt_emissao_w,
		qt_procedimento_w,
		cd_procedimento_ww,
		ie_origem_proced_ww,
		cd_doenca_cid_conta_w
	from	pls_conta_proc 	a,
		pls_conta		b
	where	b.nr_sequencia = a.nr_seq_conta
	and	a.nr_sequencia = nr_seq_proc_p;
	exception
	when others then
		dt_emissao_w 		:= clock_timestamp();
		dt_procedimento_w	:= clock_timestamp();
	end;

	if (coalesce(dt_emissao_w::text, '') = '')			and (dt_procedimento_w IS NOT NULL AND dt_procedimento_w::text <> '')		then

		dt_emissao_w := dt_procedimento_w;

	elsif (dt_emissao_w IS NOT NULL AND dt_emissao_w::text <> '')	and (coalesce(dt_procedimento_w::text, '') = '')	then

		dt_procedimento_w	:= dt_emissao_w;

	end if;

elsif (ie_tipo_item_p	= 4) then

	begin
	select	a.dt_atendimento,
		b.dt_atendimento_referencia,
		coalesce(qt_material_imp,0),
		nr_seq_material
	into STRICT	dt_material_w,
		dt_emissao_w,
		qt_mat_w,
		nr_seq_mat_w
	from	pls_conta_mat	a,
		pls_conta		b
	where	b.nr_sequencia = a.nr_seq_conta
	and	a.nr_sequencia = nr_seq_mat_p;
	exception
	when others then
		dt_emissao_w 	:= clock_timestamp();
		dt_material_w	:= clock_timestamp();
	end;

	if (coalesce(dt_emissao_w::text, '') = '')		and (dt_material_w IS NOT NULL AND dt_material_w::text <> '')	then

		dt_emissao_w := dt_material_w;

	elsif (dt_emissao_w IS NOT NULL AND dt_emissao_w::text <> '')	and (coalesce(dt_material_w::text, '') = '')		then

		dt_material_w	:= dt_emissao_w;

	end if;

elsif (ie_tipo_item_p	= 8) then

	select	max(dt_atendimento_referencia)
	into STRICT	dt_emissao_w
	from	pls_conta
	where	nr_sequencia = nr_seq_conta_p;

	dt_max_item_w	:= dt_emissao_w;

	select	max(dt_procedimento)
	into STRICT	dt_max_proc_w
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_p;

	if (dt_max_proc_w	> dt_max_item_w) then
		dt_max_item_w	:= dt_max_proc_w;
	end if;

	select	max(dt_atendimento)
	into STRICT	dt_max_mat_w
	from	pls_conta_mat
	where	nr_seq_conta	= nr_seq_conta_p;

	if (dt_max_mat_w	> dt_max_item_w) then
		dt_max_item_w	:= dt_max_mat_w;
	end if;
end if;

open C00;
loop
fetch C00 into
	cd_procedimento_p_w,
	ie_origem_proced_p_w,
	nr_seq_material_p_w,
	nr_seq_proc_w,
	nr_seq_mat_con_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin
	open C01;
	loop
	fetch C01 into
		nr_seq_regra_w,
		ie_tipo_guia_regra_w,
		qt_dias_w,
		ie_porte_anestesico_w,
		nr_seq_estrutura_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_medico_executor_regra_w,
		ie_medico_exec_solic_w,
		nr_seq_proc_espec_w,
		nr_seq_grupo_prestador_w,
		nr_seq_classificacao_regra_w,
		ie_tipo_prestador_w,
		nr_seq_tipo_prestador_regra_w,
		nr_seq_grupo_servico_regra_w,
		nr_seq_estrutura_mat_regra_w,
		nr_seq_grau_partic_regra_w,
		nr_seq_clinica_regra_w,
		ie_unid_tempo_idade_w,
		qt_idade_min_w,
		qt_idade_max_w,
		nr_seq_grupo_material_regra_w,
		nr_seq_grupo_contrato_w,
		dt_inicio_vigencia_w,
		dt_fim_vigencia_w,
		ie_item_conta_autorizada_w,
		ie_tipo_data_w,
		nr_seq_prestador_pag_w,
		nr_seq_tipo_atendimento_w,
		ie_carater_internacao_w,
		ie_tipo_internado_w,
		nr_seq_grupo_produto_w,
		nr_seq_plano_w,
		nr_seq_prestador_regra_w,
		cd_prestador_regra_w,
		ie_pcmso_regra_w,
		nr_seq_simultaneo_w,
		ie_origem_protocolo_w,
		ie_internado_regra_w/*,
		nr_seq_grupo_doenca_regra_w*/
;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (ie_origem_protocolo_w IS NOT NULL AND ie_origem_protocolo_w::text <> '') then
			if	((ie_origem_protocolo_w <> ie_origem_protocolo_conta_w) or (coalesce(ie_origem_protocolo_conta_w::text, '') = '')) then
				goto final;
			end if;
		end if;

		if (ie_tipo_guia_regra_w IS NOT NULL AND ie_tipo_guia_regra_w::text <> '') then
			if (ie_tipo_guia_w	<> ie_tipo_guia_regra_w) then
				goto final;
			end if;
		end if;
		if (ie_tipo_data_w	= 'I') then
			if (ie_tipo_item_p	= 3) then
				dt_referencia_w	:= dt_procedimento_w;
			elsif (ie_tipo_item_p	= 4) then
				dt_referencia_w	:= dt_material_w;
			elsif (ie_tipo_item_p	= 8) then
				dt_referencia_w	:= dt_max_item_w;
			end if;
		elsif (ie_tipo_data_w	= 'C') then
			dt_referencia_w	:= dt_emissao_w;
		end if;
		if	not(trunc(dt_referencia_w) between trunc(dt_inicio_vigencia_w) and trunc(fim_dia(coalesce(dt_fim_vigencia_w,dt_referencia_w)))) then
			goto final;
		end if;

		/*Regra para tipo de atendimento*/

		if (coalesce(nr_seq_tipo_atendimento_w,0) <> 0)	then
			if (nr_seq_tipo_atendimento_w <> nr_seq_tipo_atend_con_w) or (coalesce(nr_seq_tipo_atend_con_w::text, '') = '') then/*Se o tipo de atendimento da conta for nulo, não irá gerar exeção drquadros 19/06/2013*/
				goto final;
			end if;
		end if;

		/*Se for uma regra de procedimento*/

		if (cd_procedimento_w > 0)and (coalesce(nr_seq_estrutura_w,0) = 0) then
			/*Verifica se o procedimento da regra consiste com o do procedimento da conta / guia*/

			if (cd_procedimento_w <> coalesce(cd_procedimento_p_w,0)) or (ie_origem_proced_w <> coalesce(ie_origem_proced_p_w,0)) then
				goto final;
			end if;
		/*Se for regra de estrutura*/

		elsif (nr_seq_estrutura_w  > 0) and (coalesce(cd_procedimento_w,0) = 0) then
			/*Verifica-se se algum dos procedimentos daestrutura existe na conta / guia*/

			ie_estrutura_w	:= pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_w, cd_procedimento_p, ie_origem_proced_p, nr_seq_material_p);

			if (ie_estrutura_w = 'N') then
				/*Se não existe */

				goto final;
			end if;
		/*Se for regra de estrutura e procedimento verifica-se os dois*/

		elsif (cd_procedimento_w > 0)and (nr_seq_estrutura_w > 0) then
			/*Se na regra já coincidiu o procedimento com o da conta já é gerado ocorrencia sem necessidadse de verificar a estrutura.	*/

			if	(((cd_procedimento_w <> cd_procedimento_p) or (ie_origem_proced_w <> ie_origem_proced_p)) or (coalesce(cd_procedimento_p,0) = 0)) then
				/*Se for regar de material ou o procedimento não consistir com a regra é verificado a estrutura.*/

				if (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_w, cd_procedimento_p, ie_origem_proced_p, nr_seq_material_p) = 'N') then
				goto final;
				end if;
			end if;

		end if;

		/*Grupos de Doencas*/

		if	((coalesce(nr_seq_grupo_doenca_regra_w,0) > 0) and (coalesce(cd_doenca_cid_conta_w, '~X~') <> '~X~')) then
			ie_grupo_doenca_w	:= pls_se_grupo_preco_doenca(nr_seq_grupo_doenca_regra_w, cd_doenca_cid_conta_w);
				if (ie_grupo_doenca_w = 'N') then
					goto final;
				end if;
		end if;

		/*Grupo serviço*/
--askono OS362819
		if (coalesce(nr_seq_grupo_servico_regra_w,0) > 0) then
			ie_grupo_servico_w	:= pls_se_grupo_preco_servico(nr_seq_grupo_servico_regra_w, cd_procedimento_p, ie_origem_proced_p);
			if (ie_grupo_servico_w	= 'N') then
				goto final;
			end if;
		end if;

		/*Regra de estrutura de material*/

		if (coalesce(nr_seq_estrutura_mat_regra_w,0) > 0) and (coalesce(nr_seq_material_p,0)>0) then
			if (nr_seq_estrutura_mat_regra_w <> nr_seq_estrut_mat_w) then
				goto final;
			end if;
		end if;

		/* Grupo de material */

		if (coalesce(nr_seq_grupo_material_regra_w,0) > 0) and (coalesce(nr_seq_material_p,0) > 0) then
			ie_grupo_material_w	:= pls_se_grupo_preco_material(nr_seq_grupo_material_regra_w, nr_seq_material_p);
			if (ie_grupo_material_w	= 'N') then
				goto final;
			end if;
		end if;


		/*Regra grau de participação*/
-- askono OS362819
		if (coalesce(nr_seq_grau_partic_regra_w,0) > 0) then

			if (ie_tipo_item_p in (3,8)) then
				if (pls_obter_conta_grau_partic(nr_seq_conta_p, nr_seq_proc_w, nr_seq_grau_partic_regra_w) = 'N') then
					goto final;
				end if;
			end if;
		end if;

		if (coalesce(cd_medico_executor_regra_w,0) > 0) and (ie_tipo_item_p in (3,8))then
			/*Rotina que verifica os médico retorna se o médico passado como parâmetro é um destes
			    Retorna  S - Se faz parte da conta como médico
			    Retorna  N - Se não for um dos médicos da conta*/
			ie_oc_medico_exec_w	:= pls_obter_med_exec_ocor(nr_seq_conta_p, nr_seq_proc_w, ie_tipo_item_p, cd_medico_executor_regra_w, ie_medico_exec_solic_w);
			if (ie_oc_medico_exec_w = 'N') then
				goto final;
			end if;
		end if;

		/*Nesta regra é verificado se quais especialidades podem excutar tais procedimentos. Depende do campo IE_MEDICO para verificar se é uma regra de EXECUTOR ou SOLICITANTE */

		if (coalesce(nr_seq_proc_espec_w,0) <> 0) then
			if (ie_tipo_item_p = 3) then
				ie_espec_solic_proc_w := pls_obter_se_espec_solic_proc(nr_seq_proc_w, nr_seq_proc_espec_w, ie_medico_exec_solic_w);
				if (ie_espec_solic_proc_w = 'S') then
					goto final;
				end if;
			else
				goto final;
			end if;
		end if;

		if (coalesce(nr_seq_proc_w,0) > 0) then
			/*select	count(1)
			into	qt_prestador_proc_w
			from	pls_proc_participante	b,
				pls_conta_proc	 a
			where	b.nr_seq_conta_proc = a.nr_sequencia
			and	b.nr_seq_prestador > 0
			and	a.nr_sequencia	= nr_seq_proc_p
			and	rownum = 1;*/
			qt_prestador_proc_w	:= 0;
		end if;
		/*Se for uma regra que verifica o prestador executante, ou solicitante */

		if (coalesce(qt_prestador_proc_w,0) = 0) then
			if (ie_tipo_prestador_w = 'E') then
				nr_seq_prestador_w 	:= nr_seq_prestador_exec_p;
			elsif (ie_tipo_prestador_w = 'S') then
				nr_seq_prestador_w	:= nr_seq_prest_prot_p;
			else
				nr_seq_prestador_w := nr_seq_prestador_p;
			end if;

			if	(nr_seq_prestador_regra_w IS NOT NULL AND nr_seq_prestador_regra_w::text <> '' AND nr_seq_prestador_regra_w <> nr_seq_prestador_w) then
				goto final;
			end if;
			if	(cd_prestador_regra_w IS NOT NULL AND cd_prestador_regra_w::text <> '' AND cd_prestador_regra_w <> cd_prestador_exec_w) then
				goto final;
			end if;
			/*Verificar se o prestador pertence ao grupo dos prestador*/

			if (coalesce(nr_seq_grupo_prestador_w,0) > 0) then
				/* Obter dados do prestador */

				begin
				select	nr_seq_classificacao
				into STRICT	nr_seq_classificacao_w
				from	pls_prestador
				where	nr_sequencia	= nr_seq_prestador_w;
				exception
				when others then
					nr_seq_classificacao_w	:= 0;
				end;

				ie_grupo_prest_w	:= pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, nr_seq_prestador_w, nr_seq_classificacao_w);
				if (ie_grupo_prest_w = 'N') then
					goto final;
				end if;
			end if;

			/*Obter se a regra é para uma classificacao do prestador*/

			if (coalesce(nr_seq_classificacao_regra_w,0) > 0) then
				if (nr_seq_classificacao_regra_w <> nr_seq_classificacao_w) then
					goto final;
				end if;
			end if;

			/*Se for uma regra para o tipo do prestador*/

			if (coalesce(nr_seq_tipo_prestador_regra_w,0) > 0) then
				/* Obter dados do prestador */

				begin
				select	nr_seq_tipo_prestador
				into STRICT	nr_seq_tipo_prestador_w
				from	pls_prestador
				where	nr_sequencia	= nr_seq_prestador_w;
				exception
				when others then
					nr_seq_tipo_prestador_w	:= 0;
				end;

				/*Se for é verificado se o prestador é do tipo do prestador da regra*/

				if (nr_seq_tipo_prestador_regra_w <> nr_seq_tipo_prestador_w) then
					goto final;
				end if;
			end if;
		else
			open C02;
			loop
			fetch C02 into
				nr_seq_prestador_w,
				nr_seq_tipo_prestador_w,
				nr_seq_classificacao_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				if	(nr_seq_prestador_regra_w IS NOT NULL AND nr_seq_prestador_regra_w::text <> '' AND nr_seq_prestador_regra_w <> nr_seq_prestador_w) then
					goto final;
				end if;
				if	(cd_prestador_regra_w IS NOT NULL AND cd_prestador_regra_w::text <> '' AND cd_prestador_regra_w <> cd_prestador_exec_w) then
					goto final;
				end if;

				/*Verificar se o prestador pertence ao grupo dos prestador*/

				if (coalesce(nr_seq_grupo_prestador_w,0) > 0) then
					ie_grupo_prest_w	:= pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, nr_seq_prestador_w, nr_seq_classificacao_w);
					if (ie_grupo_prest_w = 'N') then
						goto final;
					end if;
				end if;

				/*Obter se a regra é para uma classificacao do prestador*/

				if (coalesce(nr_seq_classificacao_regra_w,0) > 0) then
					if (nr_seq_classificacao_regra_w <> nr_seq_classificacao_w) then
						goto final;
					end if;
				end if;

				/*Se for uma regra para o tipo do prestador*/

				if (coalesce(nr_seq_tipo_prestador_regra_w,0) > 0) then
					/*Se for é verificado se o prestador é do tipo do prestador da regra*/

					if (nr_seq_tipo_prestador_regra_w <> nr_seq_tipo_prestador_w) then
						goto final;
					end if;
				end if;
				end;
			end loop;
			close C02;
		end if;

		/* Regra de prestador pagamento */

		if (coalesce(nr_seq_prestador_pag_w,0) > 0) then
			ie_retorno_w := pls_consistir_prestador_pgto(	nr_seq_conta_p, nr_seq_proc_w, nr_seq_mat_con_w, nr_seq_prestador_pag_w, ie_retorno_w, nm_usuario_p);
			if (coalesce(ie_retorno_w,'N') = 'N') then
				goto final;
			end if;
		end if;

		/* Francisco - 28/06/2012 - Validação complementar de prestador */

		ie_validacao_compl_prest_w := pls_valida_compl_ocor_prest(	'PLS_EXCECAO_OCORRENCIA', nr_seq_regra_w, nr_seq_conta_p, nr_seq_prestador_p, dt_referencia_w, ie_validacao_compl_prest_w);

		if (ie_validacao_compl_prest_w = 'N') then
			goto final;
		end if;


		/* Verificar se for regra de quantidade de idade minima ou maxima da regra, sendo "A" por ano e "M" por meses*/

		if (ie_unid_tempo_idade_w = 'A') then
			if	(qt_idade_min_w IS NOT NULL AND qt_idade_min_w::text <> '' AND qt_idade_min_w > qt_idade_w) or
				(qt_idade_max_w IS NOT NULL AND qt_idade_max_w::text <> '' AND qt_idade_max_w < qt_idade_w) then
				goto final;
			end if;
		elsif (ie_unid_tempo_idade_w = 'M') then
			if	(qt_idade_min_w IS NOT NULL AND qt_idade_min_w::text <> '' AND qt_idade_min_w > qt_idade_meses_w) or
				(qt_idade_max_w IS NOT NULL AND qt_idade_max_w::text <> '' AND qt_idade_max_w < qt_idade_meses_w) then
				goto final;
			end if;
		end if;

		/* Verificar se o contrato do beneficiário pertence ao grupo de contrato cadastrado na regra */

		if (coalesce(nr_seq_grupo_contrato_w,0) <> 0) then
			select	count(1)
			into STRICT	qt_existe_grupo_w
			from	pls_preco_contrato	a
			where	a.nr_seq_grupo		= nr_seq_grupo_contrato_w
			and (nr_seq_contrato	= nr_seq_contrato_w
			or	nr_seq_intercambio	= nr_seq_intercambio_w)  LIMIT 1;
			if (qt_existe_grupo_w = 0) then
				goto final;
			end if;
		end if;

		if (ie_carater_internacao_w IS NOT NULL AND ie_carater_internacao_w::text <> '')	then
			if (ie_carater_internacao_w <> ie_carater_internacao_con_w)	then
				goto final;
			end if;
		end if;

		if (ie_tipo_internado_w IS NOT NULL AND ie_tipo_internado_w::text <> '')	then
			if (ie_tipo_internado_w <> ie_tipo_internado_con_w)	then
				goto final;
			end if;
		end if;
		if (nr_seq_grupo_produto_w IS NOT NULL AND nr_seq_grupo_produto_w::text <> '')	then
			ie_grupo_produto_w	:= pls_se_grupo_preco_produto(nr_seq_grupo_produto_w, nr_seq_plano_p);
			if (ie_grupo_produto_w = 'N')	then
				goto final;
			end if;
		end if;

		if (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '')	then
			if (nr_seq_plano_w	<> nr_seq_plano_p) then
				goto final;
			end if;
		end if;

		if (coalesce(nr_seq_simultaneo_w,0) > 0)	then
			ie_simultaneo_w := pls_verificar_ocorrencia_simul(	nr_seq_simultaneo_w, nr_seq_conta_p, null, cd_procedimento_p, ie_origem_proced_p, nr_seq_material_p, ie_tipo_item_p, ie_simultaneo_w, cd_estabelecimento_p, nm_usuario_p, nr_seq_proc_w, nr_seq_mat_con_w);

			if (ie_simultaneo_w = 'N') then
				goto final;
			end if;

		end if;

		if 	((cd_guia_referencia_w IS NOT NULL AND cd_guia_referencia_w::text <> '')  or (cd_guia_w IS NOT NULL AND cd_guia_w::text <> ''))  and (ie_item_conta_autorizada_w = 'S') then
			if (ie_tipo_item_p  = 3)	then
				begin
				select 	sum(b.qt_autorizada)
				into STRICT	qt_autorizada_w
				from	pls_guia_plano		a,
					pls_guia_plano_proc	b
				where	a.nr_sequencia 	= b.nr_seq_guia
				and	((a.cd_guia	= coalesce(cd_guia_referencia_w,cd_guia_w))
				or (a.cd_guia_principal = cd_guia_referencia_w))
				and	a.nr_seq_segurado = nr_seq_segurado_p
				and	b.cd_procedimento  = cd_procedimento_ww
				and	b.ie_origem_proced = ie_origem_proced_ww
				and	(b.qt_autorizada IS NOT NULL AND b.qt_autorizada::text <> '')
				and 	a.ie_status = '1'
				and	b.ie_status in ('L','S','P');
				exception
				when others then
					qt_autorizada_w := 0;
				end;

				/*select	max(a.dt_procedimento)
				into	dt_proc_mat_w
				from	pls_conta_proc	a,
					pls_conta	b
				where	b.nr_sequencia	= a.nr_seq_conta
				and 	a.nr_sequencia 	= nr_seq_proc_p
				and 	b.nr_sequencia	= nr_seq_conta_p
				and 	((b.cd_guia	        = cd_guia_w) or (b.cd_guia_referencia = cd_guia_referencia_w))
				and 	a.ie_status in('L','S','P');*/
				if (coalesce(dt_procedimento_w,clock_timestamp()) > coalesce(dt_validade_senha_w,coalesce(dt_procedimento_w,clock_timestamp())))	or (coalesce(qt_autorizada_w,0) < qt_procedimento_w) then
					goto final;
				end if;
			elsif (ie_tipo_item_p  = 4) 	then
				/*select 	max(a.dt_atendimento)
				into	dt_proc_mat_w
				from	pls_conta_mat	a,
					pls_conta	b
				where	a.nr_sequencia 	= nr_seq_mat_p
				and 	b.nr_sequencia	= a.nr_seq_conta
				and 	b.nr_sequencia	= nr_seq_conta_p
				and 	((b.cd_guia	        = cd_guia_w) or (b.cd_guia_referencia = cd_guia_referencia_w))
				and 	a.ie_status in('L','S','P');*/
				begin
				select 	sum(b.qt_autorizada)
				into STRICT	qt_autorizada_w
				from	pls_guia_plano		a,
					pls_guia_plano_mat	b
				where	a.nr_sequencia 	= b.nr_seq_guia
				and	((a.cd_guia	= coalesce(cd_guia_referencia_w,cd_guia_w))
				or (a.cd_guia_principal = cd_guia_referencia_w))
				and	a.nr_seq_segurado = nr_seq_segurado_p
				and	b.nr_seq_material = nr_seq_mat_w
				and	(b.qt_autorizada IS NOT NULL AND b.qt_autorizada::text <> '')
				and 	a.ie_status = '1'
				and	b.ie_status in ('L','S','P');
				exception
				when others then
					qt_autorizada_w := 0;
				end;

				if (coalesce(dt_material_w,clock_timestamp()) > coalesce(dt_validade_senha_w,coalesce(dt_material_w,clock_timestamp()))) or (qt_autorizada_w < qt_mat_w)then
					goto final;
				end if;
			elsif (ie_tipo_item_p = 8) 	then
				/*select	max(dt_emissao)
				into	dt_proc_mat_w
				from	pls_conta
				where	nr_sequencia		= nr_seq_conta_p
				and 	((cd_guia	        = cd_guia_w) or (cd_guia_referencia = cd_guia_referencia_w))
				and 	ie_status in('L','S','P');*/
				begin
				select 	max(1)
				into STRICT	qt_autorizada_w
				from	pls_guia_plano		a
				where	((a.cd_guia	= coalesce(cd_guia_referencia_w,cd_guia_w))
				or (a.cd_guia_principal = cd_guia_referencia_w))
				and	a.nr_seq_segurado = nr_seq_segurado_p
				and 	a.ie_status = '1';
				exception
				when others then
					qt_autorizada_w := 0;
				end;

				if (coalesce(dt_referencia_w,clock_timestamp()) > coalesce(dt_validade_senha_w,coalesce(dt_referencia_w,clock_timestamp()))) or (coalesce(qt_autorizada_w,0) = 0) then
					goto final;
				end if;
			end if;
		end if;

		if (coalesce(ie_pcmso_regra_w,'N') = 'S' ) then
			if ( ie_pcmso_benef_w <> ie_pcmso_regra_w ) then
				goto final;
			end if;
		end if;

		-- Consistência para contas que estiverem em uma guia de internação, conforme solicitado por Roni - USJRP.
		if (ie_internado_regra_w = 'S') and (ie_internado_regra_w IS NOT NULL AND ie_internado_regra_w::text <> '') then

			select	count(1)
			into STRICT	qt_guia_relacionada_inter_w
			from	pls_conta a
			where	((a.cd_guia = coalesce(cd_guia_referencia_w, cd_guia_w)) and ((coalesce(cd_guia_referencia_w, cd_guia_w) IS NOT NULL AND (coalesce(cd_guia_referencia_w, cd_guia_w))::text <> '')))
			and	a.ie_tipo_guia = 5
			and	(a.nr_seq_segurado = nr_seq_segurado_p AND nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '')  LIMIT 1;

			if (coalesce(qt_guia_relacionada_inter_w,0) = 0) then
				goto final;
			end if;
		end if;

		ds_retorno_w := 'S';
		goto final1;
		<<final>>
		qt_ocorrencia_w	:= 0;
				end;
	end loop;
	close C01;
	<<final1>>
	if (C01%ISOPEN) then
		close C01;
	end if;

	if (coalesce(ds_retorno_w,'N') = 'S')	then
		goto final2;
	end if;
end;
end loop;
close C00;

<<final2>>
if (C00%ISOPEN) then
	close C00;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_excecao_con ( nr_seq_ocorrencia_p bigint, nr_seq_conta_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, dt_emissao_p timestamp, ie_tipo_item_p bigint, nr_seq_prestador_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text, cd_estabelecimento_p text, nr_seq_plano_p bigint, ie_tipo_internado_con_p text, qt_idade_p bigint, qt_idade_meses_p bigint, nr_seq_prestador_exec_p bigint, nr_seq_prest_prot_p bigint, cd_pessoa_fisica_p text, nr_seq_contrato_p bigint, nr_seq_intercambio_p bigint, ie_tipo_segurado_p text, dt_nascimento_p timestamp, ie_pcmso_benef_p text, nr_seq_clinica_p bigint, nr_seq_tipo_acomod_conta_p bigint, cd_guia_p text, cd_guia_referencia_p text, ie_tipo_guia_conta_p text, nr_seq_tipo_atend_conta_p bigint, ie_carater_internacao_p text, nr_seq_protocolo_p bigint, nr_seq_tipo_acomodacao_p bigint, ie_origem_protocolo_conta_p text, cd_prestador_exec_p text, nr_seq_regra_pos_p pls_oc_regra_pos_estab.nr_sequencia%type default null) FROM PUBLIC;

