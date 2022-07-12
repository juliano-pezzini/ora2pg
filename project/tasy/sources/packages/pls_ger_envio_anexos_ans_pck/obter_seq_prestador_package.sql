-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ger_envio_anexos_ans_pck.obter_seq_prestador ( cd_prestador_p pls_prestador.cd_prestador%type, cd_cpf_p pls_prestador.cd_pessoa_fisica%type, cd_cgc_p pls_prestador.cd_cgc%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) RETURNS PLS_PRESTADOR.NR_SEQUENCIA%TYPE AS $body$
DECLARE


nr_seq_prestador_w     		pls_prestador.nr_sequencia%type;
ie_codigo_prest_operadora_w pls_param_importacao_conta.ie_codigo_prest_operadora%type;
cd_pessoa_fisica_w    		pessoa_fisica.cd_pessoa_fisica%type;



BEGIN

	if (cd_prestador_p IS NOT NULL AND cd_prestador_p::text <> '') then

		select  max(ie_codigo_prest_operadora)
		into STRICT  ie_codigo_prest_operadora_w
		from  pls_param_importacao_conta
		where  cd_estabelecimento = cd_estabelecimento_p;

		--Se parametro aponta que o prestador deve enviar o codigo, entao deve buscar o sequencial, caso contrario, significa que ele ja esta enviando o sequencial na tag do codigo.
		if ( ie_codigo_prest_operadora_w = 'C') then
			select 	max(a.nr_sequencia)
			into STRICT  	nr_seq_prestador_w
			from  	pls_prestador a
			where   a.cd_prestador = cd_prestador_p;
		else
			begin
				nr_seq_prestador_w := cd_prestador_p;
			exception
			when others then
				nr_seq_prestador_w := null;
			end;
		end if;

	--se veio cnpj informado
	elsif (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
		nr_seq_prestador_w  := pls_obter_prestador_cgc(cd_cgc_p, null);

	--se veio cpf informado
	elsif (cd_cpf_p IS NOT NULL AND cd_cpf_p::text <> '') then

		select  max(a.cd_pessoa_fisica)
		into STRICT  	cd_pessoa_fisica_w
		from  	pessoa_fisica  a
		where  	nr_cpf  = cd_cpf_p
		and  exists ( SELECT 1
					from  	medico  z
					where  	a.cd_pessoa_fisica = z.cd_pessoa_fisica
					and  	z.ie_situacao = 'A');

		if ( coalesce(cd_pessoa_fisica_w::text, '') = '') then
			
			select  max(a.cd_pessoa_fisica)
			into STRICT  	cd_pessoa_fisica_w
			from  	pessoa_fisica  a
			where  	nr_cpf  = cd_cpf_p
			and  	exists ( SELECT 	1
							from  	medico  z
							where  	a.cd_pessoa_fisica = z.cd_pessoa_fisica);				
      end if;

      if (cd_cpf_p IS NOT NULL AND cd_cpf_p::text <> '') then

        -- ira identificar o prestador matriz (sem prestador matriz informado)
        select  max(pr.nr_sequencia)
        into STRICT  	nr_seq_prestador_w
        from  	pls_prestador pr
        where  	pr.cd_pessoa_fisica  = cd_pessoa_fisica_w
        and  ((	coalesce(pr.dt_exclusao::text, '') = '') or (pr.dt_exclusao   >= clock_timestamp() ))
        and  	pr.dt_cadastro  <= clock_timestamp()
        and  	pr.ie_situacao = 'A'
        and   	coalesce(pr.nr_seq_prest_princ::text, '') = '';

        if ( coalesce(nr_seq_prestador_w::text, '') = '') then
          -- ira identificar o maior prestador vigente e ativo
          select  max(nr_sequencia)
          into STRICT  nr_seq_prestador_w
          from  pls_prestador
          where	cd_pessoa_fisica  = cd_pessoa_fisica_w
          and  ((coalesce(dt_exclusao::text, '') = '') or (dt_exclusao   >= clock_timestamp()))
          and  	dt_cadastro  <= clock_timestamp()
          and  	ie_situacao = 'A';
        end if;

        if ( coalesce(nr_seq_prestador_w::text, '') = '') then
			select  max(nr_sequencia)
			into STRICT  	nr_seq_prestador_w
			from  	pls_prestador
			where  	cd_pessoa_fisica  = cd_cpf_p
			and  	ie_situacao = 'A';
        end if;

        --se nao encontrou nenhum com status ativo, faz uma busca mais geral, sem considerar o status
        if ( coalesce(nr_seq_prestador_w::text, '') = '') then

          select  max(nr_sequencia)
          into STRICT  nr_seq_prestador_w
          from	pls_prestador
          where cd_pessoa_fisica  = cd_cpf_p;
        end if;

      end if;
  end if;

  return nr_seq_prestador_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_ger_envio_anexos_ans_pck.obter_seq_prestador ( cd_prestador_p pls_prestador.cd_prestador%type, cd_cpf_p pls_prestador.cd_pessoa_fisica%type, cd_cgc_p pls_prestador.cd_cgc%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;