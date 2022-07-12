-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conta_pos_proc_update ON pls_conta_pos_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conta_pos_proc_update() RETURNS trigger AS $BODY$
declare
 
nr_seq_lote_w		bigint;
 
BEGIN 
 
if (coalesce(wheb_usuario_pck.get_ie_lote_contabil, 'N') = 'N') and (coalesce(wheb_usuario_pck.get_ie_atualizacao_contabil, 'N') = 'N') then 
	select	max(b.nr_seq_lote) 
	into STRICT	nr_seq_lote_w 
	from	pls_fatura_proc 	e, 
		pls_fatura_conta 	d, 
		pls_fatura_evento 	c, 
		pls_fatura 		b, 
		pls_lote_faturamento 	a 
	where	b.nr_sequencia		= c.nr_seq_fatura 
	and	c.nr_sequencia		= d.nr_seq_fatura_evento 
	and	d.nr_sequencia		= e.nr_seq_fatura_conta 
	and	a.nr_sequencia		= b.nr_seq_lote 
	and	e.nr_seq_pos_proc 	= NEW.nr_sequencia 
	and	coalesce(b.ie_cancelamento, 'X') not in ('C', 'E') 
	and	e.ie_tipo_cobranca in ('1', '2') 
	and	a.nr_seq_lote_origem is null;
	 
	if (nr_seq_lote_w is not null) then 
		if (OLD.nr_seq_lote_fat is not null) and (NEW.nr_seq_lote_fat is null) then 
			CALL pls_gerar_fatura_log(nr_seq_lote_w, null, NEW.nr_seq_conta,	'PLS_CONTA_POS_PROC_UPDATE -'|| 
											' Conta: '||NEW.nr_seq_conta|| 
											' Lote incluso: '||nr_seq_lote_w|| 
											' Lote old: '||OLD.nr_seq_lote_fat|| 
											' Lote new: '||NEW.nr_seq_lote_fat|| 
											' Evento old: '||OLD.nr_seq_evento_fat|| 
											' Evento new: '||NEW.nr_seq_evento_fat, 'CX', 'N', NEW.nm_usuario);
			NEW.nr_seq_lote_fat	:= nr_seq_lote_w;
			NEW.nr_seq_evento_fat	:= OLD.nr_seq_evento_fat;
		end if;
	end if;
end if;
 
-- tratamento para o pós estabelecido com base no A520. Quando for gerado. 
-- se estiver atualizado e o antigo é 'A', deve permanecer 'A'. 
if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S') and (TG_OP = 'UPDATE') and (coalesce(OLD.ie_status_faturamento,'L')	= 'A') then 
	 
	NEW.ie_status_faturamento := 'A'; -- Fixo 'A', para não emitir cobrança no A520 
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conta_pos_proc_update() FROM PUBLIC;

CREATE TRIGGER pls_conta_pos_proc_update
	BEFORE UPDATE ON pls_conta_pos_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conta_pos_proc_update();

