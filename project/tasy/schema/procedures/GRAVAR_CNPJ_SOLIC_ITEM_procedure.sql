-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_cnpj_solic_item ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint, cd_cnpj_p text, nm_usuario_p text) AS $body$
DECLARE

 
ds_fornec_ant_w			varchar(255);
ds_historico_w			varchar(4000);
				

BEGIN 
 
select	coalesce(obter_nome_pf_pj(null, cd_cnpj),WHEB_MENSAGEM_PCK.get_texto(302609)) 
into STRICT	ds_fornec_ant_w 
from	solic_compra_item 
where	nr_solic_compra = nr_solic_compra_p 
and	nr_item_solic_compra = nr_item_solic_compra_p;
 
update	solic_compra_item 
set	cd_cnpj			= cd_cnpj_p 
where	nr_solic_compra		= nr_solic_compra_p 
and	nr_item_solic_compra	= nr_item_solic_compra_p;
 
if (cd_cnpj_p IS NOT NULL AND cd_cnpj_p::text <> '') then 
 
	ds_historico_w	:=	substr(WHEB_MENSAGEM_PCK.get_texto(302603,'NR_ITEM_SOLIC_COMPRA_P='||nr_item_solic_compra_p|| 
								';DS_FORNEC_ANT_W='||ds_fornec_ant_w|| 
								';CD_CNPJ_P='||obter_nome_pf_pj(null,cd_cnpj_p)),1,4000);
 
	CALL gerar_historico_solic_compra( 
		nr_solic_compra_p, 
		WHEB_MENSAGEM_PCK.get_texto(302608), 
		ds_historico_w, 
		'FI', 
		nm_usuario_p);
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_cnpj_solic_item ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint, cd_cnpj_p text, nm_usuario_p text) FROM PUBLIC;

