-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_estoque_perda ( nr_seq_item_cabine_p bigint, nr_seq_cabine_p bigint, cd_material_p bigint, qt_estoque_p bigint, cd_unidade_medida_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, dt_perda_mat_p timestamp default null, nr_seq_lote_p bigint default null, nr_seq_motivo_perda_quimio_p bigint default null, ds_observacao_p text default null, ds_erro_p INOUT text DEFAULT NULL) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
cd_local_estoque_w		smallint;
cd_operacao_w			integer;
cd_operacao_ww			integer;
cd_setor_atendimento_w		integer;
ie_centro_custo_w		varchar(1);
cd_centro_local_w		integer;
ie_material_lote_w		varchar(1);
nr_seq_lote_w			bigint;
ie_considera_lote_w		varchar(1);
cd_fornecedor_w			varchar(15);
ds_erro_w			varchar(255);
ie_consignado_w			material.ie_consignado%type;
ie_lote_consignado_w    	material_lote_fornec.cd_cgc_fornec%type;
ds_lote_fornec_w      material_lote_fornec.ds_lote_fornec%type;
dt_validade_w         material_lote_fornec.dt_validade%type;

C01 CURSOR FOR
SELECT	cd_estabelecimento,
		cd_local_estoque,
		cd_oper_perda_etq,
		cd_setor_atendimento
FROM	far_cabine_seg_biol
WHERE	nr_sequencia = nr_seq_cabine_p;


BEGIN
ds_erro_w := '';
ds_erro_p := '';
begin


select	max(cd_oper_perda_etq)
into STRICT	cd_operacao_ww
from 	motivo_perda_quimio
where	nr_sequencia = nr_seq_motivo_perda_quimio_p;

ie_centro_custo_w := Obter_Param_Usuario(3130, 226, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_centro_custo_w);
ie_considera_lote_w := Obter_Param_Usuario(3130, 306, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_considera_lote_w);

OPEN C01;
	LOOP
	FETCH C01 INTO
		cd_estabelecimento_w,
		cd_local_estoque_w,
		cd_operacao_w,
		cd_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	END LOOP;
	CLOSE C01;
	cd_centro_local_w 	:= null;
	nr_seq_lote_w		:= nr_seq_lote_p;
	
	if (ie_considera_lote_w = 'S') then
		select 	substr(obter_se_material_estoque_lote(cd_estabelecimento_w,cd_material_p),1,1)
		into STRICT	ie_material_lote_w
		;
		
		if (ie_material_lote_w = 'N') then
			nr_seq_lote_w := null;
		end if;
	else 	
		nr_seq_lote_w := null;
	end if;
	
	if (ie_centro_custo_w = 'C') then
		select 	coalesce(max(cd_centro_custo), 0)
		into STRICT	cd_centro_local_w
		from	local_estoque
		where	cd_local_estoque = cd_local_estoque_w;
	end if;
	
	select 	obter_se_mat_consignado(cd_material_p)
	into STRICT	ie_consignado_w
	;

	cd_fornecedor_w := null;

	select	coalesce(max('S'), 'N')
	into STRICT	ie_lote_consignado_w
	from	fornecedor_mat_consig_lote
	where	cd_estabelecimento 	= cd_estabelecimento_w
	and	cd_local_estoque 	= cd_local_estoque_w
	and	cd_material 		= obter_material_estoque(cd_material_p)
	and	dt_mesano_referencia	= trunc(clock_timestamp(), 'mm')
	and	nr_seq_lote 		= nr_seq_lote_p;

	if (ie_consignado_w = '1') or (ie_consignado_w = '2' AND ie_lote_consignado_w = 'S') then
		select	max(cd_cgc_fornec)
		into STRICT	cd_fornecedor_w
		from	material_lote_fornec
		where	cd_material = cd_material_p
		and	nr_sequencia = nr_seq_lote_p;
		
		select  ds_lote_fornec,
				dt_validade
		into STRICT  	ds_lote_fornec_w,
				dt_validade_w
		from  material_lote_fornec
		where  cd_material = cd_material_p
		and    nr_sequencia = nr_seq_lote_p;
	end if;
	
	INSERT INTO movimento_estoque(
		nr_movimento_estoque,	cd_estabelecimento,
		cd_local_estoque,		dt_movimento_estoque,
		cd_operacao_estoque,	cd_acao,
		cd_material,			cd_unidade_med_mov,
		qt_movimento,			dt_mesano_referencia,
		dt_atualizacao,			nm_usuario,
		ie_origem_documento,	cd_unidade_medida_estoque,
		cd_setor_atendimento,	qt_estoque,
		cd_centro_custo,		nr_seq_motivo_perda_quimio,
		nr_seq_lote_fornec, 	ds_observacao,
		cd_fornecedor,			cd_lote_fabricacao,
		dt_validade)
	VALUES (
		nextval('movimento_estoque_seq'),		cd_estabelecimento_w,
		cd_local_estoque_w,					coalesce(dt_perda_mat_p,clock_timestamp()),
		coalesce(cd_operacao_ww,cd_operacao_w),	'1',
		cd_material_p,						cd_unidade_medida_p,
		qt_estoque_p,						clock_timestamp(),
		clock_timestamp(),							nm_usuario_p,
		'10',								cd_unidade_medida_p,
		coalesce(cd_setor_atendimento_p,cd_setor_atendimento_w), qt_estoque_p,
		cd_centro_local_w,					nr_seq_motivo_perda_quimio_p,
		nr_seq_lote_w,						ds_observacao_p,
		cd_fornecedor_w,					ds_lote_fornec_w,
		dt_validade_w);

UPDATE	far_estoque_cabine
SET	QT_ESTOQUE = QT_ESTOQUE - qt_estoque_p
WHERE	nr_sequencia = nr_seq_item_cabine_p
and 	((nr_seq_lote_fornec =  coalesce(nr_seq_lote_w,0)) or (coalesce(nr_seq_lote_w,0) = 0));

COMMIT;

exception
when others then
ds_erro_w	:=	substr(sqlerrm,1,255);
ds_erro_p	:=	ds_erro_w;
	/*insert into logxxxx_tasy(
		dt_atualizacao,
		nm_usuario,
		cd_log,
		ds_log)
	values(	sysdate,
		nm_usuario_p,
		1550,
		ds_erro_w);*/
commit;

end;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_estoque_perda ( nr_seq_item_cabine_p bigint, nr_seq_cabine_p bigint, cd_material_p bigint, qt_estoque_p bigint, cd_unidade_medida_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, dt_perda_mat_p timestamp default null, nr_seq_lote_p bigint default null, nr_seq_motivo_perda_quimio_p bigint default null, ds_observacao_p text default null, ds_erro_p INOUT text DEFAULT NULL) FROM PUBLIC;

