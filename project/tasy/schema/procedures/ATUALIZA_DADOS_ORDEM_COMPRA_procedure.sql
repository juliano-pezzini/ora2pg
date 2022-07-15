-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dados_ordem_compra ( nr_ordem_compra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_comprador_p text, cd_local_entrega_p text, ie_frete_p text, nr_seq_forma_pagto_p text, nr_seq_subgrupo_compra_p text, ie_aviso_chegada_p text, ie_urgente_p text, ie_emite_obs_p text, vl_frete_p bigint, ds_observacao_p text, dt_validade_p timestamp) AS $body$
DECLARE


cd_comprador_w			varchar(10);
cd_local_entrega_w		varchar(4);
ds_observacao_w			varchar(4000);
ie_frete_w			varchar(1);
ie_aviso_chegada_w		varchar(1);
ie_urgente_w			varchar(1);
ie_emite_obs_w			varchar(1);
nr_seq_forma_pagto_w		varchar(10);
nr_seq_subgrupo_compra_w	varchar(10);
vl_frete_w			double precision;

ds_historico_p			varchar(4000);
ds_local_origem_w		varchar(100);
ds_local_destino_w		varchar(100);
ds_frete_original_w		varchar(255);
ds_frete_alterado_w		varchar(255);
nm_comprador_original_w		comprador.nm_guerra%type;
nm_comprador_alterado_w		comprador.nm_guerra%type;
ds_form_pgto_original_w		varchar(80);
ds_form_pgto_alterada_w		varchar(80);
ds_subgrupo_original_w		varchar(60);
ds_subgrupo_alterada_w		varchar(60);
dt_validade_w			timestamp;


BEGIN

select	coalesce(cd_comprador,'0'),
	coalesce(cd_local_entrega,'0'),
	coalesce(ie_frete,'0'),
	coalesce(nr_seq_forma_pagto,'0'),
	coalesce(nr_seq_subgrupo_compra,'0'),
	coalesce(ie_aviso_chegada,'N'),
	coalesce(ie_urgente,'N'),
	coalesce(ie_emite_obs,'N'),
	coalesce(vl_frete,0),
	coalesce(ds_observacao,'0'),
	coalesce(dt_validade,clock_timestamp())
into STRICT	cd_comprador_w,
	cd_local_entrega_w,
	ie_frete_w,
	nr_seq_forma_pagto_w,
	nr_seq_subgrupo_compra_w,
	ie_aviso_chegada_w,
	ie_urgente_w,
	ie_emite_obs_w,
	vl_frete_w,
	ds_observacao_w,
	dt_validade_w
from	ordem_compra
where	nr_ordem_compra = nr_ordem_compra_p
and	cd_estabelecimento = cd_estabelecimento_p;

if (cd_comprador_p <> cd_comprador_w) then
	update	ordem_compra
	set	cd_comprador = cd_comprador_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	select	sup_obter_nome_comprador(cd_estabelecimento_p,cd_comprador_w),
		sup_obter_nome_comprador(cd_estabelecimento_p,cd_comprador_p)
	into STRICT	nm_comprador_original_w,
		nm_comprador_alterado_w
	;

	--798792 - Comprador
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(798792)||
									';DS_VALOR_OLD='||nm_comprador_original_w||
									';DS_VALOR_NEW='||nm_comprador_alterado_w),1,4000);

	CALL inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(798792)),--Alteração de valor do campo "#@DS_CAMPO#@".
					ds_historico_p,
					nm_usuario_p);
end if;

if (coalesce(cd_local_entrega_p,'0') <> coalesce(cd_local_entrega_w,'0')) then
	update	ordem_compra
	set	cd_local_entrega = cd_local_entrega_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	select	obter_desc_local_estoque(cd_local_entrega_w),
		obter_desc_local_estoque(cd_local_entrega_p)
	into STRICT	ds_local_origem_w,
		ds_local_destino_w
	;

	--798795 - Local entrega"
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(798795)||
									';DS_VALOR_OLD='||cd_local_entrega_w || ' - ' || ds_local_origem_w||
									';DS_VALOR_NEW='||cd_local_entrega_p || ' - ' || ds_local_destino_w),1,4000);

	CALL inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(798795)), -- "Local entrega".',
					ds_historico_p,
					nm_usuario_p);
end if;

if	(nvl(ie_frete_p,'0') <> nvl(ie_frete_w,'0')) then
	update	ordem_compra
	set	ie_frete = ie_frete_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	select	obter_valor_dominio(87,ie_frete_w),
		obter_valor_dominio(87,ie_frete_p)
	into	ds_frete_original_w,
		ds_frete_alterado_w
	from	dual;

	--798796 - Tipo frete
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(798796)||
									';DS_VALOR_OLD='||ds_frete_original_w||
									';DS_VALOR_NEW='||ds_frete_alterado_w),1,4000);


	inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(798796)), -- "Tipo frete".',
					ds_historico_p,
					nm_usuario_p);
end if;

