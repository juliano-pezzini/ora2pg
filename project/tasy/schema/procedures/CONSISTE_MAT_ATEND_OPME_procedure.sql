-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_mat_atend_opme (cd_material_p bigint, qt_material_p bigint, nr_seq_lote_fornec_p bigint, cd_estabelecimento_p bigint, cd_tipo_baixa_p bigint, cd_local_estoque_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE



ie_saldo_estoque_w		varchar(1);
cd_cgc_fornec_w			varchar(14);
ie_consignado_w			varchar(1);
ds_erro_w			varchar(255);
ie_consiste_saldo_lote_w	varchar(1);
qt_saldo_lote_fornec_w		double precision;
ie_atualiza_estoque_w		varchar(1);
ie_estoque_disp_w		varchar(1);


BEGIN

select	coalesce(max(ie_consignado),'0')
into STRICT	ie_consignado_w
from	material
where	cd_material = cd_material_p;

select	coalesce(max(ie_atualiza_estoque),'S')
into STRICT	ie_atualiza_estoque_w
from	tipo_baixa_prescricao
where	ie_prescricao_devolucao = 'P'
and 	cd_tipo_baixa = cd_tipo_baixa_p
and 	ie_situacao = 'A';

if (ie_consignado_w <> '0') then
	begin
	if (coalesce(nr_seq_lote_fornec_p, 0) > 0) then
		select	cd_cgc_fornec
		into STRICT	cd_cgc_fornec_w
		from	material_lote_fornec
		where	nr_sequencia = nr_seq_lote_fornec_p;
	else
		cd_cgc_fornec_w	:= obter_fornecedor_regra_consig(
					cd_estabelecimento_p,
					cd_material_p,
					'1');
	end if;
	end;
end if;

ie_saldo_estoque_w := obter_disp_estoque(cd_material_p, cd_local_estoque_p, cd_estabelecimento_p, 0, qt_material_p, cd_cgc_fornec_w, ie_saldo_estoque_w);

if	((ie_saldo_estoque_w = 'S') or (coalesce(ie_atualiza_estoque_w,'S') = 'N')) then
	ie_estoque_disp_w:= 'S';
else
	ie_estoque_disp_w:= 'N';
end if;

if (coalesce(nr_seq_lote_fornec_p, 0) > 0) then
	qt_saldo_lote_fornec_w	:= obter_saldo_lote_fornec(nr_seq_lote_fornec_p);
end if;

if 	(ie_saldo_estoque_w <> 'S' AND ie_estoque_disp_w <> 'S') then
	ds_erro_w:= WHEB_MENSAGEM_PCK.get_texto(278857);
elsif (ie_consiste_saldo_lote_w = 's') and (coalesce(nr_seq_lote_fornec_p,0) > 0) and (coalesce(qt_saldo_lote_fornec_w,0) <= 0) then
	ds_erro_w:= WHEB_MENSAGEM_PCK.get_texto(278858) || chr(13) || chr(10) || WHEB_MENSAGEM_PCK.get_texto(278859);
end if;

ds_erro_p:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_mat_atend_opme (cd_material_p bigint, qt_material_p bigint, nr_seq_lote_fornec_p bigint, cd_estabelecimento_p bigint, cd_tipo_baixa_p bigint, cd_local_estoque_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

