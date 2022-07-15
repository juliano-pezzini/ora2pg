-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_estoque_sobra_overfill ( nr_seq_cabine_p bigint, cd_material_p bigint, qt_estoque_p bigint, cd_unidade_medida_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, nr_sequencia_p bigint, nr_seq_lote_p bigint default null, nr_seq_motivo_perda_quimio_p bigint default null, ds_observacao_p text default null) AS $body$
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
ie_consignado_w			varchar(1);
cd_perfil_ativo_w		integer;
ie_estoque_w			varchar(1);
cd_oper_consumo_consig_w 	integer;
ie_lote_consignado_w    	varchar(1);
cd_oper_perda_sobra_overfill_w	integer;
cd_operacao_motivo_w			integer;
nr_seq_dil_vinculado_w			bigint;
nr_seq_cabine_w					bigint;
ie_somente_consignado_w varchar(1);
ds_lote_fornec_w      material_lote_fornec.ds_lote_fornec%type;
dt_validade_w         material_lote_fornec.dt_validade%type;

C01 CURSOR FOR
SELECT	cd_estabelecimento,
		cd_local_estoque,
		cd_oper_perda_etq,
		cd_setor_atendimento,
		cd_oper_perda_consig,
		cd_oper_perda_sobra_overfill
FROM	far_cabine_seg_biol
WHERE	nr_sequencia = coalesce(nr_seq_cabine_p, nr_seq_cabine_w);

C02 CURSOR FOR
SELECT 	nr_sequencia
FROM 	quimio_sobra_overfill
WHERE 	nr_seq_superior = nr_sequencia_p;


BEGIN
begin

select 	max(nr_seq_cabine)
into STRICT	nr_seq_cabine_w
from 	quimio_sobra_overfill
where 	nr_sequencia = nr_sequencia_p;

cd_estabelecimento_w	:=	wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_ativo_w	:=	obter_perfil_ativo;

ie_centro_custo_w := Obter_Param_Usuario(3130, 226, cd_perfil_ativo_w, nm_usuario_p, cd_estabelecimento_w, ie_centro_custo_w);
ie_considera_lote_w := Obter_Param_Usuario(3130, 306, cd_perfil_ativo_w, nm_usuario_p, cd_estabelecimento_w, ie_considera_lote_w);
ie_somente_consignado_w := Obter_Param_Usuario(3130, 311, cd_perfil_ativo_w, nm_usuario_p, cd_estabelecimento_w, ie_somente_consignado_w);

if (coalesce(nr_seq_motivo_perda_quimio_p,0) > 0) then
	select	max(cd_oper_perda_etq)
	into STRICT	cd_operacao_motivo_w
	from 	motivo_perda_quimio
	where	nr_sequencia = nr_seq_motivo_perda_quimio_p;
end if;

