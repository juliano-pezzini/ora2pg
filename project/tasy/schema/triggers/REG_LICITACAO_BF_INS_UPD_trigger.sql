-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_licitacao_bf_ins_upd ON reg_licitacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_licitacao_bf_ins_upd() RETURNS trigger AS $BODY$
DECLARE

ie_status_w  bigint;

BEGIN

select count(*)
into STRICT ie_status_w
from reg_lic_item
where nr_seq_licitacao = NEW.nr_sequencia and obter_bloq_canc_proj_rec(nr_seq_proj_rec) > 0;

if (ie_status_w > 0) then
    CALL wheb_mensagem_pck.exibir_mensagem_abort(1144309);  -- Registro associado a um projeto bloqueado ou cancelado. 
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_licitacao_bf_ins_upd() FROM PUBLIC;

CREATE TRIGGER reg_licitacao_bf_ins_upd
	BEFORE INSERT OR UPDATE ON reg_licitacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_licitacao_bf_ins_upd();
