-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Busca o prestador atravez do CPF informado



CREATE OR REPLACE FUNCTION pls_conv_xml_cta_pck.obter_prestador_cpf ( cd_cpf_prestador_p pls_protocolo_conta_imp.cd_cpf_prestador%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS bigint AS $body$
DECLARE


cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_prestador_conv_w		pls_protocolo_conta_imp.nr_seq_prestador_conv%type;


BEGIN
nr_seq_prestador_conv_w := null;

-- Verifica se existe uma pessoa fisica cadastrada com o CPF do XML

-- e se a mesma _ um m_dico

select	max(a.cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	pessoa_fisica a,
	medico b
where	a.nr_cpf = cd_cpf_prestador_p
and	b.cd_pessoa_fisica = a.cd_pessoa_fisica;

if (current_setting('pls_conv_xml_cta_pck.ie_prestador_w')::pls_controle_estab.ie_prestador%type = 'S') then

	-- Se encontrou o cd_pessoa_fisica ent_o verificamos se existe um prestador ativo com este c_digo

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then

		select	max(nr_sequencia)
		into STRICT	nr_seq_prestador_conv_w
		from	pls_prestador
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and	ie_prestador_matriz = 'S'
		and	ie_situacao = 'A'
		and	cd_estabelecimento = cd_estabelecimento_p
		and	((coalesce(dt_exclusao::text, '') = '') or (dt_exclusao 	>= clock_timestamp()))
		and	dt_cadastro	<= clock_timestamp();
		
		if (coalesce(nr_seq_prestador_conv_w::text, '') = '') then
			
			select	max(nr_sequencia)
			into STRICT	nr_seq_prestador_conv_w
			from	pls_prestador
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	ie_prestador_matriz = 'S'
			and	ie_situacao = 'A'
			and	cd_estabelecimento = cd_estabelecimento_p;
			
		end if;
		
		-- se n_o encontrou com prestador matriz

		if (coalesce(nr_seq_prestador_conv_w::text, '') = '') then
		
			select	max(nr_sequencia)
			into STRICT	nr_seq_prestador_conv_w
			from	pls_prestador
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	ie_situacao = 'A'
			and	cd_estabelecimento = cd_estabelecimento_p
			and	((coalesce(dt_exclusao::text, '') = '') or (dt_exclusao 	>= clock_timestamp()))
			and	dt_cadastro	<= clock_timestamp();
			
			if (coalesce(nr_seq_prestador_conv_w::text, '') = '') then
			
				select	max(nr_sequencia)
				into STRICT	nr_seq_prestador_conv_w
				from	pls_prestador
				where	cd_pessoa_fisica = cd_pessoa_fisica_w
				and	ie_situacao = 'A'
				and	cd_estabelecimento = cd_estabelecimento_p;
			
			end if;
			
		end if;
	end if;
else
	-- Se encontrou o cd_pessoa_fisica ent_o verificamos se existe um prestador ativo com este c_digo

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then

		select	max(nr_sequencia)
		into STRICT	nr_seq_prestador_conv_w
		from	pls_prestador
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and	ie_prestador_matriz = 'S'
		and	ie_situacao = 'A'
		and	((coalesce(dt_exclusao::text, '') = '') or (dt_exclusao 	>= clock_timestamp()))
		and	dt_cadastro	<= clock_timestamp();
		
		if (coalesce(nr_seq_prestador_conv_w::text, '') = '') then
			
			select	max(nr_sequencia)
			into STRICT	nr_seq_prestador_conv_w
			from	pls_prestador
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	ie_prestador_matriz = 'S'
			and	ie_situacao = 'A';
			
		end if;
		
		-- se n_o encontrou com prestador matriz

		if (coalesce(nr_seq_prestador_conv_w::text, '') = '') then
		
			select	max(nr_sequencia)
			into STRICT	nr_seq_prestador_conv_w
			from	pls_prestador
			where	cd_pessoa_fisica = cd_pessoa_fisica_w
			and	ie_situacao = 'A'
			and	((coalesce(dt_exclusao::text, '') = '') or (dt_exclusao 	>= clock_timestamp()))
			and	dt_cadastro	<= clock_timestamp();
			
		end if;
	end if;
end if;

return	nr_seq_prestador_conv_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conv_xml_cta_pck.obter_prestador_cpf ( cd_cpf_prestador_p pls_protocolo_conta_imp.cd_cpf_prestador%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
