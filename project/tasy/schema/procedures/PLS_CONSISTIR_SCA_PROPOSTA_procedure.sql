-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_sca_proposta ( nr_seq_pessoa_prop_p bigint, nr_seq_plano_sca_p bigint, nr_seq_tabela_p bigint, cd_estabelecimento_p bigint, ds_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


ie_proposta_adesao_w		varchar(2);
qt_idade_sca_w			bigint;
qt_idade_benef_w		bigint;
ds_erro_w			varchar(4000);
qt_retorno_plano_w		bigint;
ds_plano_w			varchar(255);
ie_grau_dependencia_w		varchar(10);
ds_dependencia_w		varchar(255);
ie_titularidade_seg_w		varchar(10);
ie_utilizar_tab_prop_w		varchar(10);
qt_idade_min_sca_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_beneficiario_w		bigint;
ie_desconsiderar_idade_w	varchar(10);
ie_regulamentacao_ant_w		varchar(10);
ie_regulamentacao_nova_w	varchar(10);
nr_seq_restringir_sca_w		bigint;
qt_plano_adic_w			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from 	pls_restringir_plano_sca
	where 	nr_seq_plano = nr_seq_plano_w
	and 	ie_situacao = 'A'
	and 	clock_timestamp() between dt_inicio_vigencia_ref and dt_fim_vigencia_ref
	order by 1;


BEGIN
ie_utilizar_tab_prop_w		:= coalesce(obter_valor_param_usuario(1232, 36, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

ie_desconsiderar_idade_w	:= 'N';

/*Dados do beneficiário*/

select	obter_idade_pf(a.cd_beneficiario,clock_timestamp(),'A'),
	CASE WHEN coalesce(nr_seq_titular::text, '') = '' THEN CASE WHEN coalesce(nr_seq_titular_contrato::text, '') = '' THEN 'T'  ELSE 'D' END   ELSE 'D' END ,
	nr_seq_plano,
	nr_seq_beneficiario
into STRICT	qt_idade_benef_w,
	ie_titularidade_seg_w,
	nr_seq_plano_w,
	nr_seq_beneficiario_w
from	pls_proposta_beneficiario	a
where	a.nr_sequencia			= nr_seq_pessoa_prop_p;

/*aaschlote 03/12/2013 OS 646773*/

if (nr_seq_beneficiario_w IS NOT NULL AND nr_seq_beneficiario_w::text <> '') and (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then
	select	max(ie_regulamentacao)
	into STRICT	ie_regulamentacao_nova_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_plano_w;

	select	max(B.Ie_regulamentacao)
	into STRICT	ie_regulamentacao_ant_w
	from	pls_plano	b,
		pls_segurado	a
	where	a.nr_seq_plano	= b.nr_sequencia
	and	a.nr_sequencia	= nr_seq_beneficiario_w;

	ie_desconsiderar_idade_w	:= pls_obter_se_desc_idade_sca(nr_seq_plano_sca_p,ie_regulamentacao_ant_w,ie_regulamentacao_nova_w,nr_seq_beneficiario_w);
end if;

/*Dados do SCA*/

select	qt_idade_sca,
	coalesce(ie_grau_dependencia,'A'),
	ds_plano,
	qt_idade_min_sca
into STRICT	qt_idade_sca_w,
	ie_grau_dependencia_w,
	ds_plano_w,
	qt_idade_min_sca_w
from	pls_plano
where	nr_sequencia	= nr_seq_plano_sca_p;

/*Dados da tabela de preço*/

select	max(ie_proposta_adesao)
into STRICT	ie_proposta_adesao_w
from	pls_tabela_preco
where	nr_sequencia	= nr_seq_tabela_p;

select	count(*)
into STRICT	qt_retorno_plano_w
from	pls_plano
where	nr_sequencia 		= nr_seq_plano_sca_p
and	ie_tipo_operacao	<> 'A';

select	CASE WHEN ie_grau_dependencia_w='T' THEN 'titular'  ELSE 'dependente' END
into STRICT	ds_dependencia_w
;

if	(ie_grau_dependencia_w <> 'A' AND ie_grau_dependencia_w <> ie_titularidade_seg_w) then
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280876, 'DS_PLANO_P=' || ds_plano_w || ';DS_DEPENDENCIA_P=' || ds_dependencia_w);
end if;

if (coalesce(qt_retorno_plano_w,0) > 0) then
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280881);
end if;

if (coalesce(nr_seq_tabela_p::text, '') = '') then
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(289753);
elsif (coalesce(ie_proposta_adesao_w,'N') = 'N') and (ie_utilizar_tab_prop_w = 'N') then
	ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(295839,'NR_SEQ_TABELA='||nr_seq_tabela_p||';NR_SEQ_PLANO='||nr_seq_plano_w);
end if;

if (ie_desconsiderar_idade_w = 'N') then
	if	((qt_idade_benef_w > coalesce(qt_idade_sca_w,qt_idade_benef_w)) or (qt_idade_benef_w < coalesce(qt_idade_min_sca_w,qt_idade_benef_w))) then
		ds_erro_w	:= ds_erro_w || wheb_mensagem_pck.get_texto(280887);
	end if;
end if;

open C01;
loop
fetch C01 into
	nr_seq_restringir_sca_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	count(*)
	into STRICT	qt_plano_adic_w
	from 	pls_restringir_sca_item
	where 	nr_seq_regra = nr_seq_restringir_sca_w
	and 	nr_seq_plano_adic = nr_seq_plano_sca_p;

	if (qt_plano_adic_w > 0) then
		ds_erro_w := ds_erro_w || wheb_mensagem_pck.get_texto(472075,'NR_SEQ_SCA='||nr_seq_plano_sca_p||';NR_SEQ_PLANO='||nr_seq_plano_w);
	end if;
	end;
end loop;
close C01;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_sca_proposta ( nr_seq_pessoa_prop_p bigint, nr_seq_plano_sca_p bigint, nr_seq_tabela_p bigint, cd_estabelecimento_p bigint, ds_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;

