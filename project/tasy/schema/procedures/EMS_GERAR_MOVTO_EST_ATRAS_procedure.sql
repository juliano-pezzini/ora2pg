-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ems_gerar_movto_est_atras (cd_estabelecimento_p bigint, --Informar '0' para considerar todos 
 dt_movto_p timestamp, nm_usuario_p text) AS $body$
DECLARE

--Criada para buscar movimentos do dia anterior que não foram integrados (gerados na w_movimento_estoque) 
dt_movimento_estoque_w	timestamp;
cd_material_w		integer;
cd_material_estoque_w	integer;
cd_centro_custo_w	integer;
cd_centro_custo_ww	varchar(20);
vl_movimento_w		double precision;
nr_movimento_estoque_w	bigint;
nr_seq_regra_w		bigint;
ie_entrada_saida_w	varchar(1);
cd_operacao_estoque_w	smallint;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
cd_local_estoque_w	smallint;
cd_local_destino_w	smallint;
cd_sistema_ant_w	varchar(20);
qt_horas_w		bigint;
cd_unidade_medida_w	varchar(30);
cd_unidade_medida_ww	varchar(30);
qt_movimento_w		double precision;
cd_conta_contabil_w	varchar(30);
cd_conta_contabil_ww	varchar(30);
cd_acao_w		varchar(1);
ie_tipo_requisicao_w	varchar(3);
cd_setor_atendimento_w	bigint;
cd_fornecedor_w		varchar(14);
ds_observacao_w		varchar(255);
dt_mesano_referencia_w	timestamp;
ie_origem_documento_w	varchar(3);
ds_lote_fornec_w	varchar(80);
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_seq_lote_fornec_w	movimento_estoque.nr_seq_lote_fornec%type;
dt_validade_w		material_lote_fornec.dt_validade%type;
ie_integra_w		varchar(1);

c01 CURSOR FOR 
	SELECT	dt_movimento_estoque, 
		cd_material, 
		cd_material_estoque, 
		cd_centro_custo, 
		coalesce(vl_movimento,0), 
		nr_movimento_estoque, 
		cd_operacao_estoque, 
		cd_local_estoque, 
		cd_unidade_medida_estoque, 
		qt_movimento, 
		cd_acao, 
		cd_local_estoque_destino, 
		cd_setor_atendimento, 
		cd_fornecedor, 
		ds_observacao, 
		dt_mesano_referencia, 
		ie_origem_documento, 
		substr(obter_dados_lote_fornec(nr_seq_lote_fornec,'D'),1,80), 
		nr_seq_lote_fornec, 
		cd_estabelecimento 
	from	movimento_estoque a 
	where (coalesce(cd_estabelecimento_p,0) = 0 or cd_estabelecimento_p = cd_estabelecimento) 
	and 	trunc(dt_movimento_estoque, 'dd') = trunc(dt_movto_p) 
	and (ie_origem_documento <> '11') 
	and	ie_origem_documento <> '12' 
	and	not exists (	SELECT	1 
				from	w_movimento_estoque 
				where	nr_movimento_estoque = a.nr_movimento_estoque);


BEGIN 
 
open c01;
loop 
fetch c01 into	 
	dt_movimento_estoque_w, 
	cd_material_w, 
	cd_material_estoque_w, 
	cd_centro_custo_w, 
	vl_movimento_w, 
	nr_movimento_estoque_w, 
	cd_operacao_estoque_w, 
	cd_local_estoque_w, 
	cd_unidade_medida_w, 
	qt_movimento_w, 
	cd_acao_w, 
	cd_local_destino_w, 
	cd_setor_atendimento_w, 
	cd_fornecedor_w, 
	ds_observacao_w, 
	dt_mesano_referencia_w, 
	ie_origem_documento_w, 
	ds_lote_fornec_w, 
	nr_seq_lote_fornec_w, 
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin	 
	 
	ie_integra_w := obter_se_integr_movto_estoque(nr_movimento_estoque_w);
	 
	if (ie_integra_w = 'S') then 
		if (coalesce(nr_seq_lote_fornec_w,0) > 0) then 
			select	dt_validade 
			into STRICT	dt_validade_w 
			from	material_lote_fornec 
			where	nr_sequencia = nr_seq_lote_fornec_w;
		end if;
 
		insert into w_movimento_estoque( 
			cd_acao, 
			cd_centro_custo, 
			cd_estabelecimento, 
			cd_fornecedor, 
			cd_local_estoque, 
			cd_material, 
			cd_material_estoque, 
			cd_operacao_estoque, 
			ds_observacao, 
			dt_mesano_referencia, 
			dt_movimento_estoque, 
			ie_envio_recebe, 
			ie_origem_documento, 
			ie_pendente, 
			ie_tipo_integracao, 
			nm_usuario, 
			nr_sequencia, 
			qt_movimento, 
			ds_razao_social, 
			nr_movimento_estoque, 
			dt_validade) 
		values (	cd_acao_w, 
			cd_centro_custo_w, 
			cd_estabelecimento_w, 
			cd_fornecedor_w, 
			cd_local_estoque_w, 
			cd_material_w, 
			cd_material_estoque_w, 
			cd_operacao_estoque_w, 
			ds_observacao_w, 
			dt_mesano_referencia_w, 
			dt_movimento_estoque_w, 
			'E', 
			ie_origem_documento_w, 
			'S', 
			'EMS', 
			nm_usuario_p, 
			nextval('w_movimento_estoque_seq'), 
			qt_movimento_w, 
			ds_lote_fornec_w, 
			nr_movimento_estoque_w, 
			dt_validade_w);
	end if;
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ems_gerar_movto_est_atras (cd_estabelecimento_p bigint, dt_movto_p timestamp, nm_usuario_p text) FROM PUBLIC;

