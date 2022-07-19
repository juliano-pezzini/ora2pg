-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_altera_valor_pos ( nr_seq_analise_p bigint, nr_seq_conta_pos_p bigint, nr_seq_w_item_p bigint, vl_total_p bigint, qt_item_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ X ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
vl_administracao_w	pls_conta_pos_estabelecido.vl_administracao%type;
tx_administracao_w	pls_conta_pos_estabelecido.tx_administracao%type;
vl_medico_w		pls_conta_pos_estabelecido.vl_medico%type	:= 0;
vl_materiais_w		pls_conta_pos_estabelecido.vl_materiais%type	:= 0;
ie_tipo_item_w		varchar(1);

BEGIN
 
select	max(ie_tipo_item) 
into STRICT	ie_tipo_item_w 
from	(SELECT	'P' ie_tipo_item 
	from	pls_conta_pos_estabelecido 
	where	nr_sequencia		= nr_seq_conta_pos_p 
	and	(nr_seq_conta_proc IS NOT NULL AND nr_seq_conta_proc::text <> '') 
	and	((ie_situacao		= 'A')or (coalesce(ie_situacao::text, '') = '')) 
	
union
 
	SELECT	'M' ie_tipo_item 
	from	pls_conta_pos_estabelecido 
	where	nr_sequencia		= nr_seq_conta_pos_p 
	and	(nr_seq_conta_mat IS NOT NULL AND nr_seq_conta_mat::text <> '') 
	and	((ie_situacao		= 'A')or (coalesce(ie_situacao::text, '') = ''))) alias11;
	 
select	max(tx_administracao) 
into STRICT	tx_administracao_w 
from	pls_conta_pos_estabelecido 
where	nr_sequencia	= nr_seq_conta_pos_p 
and	((ie_situacao		= 'A')or (coalesce(ie_situacao::text, '') = ''));
 
vl_administracao_w	:= dividir((vl_total_p),100 + coalesce(tx_administracao_w,0)) * tx_administracao_w;
 
if (ie_tipo_item_w	= 'M') then	 
	vl_materiais_w	:= vl_total_p - vl_administracao_w;
	update	pls_conta_pos_estabelecido 
	set	vl_beneficiario		= vl_total_p, 
		vl_materiais		= vl_materiais_w, 
		vl_custo_operacional	= 0, 
		vl_medico		= 0, 
		qt_item			= qt_item_p, 
		vl_administracao	= vl_administracao_w, 
		dt_atualizacao		= clock_timestamp(), 
		nm_usuario		= nm_usuario_p 
	where	nr_sequencia		= nr_seq_conta_pos_p 
	and	((ie_situacao		= 'A')or (coalesce(ie_situacao::text, '') = ''));
else 
	vl_medico_w		:= vl_total_p - vl_medico_w;
 
	update	pls_conta_pos_estabelecido 
	set	vl_beneficiario		= vl_total_p, 
		vl_materiais		= 0, 
		vl_custo_operacional	= 0, 
		vl_medico		= vl_medico_w, 
		qt_item			= qt_item_p, 
		dt_atualizacao		= clock_timestamp(), 
		nm_usuario		= nm_usuario_p 
	where	nr_sequencia		= nr_seq_conta_pos_p 
	and	((ie_situacao		= 'A')or (coalesce(ie_situacao::text, '') = ''));
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_altera_valor_pos ( nr_seq_analise_p bigint, nr_seq_conta_pos_p bigint, nr_seq_w_item_p bigint, vl_total_p bigint, qt_item_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

