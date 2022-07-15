-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ordem_compra_ges_opme_js ( nr_ordem_compra_p INOUT bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
nr_ordem_compra_w			bigint;
ds_material_w				varchar(255);
cd_unidade_medida_w			varchar(30);
qt_material_w				double precision;
cd_material_w				integer;
cond_pag_padrao_w			varchar(255);
nr_item_oci_w				integer;
moeda_padrao_w				integer;
cd_comprador_w				varchar(10);
cd_cgc_w				varchar(14);
nm_paciente_lote_w			varchar(255);
nr_prescricao_w				bigint;

 
C01 CURSOR FOR 
SELECT	 	a.cd_material, 
		SUBSTR(obter_desc_material(a.CD_MATERIAL),1,60) ds_material, 
		CEIL(SUM(coalesce(a.qt_prevista,0))) qt_prevista, 
		SUBSTR(obter_dados_material(cd_material,'UMC'),1,5) unidade_medida, 
		SUBSTR(obter_nome_paciente_lote_opme(a.nr_lote_producao,'D'),1,255) nm_paciente_lote 
FROM  		lote_producao_comp a 
WHERE 		a.nr_seq_protocolo = nr_seq_protocolo_p 
GROUP BY 	SUBSTR(obter_nome_paciente_lote_opme(a.nr_lote_producao,'D'),1,255), 
		a.cd_material, 
		SUBSTR(obter_dados_material(cd_material,'UMC'),1,5), 
		SUBSTR(obter_desc_material(a.CD_MATERIAL),1,60) 
ORDER BY 1;


BEGIN 
 
nr_ordem_compra_p	:= 0;
 
select 	max(cd_comprador_padrao) 
into STRICT	cd_comprador_w 
from 	PARAMETRO_COMPRAS 
where 	cd_estabelecimento = cd_estabelecimento_p;
 
SELECT max(cd_cgc) 
into STRICT	cd_cgc_w 
FROM 	protocolo_fornec_opme 
WHERE  nr_sequencia = nr_seq_protocolo_p;
 
select	nextval('ordem_compra_seq') 
into STRICT	nr_ordem_compra_w
;
 
SELECT max(b.nr_prescricao) 
into STRICT	nr_prescricao_w 
FROM  lote_producao_comp a, 
	lote_producao b 
WHERE 	a.nr_lote_producao = b.nr_lote_producao 
AND	a.nr_seq_protocolo = nr_seq_protocolo_p;
 
 
cond_pag_padrao_w := obter_param_usuario(10025, 2, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cond_pag_padrao_w);
if (coalesce(cond_pag_padrao_w::text, '') = '') then 
CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(195750);
end if;
 
moeda_padrao_w := obter_param_usuario(10025, 1, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, moeda_padrao_w);
if (coalesce(moeda_padrao_w::text, '') = '') then 
CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(19575);
end if;
 
 
insert into ordem_compra( 
	nr_ordem_compra, 
	cd_estabelecimento, 
	cd_condicao_pagamento, 
	cd_comprador, 
	cd_moeda, 
	dt_ordem_compra, 
	dt_atualizacao, 
	nm_usuario, 
	dt_inclusao, 
	cd_pessoa_solicitante, 
	ie_emite_obs, 
	ie_somente_pagto, 
	ie_tipo_ordem, 
	dt_entrega, 
	ie_aviso_chegada, 
	ie_urgente, 
	ie_frete, 
	ie_situacao, 
	cd_cgc_fornecedor) 
values (	nr_ordem_compra_w, 
	cd_estabelecimento_p, 
	cond_pag_padrao_w, 
	cd_comprador_w, 
	moeda_padrao_w, 
	clock_timestamp(), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	cd_pessoa_fisica_p, 
	'N', 
	'N', 
	'R', 
	clock_timestamp(), 
	'N', 
	'N', 
	'N', 
	'A', 
	cd_cgc_w);
 
open C01;
loop 
fetch C01 into 
	cd_material_w, 
	ds_material_w, 
	qt_material_w, 
	cd_unidade_medida_w, 
	nm_paciente_lote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	select	coalesce(max(nr_item_oci),0)+1 
	into STRICT	nr_item_oci_w 
	from 	ordem_compra_item 
	where 	nr_ordem_compra = nr_ordem_compra_w;
 
	insert into ordem_compra_item( 
		NR_ORDEM_COMPRA, 
		NR_ITEM_OCI, 
		cd_material, 
		CD_UNIDADE_MEDIDA_COMPRA, 
		qt_material, 
		qt_original, 
		dt_atualizacao, 
		nm_usuario, 
		CD_PESSOA_SOLICITANTE, 
		VL_UNITARIO_MATERIAL, 
		VL_UNIT_MAT_ORIGINAL, 
		ie_situacao, 
		ds_observacao, 
		vl_total_item) 
	values (	nr_ordem_compra_w, 
		nr_item_oci_w, 
		cd_material_w, 
		cd_unidade_medida_w, 
		qt_material_w, 
		qt_material_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_pessoa_fisica_p, 
		0, 
		0, 
		'A', 
		nm_paciente_lote_w, 
		round((qt_material_w * 0)::numeric,4));
 
 
 
	insert into ordem_compra_item_entrega( 
		nr_sequencia, 
		nr_ordem_compra, 
		nr_item_oci, 
		dt_prevista_entrega, 
		qt_prevista_entrega, 
		dt_atualizacao, 
		nm_usuario, 
		dt_entrega_original, 
		dt_entrega_limite) 
	values (	nextval('ordem_compra_item_entrega_seq'), 
		nr_ordem_compra_w, 
		nr_item_oci_w, 
		clock_timestamp(), 
		qt_material_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		clock_timestamp());
		 
		 
		 
		update protocolo_fornec_opme a 
		set  a.nr_ordem_compra 	= nr_ordem_compra_w 
		where a.nr_Sequencia 		= nr_seq_protocolo_p;
		 
	end;
end loop;
close C01;
 
commit;
 
begin 
CALL gerar_status_prescr_opm('O',nr_prescricao_w,'',cd_estabelecimento_p,nm_usuario_p);
exception 
when others then 
	null;
end;
 
nr_ordem_compra_p	:= nr_ordem_compra_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ordem_compra_ges_opme_js ( nr_ordem_compra_p INOUT bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