OPEN C01;
	LOOP
	FETCH C01 INTO
		cd_estabelecimento_w,
		cd_local_estoque_w,
		cd_operacao_w,
		cd_setor_atendimento_w,
		cd_oper_consumo_consig_w,
		cd_oper_perda_sobra_overfill_w;
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
	/*
	select 	max(cd_fornecedor) 
	into 	cd_fornecedor_w
	from 	fornecedor_mat_consig_lote
	where	cd_material = cd_material_p;*/

	
	
	
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	select 	obter_se_mat_consignado(cd_material_p)
	into STRICT	ie_consignado_w
	;

	cd_fornecedor_w := null;

	select	coalesce(max('S'), 'N')
	into STRICT	ie_lote_consignado_w
	from	fornecedor_mat_consig_lote
	where	cd_estabelecimento 	= cd_estabelecimento_w
	and	cd_local_estoque 	= cd_local_estoque_w
	and	cd_material 		= cd_material_p
	and	dt_mesano_referencia	= trunc(clock_timestamp(), 'mm')
	and	nr_seq_lote 		= nr_seq_lote_w;

	if (ie_consignado_w = '1') or
	(ie_consignado_w = '2' AND ie_lote_consignado_w = 'S') then
	select	max(cd_cgc_fornec)
	into STRICT	cd_fornecedor_w
	from	material_lote_fornec
	where	cd_material = cd_material_p
	and	nr_sequencia = nr_seq_lote_w;
	
	select ds_lote_fornec,
           dt_validade
    into STRICT   ds_lote_fornec_w,
           dt_validade_w
    from   material_lote_fornec
    where  cd_material  = cd_material_p
    and    nr_sequencia = nr_seq_lote_w;
	
	end if;

	if (ie_consignado_w = '2') then
		begin
			if (ie_somente_consignado_w = 'S') then
				begin
					-- verifica estoque consignado
					ie_estoque_w := Obter_Disp_estoque(
						cd_material_p, cd_local_estoque_w, cd_estabelecimento_w, 0, qt_estoque_p, cd_fornecedor_w, ie_estoque_w);
				end;
			else
				-- verificar se possui estoque normal
				ie_estoque_w := Obter_Disp_estoque(
					cd_material_p, cd_local_estoque_w, cd_estabelecimento_w, 0, qt_estoque_p, null, ie_estoque_w);

				-- se possuir estoque normal

				-- baixar do estoque normal, depois do consignado
				if (ie_estoque_w = 'S') then
					cd_fornecedor_w := null;
				else
					-- verifica estoque consignado
					ie_estoque_w := Obter_Disp_estoque(
					cd_material_p, cd_local_estoque_w, cd_estabelecimento_w, 0, qt_estoque_p, cd_fornecedor_w, ie_estoque_w);
				end if;
			end if;
		end;
	else
		ie_estoque_w := Obter_Disp_estoque(
			cd_material_p, cd_local_estoque_w, cd_estabelecimento_w, 0, qt_estoque_p, cd_fornecedor_w, ie_estoque_w);
	end if;

	cd_operacao_ww := coalesce(cd_oper_perda_sobra_overfill_w, cd_operacao_w);
	if (cd_fornecedor_w IS NOT NULL AND cd_fornecedor_w::text <> '') then
    		cd_operacao_ww := coalesce(cd_oper_consumo_consig_w, cd_operacao_ww);
	end if;

	INSERT INTO movimento_estoque(
		nr_movimento_estoque,		cd_estabelecimento,
		cd_local_estoque,		dt_movimento_estoque,
		cd_operacao_estoque,		cd_acao,
		cd_material,			cd_unidade_med_mov,
		qt_movimento,			dt_mesano_referencia,
		dt_atualizacao,			nm_usuario,
		ie_origem_documento,		cd_unidade_medida_estoque,
		cd_setor_atendimento,		qt_estoque,
		cd_centro_custo,
		nr_seq_motivo_perda_quimio, ds_observacao,
		nr_seq_lote_fornec, 		cd_fornecedor,
		cd_lote_fabricacao,dt_validade)
	VALUES (
		nextval('movimento_estoque_seq'),	cd_estabelecimento_w,
		cd_local_estoque_w,		clock_timestamp(),
		coalesce(cd_operacao_motivo_w,cd_operacao_ww), '1',
		cd_material_p,			cd_unidade_medida_p,
		qt_estoque_p,			clock_timestamp(),
		clock_timestamp(),			nm_usuario_p,
		'10',				cd_unidade_medida_p,
		coalesce(cd_setor_atendimento_p,cd_setor_atendimento_w), qt_estoque_p,
		cd_centro_local_w,
		nr_seq_motivo_perda_quimio_p, ds_observacao_p,
		nr_seq_lote_w,			cd_fornecedor_w,
		ds_lote_fornec_w,dt_validade_w);

OPEN C02; --excluir todos os diluentes vinculados ao medicamento
	LOOP
	FETCH C02 INTO
		nr_seq_dil_vinculado_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		delete 	from quimio_sobra_overfill
		where	nr_sequencia 	= nr_seq_dil_vinculado_w
		or nr_seq_superior = nr_seq_dil_vinculado_w;
		end;
	END LOOP;
	CLOSE C02;
	
delete 	from quimio_sobra_overfill
where	nr_sequencia 	= nr_sequencia_p;
COMMIT;

exception
when others then
ds_erro_w	:=	substr(sqlerrm,1,255);
	/*insert into logxxx_tasy(
		dt_atualizacao,
		nm_usuario,
		cd_log,
		ds_log)
	values(	sysdate,
		nm_usuario_p,
		1550,
		ds_erro_w);*/
commit;

CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(184695, 'ERRO='||ds_erro_w);

end;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_estoque_sobra_overfill ( nr_seq_cabine_p bigint, cd_material_p bigint, qt_estoque_p bigint, cd_unidade_medida_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, nr_sequencia_p bigint, nr_seq_lote_p bigint default null, nr_seq_motivo_perda_quimio_p bigint default null, ds_observacao_p text default null) FROM PUBLIC;

