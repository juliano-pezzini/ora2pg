-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE inconsistencias_sib AS (nr_seq_lote_inco_sib bigint);


CREATE OR REPLACE PROCEDURE pls_consistir_lote_sib ( nr_seq_lote_sib_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_abrangencia_pre_w		pls_interf_sib.cd_abrangencia_pre%type;
cd_ans_w			pls_interf_sib.cd_ans%type;
cd_cei_w			pls_interf_sib.cd_cei%type;
cd_cgc_w			pls_interf_sib.cd_cgc%type;
cd_cgc_estipulante_w		pls_interf_sib.cd_cgc_estipulante%type;
cd_cns_w			pls_interf_sib.cd_cns%type;
cd_ind_copartic_franquia_w	pls_interf_sib.cd_indicacao_copartic_franquia%type;
cd_motivo_w			pls_interf_sib.cd_motivo%type;
cd_nacionalidade_w		pls_interf_sib.cd_nacionalidade%type;
cd_pessoa_fisica_w		pls_interf_sib.cd_pessoa_fisica%type;
cd_plano_ans_w			pls_interf_sib.cd_plano_ans%type;
cd_plano_ans_pre_w		pls_interf_sib.cd_plano_ans_pre%type;
cd_segmentacao_pre_w		pls_interf_sib.cd_segmentacao_pre%type;
cd_usuario_plano_w		pls_interf_sib.cd_usuario_plano%type;
cd_usuario_plano_sup_w		pls_interf_sib.cd_usuario_plano_sup%type;
cd_vinculo_benef_w		pls_interf_sib.cd_vinculo_benef%type;
cep_w				pls_interf_sib.cep%type;
ds_bairro_w			pls_interf_sib.ds_bairro%type;
ds_complemento_w		pls_interf_sib.ds_complemento%type;
ds_modalidade_w			pls_interf_sib.ds_modalidade%type;
ds_municipio_w			pls_interf_sib.ds_municipio%type;
ds_numero_w			pls_interf_sib.ds_numero%type;
ds_observacao_w			pls_interf_sib.ds_observacao%type;
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
dt_adaptacao_w			timestamp;
dt_adesao_plano_w		timestamp;
dt_cancelamento_w		timestamp;
dt_nascimento_w			timestamp;
dt_reinclusao_w			timestamp;
ie_carencia_temp_w		pls_interf_sib.ie_carencia_temp%type;
ie_itens_excluid_cobertura_w	pls_interf_sib.ie_itens_excluid_cobertura%type;
ie_sexo_w			pls_interf_sib.ie_sexo%type;
ie_tipo_reg_w			pls_interf_sib.ie_tipo_reg%type;
logradouro_w			pls_interf_sib.logradouro%type;
nm_beficiario_w			pls_interf_sib.nm_beficiario%type;
nm_mae_benef_w			pls_interf_sib.nm_mae_benef%type;
nr_cpf_w			pls_interf_sib.nr_cpf%type;
nr_identidade_w			pls_interf_sib.nr_identidade%type;
nr_pis_pasep_w			pls_interf_sib.nr_pis_pasep%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_sequencia_w			pls_interf_sib.nr_sequencia%type;
tp_contratacao_pre_w		pls_interf_sib.tp_contracao_pre%type;
uf_w				pls_interf_sib.uf%type;
nr_seq_titular_w		pls_interf_sib.nr_seq_titular%type;
nr_idade_pf_w			smallint;
cd_pais_sib_w			pls_interf_sib.cd_pais%type;
ie_brasileiro_w			nacionalidade.ie_brasileiro%type;
qt_registros_inconsistentes_w	pls_interf_sib.qt_registros_incosistentes%type;
nr_cco_w			pls_interf_sib.nr_cco%type;
ie_digito_cco_w			pls_interf_sib.ie_digito_cco%type;
ie_utilizar_sem_cco_w		varchar(2);
nr_reg_geral_estrang_resp_w	varchar(30);
ie_resp_brasileiro_w		varchar(5);
cd_declaracao_nasc_vivo_w	pessoa_fisica.cd_declaracao_nasc_vivo%type;
qt_benef_inco_w			integer := 0;
cd_municipio_ibge_resid_w	pls_interf_sib.cd_municipio_ibge_resid%type;
ie_tipo_logradouro_w		pls_interf_sib.ie_tipo_logradouro%type;
i_w				bigint;
nr_seq_lote_inco_sib_w		pls_lote_consistencia_sib.nr_sequencia%type;
nr_vetor_w			bigint;
ie_nome_mae_invalido_w		varchar(10);
ie_nome_benef_invalido_w	varchar(10);
ie_tipo_contratacao_w		varchar(10);
qt_caracter_cep_w		bigint;
ie_regulamentacao_w		pls_plano.ie_regulamentacao%type;

c01 CURSOR FOR
	SELECT	cd_abrangencia_pre,
		cd_ans,
		cd_cei,
		cd_cgc,
		cd_cgc_estipulante,
		cd_cns,
		cd_indicacao_copartic_franquia,
		cd_motivo,
		cd_nacionalidade,
		cd_pessoa_fisica,
		cd_plano_ans,
		cd_plano_ans_pre,
		cd_segmentacao_pre,
		cd_usuario_plano,
		cd_usuario_plano_sup,
		cd_vinculo_benef,
		cep,
		ds_bairro,
		ds_complemento,
		ds_modalidade,
		ds_municipio,
		ds_numero,
		ds_observacao,
		ds_orgao_emissor_ci,
		dt_adaptacao,
		dt_adesao_plano,
		dt_cancelamento,
		dt_nascimento,
		dt_reinclusao,
		ie_carencia_temp,
		ie_itens_excluid_cobertura,
		ie_sexo,
		ie_tipo_reg,
		logradouro,
		nm_beficiario,
		trim(both nm_mae_benef),
		nr_cpf,
		nr_identidade,
		nr_pis_pasep,
		nr_seq_segurado,
		nr_sequencia,
		tp_contracao_pre,
		uf,
		coalesce(cd_pais,'0'),
		nr_seq_titular,
		nr_cco,
		ie_digito_cco,
		cd_declaracao_nasc_vivo,
		cd_municipio_ibge_resid,
		ie_tipo_logradouro
	from	pls_interf_sib
	where	nr_seq_lote_sib = nr_seq_lote_sib_p
	and	(nr_seq_segurado IS NOT NULL AND nr_seq_segurado::text <> '')
	and	coalesce(nr_seq_segurado_p::text, '') = ''
	
union all

	SELECT	cd_abrangencia_pre,
		cd_ans,
		cd_cei,
		cd_cgc,
		cd_cgc_estipulante,
		cd_cns,
		cd_indicacao_copartic_franquia,
		cd_motivo,
		cd_nacionalidade,
		cd_pessoa_fisica,
		cd_plano_ans,
		cd_plano_ans_pre,
		cd_segmentacao_pre,
		cd_usuario_plano,
		cd_usuario_plano_sup,
		cd_vinculo_benef,
		cep,
		ds_bairro,
		ds_complemento,
		ds_modalidade,
		ds_municipio,
		ds_numero,
		ds_observacao,
		ds_orgao_emissor_ci,
		dt_adaptacao,
		dt_adesao_plano,
		dt_cancelamento,
		dt_nascimento,
		dt_reinclusao,
		ie_carencia_temp,
		ie_itens_excluid_cobertura,
		ie_sexo,
		ie_tipo_reg,
		logradouro,
		nm_beficiario,
		trim(both nm_mae_benef),
		nr_cpf,
		nr_identidade,
		nr_pis_pasep,
		nr_seq_segurado,
		nr_sequencia,
		tp_contracao_pre,
		uf,
		coalesce(cd_pais,'0'),
		nr_seq_titular,
		nr_cco,
		ie_digito_cco,
		cd_declaracao_nasc_vivo,
		cd_municipio_ibge_resid,
		ie_tipo_logradouro
	from	pls_interf_sib
	where	nr_seq_lote_sib = nr_seq_lote_sib_p
	and	nr_seq_segurado	= nr_seq_segurado_p
	and	(nr_seq_segurado IS NOT NULL AND nr_seq_segurado::text <> '')
	and	(nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '');

c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_segurado
	from	pls_interf_sib
	where	nr_seq_lote_sib = nr_seq_lote_sib_p
	and	ie_tipo_reg in (1,2,5,7,8);

c03 CURSOR FOR
	SELECT	c.nr_sequencia
	from	pls_lote_consistencia_sib	c,
		pls_segurado			b,
		pls_lote_sib			a
	where	c.nr_seq_segurado	= b.nr_sequencia
	and	c.nr_seq_lote_sib 	= a.nr_sequencia
	and	a.nr_sequencia		= nr_seq_lote_sib_p
	and	b.nr_sequencia		= nr_seq_segurado_p
	and 	(nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '')
	
union all

	SELECT	c.nr_sequencia
	from	pls_lote_consistencia_sib	c,
		pls_segurado			b,
		pls_lote_sib			a
	where	c.nr_seq_segurado	= b.nr_sequencia
	and	c.nr_seq_lote_sib	= a.nr_sequencia
	and	a.nr_sequencia		= nr_seq_lote_sib_p
	and 	coalesce(nr_seq_segurado_p::text, '') = '';


type		fetch_array is table of c02%rowtype;
s_array		fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_c02_w			vetor;
type vetor2 is table of inconsistencias_sib index by integer;
vetor_w				vetor2;

BEGIN

ie_utilizar_sem_cco_w := coalesce(obter_valor_param_usuario(1214, 6, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'S');

i_w	:= 0;

open c03;
loop
fetch c03 into
	nr_seq_lote_inco_sib_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin
	nr_vetor_w	:= vetor_w.count+1;
	vetor_w[nr_vetor_w].nr_seq_lote_inco_sib	:= nr_seq_lote_inco_sib_w;
	end;
end loop;
close c03;

for i in 1..vetor_w.count loop
	i_w	:= i_w + 1;

	delete	FROM pls_lote_consistencia_sib
	where	nr_sequencia	= vetor_w[i].nr_seq_lote_inco_sib;

	if (i_w = 1000) then
		i_w	:= 0;
		commit;
	end if;
end loop;

update	pls_lote_sib
set 	dt_consistencia = CASE WHEN dt_consistencia = NULL THEN clock_timestamp()  ELSE dt_consistencia END
where	nr_sequencia = nr_seq_lote_sib_p;

i_w	:= 0;

open c01;
loop
fetch c01 into
	cd_abrangencia_pre_w,
	cd_ans_w,
	cd_cei_w,
	cd_cgc_w,
	cd_cgc_estipulante_w,
	cd_cns_w,
	cd_ind_copartic_franquia_w,
	cd_motivo_w,
	cd_nacionalidade_w,
	cd_pessoa_fisica_w,
	cd_plano_ans_w,
	cd_plano_ans_pre_w,
	cd_segmentacao_pre_w,
	cd_usuario_plano_w,
	cd_usuario_plano_sup_w,
	cd_vinculo_benef_w,
	cep_w,
	ds_bairro_w,
	ds_complemento_w,
	ds_modalidade_w,
	ds_municipio_w,
	ds_numero_w,
	ds_observacao_w,
	ds_orgao_emissor_ci_w,
	dt_adaptacao_w,
	dt_adesao_plano_w,
	dt_cancelamento_w,
	dt_nascimento_w,
	dt_reinclusao_w,
	ie_carencia_temp_w,
	ie_itens_excluid_cobertura_w,
	ie_sexo_w,
	ie_tipo_reg_w,
	logradouro_w,
	nm_beficiario_w,
	nm_mae_benef_w,
	nr_cpf_w,
	nr_identidade_w,
	nr_pis_pasep_w,
	nr_seq_segurado_w,
	nr_sequencia_w,
	tp_contratacao_pre_w,
	uf_w,
	cd_pais_sib_w,
	nr_seq_titular_w,
	nr_cco_w,
	ie_digito_cco_w,
	cd_declaracao_nasc_vivo_w,
	cd_municipio_ibge_resid_w,
	ie_tipo_logradouro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	nr_idade_pf_w	:= trunc(months_between(clock_timestamp(), trunc(dt_nascimento_w,'month')) / 12);

	/* aaschlote - caso o beneficiário tenha mais de 999 anos, avisar na tela essa situação*/

	if (length(nr_idade_pf_w) > 3) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(184383,'NM_BENEFICIARIO='||nm_beficiario_w);
	end if;

	begin
	select	b.ie_tipo_contratacao,
		b.ie_regulamentacao
	into STRICT	ie_tipo_contratacao_w,
		ie_regulamentacao_w
	from	pls_plano	b,
		pls_segurado	a
	where	a.nr_seq_plano	 = b.nr_sequencia
	and	a.nr_sequencia	= nr_seq_segurado_w;
	exception
	when others then
		ie_tipo_contratacao_w	:= '';
		ie_regulamentacao_w	:= '';
	end;

	if (coalesce(cd_nacionalidade_w,'0') <> '0') then
		select	ie_brasileiro
		into STRICT	ie_brasileiro_w
		from	nacionalidade
		where	cd_nacionalidade = cd_nacionalidade_w;
	end if;

	/* 2 - nome da mãe do beneficiário não informado */

	if (coalesce(nm_mae_benef_w::text, '') = '')  then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 2, 'B');
	end if;
	/* 1 - código do beneficiário na operadora não informado*/

	if (coalesce(cd_usuario_plano_w::text, '') = '') then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 1, 'B');
	end if;
	/* 3 - nome do beneficiário não informado */

	if (coalesce(nm_beficiario_w::text, '') = '') then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 3, 'B');
	end if;
	/* 4 - data de nasc. do beneficiário não informado*/

	if (coalesce(dt_nascimento_w::text, '') = '') then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 4, 'B');
	end if;
	/* 5- sexo do beneficiário não informado */

	if (coalesce(ie_sexo_w::text, '') = '') then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 5, 'B');
	end if;

	nr_cpf_w	:= lpad(nr_cpf_w,11,'0');

	/* caso o beneficiário for brasileiro verifica se tem CPF, caso contrário não verifica OS  - 406270*/

	if (coalesce(ie_brasileiro_w,'S') = 'S') then
		if (nr_cpf_w = '00000000000') then
			/*caso o beneficiário seja menor, pode apenas possui o nome da mãe*/

			if (nr_idade_pf_w	< 18) and (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then
				if (coalesce(ie_resp_brasileiro_w,'S') = 'S')  and (coalesce(nm_mae_benef_w::text, '') = '')then
					CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 6, 'B');
				elsif (coalesce(ie_resp_brasileiro_w,'S') = 'N')  and (nr_reg_geral_estrang_resp_w = '0') then
					CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 6, 'B');
				end if;
			else
				CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 6, 'B');
			end if;
		end if;
	end if;

	if	((nr_identidade_w IS NOT NULL AND nr_identidade_w::text <> '') or (ds_orgao_emissor_ci_w IS NOT NULL AND ds_orgao_emissor_ci_w::text <> '') or (cd_pais_sib_w <> '0')) then
		if (nr_identidade_w IS NOT NULL AND nr_identidade_w::text <> '') then
			/* 8 -  orgão emissor do documento de identificação do beneficiário não informado */

			if (coalesce(ds_orgao_emissor_ci_w::text, '') = '') then
				CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 8, 'B');
			end if;
			/* 9 -país emissor do documento de identificação do beneficiário não informado*/

			if (cd_pais_sib_w = '0') then
				CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 9, 'B');
			end if;
		else
			/* 22 -  órgão emissor preenchido sem número carteira de identidade */

			if (ds_orgao_emissor_ci_w IS NOT NULL AND ds_orgao_emissor_ci_w::text <> '') then
				CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 22, 'B');
			end if;
		end if;
	end if;

	if (cd_plano_ans_w <> '000000000') then
		if (cd_segmentacao_pre_w <> 0) then
		/* 14 - plano regulamentado nao deve ser informado a segementação  */

			CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 14, 'B');
		end if;
		/* 15 - plano regulamentado não deve ser informado a cobertura geográfica*/

		if (cd_abrangencia_pre_w <> 0) then
			CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 15, 'B');
		end if;
		/* 16 - plano regulamentado não deve ser informado o tipo de contratação*/

		if (tp_contratacao_pre_w <> 0) then
			CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 16, 'B');
		end if;
	end if;

	/* 17 - Plano não regulamentado deve ser informado a segementação*/

	if (cd_plano_ans_pre_w IS NOT NULL AND cd_plano_ans_pre_w::text <> '') then
		if (cd_segmentacao_pre_w = 0) then
			CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 17, 'B');
		end if;
		/* 18 - plano não regulamentado deve ser informado a cobertura geográfica*/

		if (cd_abrangencia_pre_w = 0) then
			CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 18, 'B');
		end if;
		/* 19 - plano não regulamentado deve ser informado o tipo de contratação*/

		if (tp_contratacao_pre_w = 0) then
			CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 19, 'B');
		end if;
	end if;
	qt_caracter_cep_w	:= length(cep_w);
	/* 10 - cep do beneficiário não informado */

	if (cep_w = '00000000') or (coalesce(cep_w::text, '') = '') or (qt_caracter_cep_w < 8) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 10, 'B');
	end if;
	/* 11 -uf do beneficiário não informado*/

	if (coalesce(uf_w::text, '') = '') then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 11, 'B');
	end if;
	/* 12 - municipio do beneficiário não informado*/

	if (coalesce(ds_municipio_w::text, '') = '') or (ds_municipio_w = 0) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 12, 'B');
	end if;
	/* 13 - logradouro do beneficiário não informado*/

	if (coalesce(logradouro_w::text, '') = '') then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 13, 'B');
	end if;
	/* 5 - Sexo do Beneficiário não informado*/

	if (ie_sexo_w = 0) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 5, 'B');
	end if;

	/* 20 - Beneficiário sem CCO, de acordo com o parâmetro 6*/

	if (ie_tipo_reg_w in (2,5,7,8)) then
		if (coalesce(nr_cco_w,0) = 0) and (ie_utilizar_sem_cco_w = 'S') then
			CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 20, 'B');
		end if;
	end if;

	/*aaschlote 31/07/2012 - Comentei essa linha, pois de agora em diante essas consistências serão obrigatórias para os beneficiários
	if	(dt_adesao_plano_w is not null) and
		(dt_adesao_plano_w >= to_date('01/04/2011')) then
	*/
	/*23 - número do cartão nacional do sus não informado*/

	if	((coalesce(cd_cns_w::text, '') = '') or (cd_cns_w = '000000000000000')) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 23, 'B');
	end if;

	/*24 - número da declaração de nascido vivo não informado*/

	if (coalesce(cd_declaracao_nasc_vivo_w::text, '') = '') and (dt_nascimento_w >= to_date('01/01/2010')) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 24, 'B');
	end if;

	/*26 - pis/pasep do beneficiário não informado*/

	if	((coalesce(nr_pis_pasep_w::text, '') = '') or (nr_pis_pasep_w = '00000000000')) and (cd_vinculo_benef_w = 1) /*aaschlote 03/12/2011 390201*/
