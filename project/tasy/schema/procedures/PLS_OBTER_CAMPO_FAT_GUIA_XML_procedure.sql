-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_campo_fat_guia_xml ( nr_seq_campo_p pls_regra_campos_guia_xml.nr_seq_campo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type, ds_valor_atual_p text, ds_valor_novo_p INOUT text) AS $body$
DECLARE


ds_valor_novo_w		varchar(255);
ie_origem_w		pls_regra_campos_guia_xml.ie_origem%type := null;
ds_valor_w		pls_regra_campos_guia_xml.ds_valor%type := null;
nr_seq_prestador_w	pls_prestador.nr_sequencia%type;

c01 CURSOR( 	nr_seq_campo_pc		pls_regra_campos_guia_xml.nr_seq_campo%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type,
		nr_seq_pagador_pc	pls_contrato_pagador.nr_sequencia%type,
		ie_tipo_guia_pc		pls_conta.ie_tipo_guia%type) FOR
	SELECT	ie_origem,
		ds_valor
	from	pls_regra_campos_guia_xml
	where	nr_seq_campo		= nr_seq_campo_pc
	and	cd_estabelecimento	= cd_estabelecimento_pc
	and	((coalesce(nr_seq_pagador::text, '') = '') or (nr_seq_pagador	= nr_seq_pagador_pc))
	and	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia = ie_tipo_guia_pc))
	order by coalesce(nr_seq_pagador,0);

BEGIN
for r_C01_w in C01(nr_seq_campo_p,cd_estabelecimento_p,nr_seq_pagador_p, ie_tipo_guia_p) loop
	ie_origem_w	:= r_C01_w.ie_origem;
	ds_valor_w	:= r_C01_w.ds_valor;
end loop;

if (coalesce(ds_valor_w::text, '') = '') then
	if (ie_origem_w = 'NREC') then -- Número da requisição da autorização
		select	max(x.nr_sequencia)
		into STRICT	ds_valor_novo_p
		from	pls_conta		a,
			pls_guia_plano		c,
			pls_execucao_req_item	i,
			pls_requisicao		x
		where	x.nr_sequencia		= i.nr_seq_requisicao
		and	c.nr_sequencia		= i.nr_seq_guia
		and	c.nr_sequencia		= a.nr_seq_guia
		and	a.nr_sequencia		= nr_seq_conta_p;

	elsif (ie_origem_w = 'CMTE') then -- Código da matrícula do estipulante
		select	max(x.cd_matricula_estipulante)
		into STRICT	ds_valor_novo_p
		from	pls_segurado	x,
			pls_conta	a
		where	x.nr_sequencia	= a.nr_seq_segurado
		and	a.nr_sequencia	= nr_seq_conta_p;
	elsif (ie_origem_w = 'SE') then
		select	max(x.cd_senha_externa)
		into STRICT	ds_valor_novo_p
		from	pls_conta		a,
			pls_guia_plano		c,
			pls_execucao_req_item	i,
			pls_requisicao		x
		where	x.nr_sequencia		= i.nr_seq_requisicao
		and	c.nr_sequencia		= i.nr_seq_guia
		and	c.nr_sequencia		= a.nr_seq_guia
		and	a.nr_sequencia		= nr_seq_conta_p;

	elsif (ie_origem_w = 'CPS') then
		select	nr_seq_prestador
		into STRICT	nr_seq_prestador_w
		from	pls_conta
		where	nr_sequencia = nr_seq_conta_p;

		if (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
			select	substr(obter_dados_pf(cd_pessoa_fisica,'CPF'),1,11) nr_cpf
			into STRICT	ds_valor_novo_p
			from	pls_prestador
			where	nr_sequencia = nr_seq_prestador_w;

			if (coalesce(ds_valor_novo_p::text, '') = '') then
				select	cd_cgc
				into STRICT	ds_valor_novo_p
				from	pls_prestador
				where	nr_sequencia = nr_seq_prestador_w;
			end if;
		end if;

	else
		ds_valor_novo_p	:= ds_valor_atual_p;
	end if;
else

	-- se foi colocado o valor "@null", em formato de varchar, deverá converter para null
	if (upper(ds_valor_w) = '@NULL') then

		ds_valor_w := null;
	else
		ds_valor_novo_p	:= ds_valor_w;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_campo_fat_guia_xml ( nr_seq_campo_p pls_regra_campos_guia_xml.nr_seq_campo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_tipo_guia_p pls_conta.ie_tipo_guia%type, ds_valor_atual_p text, ds_valor_novo_p INOUT text) FROM PUBLIC;

