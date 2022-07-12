-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_contestacao_delete ON pls_contestacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_contestacao_delete() RETURNS trigger AS $BODY$
declare
 
nr_seq_fatura_w		bigint;
ds_aplicacao_w		varchar(50);
 
BEGIN 
select	max(nr_seq_pls_fatura) 
into STRICT	nr_seq_fatura_w 
from	pls_lote_contestacao 
where	nr_sequencia = OLD.nr_seq_lote;
 
if (nr_seq_fatura_w is not null) then					 
	update	pls_fatura_proc 
	set	ie_liberado	= 'S' 
	where	nr_seq_fatura_conta in (SELECT	x.nr_sequencia 
					from	pls_fatura_conta	x, 
						pls_fatura_evento	z, 
						pls_fatura		w 
					where	w.nr_sequencia	= z.nr_seq_fatura 
					and	z.nr_sequencia	= x.nr_seq_fatura_evento 
					and	x.nr_seq_conta	= OLD.nr_seq_conta 
					and	w.nr_sequencia	= nr_seq_fatura_w);
 
	update	pls_fatura_mat 
	set	ie_liberado	= 'S' 
	where	nr_seq_fatura_conta in (SELECT	x.nr_sequencia 
					from	pls_fatura_conta	x, 
						pls_fatura_evento	z, 
						pls_fatura		w 
					where	w.nr_sequencia	= z.nr_seq_fatura 
					and	z.nr_sequencia	= x.nr_seq_fatura_evento 
					and	x.nr_seq_conta	= OLD.nr_seq_conta 
					and	w.nr_sequencia	= nr_seq_fatura_w);
end if;	
 
if (pls_se_aplicacao_tasy = 'S') then 
	ds_aplicacao_w 		:= 'Aplicacao TASY ;';
else 
	ds_aplicacao_w 		:= 'Banco ;';
end if;
 
insert into log_exclusao(nm_tabela, 
	dt_atualizacao, 
	nm_usuario, 
	ds_chave) 
values (	'PLS_CONTESTACAO', 
	LOCALTIMESTAMP, 
	OLD.nm_usuario, 
	substr('NR_SEQUENCIA='||OLD.nr_sequencia||', NM_USUARIO='||OLD.nm_usuario||', NM_USUARIO_NREC='||OLD.nm_usuario_nrec|| 
	',NR_SEQ_CONTA='||OLD.nr_seq_conta||', NR_SEQ_LOTE='||OLD.nr_seq_lote||', Máquina='||wheb_usuario_pck.get_machine||' - '||ds_aplicacao_w,1,255));		
				 
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_contestacao_delete() FROM PUBLIC;

CREATE TRIGGER pls_contestacao_delete
	BEFORE DELETE ON pls_contestacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_contestacao_delete();
