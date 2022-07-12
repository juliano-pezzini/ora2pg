-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_dados_pedido ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, ie_tipo_retorno_p bigint, param1 text, param2 text, param3 text) RETURNS varchar AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: obter dados para o pedido de autorizacao

ie_tipo_retorno_p:
1 = ie_tipo_guia
2 = ie_tipo_acomodacao


param1 - ie_tipo_guia (ordem servico intercambio)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w        		varchar(255);
nr_seq_tipo_acomodacao_w	pls_plano_acomodacao.nr_seq_tipo_acomodacao%type;
nr_seq_plano_w        		pls_plano.nr_sequencia%type;
nr_seq_categoria_w      	pls_plano_acomodacao.nr_seq_categoria%type;
ie_tipo_guia_w			pls_guia_plano.ie_tipo_guia%type;


BEGIN

if (pls_obter_versao_scs in ('080','090')) then
	if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	  --Tipo Guia
	  if (ie_tipo_retorno_p = 1) then
	    select  CASE WHEN ie_tipo_guia=8 THEN 3 WHEN ie_tipo_guia=1 THEN 3 WHEN ie_tipo_guia=3 THEN 1  ELSE ie_tipo_guia END
	    into STRICT  ds_retorno_w
	    from  pls_requisicao
	    where   nr_sequencia = nr_seq_requisicao_p;
	  elsif (ie_tipo_retorno_p = 2) then
			select  max(nr_seq_plano),
					max(ie_tipo_guia)
			into STRICT	nr_seq_plano_w,
					ie_tipo_guia_w
			from  pls_requisicao
			where  nr_sequencia = nr_seq_requisicao_p;
		if (ie_tipo_guia_w in (1,8)) then
			begin
			  select  nr_seq_categoria
			  into STRICT  nr_seq_categoria_w
			  from  pls_plano_acomodacao
			  where  nr_seq_plano    = nr_seq_plano_w;
			exception
			when others then
			  nr_seq_categoria_w := null;
			end;

			if (nr_seq_categoria_w IS NOT NULL AND nr_seq_categoria_w::text <> '') then
			  select  max(nr_seq_tipo_acomodacao)
			  into STRICT  nr_seq_tipo_acomodacao_w
			  from  pls_regra_categoria
			  where  nr_seq_categoria  = nr_seq_categoria_w
			  and  ie_acomod_padrao  = 'S';
			else
			  select  max(nr_seq_tipo_acomodacao)
			  into STRICT  nr_seq_tipo_acomodacao_w
			  from  pls_plano_acomodacao
			  where  nr_seq_plano    = nr_seq_plano_w
			  and  ie_acomod_padrao  = 'S';
			end if;

			--Se nao houver padrao
			if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then
			  select  max(nr_seq_tipo_acomodacao)
			  into STRICT  nr_seq_tipo_acomodacao_w
			  from  pls_plano_acomodacao
			  where  nr_seq_plano    = nr_seq_plano_w;
			end if;

			select  coalesce(max(ie_tipo_acomodacao_ptu),'C')
			into STRICT  ds_retorno_w
			from  pls_tipo_acomodacao
			where  nr_sequencia  = nr_seq_tipo_acomodacao_w;
		else
			ds_retorno_w := 'C';
		end if;
	  end if;
	elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	  --Tipo Guia
	  if (ie_tipo_retorno_p = 1) then
	    select  CASE WHEN ie_tipo_guia=8 THEN 3 WHEN ie_tipo_guia=1 THEN 3 WHEN ie_tipo_guia=3 THEN 1  ELSE ie_tipo_guia END
	    into STRICT  ds_retorno_w
	    from  pls_guia_plano
	    where  nr_sequencia = nr_seq_guia_p;

	  elsif (ie_tipo_retorno_p = 2) then
	    select  max(nr_seq_plano),
				max(ie_tipo_guia)
	    into STRICT	nr_seq_plano_w,
				ie_tipo_guia_w
	    from	pls_guia_plano
	    where  nr_sequencia = nr_seq_guia_p;

		if (ie_tipo_guia_w in (1,8)) then
			begin
			  select  nr_seq_categoria
			  into STRICT  nr_seq_categoria_w
			  from  pls_plano_acomodacao
			  where  nr_seq_plano    = nr_seq_plano_w;
			exception
			when others then
			  nr_seq_categoria_w := null;
			end;

			if (nr_seq_categoria_w IS NOT NULL AND nr_seq_categoria_w::text <> '') then
			  select  max(nr_seq_tipo_acomodacao)
			  into STRICT  nr_seq_tipo_acomodacao_w
			  from  pls_regra_categoria
			  where  nr_seq_categoria  = nr_seq_categoria_w
			  and  ie_acomod_padrao  = 'S';
			else
			  select  max(nr_seq_tipo_acomodacao)
			  into STRICT  nr_seq_tipo_acomodacao_w
			  from  pls_plano_acomodacao
			  where  nr_seq_plano    = nr_seq_plano_w
			  and  ie_acomod_padrao  = 'S';
			end if;

			--Se nao houver padrao
			if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then
			  select  max(nr_seq_tipo_acomodacao)
			  into STRICT  nr_seq_tipo_acomodacao_w
			  from  pls_plano_acomodacao
			  where  nr_seq_plano    = nr_seq_plano_w;
			end if;

			select  coalesce(max(ie_tipo_acomodacao_ptu),'C')
			into STRICT  ds_retorno_w
			from  pls_tipo_acomodacao
			where  nr_sequencia  = nr_seq_tipo_acomodacao_w;
		else
			ds_retorno_w := 'C';
		end if;
	  end if;
	elsif (param1 IS NOT NULL AND param1::text <> '') then
		 if (ie_tipo_retorno_p = 1) then
			select	CASE WHEN param1=8 THEN 3 WHEN param1=1 THEN 3 WHEN param1=3 THEN 1  ELSE param1 END
			into STRICT	ds_retorno_w
			;
		end if;
	end if;
else
	if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
		--Tipo Guia
		if (ie_tipo_retorno_p = 1) then
			select	ie_tipo_guia
			into STRICT	ds_retorno_w
			from	pls_requisicao
			where 	nr_sequencia = nr_seq_requisicao_p;
		end if;

	elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
		--Tipo Guia
		if (ie_tipo_retorno_p = 1) then	
			select	ie_tipo_guia
			into STRICT	ds_retorno_w
			from	pls_guia_plano
			where	nr_sequencia = nr_seq_guia_p;
		end if;
	end if;
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_dados_pedido ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, ie_tipo_retorno_p bigint, param1 text, param2 text, param3 text) FROM PUBLIC;