then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 26, 'B');
	end if;

	/*25 - Número do cartão do SUS deve possuir 15 dígitos*/

	if	((coalesce(cd_cns_w::text, '') = '') or (cd_cns_w	<> '0')) and (length(cd_cns_w) <> 15) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 25, 'B');
	end if;

	/*27 - Código do município IBGE residencial do beneficiário não informado*/

	if (ie_tipo_logradouro_w	= '1') then
		if (coalesce(cd_municipio_ibge_resid_w::text, '') = '') or (cd_municipio_ibge_resid_w = '0') then
			CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 27, 'B');
		end if;
	end if;

	ie_nome_benef_invalido_w	:= pls_consistir_letra_unica_pf(nm_beficiario_w);
	ie_nome_mae_invalido_w		:= pls_consistir_letra_unica_pf(nm_mae_benef_w);

	/*28 - Nome do beneficiário ou da mãe inválido*/

	if (ie_nome_mae_invalido_w = 'S') or (ie_nome_benef_invalido_w = 'S') then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 28, 'B');
	end if;

	/*29 - Beneficiário titular possuir plano não regulamentado e individual/familiar superior 01/01/1999*/

	if (ie_regulamentacao_w = 'R') and (ie_tipo_contratacao_w = 'I') and ((trim(both cd_plano_ans_pre_w) IS NOT NULL AND (trim(both cd_plano_ans_pre_w))::text <> '')) and (dt_adesao_plano_w IS NOT NULL AND dt_adesao_plano_w::text <> '') and (coalesce(nr_seq_titular_w::text, '') = '') and (dt_adesao_plano_w >= to_date('01/01/1999')) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 29, 'B');
	end if;

	/*30 - Falta informação do número do protocolo ANS ou do SCPA para o produto do beneficiário*/

	if (cd_plano_ans_w = '000000000') and (coalesce(trim(both cd_plano_ans_pre_w)::text, '') = '') then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 30, 'B');
	end if;

	/* 32 - Beneficiário de exclusão sem data de cancelamento*/

	if (coalesce(dt_cancelamento_w::text, '') = '') and (ie_tipo_reg_w = 7) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 32, 'B');
	end if;

	/* 33 - Número da declaração de nascido vivo inválido */

	if (cd_declaracao_nasc_vivo_w IS NOT NULL AND cd_declaracao_nasc_vivo_w::text <> '') and
		((obter_se_somente_numero(cd_declaracao_nasc_vivo_w) = 'N') or (length(cd_declaracao_nasc_vivo_w) <> 11)) then
		CALL pls_gravar_cosistencia_sib(nr_seq_segurado_w, null, nr_seq_lote_sib_p, null, null, '', nm_usuario_p, 33, 'B');
	end if;

	if (i_w = 1000) then
		i_w	:= 0;
		commit;
	end if;
