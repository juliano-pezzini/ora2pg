-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_item_cabine ( cd_mat_barra_p text, ie_tipo_barra_p text, nm_usuario_p text, cd_estabelecimento_p bigint, cd_material_p INOUT bigint, qt_material_p INOUT bigint, nr_seq_lote_p INOUT bigint, cd_unid_med_p INOUT text, ds_pergunta_p INOUT text, ds_material_p INOUT text, ds_validade_p INOUT text, dt_validade_p INOUT timestamp) AS $body$
DECLARE


atualiza_quant_estoque_cons_w	varchar(1);
consistir_lote_w		varchar(1);
cd_local_estoque_w		bigint;
nr_seq_loteagrup_w		bigint;
cd_kit_mat_w		integer;
ds_validade_w		varchar(10);
ds_material_w		varchar(255);
nr_etiqueta_lp_w		varchar(10);
ds_erro_w			varchar(255);
qt_conversao_w		double precision;
qt_material_conv_w		numeric(20);
cd_tipo_material_w	varchar(10);
ie_consiste_estoque_w	varchar(1);
dt_validade_w		timestamp;


BEGIN

SELECT * FROM converte_codigo_barras(
	cd_mat_barra_p, cd_estabelecimento_p, ie_tipo_barra_p, null, cd_material_p, qt_material_p, nr_seq_lote_p, nr_seq_loteagrup_w, cd_kit_mat_w, ds_validade_w, ds_material_w, cd_unid_med_p, nr_etiqueta_lp_w, ds_erro_w) INTO STRICT cd_material_p, qt_material_p, nr_seq_lote_p, nr_seq_loteagrup_w, cd_kit_mat_w, ds_validade_w, ds_material_w, cd_unid_med_p, nr_etiqueta_lp_w, ds_erro_w;

/* Quimioterapia - Parametro [130] - Ao incluir o item na cabine, fazer a conversao entre unidade de estoque e de consumo */

atualiza_quant_estoque_cons_w := obter_param_usuario(3130, 130, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, atualiza_quant_estoque_cons_w);

if ('S' = atualiza_quant_estoque_cons_w) then
	begin
	select	coalesce(obter_conversao_material(cd_material_p, 'EC'), 1)
	into STRICT	qt_conversao_w
	;

	if (qt_conversao_w > 1) and (coalesce(qt_material_p, 0) > 0) then
		qt_material_p	:= coalesce(qt_material_p, 0) * qt_conversao_w;
	end if;
	end;
end if;

if (coalesce(cd_material_p, 0) = 0) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(58526);
end if;

/* Quimioterapia - Parametro [35] - Consistir lote fornecedor na alimentacao da cabine */

consistir_lote_w := obter_param_usuario(3130, 35, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, consistir_lote_w);

select	obter_tipo_material(cd_material_p,'C')
into STRICT	cd_tipo_material_w
;

select	substr(obter_regra_consiste_lote(cd_material_p),1,1)
into STRICT	ie_consiste_estoque_w
;


if	(('S' = consistir_lote_w and coalesce(nr_seq_lote_p, 0) < 1) or
	(('M' = consistir_lote_w) and (coalesce(nr_seq_lote_p, 0) < 1) and (cd_tipo_material_w <> 1))) or
	(('C' = consistir_lote_w) and (coalesce(nr_seq_lote_p, 0) < 1) and (coalesce(ie_consiste_estoque_w,'N') = 'S') ) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(58530);
end if;

select 	max(dt_validade)
into STRICT 	dt_validade_w
from 	material_lote_fornec
where 	nr_sequencia 	= nr_seq_lote_p;

ds_material_p	:= ds_material_w;
ds_validade_p 	:= ds_validade_w;
dt_validade_p 	:= dt_validade_w;
ds_pergunta_p	:= substr(obter_texto_tasy(58560, wheb_usuario_pck.get_nr_seq_idioma),1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_item_cabine ( cd_mat_barra_p text, ie_tipo_barra_p text, nm_usuario_p text, cd_estabelecimento_p bigint, cd_material_p INOUT bigint, qt_material_p INOUT bigint, nr_seq_lote_p INOUT bigint, cd_unid_med_p INOUT text, ds_pergunta_p INOUT text, ds_material_p INOUT text, ds_validade_p INOUT text, dt_validade_p INOUT timestamp) FROM PUBLIC;

