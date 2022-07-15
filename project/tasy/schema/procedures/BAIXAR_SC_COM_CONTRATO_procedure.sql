-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_sc_com_contrato ( nr_cot_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_solic_compra_w			bigint;
nr_item_solic_compra_w		bigint;
nr_seq_contrato_w			bigint;

c01 CURSOR FOR 
SELECT	distinct 
	a.nr_solic_compra, 
	a.nr_item_solic_compra, 
	b.nr_seq_contrato 
from	solic_compra_item_agrup_v a, 
	contrato_regra_nf b 
where	a.nr_cot_compra = b.nr_cot_compra 
and	a.nr_item_cot_compra = b.nr_item_cot_compra 
and	a.nr_cot_compra = nr_cot_compra_p;

c02 CURSOR FOR 
SELECT	nr_cot_compra, 
	nr_item_cot_compra 
from	cot_compra_solic_agrup 
where	nr_solic_compra = nr_solic_compra_w;


BEGIN 
 
open c01;
loop 
fetch c01 into 	 
	nr_solic_compra_w, 
	nr_item_solic_compra_w, 
	nr_seq_contrato_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	update	solic_compra_item 
	set 	dt_baixa			= clock_timestamp(), 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_solic_compra 		= nr_solic_compra_w 
	and	nr_item_solic_compra	= nr_item_solic_compra_w;
 
	CALL gerar_hist_solic_sem_commit( 
			nr_solic_compra_w, 
			WHEB_MENSAGEM_PCK.get_texto(297896), 
			WHEB_MENSAGEM_PCK.get_texto(297897,'NR_ITEM_SOLIC_COMPRA_W=' || nr_item_solic_compra_w || ';' || 
							'NR_SOLIC_COMPRA_W=' || nr_solic_compra_w || ';' || 
							'NR_COT_COMPRA_P=' || nr_cot_compra_p), 
			'B', 
			nm_usuario_p);	
 
	update	solic_compra 
	set	dt_baixa			= clock_timestamp(), 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_solic_compra		= nr_solic_compra_w 
	and	not exists ( 
		SELECT 1 
		from	solic_compra_item 
		where	nr_solic_compra = nr_solic_compra_w 
		and	coalesce(dt_baixa::text, '') = '');
 
	update	processo_aprov_compra a 
	set	a.ie_aprov_reprov	= 'B', 
		a.ds_observacao		= substr(WHEB_MENSAGEM_PCK.get_texto(297898,'DS_OBSERVACAO_W=' || a.ds_observacao || ';' || 'NR_SEQ_CONTRATO_W=' || nr_seq_contrato_w),1,2000), 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	a.nr_sequencia in ( 
		SELECT	distinct(nr_seq_aprovacao) 
		from	solic_compra_item 
		where	nr_solic_compra = nr_solic_compra_w) 
	and	ie_aprov_reprov = 'P' 
	and	not exists ( 
		SELECT	1 
		from	solic_compra_item x 
		where	x.nr_seq_aprovacao = a.nr_sequencia 
		and	coalesce(dt_baixa::text, '') = '');
		 
	end;	
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_sc_com_contrato ( nr_cot_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

