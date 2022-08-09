-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ca_mov_estoque_materiais ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w			integer;
cd_estabelecimento_w	smallint;
cd_local_estoque_w		smallint;
cd_setor_atendimento_w  integer;
ie_material_estoque_w	varchar(1);
cd_oper_consumo_w		smallint;
cd_conta_contabil_w		varchar(20)	:= '';
cd_centro_custo_w		integer;
nr_movimento_estoque_w	bigint;
cd_unid_med_w			varchar(30);
nr_seq_atividade_w		bigint;

C01 CURSOR FOR
	SELECT	cd_material
	from	ca_atividade_material
	where	nr_seq_atividade = nr_seq_atividade_w;


BEGIN

select	max(nr_seq_atividade)
into STRICT	nr_seq_atividade_w
from	ca_controle_atividade
where	nr_sequencia = nr_sequencia_p;

cd_estabelecimento_w   := wheb_usuario_pck.get_cd_estabelecimento;
cd_setor_atendimento_w := wheb_usuario_pck.get_cd_setor_atendimento;

select	coalesce(max(cd_local_estoque),0)
into STRICT    cd_local_estoque_w
from    setor_atendimento
where   cd_setor_atendimento = cd_setor_atendimento_w
and     cd_estabelecimento	 = cd_estabelecimento_w;

open C01;
loop
fetch C01 into
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	substr(cd_unidade_medida_consumo,1,30)
	into STRICT	cd_unid_med_w
	from 	material
	where	cd_material = cd_material_w;

	ie_material_estoque_w := substr(obter_se_material_estoque(cd_estabelecimento_w, 0, cd_material_w),1,1);

	if (ie_material_estoque_w = 'S') then

		select	coalesce(max(cd_operacao_consumo_setor),0)
		into STRICT	cd_oper_consumo_w
		from	parametro_estoque
		where	cd_estabelecimento	= cd_estabelecimento_w;

		SELECT * FROM Define_Conta_Material(cd_estabelecimento_w, cd_material_w, 3, null, cd_setor_atendimento_w, null, null, null, null, null, cd_local_estoque_w, cd_oper_consumo_w, clock_timestamp(), cd_conta_contabil_w, cd_centro_custo_w, null, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;

		select	nextval('movimento_estoque_seq')
		into STRICT	nr_movimento_estoque_w
		;

		insert into movimento_estoque(
			nr_movimento_estoque,
			cd_estabelecimento,
			cd_local_estoque,
			dt_movimento_estoque,
			cd_operacao_estoque,
			cd_acao,
			cd_material,
			dt_mesano_referencia,
			qt_movimento,
			dt_atualizacao,
			nm_usuario,
			ie_origem_documento,
			cd_unidade_medida_estoque,
			cd_setor_atendimento,
			qt_estoque,
			cd_centro_custo,
			cd_unidade_med_mov,
			ds_observacao,
			cd_conta_contabil)
		values (	nr_movimento_estoque_w,
			cd_estabelecimento_W,
			cd_local_estoque_w,
			clock_timestamp(),
			cd_oper_consumo_w,
			'1',
			cd_material_w,
			clock_timestamp(),
			1,
			clock_timestamp(),
			nm_usuario_p,
			21,
			cd_unid_med_w,
			cd_setor_atendimento_w,
			1,
			cd_centro_custo_w,
			cd_unid_med_w,
			substr('ca_mov_estoque_materiais - atividade: '|| nr_seq_atividade_w,1,255),
			cd_conta_contabil_w);

	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ca_mov_estoque_materiais ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
