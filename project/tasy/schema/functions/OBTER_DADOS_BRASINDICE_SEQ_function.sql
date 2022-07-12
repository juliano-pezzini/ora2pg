-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_brasindice_seq ( nr_seq_bras_preco_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* opções brasindice

	clab - código do laboratório
	dlab - descrição do laboratório
	cmed - código do medicamento
	dmed - descrição do medicamento
	capr - código da apresentação
	dapr - descrição da apresentação
	prec - tipo de preço - pfb ou pmc
	tiss - código do tiss
	ean - código do ean
	dtv - data de inicio da vigência
	ver - versão atual
	tuss - código do tuss
	hier - código da hierarquia

*/
ds_retorno_w			varchar(255)	:= '';
cd_laboratorio_w		varchar(6);
ds_laboratorio_w		varchar(40);
cd_medicamento_w		varchar(6);
ds_medicamento_w		varchar(80);
cd_apresentacao_w		varchar(6);
ds_apresentacao_w		varchar(155);
ie_tipo_preco_w			varchar(3);
cd_tiss_w			varchar(15);
cd_ean_w			varchar(20);
dt_inicio_vigencia_w		varchar(20);
ie_versao_atual_w		bigint;
cd_tuss_w			bigint;
cd_hierarquia_w			varchar(10);


BEGIN

if (coalesce(nr_seq_bras_preco_p,0) > 0) then

	select	max(cd_laboratorio),
		max(cd_medicamento),
		max(cd_apresentacao),
		max(ie_tipo_preco),
		max(cd_tiss),
		max(cd_ean),
		max(dt_inicio_vigencia),
		max(ie_versao_atual),
		max(cd_tuss),
		max(cd_hierarquia)
	into STRICT	cd_laboratorio_w,
		cd_medicamento_w,
		cd_apresentacao_w,
		ie_tipo_preco_w,
		cd_tiss_w,
		cd_ean_w,
		dt_inicio_vigencia_w,
		ie_versao_atual_w,
		cd_tuss_w,
		cd_hierarquia_w
	from	brasindice_preco
	where	nr_sequencia = nr_seq_bras_preco_p;

	if (ie_opcao_p = 'CLAB') then
		ds_retorno_w	:= cd_laboratorio_w;
	elsif (ie_opcao_p = 'DLAB') then

		if (cd_laboratorio_w IS NOT NULL AND cd_laboratorio_w::text <> '') then
			select coalesce(max(ds_laboratorio), wheb_mensagem_pck.get_texto(297045)||' :' || cd_laboratorio_w)
			into STRICT ds_laboratorio_w
			from brasindice_laboratorio
			where cd_laboratorio = cd_laboratorio_w;
		end if;

		ds_retorno_w	:= ds_laboratorio_w;
	elsif (ie_opcao_p = 'CMED') then
		ds_retorno_w	:= cd_medicamento_w;
	elsif (ie_opcao_p = 'DMED') then

		if (cd_medicamento_w IS NOT NULL AND cd_medicamento_w::text <> '') then
			select coalesce(max(ds_medicamento), wheb_mensagem_pck.get_texto(297048)||' :' || cd_medicamento_w)
			into STRICT ds_medicamento_w
			from brasindice_medicamento
			where cd_medicamento 		= cd_medicamento_w;
		end if;

		ds_retorno_w	:= ds_medicamento_w;
	elsif (ie_opcao_p = 'CAPR') then
		ds_retorno_w	:= cd_apresentacao_w;
	elsif (ie_opcao_p = 'DAPR') then

		if (cd_apresentacao_w IS NOT NULL AND cd_apresentacao_w::text <> '') then
			select coalesce(max(ds_apresentacao), wheb_mensagem_pck.get_texto(310333)||' :'|| cd_apresentacao_w)
			into STRICT ds_apresentacao_w
			from brasindice_apresentacao
			where cd_apresentacao 		= cd_apresentacao_w;
		end if;

		ds_retorno_w	:= ds_apresentacao_w;
	elsif (ie_opcao_p = 'PREC') then
		ds_retorno_w	:= ie_tipo_preco_w;
	elsif (ie_opcao_p = 'TISS') then
		ds_retorno_w	:= cd_tiss_w;
	elsif (ie_opcao_p = 'EAN') then
		ds_retorno_w	:= cd_ean_w;
	elsif (ie_opcao_p = 'DTV') then
		ds_retorno_w	:= dt_inicio_vigencia_w;
	elsif (ie_opcao_p = 'VER') then
		ds_retorno_w	:= ie_versao_atual_w;
	elsif (ie_opcao_p = 'TUSS') then
		ds_retorno_w	:= cd_tuss_w;
	elsif (ie_opcao_p = 'HIER') then
		ds_retorno_w	:= cd_hierarquia_w;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_brasindice_seq ( nr_seq_bras_preco_p bigint, ie_opcao_p text) FROM PUBLIC;

