-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_envia_solic_protheus ( nr_solic_compra_p bigint, ie_operacao_p text, nm_usuario_p text, nr_seq_integracao_p INOUT bigint) AS $body$
DECLARE

 
dt_solic_compra_w			timestamp;
cd_pessoa_solicitante_w		varchar(10);
nm_pessoa_solicitante_w		varchar(255);
ds_observacao_w			varchar(255);
cd_local_estoque_w		integer;
nr_seq_integracao_w		bigint;
cd_estabelecimento_w		integer;

nr_item_solic_compra_w		bigint;
cd_material_w			bigint;
qt_material_w			double precision;
nr_seq_marca_w			bigint;
dt_solic_item_w			timestamp;

qt_existe_w			bigint;
nr_seq_item_integ_w		bigint;
cd_material_ww			bigint;
cd_unidade_medida_ww		varchar(30);
cd_local_estoque_ww		varchar(10);
ds_marca_w			varchar(80);
cd_unidade_medida_w		varchar(30);

c01 CURSOR FOR 
SELECT	a.nr_item_solic_compra, 
	a.cd_material, 
	a.qt_material, 
	a.nr_seq_marca, 
	a.dt_solic_item, 
	a.cd_unidade_medida_compra 
from	solic_compra_item a 
where	a.nr_solic_compra = nr_solic_compra_p 
and	substr(obter_se_integr_item_sc_ext(a.nr_solic_compra,a.nr_item_solic_compra,'PR'),1,1) = 'S' 
order by	nr_item_solic_compra;


BEGIN 
 
select	cd_estabelecimento, 
	dt_solicitacao_compra, 
	cd_pessoa_solicitante, 
	substr(obter_nome_pf(cd_pessoa_solicitante),1,255), 
	substr(ds_observacao,1,255), 
	cd_local_estoque 
into STRICT	cd_estabelecimento_w, 
	dt_solic_compra_w, 
	cd_pessoa_solicitante_w, 
	nm_pessoa_solicitante_w, 
	ds_observacao_w, 
	cd_local_estoque_w 
from	solic_compra 
where	nr_solic_compra = nr_solic_compra_p;
 
select	nextval('w_envia_solic_compra_integ_seq') 
into STRICT	nr_seq_integracao_w
;
 
insert into w_envia_solic_compra_integ( 
	nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	nr_solic_compra, 
	cd_pessoa_solicitante, 
	nm_pessoa_solicitante, 
	dt_solicitacao_compra, 
	ds_observacao, 
	ie_sistema, 
	ie_operacao_integ) 
values ( 
	nr_seq_integracao_w, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	nr_solic_compra_p, 
	cd_pessoa_solicitante_w, 
	nm_pessoa_solicitante_w, 
	dt_solic_compra_w, 
	ds_observacao_w, 
	'PR', 
	ie_operacao_p);
 
open c01;
loop 
fetch c01 into 
	nr_item_solic_compra_w, 
	cd_material_w, 
	qt_material_w, 
	nr_seq_marca_w, 
	dt_solic_item_w, 
	cd_unidade_medida_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	select	nextval('w_envia_solic_item_integ_seq') 
	into STRICT	nr_seq_item_integ_w 
	;
 
	select	coalesce(max(ds_marca),'') 
	into STRICT	ds_marca_w 
	from	marca 
	where	nr_sequencia = nr_seq_marca_w;
 
	select	somente_numero(coalesce(max(cd_sistema_ant),0)) 
	into STRICT	cd_material_ww 
	from	material 
	where	cd_material = cd_material_w;
 
	select	coalesce(max(cd_sistema_ant),max(cd_unidade_medida)) 
	into STRICT	cd_unidade_medida_ww 
	from	unidade_medida 
	where	cd_unidade_medida = cd_unidade_medida_w;
 
	select	max(cd_externo) 
	into STRICT	cd_local_estoque_ww 
	from	conversao_meio_externo 
	where	ie_sistema_externo = 'PTH' 
	and	nm_tabela = 'LOCAL_ESTOQUE' 
	and	nm_atributo = 'CD_LOCAL_ESTOQUE' 
	and	cd_interno = to_char(cd_local_estoque_w);
 
	insert into w_envia_solic_item_integ( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_solic_integ, 
		nr_solic_compra, 
		nr_item_solic_compra, 
		cd_material, 
		qt_material, 
		ds_marca, 
		cd_unidade_medida, 
		cd_local_estoque, 
		dt_solic_item) 
	values ( 
		nr_seq_item_integ_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_integracao_w, 
		nr_solic_compra_p, 
		nr_item_solic_compra_w, 
		cd_material_ww, 
		qt_material_w, 
		ds_marca_w, 
		cd_unidade_medida_ww, 
		cd_local_estoque_ww, 
		dt_solic_item_w);
 
	end;
end loop;
close c01;
 
nr_seq_integracao_p	:= coalesce(nr_seq_integracao_w,0);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_envia_solic_protheus ( nr_solic_compra_p bigint, ie_operacao_p text, nm_usuario_p text, nr_seq_integracao_p INOUT bigint) FROM PUBLIC;