end loop;
close C01;

open c02;
loop
fetch c02 bulk collect into s_array limit 1000;
	vetor_c02_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on c02 */
end loop;
close c02;

qt_registros_inconsistentes_w	:= 0;

for i in 1..vetor_c02_w.count loop
	s_array := vetor_c02_w(i);
	for z in 1..s_array.count loop
		begin
		nr_sequencia_w		:= s_array[z].nr_sequencia;
		nr_seq_segurado_w	:= s_array[z].nr_seq_segurado;

		select	count(1)
		into STRICT	qt_benef_inco_w
		from	pls_lote_consistencia_sib	b,
			pls_lote_sib			a
		where	b.nr_seq_lote_sib	= a.nr_sequencia
		and	a.nr_sequencia		= nr_seq_lote_sib_p
		and	b.nr_seq_segurado	= nr_seq_segurado_w
		and	b.ie_origem_consistencia = 'B';

		if (qt_benef_inco_w > 0) then
			qt_registros_inconsistentes_w	:= qt_registros_inconsistentes_w + 1;
			update	pls_interf_sib
			set	ie_inconsistencia	= 'S'
			where	nr_seq_lote_sib		= nr_seq_lote_sib_p
			and	nr_sequencia		= nr_sequencia_w;
		else
			update	pls_interf_sib
			set	ie_inconsistencia	= 'N'
			where	nr_seq_lote_sib		= nr_seq_lote_sib_p
			and	nr_sequencia		= nr_sequencia_w;
		end if;
		end;
	end loop;
	commit;
end loop;

update	pls_interf_sib
set	qt_registros_incosistentes	= qt_registros_inconsistentes_w
where	nr_seq_lote_sib			= nr_seq_lote_sib_p
and	ie_tipo_reg			= 9;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_lote_sib ( nr_seq_lote_sib_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

