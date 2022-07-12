-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_imp_xml_cta_pck.usar_nova_imp_xml ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);
ie_metodo_imp_xml_w	pls_param_importacao_conta.ie_metodo_imp_xml%type;


BEGIN

if (current_setting('pls_imp_xml_cta_pck.ie_usa_imp_novo_w')::varchar(1) = 'S') then
	ie_retorno_w := 'S';
else

	-- se a data da ultima solicitacao nao estiver registrada ou 

	-- se ja se passou 67 segundos deste a ultima solicitacao ou

	-- se o estabelecimento anterior for diferente do ultimo solicitado

	if	((current_setting('pls_imp_xml_cta_pck.dt_ultima_solicitacao_w')::coalesce(timestamp::text, '') = '') or
		(current_setting('pls_imp_xml_cta_pck.dt_ultima_solicitacao_w')::timestamp <= (clock_timestamp() - interval '67 seconds')) or (coalesce(current_setting('pls_imp_xml_cta_pck.cd_estabelecimento_ultimo_w')::estabelecimento.cd_estabelecimento%type, -1) != coalesce(cd_estabelecimento_p, -2))) then

		-- se tiver estabelecimento filtra por estabelecimento

		if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
			select	max(ie_metodo_imp_xml)
			into STRICT	ie_metodo_imp_xml_w
			from	pls_param_importacao_conta
			where	cd_estabelecimento = cd_estabelecimento_p;
		end if;
		-- se nao encontrou nada acima busca sem considerar estabelecimento

		if (coalesce(ie_metodo_imp_xml_w::text, '') = '') then
			select	max(ie_metodo_imp_xml)
			into STRICT	ie_metodo_imp_xml_w
			from	pls_param_importacao_conta;
		end if;

		-- se for 2 e pelo metodo novo, caso contrario vai pelo antigo

		if (ie_metodo_imp_xml_w = '2') then
			ie_retorno_w := 'S';
		else
			ie_retorno_w := 'N';
		end if;

		PERFORM set_config('pls_imp_xml_cta_pck.cd_estabelecimento_ultimo_w', cd_estabelecimento_p, false);
		PERFORM set_config('pls_imp_xml_cta_pck.dt_ultima_solicitacao_w', clock_timestamp(), false);
		PERFORM set_config('pls_imp_xml_cta_pck.ie_ultimo_retorno_imp_xml_w', ie_retorno_w, false);
	else
		-- se nao fizer a consulta retorna o que retornou por ultimo

		ie_retorno_w := current_setting('pls_imp_xml_cta_pck.ie_ultimo_retorno_imp_xml_w')::varchar(1);
	end if;
end if;

return ie_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_imp_xml_cta_pck.usar_nova_imp_xml ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;