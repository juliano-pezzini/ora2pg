-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_gerar_ordem_venc ( nr_cot_compra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_fornecedor_p bigint, ds_erro_p INOUT text, ie_consiste_p INOUT text) AS $body$
DECLARE


vl_preco_liquido_w			double precision;
vl_minimo_nf_w				pessoa_juridica.vl_minimo_nf%type;
cd_fornecedor_w				cot_compra_forn.cd_cgc_fornecedor%type;
ds_fornecedor_w				pessoa_juridica.ds_razao_social%type;
ds_erro_w				varchar(255) := '';
ie_consiste_doc_vencido_w			varchar(1) := 'N';
ie_consiste_valor_minimo_w			varchar(1) := 'N';
ie_consiste_w				varchar(1) := 'N';

C01 CURSOR FOR
SELECT	distinct(cd_cgc_fornecedor),
	sum(vl_preco_liquido)
from	cot_compra_resumo_v
where 	nr_cot_compra      = nr_cot_compra_p
/* and	nr_seq_cot_item_forn = obter_venc_cot_fornec_item(nr_cot_compra, nr_item_cot_compra)
OS 413793 - Retirado para considerar tambem os itens desdobrados (que nao sao pegos como vencedores) */
and	coalesce(nr_seq_fornecedor_p::text, '') = ''
group	by cd_cgc_fornecedor

union

SELECT	distinct(cd_cgc_fornecedor),
	sum(vl_preco_liquido)
from	cot_compra_resumo_v
where 	nr_cot_compra      = nr_cot_compra_p
and	nr_seq_cot_item_forn  = nr_seq_fornecedor_p
and	(nr_seq_fornecedor_p IS NOT NULL AND nr_seq_fornecedor_p::text <> '')
group by	cd_cgc_fornecedor;

/*Este cursor pega somente os fornecedores vencedores para consistir somente os vencedores*/

c02 CURSOR FOR
SELECT	distinct(cd_cgc_fornecedor)
from	cot_compra_forn_item_tr_v
where 	nr_cot_compra      = nr_cot_compra_p
and	nr_seq_item_fornec = obter_venc_cot_fornec_item(nr_cot_compra, nr_item_cot_compra)
and	obter_se_existe_doc_venc_cot(cd_cgc_fornecedor, nr_cot_compra) = 'S';


BEGIN

select	substr(coalesce(obter_valor_param_usuario(915,8, Obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p),'S'),1,1),
	substr(coalesce(obter_valor_param_usuario(915,48, Obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p),'S'),1,1)
into STRICT	ie_consiste_valor_minimo_w,
	ie_consiste_doc_vencido_w
;

if (ie_consiste_valor_minimo_w <> 'N') then
	begin
	open c01;
	loop
	fetch c01 into
		cd_fornecedor_w,
		vl_preco_liquido_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	obter_dados_pf_pj_estab(cd_estabelecimento_p, null, cd_fornecedor_w, 'EVM'),
			obter_dados_pf_pj_estab(cd_estabelecimento_p, null, cd_fornecedor_w, 'N')
		into STRICT	vl_minimo_nf_w,
			ds_fornecedor_w
		;
		
		if (vl_preco_liquido_w < vl_minimo_nf_w) then
			ie_consiste_w	:= ie_consiste_valor_minimo_w;			
			ds_erro_w	:= substr(ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(281400) || ds_fornecedor_w || WHEB_MENSAGEM_PCK.get_texto(281401) || vl_minimo_nf_w || chr(13) || chr(10),1,255);
		end if;
		end;
	end loop;
	close c01;
	end;
end if;

if (ie_consiste_doc_vencido_w <> 'N')  then
	begin
	open C02;
	loop
	fetch C02 into	
		cd_fornecedor_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		
		select	obter_dados_pf_pj_estab(cd_estabelecimento_p, null, cd_fornecedor_w, 'N')
		into STRICT	ds_fornecedor_w
		;		
		
		if (ie_consiste_doc_vencido_w = 'S') then		
			ie_consiste_w	:= 'S';	
		else
			ie_consiste_w	:= 'Q';
		end if;
		
		ds_erro_w	:= substr(ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(281400) || ds_fornecedor_w || WHEB_MENSAGEM_PCK.get_texto(281402) || chr(13) || chr(10),1,255);
		
		end;
	end loop;
	close C02;
	end;
end if;

ds_erro_p	:= ds_erro_w;
ie_consiste_p	:= ie_consiste_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_gerar_ordem_venc ( nr_cot_compra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_fornecedor_p bigint, ds_erro_p INOUT text, ie_consiste_p INOUT text) FROM PUBLIC;
