-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_lote_pagamento_pck.obter_funcao_pagamento_prod ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ie_funcao_pagamento_w	pls_parametro_pagamento.ie_funcao_pagamento%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;


BEGIN

-- se nao foi passado estabelecimento busca do usuario

if (coalesce(cd_estabelecimento_p::text, '') = '') then

	cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
else
	cd_estabelecimento_w := cd_estabelecimento_p;
end if;

-- se a data da ultima solicitacao nao estiver registrada ou 

-- se ja se passou 67 segundos deste a ultima solicitacao ou

-- se o estabelecimento anterior for diferente do ultimo solicitado

if	((current_setting('pls_pp_lote_pagamento_pck.dt_ultima_solicitacao_w')::coalesce(timestamp::text, '') = '') or
	(current_setting('pls_pp_lote_pagamento_pck.dt_ultima_solicitacao_w')::timestamp <= (clock_timestamp() - interval '67 seconds')) or (coalesce(current_setting('pls_pp_lote_pagamento_pck.cd_estab_ult_obter_func_w')::estabelecimento.cd_estabelecimento%type, -1) != coalesce(cd_estabelecimento_w, -2))) then

	-- tem chance de ser nulo (job por exemplo)

	if (coalesce(cd_estabelecimento_w::text, '') = '') then

		select	coalesce(max(ie_funcao_pagamento), '1')
		into STRICT	ie_funcao_pagamento_w
		from	pls_parametro_pagamento;
	else
		select	coalesce(max(ie_funcao_pagamento), '1')
		into STRICT	ie_funcao_pagamento_w
		from	pls_parametro_pagamento
		where	cd_estabelecimento = cd_estabelecimento_w;
	end if;

	PERFORM set_config('pls_pp_lote_pagamento_pck.cd_estab_ult_obter_func_w', cd_estabelecimento_w, false);
	PERFORM set_config('pls_pp_lote_pagamento_pck.dt_ultima_solicitacao_w', clock_timestamp(), false);
	PERFORM set_config('pls_pp_lote_pagamento_pck.ie_funcao_pgto_obter_func_w', ie_funcao_pagamento_w, false);
else
	-- se nao fizer a consulta retorna o que retornou por ultimo

	ie_funcao_pagamento_w := current_setting('pls_pp_lote_pagamento_pck.ie_funcao_pgto_obter_func_w')::pls_parametro_pagamento.ie_funcao_pagamento%type;
end if;

return ie_funcao_pagamento_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_lote_pagamento_pck.obter_funcao_pagamento_prod ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;