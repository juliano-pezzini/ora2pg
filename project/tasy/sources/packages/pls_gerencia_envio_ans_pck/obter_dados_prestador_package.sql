-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Function para retornar os dados do prestador executor da conta



CREATE OR REPLACE FUNCTION pls_gerencia_envio_ans_pck.obter_dados_prestador ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_prest_inter_p pls_prestador_intercambio.nr_sequencia%type, cd_pf_reembolso_p pls_conta.cd_pessoa_fisica%type, cd_cgc_reembolso_p pls_conta.cd_cgc%type) RETURNS DADOS_PRESTADOR AS $body$
DECLARE


dados_prestador_w	dados_prestador;
ie_tipo_endereco_w	pls_prestador.ie_tipo_endereco%type;
ie_tipo_complemento_w	compl_pessoa_fisica.ie_tipo_complemento%type;
nr_seq_prestador_w	pls_prestador.nr_sequencia%type;


BEGIN

if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then

	select	max(nr_seq_prest_ans)
	into STRICT	nr_seq_prestador_w
	from	pls_prestador
	where	nr_sequencia = nr_seq_prestador_p;

	if (coalesce(nr_seq_prestador_w::text, '') = '') then
		nr_seq_prestador_w := nr_seq_prestador_p;
	end if;

	begin
	dados_prestador_w.cd_cnes := substr(trim(both pls_obter_cnes_prestador(nr_seq_prestador_w)), 0, 7);
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(318175, 'NR_SEQ_PRESTADOR=' || nr_seq_prestador_w);
		-- Mensagem: Uma inconsistncia foi encontrada! Favor verificar o nmero do CNES do prestador executor seq. NR_SEQ_PRESTADOR. (O nmero do CNES precisa ter no mximo 7 caracteres.)');

	end;

	select	max(CASE WHEN coalesce(cd_cgc::text, '') = '' THEN  '2'  ELSE '1' END ) ie_identificador,
		max(cd_cgc),
		max(cd_pessoa_fisica)
	into STRICT	dados_prestador_w.ie_tipo_identificador,
		dados_prestador_w.cd_cpf_cgc,
		dados_prestador_w.cd_pessoa_fisica
	from	pls_prestador
	where	nr_sequencia = nr_seq_prestador_w;

	if ( dados_prestador_w.ie_tipo_identificador = '1' ) then

		select	max(substr(cd_municipio_ibge, 0, 7))
		into STRICT	dados_prestador_w.cd_municipio_ibge
		from	pessoa_juridica
		where	cd_cgc 	= dados_prestador_w.cd_cpf_cgc;


	--Identificador 2 - CPF

	elsif ( dados_prestador_w.ie_tipo_identificador = '2' ) then
		select	max(nr_cpf)
		into STRICT	dados_prestador_w.cd_cpf_cgc
		from	pessoa_fisica
		where	cd_pessoa_fisica = dados_prestador_w.cd_pessoa_fisica;

		select	max(ie_tipo_endereco)
		into STRICT	ie_tipo_endereco_w
		from	pls_prestador
		where	nr_sequencia = nr_seq_prestador_w;

		if (ie_tipo_endereco_w IS NOT NULL AND ie_tipo_endereco_w::text <> '') then
			if (ie_tipo_endereco_w = 'PFC') then
				ie_tipo_complemento_w := 2;
			elsif (ie_tipo_endereco_w = 'PFR') then
				ie_tipo_complemento_w := 1;
			elsif (ie_tipo_endereco_w = 'PFA') then
				ie_tipo_complemento_w := 9;
			end if;
		else
			ie_tipo_complemento_w := 2;
		end if;

		select	substr(max(b.cd_municipio_ibge), 0, 7)
		into STRICT	dados_prestador_w.cd_municipio_ibge
		from	compl_pessoa_fisica b
		where	b.cd_pessoa_fisica 	= dados_prestador_w.cd_pessoa_fisica
		and	b.ie_tipo_complemento 	= ie_tipo_complemento_w;
	end if;

elsif (nr_seq_prest_inter_p IS NOT NULL AND nr_seq_prest_inter_p::text <> '') then

	select	max(CASE WHEN coalesce(cd_cgc_intercambio::text, '') = '' THEN  '2'  ELSE '1' END ) ie_identificador,
		max(coalesce(nr_cpf,cd_cgc_intercambio)),
		max(cd_pessoa_fisica),
		max(substr(cd_cnes, 0, 7)),
		max(cd_municipio_ibge)
	into STRICT	dados_prestador_w.ie_tipo_identificador,
		dados_prestador_w.cd_cpf_cgc,
		dados_prestador_w.cd_pessoa_fisica,
		dados_prestador_w.cd_cnes,
		dados_prestador_w.cd_municipio_ibge
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_inter_p;

elsif ((cd_pf_reembolso_p IS NOT NULL AND cd_pf_reembolso_p::text <> '') or (cd_cgc_reembolso_p IS NOT NULL AND cd_cgc_reembolso_p::text <> '')) then

	dados_prestador_w.cd_cpf_cgc		:= cd_cgc_reembolso_p;
	dados_prestador_w.cd_pessoa_fisica	:= cd_pf_reembolso_p;

	select	max(CASE WHEN cd_cgc_reembolso_p='' THEN  '2'  ELSE '1' END ) ie_identificador
	into STRICT	dados_prestador_w.ie_tipo_identificador
	;

	if (dados_prestador_w.ie_tipo_identificador = '1' ) then
		select	max(substr(cd_municipio_ibge, 0, 7)),
			max(substr(cd_cnes, 0, 7))
		into STRICT	dados_prestador_w.cd_municipio_ibge,
			dados_prestador_w.cd_cnes
		from	pessoa_juridica
		where	cd_cgc 	= dados_prestador_w.cd_cpf_cgc;
	elsif ( dados_prestador_w.ie_tipo_identificador = '2' ) then
		select	max(nr_cpf),
			max(substr(cd_cnes, 0, 7))
		into STRICT	dados_prestador_w.cd_cpf_cgc,
			dados_prestador_w.cd_cnes
		from	pessoa_fisica
		where	cd_pessoa_fisica = dados_prestador_w.cd_pessoa_fisica;

		select	max(b.cd_municipio_ibge)
		into STRICT	dados_prestador_w.cd_municipio_ibge
		from	compl_pessoa_fisica b
		where	b.cd_pessoa_fisica 	= dados_prestador_w.cd_pessoa_fisica
		and	b.ie_tipo_complemento 	= 2;
	end if;

end if;

return	dados_prestador_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pls_gerencia_envio_ans_pck.obter_dados_prestador ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_prest_inter_p pls_prestador_intercambio.nr_sequencia%type, cd_pf_reembolso_p pls_conta.cd_pessoa_fisica%type, cd_cgc_reembolso_p pls_conta.cd_cgc%type) FROM PUBLIC;