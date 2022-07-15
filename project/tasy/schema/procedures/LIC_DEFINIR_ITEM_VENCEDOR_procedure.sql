-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_definir_item_vencedor ( nr_sequencia_p bigint, ds_motivo_vencedor_p text, nm_usuario_p text) AS $body$
DECLARE

 
 
nr_seq_licitacao_w			bigint;
nr_seq_fornec_w			bigint;
nr_seq_lic_item_w			bigint;
ds_fornecedor_w			varchar(100);
nr_seq_fornecedor_w		bigint;
ie_qualificado_w			varchar(1);


BEGIN 
 
select	nr_seq_licitacao, 
	nr_seq_lic_item, 
	nr_seq_fornec, 
	coalesce(ie_qualificado,'S') 
into STRICT	nr_seq_licitacao_w, 
	nr_seq_lic_item_w, 
	nr_seq_fornecedor_w, 
	ie_qualificado_w 
from	reg_lic_item_fornec 
where	nr_sequencia = nr_sequencia_p;
 
if (ie_qualificado_w = 'N') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266180);
	--'Este item não pode ser vencedor porque está desqualificado.'); 
end if;
 
select	coalesce(max(nr_seq_fornec),0) 
into STRICT	nr_seq_fornec_w 
from	reg_lic_item_fornec 
where	coalesce(ie_vencedor,'N') = 'S' 
and	nr_seq_lic_item = nr_seq_lic_item_w 
and	nr_seq_licitacao = nr_seq_licitacao_w;
 
select	substr(max(obter_nome_pf_pj(null,cd_cgc_fornec)),1,100) 
into STRICT	ds_fornecedor_w 
from	reg_lic_fornec 
where	nr_sequencia = nr_seq_fornecedor_w;
 
if (nr_seq_fornec_w > 0) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266181,'DS_FORNECEDOR=' || ds_fornecedor_w);
	--'Já existe o fornecedor (' || ds_fornecedor_w || ') que é vendedor deste item.'); 
end if;
 
update	reg_lic_item_fornec 
set	ie_vencedor = 'S', 
	ds_motivo_vencedor = ds_motivo_vencedor_p 
where	nr_sequencia = nr_sequencia_p;
 
insert into reg_lic_historico( 
	nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	ie_tipo_historico, 
	ds_observacao, 
	nr_seq_licitacao) 
values(	nextval('reg_lic_historico_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	'DV', 
	WHEB_MENSAGEM_PCK.get_texto(312581, 'NR_SEQ_LIC_ITEM_W=' || nr_seq_lic_item_w) || ds_fornecedor_w, --'Definido(manualmente) item ' || nr_seq_lic_item_w || ' como vencedor para o fornecedor 
	nr_seq_licitacao_w);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_definir_item_vencedor ( nr_sequencia_p bigint, ds_motivo_vencedor_p text, nm_usuario_p text) FROM PUBLIC;

