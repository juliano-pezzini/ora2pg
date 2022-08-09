-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_duplicar_montagem_kit ( nr_sequencia_p bigint, qt_duplicar_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
qt_duplicado_w		bigint;
dt_atualizacao_w	timestamp := clock_timestamp();
cd_material_w   	kit_estoque_comp.cd_material%type;
qt_material_w    	kit_estoque_comp.qt_material%type;
nr_seq_lote_fornec_w    kit_estoque_comp.nr_seq_lote_fornec%type;
cd_local_estoque_w 	kit_estoque.cd_local_estoque%type;
cd_estabelecimento_w 	kit_estoque.cd_estabelecimento%type;
cd_cgc_fornec_w         material_lote_fornec.cd_cgc_fornec%type;
ie_consignado_w         material.ie_consignado%type;
ie_estoque_disp_w	varchar(1);
ie_saldo_estoque_w	varchar(1);


c01 CURSOR FOR
SELECT	b.cd_material,
        b.qt_material,
	b.nr_seq_lote_fornec,
	a.cd_local_estoque,
	a.cd_estabelecimento
from    kit_estoque a,
        kit_estoque_comp b
where   a.nr_sequencia = b.nr_seq_kit_estoque
and     a.nr_sequencia = nr_sequencia_p;	



BEGIN

open c01;
loop
fetch c01 into
       cd_material_w,
       qt_material_w,
       nr_seq_lote_fornec_w,
       cd_local_estoque_w,
       cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin
	select	coalesce(ie_consignado,'0')
	into STRICT	ie_consignado_w
	from	material
	where	cd_material = cd_material_w;
	if (ie_consignado_w <> '0') then
		begin
		if (coalesce(nr_seq_lote_fornec_w, 0) > 0) then
			select	cd_cgc_fornec
			into STRICT	cd_cgc_fornec_w
			from	material_lote_fornec
			where	nr_sequencia = nr_seq_lote_fornec_w;
		else
			cd_cgc_fornec_w	:= obter_fornecedor_regra_consig(
						cd_estabelecimento_w,
						cd_material_w,
						'1',
						cd_local_estoque_w);
		end if;
		end;
	end if;
	
	
	ie_saldo_estoque_w := obter_disp_estoque(cd_material_w, cd_local_estoque_w, cd_estabelecimento_w, 0, qt_material_w, cd_cgc_fornec_w, ie_saldo_estoque_w, nr_seq_lote_fornec_w);
		
	if (ie_saldo_estoque_w = 'S') 	then
		ie_estoque_disp_w:= 'S';
	else
		ie_estoque_disp_w:= 'N';
	end if;
	
	if	not(ie_estoque_disp_w = 'S') then	
	        CALL wheb_mensagem_pck.exibir_mensagem_abort(840135,'CD_MATERIAL_W='||cd_material_w);
	end if;
	end;
		
end loop;
close c01;


qt_duplicado_w := 0;

while(qt_duplicado_w < qt_duplicar_p) loop
	begin
	select	nextval('kit_estoque_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert into kit_estoque(
		nr_sequencia,
		cd_kit_material,
		dt_atualizacao,
		nm_usuario,
		dt_montagem,
		nm_usuario_montagem,
		cd_estabelecimento,
		cd_medico,
		cd_local_estoque,
		cd_convenio,
		ie_tipo_convenio,
		ie_status,
		ie_sexo,
		ds_observacao,
		nr_seq_kit_origem,
		nr_seq_reg_kit,
		nr_seq_solic_kit,
		cd_setor_destino,
		cd_material,
		cd_setor_exclusivo,
		cd_categoria)
	SELECT	nr_sequencia_w,
		cd_kit_material,
		dt_atualizacao_w,
		nm_usuario_p,
		dt_atualizacao_w,
		nm_usuario_p,
		cd_estabelecimento,
		cd_medico,
		cd_local_estoque,
		cd_convenio,
		ie_tipo_convenio,
		ie_status,
		ie_sexo,
		ds_observacao,
		nr_sequencia_p,
		nr_seq_reg_kit,
		nr_seq_solic_kit,
		cd_setor_destino,
		cd_material,
		cd_setor_exclusivo,
		cd_categoria
	from	kit_estoque
	where	nr_sequencia = nr_sequencia_p;
	
	insert into kit_estoque_comp(
		nr_seq_kit_estoque,
		nr_sequencia,
		cd_material,
		dt_atualizacao,
		nm_usuario,
		qt_material,
		ie_gerado_barras,
		nr_seq_lote_fornec,
		nr_seq_motivo_exclusao,
		nr_seq_item_kit,
		dt_exclusao,
		nm_usuario_exclusao,
		cd_material_troca,
		nm_usuario_troca,
		ds_motivo_troca,
		nr_seq_reg_kit)
	SELECT	nr_sequencia_w,
		row_number() OVER () AS rownum,
		cd_material,
		dt_atualizacao_w,
		nm_usuario_p,
		qt_material,
		ie_gerado_barras,
		nr_seq_lote_fornec,
		nr_seq_motivo_exclusao,
		nr_seq_item_kit,
		dt_exclusao,
		nm_usuario_exclusao,
		cd_material_troca,
		nm_usuario_troca,
		ds_motivo_troca,
		nr_seq_reg_kit
	from	kit_estoque_comp
	where	nr_seq_kit_estoque = nr_sequencia_p
	and	coalesce(dt_exclusao::text, '') = ''
	order by nr_sequencia;
	
	qt_duplicado_w := (qt_duplicado_w + 1);
	end;
end loop;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_duplicar_montagem_kit ( nr_sequencia_p bigint, qt_duplicar_p bigint, nm_usuario_p text) FROM PUBLIC;
