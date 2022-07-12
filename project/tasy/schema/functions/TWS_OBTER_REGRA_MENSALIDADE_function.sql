-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tws_obter_regra_mensalidade ( nr_seq_pagador_p pls_segurado_pagador.nr_sequencia%type, ie_titular_p text, ie_pagador_p text, ie_tipo_acesso_p pls_regra_visual_mens_web.ie_tipo_acesso%type, ie_parametro_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Obter os parametros referente a consulta de mensalidade no portal do plano de saude
IE_PARAMETRO: 
VB - Segunda via boleto
VM - Visualizar mensalidade total
RE - Possui regra
VNF - Visualizar nota fiscal
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_regra_w			pls_regra_visual_mens_web.nr_sequencia%type;
ie_permite_segunda_via_w	pls_regra_visual_mens_web.ie_permite_segunda_via%type;
ie_visualizar_mensalidade_w	pls_regra_visual_mens_web.ie_visualizar_mensalidade%type;
ie_link_nota_fiscal_w		pls_regra_visual_mens_web.ie_visualizar_link_nota_fiscal%type;
retorno_w			varchar(2);


BEGIN

select	max(a.nr_sequencia) nr_seq_regra
into STRICT	nr_seq_regra_w
from	pls_regra_visual_mens_web a
where	clock_timestamp() between coalesce(a.dt_inicio_vigencia, clock_timestamp()) and coalesce(a.dt_fim_vigencia, clock_timestamp())
and	a.ie_tipo_acesso = ie_tipo_acesso_p
and	((coalesce(a.nr_seq_pagador::text, '') = '') or (a.nr_seq_pagador = nr_seq_pagador_p))
and	((coalesce(a.nr_seq_forma_cobranca::text, '') = '') or (exists (	SELECT	1
							from	pls_contrato_pagador_fin x
							where	x.nr_seq_pagador	= nr_seq_pagador_p
							and	a.nr_seq_forma_cobranca = x.nr_seq_forma_cobranca
							and	coalesce(x.dt_fim_vigencia::text, '') = '')))
and	((coalesce(a.ie_tipo_pagador, 'A') = 'A')
	or ((coalesce(a.ie_tipo_pagador, 'A') = 'F') and (exists (	select	1
								from	pls_contrato_pagador x
								where	x.nr_sequencia	= nr_seq_pagador_p
								and	(x.cd_pessoa_fisica IS NOT NULL AND x.cd_pessoa_fisica::text <> ''))))
	or ((coalesce(a.ie_tipo_pagador, 'A') = 'J') and (exists (	select	1
								from	pls_contrato_pagador x
								where	x.nr_sequencia	= nr_seq_pagador_p
								and	(x.cd_cgc IS NOT NULL AND x.cd_cgc::text <> '')))))
and	((coalesce(a.ie_titular_pagador, 'A') = 'A')
	or ((coalesce(a.ie_titular_pagador, 'A') = 'T') and (ie_titular_p = 'S'))
	or ((coalesce(a.ie_titular_pagador, 'A') = 'P') and (ie_pagador_p = 'S')));

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
	select	ie_visualizar_mensalidade, --Visualizar o valor total da mensalidade ou valor somente do segurado
		ie_permite_segunda_via,    --Permite realizar impressao do boleto
		ie_visualizar_link_nota_fiscal --Permite acesso a nota fiscal eletronica
	into STRICT	ie_visualizar_mensalidade_w,
		ie_permite_segunda_via_w,
		ie_link_nota_fiscal_w
	from	pls_regra_visual_mens_web
	where	nr_sequencia = nr_seq_regra_w;
end if;

if ( ie_parametro_p = 'VB' ) then
	retorno_w := coalesce(ie_permite_segunda_via_w,'N');
elsif ( ie_parametro_p = 'VM' ) then
	retorno_w := coalesce(ie_visualizar_mensalidade_w,'N');
elsif ( ie_parametro_p = 'VNF') then
	retorno_w := coalesce(ie_link_nota_fiscal_w,'N');
elsif ( ie_parametro_p = 'RE' and (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '')) then
	retorno_w := to_char(nr_seq_regra_w);
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tws_obter_regra_mensalidade ( nr_seq_pagador_p pls_segurado_pagador.nr_sequencia%type, ie_titular_p text, ie_pagador_p text, ie_tipo_acesso_p pls_regra_visual_mens_web.ie_tipo_acesso%type, ie_parametro_p text) FROM PUBLIC;

