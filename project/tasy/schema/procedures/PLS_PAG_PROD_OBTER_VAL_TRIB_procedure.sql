-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_pag_prod_obter_val_trib ( ie_apuracao_piso_p text, ie_cnpj_p text, cd_pessoa_fisica_p text, cd_cgc_p text, cd_cnpj_raiz_p text, ie_restringe_estab_p text, cd_empresa_p bigint, cd_tributo_p bigint, dt_tributo_p timestamp, vl_soma_trib_nao_retido_p INOUT bigint, vl_soma_base_nao_retido_p INOUT bigint, vl_soma_trib_adic_p INOUT bigint, vl_soma_base_adic_p INOUT bigint, vl_trib_anterior_p INOUT bigint, vl_total_base_p INOUT bigint, vl_reducao_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_select_w			bigint;
ie_tipo_tributo_w		tributo.ie_tipo_tributo%type;
dt_inicio_tributo_w		timestamp;
dt_fim_tributo_w		timestamp;


BEGIN
if (ie_apuracao_piso_p = 'S') then
	if (ie_cnpj_p = 'Estab') then
		if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
			ie_select_w := 1;
		else
			ie_select_w := 2;
		end if;
	else
		if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
			ie_select_w := 3;
		else
			ie_select_w := 4;
		end if;
	end if;
else
	if (ie_cnpj_p = 'Estab') then
		if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
			ie_select_w := 5;
		else
			ie_select_w := 6;
		end if;
	else
		if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
			ie_select_w := 7;
		else
			ie_select_w := 8;
		end if;
	end if;
end if;

select	a.ie_tipo_tributo
into STRICT	ie_tipo_tributo_w
from	tributo a
where	cd_tributo = cd_tributo_p;

dt_inicio_tributo_w 	:= trunc(dt_tributo_p,'month');
dt_fim_tributo_w	:= fim_mes(dt_tributo_p);

if (ie_select_w in (1, 3)) then
	select	/*+ USE_CONCAT */	-- Edgar 08/09/2009, OS 160898, coloquei o use_concat para transformar os OR em UNION
		coalesce(sum(vl_soma_trib_nao_retido),0),
		coalesce(sum(vl_soma_base_nao_retido),0),
		coalesce(sum(vl_soma_trib_adic),0),
		coalesce(sum(vl_soma_base_adic),0),
		coalesce(sum(vl_tributo),0),
		coalesce(sum(vl_total_base),0),
		coalesce(sum(vl_reducao),0)
	into STRICT	vl_soma_trib_nao_retido_p,
		vl_soma_base_nao_retido_p,
		vl_soma_trib_adic_p,
		vl_soma_base_adic_p,
		vl_trib_anterior_p,
		vl_total_base_p,
		vl_reducao_p
	from	valores_tributo_v
	where	coalesce(cd_empresa,coalesce(cd_empresa_p,0)) = coalesce(cd_empresa_p,0)
	and		obter_tipo_tributo(cd_tributo)			= ie_tipo_tributo_w
	and	cd_pessoa_fisica		= cd_pessoa_fisica_p
	and	dt_tributo between  dt_inicio_tributo_w and dt_fim_tributo_w
	and	((ie_restringe_estab_p		= 'N') or (cd_estabelecimento		= cd_estabelecimento_p) or (cd_estab_financeiro		= cd_estabelecimento_p))
	and	ie_apuracao_piso_p		= ie_base_calculo
	and	ie_baixa_titulo			= 'N';
elsif (ie_select_w in (5, 7)) then
	select	/*+ USE_CONCAT */	-- Edgar 08/09/2009, OS 160898, coloquei o use_concat para transformar os OR em UNION
		coalesce(sum(vl_soma_trib_nao_retido),0),
		coalesce(sum(vl_soma_base_nao_retido),0),
		coalesce(sum(vl_soma_trib_adic),0),
		coalesce(sum(vl_soma_base_adic),0),
		coalesce(sum(vl_tributo),0),
		coalesce(sum(vl_total_base),0),
		coalesce(sum(vl_reducao),0)
	into STRICT	vl_soma_trib_nao_retido_p,
		vl_soma_base_nao_retido_p,
		vl_soma_trib_adic_p,
		vl_soma_base_adic_p,
		vl_trib_anterior_p,
		vl_total_base_p,
		vl_reducao_p
	from	valores_tributo_v
	where	coalesce(cd_empresa,coalesce(cd_empresa_p,0)) = coalesce(cd_empresa_p,0)
	and		obter_tipo_tributo(cd_tributo)			= ie_tipo_tributo_w
	and	ie_origem_valores		= 'PP'
	and	cd_pessoa_fisica		= cd_pessoa_fisica_p
	and	dt_tributo between  dt_inicio_tributo_w and dt_fim_tributo_w
	and	((ie_restringe_estab_p		= 'N') or (cd_estabelecimento		= cd_estabelecimento_p) or (cd_estab_financeiro		= cd_estabelecimento_p))
	and	ie_baixa_titulo			= 'N';
elsif (ie_select_w = 2) then
	select	/*+ USE_CONCAT */	-- Edgar 08/09/2009, OS 160898, coloquei o use_concat para transformar os OR em UNION
		coalesce(sum(vl_soma_trib_nao_retido),0),
		coalesce(sum(vl_soma_base_nao_retido),0),
		coalesce(sum(vl_soma_trib_adic),0),
		coalesce(sum(vl_soma_base_adic),0),
		coalesce(sum(vl_tributo),0),
		coalesce(sum(vl_total_base),0),
		coalesce(sum(vl_reducao),0)
	into STRICT	vl_soma_trib_nao_retido_p,
		vl_soma_base_nao_retido_p,
		vl_soma_trib_adic_p,
		vl_soma_base_adic_p,
		vl_trib_anterior_p,
		vl_total_base_p,
		vl_reducao_p
	from	valores_tributo_v
	where	coalesce(cd_empresa,coalesce(cd_empresa_p,0)) = coalesce(cd_empresa_p,0)
	and		obter_tipo_tributo(cd_tributo)			= ie_tipo_tributo_w
	and	cd_cgc				= cd_cgc_p
	and	dt_tributo between  dt_inicio_tributo_w and dt_fim_tributo_w
	and	((ie_restringe_estab_p		= 'N') or (cd_estabelecimento		= cd_estabelecimento_p) or (cd_estab_financeiro		= cd_estabelecimento_p))
	and	ie_apuracao_piso_p		= ie_base_calculo
	and	ie_baixa_titulo			= 'N';
elsif (ie_select_w = 4) then
	select	/*+ USE_CONCAT */			-- Edgar 08/09/2009, OS 160898, coloquei o use_concat para transformar os OR em UNION
		coalesce(sum(vl_soma_trib_nao_retido),0),
		coalesce(sum(vl_soma_base_nao_retido),0),
		coalesce(sum(vl_soma_trib_adic),0),
		coalesce(sum(vl_soma_base_adic),0),
		coalesce(sum(vl_tributo),0),
		coalesce(sum(vl_total_base),0),
		coalesce(sum(vl_reducao),0)
	into STRICT	vl_soma_trib_nao_retido_p,
		vl_soma_base_nao_retido_p,
		vl_soma_trib_adic_p,
		vl_soma_base_adic_p,
		vl_trib_anterior_p,
		vl_total_base_p,
		vl_reducao_p
	from	valores_tributo_v
	where	coalesce(cd_empresa,coalesce(cd_empresa_p,0)) = coalesce(cd_empresa_p,0)
	and		obter_tipo_tributo(cd_tributo)			= ie_tipo_tributo_w
	and	cd_cnpj_raiz			= cd_cnpj_raiz_p
	and	dt_tributo between  dt_inicio_tributo_w and dt_fim_tributo_w
	and	((ie_restringe_estab_p		= 'N') or (cd_estabelecimento		= cd_estabelecimento_p) or (cd_estab_financeiro		= cd_estabelecimento_p))
	and	ie_apuracao_piso_p		= ie_base_calculo
	and	ie_baixa_titulo			= 'N';
elsif (ie_select_w = 6) then
	select	/*+ USE_CONCAT */	-- Edgar 08/09/2009, OS 160898, coloquei o use_concat para transformar os OR em UNION
		coalesce(sum(vl_soma_trib_nao_retido),0),
		coalesce(sum(vl_soma_base_nao_retido),0),
		coalesce(sum(vl_soma_trib_adic),0),
		coalesce(sum(vl_soma_base_adic),0),
		coalesce(sum(vl_tributo),0),
		coalesce(sum(vl_total_base),0),
		coalesce(sum(vl_reducao),0)
	into STRICT	vl_soma_trib_nao_retido_p,
		vl_soma_base_nao_retido_p,
		vl_soma_trib_adic_p,
		vl_soma_base_adic_p,
		vl_trib_anterior_p,
		vl_total_base_p,
		vl_reducao_p
	from	valores_tributo_v
	where	coalesce(cd_empresa,coalesce(cd_empresa_p,0)) = coalesce(cd_empresa_p,0)
	and		obter_tipo_tributo(cd_tributo)			= ie_tipo_tributo_w
	and	ie_origem_valores		= 'PP'
	and	cd_cgc				= cd_cgc_p
	and	dt_tributo between  dt_inicio_tributo_w and dt_fim_tributo_w
	and	((ie_restringe_estab_p		= 'N') or (cd_estabelecimento		= cd_estabelecimento_p) or (cd_estab_financeiro		= cd_estabelecimento_p))
	and	ie_baixa_titulo			= 'N';
elsif (ie_select_w = 8) then
	select	/*+ USE_CONCAT */	-- Edgar 08/09/2009, OS 160898, coloquei o use_concat para transformar os OR em UNION
		coalesce(sum(vl_soma_trib_nao_retido),0),
		coalesce(sum(vl_soma_base_nao_retido),0),
		coalesce(sum(vl_soma_trib_adic),0),
		coalesce(sum(vl_soma_base_adic),0),
		coalesce(sum(vl_tributo),0),
		coalesce(sum(vl_total_base),0),
		coalesce(sum(vl_reducao),0)
	into STRICT	vl_soma_trib_nao_retido_p,
		vl_soma_base_nao_retido_p,
		vl_soma_trib_adic_p,
		vl_soma_base_adic_p,
		vl_trib_anterior_p,
		vl_total_base_p,
		vl_reducao_p
	from	valores_tributo_v
	where	coalesce(cd_empresa,coalesce(cd_empresa_p,0)) = coalesce(cd_empresa_p,0)
	and		obter_tipo_tributo(cd_tributo)			= ie_tipo_tributo_w
	and	ie_origem_valores		= 'PP'
	and	cd_cnpj_raiz			= cd_cnpj_raiz_p
	and	dt_tributo between  dt_inicio_tributo_w and dt_fim_tributo_w
	and	((ie_restringe_estab_p		= 'N') or (cd_estabelecimento		= cd_estabelecimento_p) or (cd_estab_financeiro		= cd_estabelecimento_p))
	and	ie_baixa_titulo			= 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pag_prod_obter_val_trib ( ie_apuracao_piso_p text, ie_cnpj_p text, cd_pessoa_fisica_p text, cd_cgc_p text, cd_cnpj_raiz_p text, ie_restringe_estab_p text, cd_empresa_p bigint, cd_tributo_p bigint, dt_tributo_p timestamp, vl_soma_trib_nao_retido_p INOUT bigint, vl_soma_base_nao_retido_p INOUT bigint, vl_soma_trib_adic_p INOUT bigint, vl_soma_base_adic_p INOUT bigint, vl_trib_anterior_p INOUT bigint, vl_total_base_p INOUT bigint, vl_reducao_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

