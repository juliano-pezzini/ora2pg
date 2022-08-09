-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_adiciona_microempresa ( nr_seq_licitacao_p bigint, nr_seq_fornec_p bigint, nr_seq_lic_item_p bigint, vl_lance_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
					 
nr_seq_lance_w			bigint;
vl_melhor_inicial_w			double precision;
vl_inicial_w			double precision;
nr_seq_lic_item_fornec_w		bigint;


BEGIN 
	 
select	coalesce(max(nr_seq_lance),0) +1 
into STRICT	nr_seq_lance_w 
from	reg_lic_fornec_lance 
where	nr_seq_lic_item	= nr_seq_lic_item_p 
and	nr_seq_licitacao	= nr_seq_licitacao_p;
 
select	coalesce(min(vl_item), 0) 
into STRICT	vl_inicial_w 
from	reg_lic_fornec_lance 
where	nr_seq_licitacao	= nr_seq_licitacao_p 
and	nr_seq_lic_item	= nr_seq_lic_item_p 
and	nr_seq_fornec	= nr_seq_fornec_p 
and	vl_item		> 0;
 
select	nr_sequencia 
into STRICT	nr_seq_lic_item_fornec_w 
from	reg_lic_item_fornec 
where	nr_seq_fornec	= nr_seq_fornec_p 
and	nr_seq_lic_item	= nr_seq_lic_item_p;
 
select	lic_obter_valor_vencedor_item(nr_seq_licitacao_p, nr_seq_lic_item_p) 
into STRICT	vl_melhor_inicial_w
;
	 
insert into reg_lic_fornec_lance( 
	nr_sequencia,				dt_atualizacao,			nm_usuario, 
	dt_atualizacao_nrec,			nm_usuario_nrec,			nr_seq_licitacao, 
	nr_seq_fornec,				nr_seq_lance,			nr_seq_lic_item, 
	nr_seq_lic_item_fornec,			vl_item,				vl_inicial, 
	ie_qualificado,				vl_melhor_inicial,			dt_fechamento_rodada, 
	nm_usuario_fechamento) 
values (	nextval('reg_lic_fornec_lance_seq'),		clock_timestamp(),				nm_usuario_p, 
	clock_timestamp(),					nm_usuario_p,			nr_seq_licitacao_p, 
	nr_seq_fornec_p,				nr_seq_lance_w,			nr_seq_lic_item_p, 
	nr_seq_lic_item_fornec_w,			vl_lance_p,			vl_inicial_w, 
	'S',					vl_melhor_inicial_w,			null, 
	nm_usuario_p);
 
update	reg_lic_vencedor 
set	nr_seq_fornec		= nr_seq_fornec_p, 
	vl_item			= vl_lance_p 
where	nr_seq_licitacao		= nr_seq_licitacao_p 
and	nr_seq_lic_item		= nr_seq_lic_item_p;
 
update	reg_lic_item_fornec 
set	vl_item			= vl_lance_p 
where	nr_seq_licitacao		= nr_seq_licitacao_p 
and	nr_seq_lic_item		= nr_seq_lic_item_p 
and	nr_seq_fornec		= nr_seq_fornec_p;
	 
insert into reg_lic_historico( 
	nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	ie_tipo_historico, 
	ds_observacao, 
	nr_seq_licitacao) 
values (	nextval('reg_lic_historico_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	'AM', 
	substr(WHEB_MENSAGEM_PCK.get_texto(310355, 'NR_SEQ_FORNEC_P=' || substr(obter_fornec_reg_lic_fornec(nr_seq_fornec_p),1,100) || ';NR_SEQ_LIC_ITEM_P=' || nr_seq_lic_item_p) || campo_mascara(vl_lance_p,4) || '.',1,255), --Adicionado a microempresa 
	nr_seq_licitacao_p);	
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_adiciona_microempresa ( nr_seq_licitacao_p bigint, nr_seq_fornec_p bigint, nr_seq_lic_item_p bigint, vl_lance_p bigint, nm_usuario_p text) FROM PUBLIC;
