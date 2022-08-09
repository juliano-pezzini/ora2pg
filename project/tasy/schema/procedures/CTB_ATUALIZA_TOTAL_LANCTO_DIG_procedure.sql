-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_atualiza_total_lancto_dig ( nr_sequencia_p bigint, nr_lote_contabil_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
vl_credito_w  ctb_movimento.vl_movimento%type;
vl_debito_w  ctb_movimento.vl_movimento%type;


BEGIN 
 
select coalesce(sum(vl_movimento),0) 
into STRICT vl_debito_w 
from w_ctb_lancamento 
where nr_seq_lancamento = nr_sequencia_p 
and  nr_lote_contabil = nr_lote_contabil_p 
and	 ie_status_origem <> 'EX' 
and  (cd_conta_debito IS NOT NULL AND cd_conta_debito::text <> '');
 
select coalesce(sum(vl_movimento),0) 
into STRICT vl_credito_w 
from w_ctb_lancamento 
where nr_seq_lancamento = nr_sequencia_p 
and	 ie_status_origem <> 'EX' 
and  nr_lote_contabil = nr_lote_contabil_p 
and  (cd_conta_credito IS NOT NULL AND cd_conta_credito::text <> '');
 
 
update w_ctb_dados_lancamento 
set  vl_debito 		= vl_debito_w, 
    vl_credito 		= vl_credito_w 
where nr_sequencia 	= nr_sequencia_p 
and  nr_lote_contabil = nr_lote_contabil_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_atualiza_total_lancto_dig ( nr_sequencia_p bigint, nr_lote_contabil_p bigint, nm_usuario_p text) FROM PUBLIC;
