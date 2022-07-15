-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_consistir_material_barras ( nr_seq_entrega_item_p bigint, cd_material_p bigint, qt_material_p bigint, nr_seq_lote_fornec_p bigint, cd_estabelecimento_p bigint, cd_local_estoque_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
cd_local_estoque_w		smallint;
ds_erro_w			varchar(255) := '';
nr_atendimento_w		bigint;
cd_setor_atendimento_w		integer;
ie_material_estoque_w		varchar(1);
ie_baixa_estoque_pac_w		varchar(1);
ie_consignado_w			varchar(1);
cd_cgc_fornec_w			varchar(14);
ie_saldo_estoque_w		varchar(1);
qt_saldo_lote_fornec_w		double precision;
ie_estoque_disp_w		varchar(1);
cd_material_estoque_w		integer;
qt_conv_estoque_w		double precision;
qt_material_w			double precision;
					

BEGIN 
if (nr_seq_entrega_item_p IS NOT NULL AND nr_seq_entrega_item_p::text <> '') then 
 
	cd_local_estoque_w := cd_local_estoque_p;
 
	select	fa_obter_atendimento_entrega(a.nr_sequencia) 
	into STRICT	nr_atendimento_w 
	from	fa_entrega_medicacao a, 
		fa_entrega_medicacao_item b 
	where	b.nr_seq_fa_entrega = a.nr_sequencia 
	and	b.nr_sequencia = nr_seq_entrega_item_p;
 
	cd_setor_atendimento_w := Obter_Setor_Atendimento(nr_atendimento_w);
 
	select	max(cd_material_estoque), 
		coalesce(max(qt_conv_estoque_consumo),1) 
	into STRICT	cd_material_estoque_w, 
		qt_conv_estoque_w 
	from	material 
	where	cd_material = cd_material_p;
	 
	qt_material_w	:= dividir(coalesce(qt_material_p,0), coalesce(qt_conv_estoque_w,1));
	 
	select	coalesce(max(ie_material_estoque),'N') 
	into STRICT	ie_material_estoque_w 
	from	material_estab 
	where	cd_material = cd_material_p 
	and	cd_estabelecimento = cd_estabelecimento_p;
 
	select	obter_se_baixa_estoque_pac(cd_setor_atendimento_w, cd_material_p,null,0) 
	into STRICT	ie_baixa_estoque_pac_w 
	;
 
	select	coalesce(ie_consignado,'0') 
	into STRICT	ie_consignado_w 
	from	material 
	where	cd_material = cd_material_p;
 
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
 
	ie_saldo_estoque_w := obter_disp_estoque(cd_material_p, cd_local_estoque_w, cd_estabelecimento_p, 0, qt_material_p, cd_cgc_fornec_w, ie_saldo_estoque_w);
	 
	if (coalesce(nr_seq_lote_fornec_p, 0) > 0) and (ie_material_estoque_w = 'S') then 
		qt_saldo_lote_fornec_w := obter_saldo_disp_estoque(cd_estabelecimento_p,cd_material_estoque_w,cd_local_estoque_w,trunc(clock_timestamp(),'mm'),nr_seq_lote_fornec_p);
	end if;
	 
			 
	if	((ie_baixa_estoque_pac_w = 'N') or (ie_saldo_estoque_w = 'S')) 	then 
		ie_estoque_disp_w:= 'S';
	else 
		ie_estoque_disp_w:= 'N';
	end if;
	 
	if	(ie_estoque_disp_w <> 'S' AND ie_material_estoque_w = 'S') then 
		ds_erro_w:= WHEB_MENSAGEM_PCK.get_texto(279142,null);
	elsif (coalesce(nr_seq_lote_fornec_p,0) > 0) and (coalesce(qt_saldo_lote_fornec_w,0) <= 0) and (ie_material_estoque_w = 'S') then 
		ds_erro_w:= Wheb_mensagem_pck.get_texto(279146,null);
	elsif qt_saldo_lote_fornec_w < qt_material_w then 
		ds_erro_w := wheb_mensagem_pck.get_texto(279148,'CD_MATERIAL='|| obter_desc_material(cd_material_p) 
		||';NR_SEQ_LOTE_FORNEC='|| nr_seq_lote_fornec_p||';QT_SALDO_LOTE_FORNEC='|| qt_saldo_lote_fornec_w);
	end if;
end if;
 
ds_erro_p:= ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_consistir_material_barras ( nr_seq_entrega_item_p bigint, cd_material_p bigint, qt_material_p bigint, nr_seq_lote_fornec_p bigint, cd_estabelecimento_p bigint, cd_local_estoque_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