if (coalesce(nr_seq_forma_pagto_p,'0') <> coalesce(nr_seq_forma_pagto_w,'0')) then
	update	ordem_compra
	set	nr_seq_forma_pagto = CASE WHEN nr_seq_forma_pagto_p='0' THEN null  ELSE nr_seq_forma_pagto_p END
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	select	obter_desc_forma_pagto(nr_seq_forma_pagto_w),
		obter_desc_forma_pagto(nr_seq_forma_pagto_p)
	into STRICT	ds_form_pgto_original_w,
		ds_form_pgto_alterada_w
	;

	--798798 - Forma pagto
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(798798)||
									';DS_VALOR_OLD='||ds_form_pgto_original_w||
									';DS_VALOR_NEW='||ds_form_pgto_alterada_w),1,4000);

	CALL inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(798798)), -- "Forma pagto".',
					ds_historico_p,
					nm_usuario_p);
end if;

if	(nvl(nr_seq_subgrupo_compra_p,'0') <> nvl(nr_seq_subgrupo_compra_w,'0')) then
	update	ordem_compra
	set	nr_seq_subgrupo_compra = decode(nr_seq_subgrupo_compra_p,'0',null,nr_seq_subgrupo_compra_p)
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	select	obter_desc_subgrupo_compra(nr_seq_subgrupo_compra_w),
		obter_desc_subgrupo_compra(nr_seq_subgrupo_compra_p)
	into	ds_subgrupo_original_w,
		ds_subgrupo_alterada_w
	from	dual;

	--799186 - Subgrupo compra
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(799186)||
									';DS_VALOR_OLD='||ds_subgrupo_original_w||
									';DS_VALOR_NEW='||ds_subgrupo_alterada_w),1,4000);

	inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(799186)), -- "Subgrupo compra".',
					ds_historico_p,
					nm_usuario_p);
end if;

if (ie_aviso_chegada_p <> ie_aviso_chegada_w) then
	update	ordem_compra
	set	ie_aviso_chegada = ie_aviso_chegada_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;


	--799225 - Avisa chegada mat
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(799225)||
									';DS_VALOR_OLD='||ie_aviso_chegada_w||
									';DS_VALOR_NEW='||ie_aviso_chegada_p),1,4000);

	CALL inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(799225)), -- "Avisa chegada mat.".',
					ds_historico_p,
					nm_usuario_p);
end if;

if	(ie_urgente_p <> ie_urgente_w) then
	update	ordem_compra
	set	ie_urgente = ie_urgente_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	--799230 - Urgente
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(799230)||
									';DS_VALOR_OLD='||ie_urgente_w||
									';DS_VALOR_NEW='||ie_urgente_p),1,4000);

	inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(799230)), -- "Urgente".',
					ds_historico_p,
					nm_usuario_p);
end if;

if (ie_emite_obs_p <> ie_emite_obs_w) then
	update	ordem_compra
	set	ie_emite_obs = ie_emite_obs_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;


	--799232  - Emite observação
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(799232)||
									';DS_VALOR_OLD='||ie_emite_obs_w||
									';DS_VALOR_NEW='||ie_emite_obs_p),1,4000);

	CALL inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(799232)), -- "Emite observação".',
					ds_historico_p,
					nm_usuario_p);
end if;

if	(nvl(vl_frete_p,0) <> nvl(vl_frete_w,0)) then
	update	ordem_compra
	set	vl_frete = vl_frete_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	--799243 - Valor Frete
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(799243)||
									';DS_VALOR_OLD='|| campo_mascara_virgula_casas(vl_frete_w,2)||
									';DS_VALOR_NEW='|| campo_mascara_virgula_casas(vl_frete_p,2)),1,4000);

	inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(799243)), -- "Valor Frete".
					ds_historico_p,
					nm_usuario_p);
end if;

if	(ds_observacao_p <> ds_observacao_w) then
	update	ordem_compra
	set	ds_observacao = ds_observacao_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	--799254 - Observação
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(799389),1,4000);

	inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(799254)), -- "Observação".
					ds_historico_p,
					nm_usuario_p);
end if;

if	(nvl(dt_validade_p,sysdate) <> nvl(dt_validade_w,sysdate)) then
	update	ordem_compra
	set	dt_validade = dt_validade_p
	where	nr_ordem_compra = nr_ordem_compra_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	--799243 - Dt validade
	ds_historico_p := substr(wheb_mensagem_pck.get_texto(798788,	'DS_CAMPO='||wheb_mensagem_pck.get_texto(799393)||
									';DS_VALOR_OLD='|| dt_validade_w ||
									';DS_VALOR_NEW='|| dt_validade_p ),1,4000);

	inserir_historico_ordem_compra(	nr_ordem_compra_p,
					'S',
					wheb_mensagem_pck.get_texto(798794,'DS_CAMPO='||wheb_mensagem_pck.get_texto(799393)), -- "Dt validade".',
					ds_historico_p,
					nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dados_ordem_compra ( nr_ordem_compra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_comprador_p text, cd_local_entrega_p text, ie_frete_p text, nr_seq_forma_pagto_p text, nr_seq_subgrupo_compra_p text, ie_aviso_chegada_p text, ie_urgente_p text, ie_emite_obs_p text, vl_frete_p bigint, ds_observacao_p text, dt_validade_p timestamp) FROM PUBLIC;

