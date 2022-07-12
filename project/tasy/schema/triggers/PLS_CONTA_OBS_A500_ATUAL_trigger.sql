-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conta_obs_a500_atual ON pls_conta_observacao_a500 CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conta_obs_a500_atual() RETURNS trigger AS $BODY$
declare

BEGIN
-- verifica se deve executar essa trigger, a mesma apresenta problema de trigger mutante quando executada
-- no processo de excluir protocolos do portal
if (pls_util_pck.ie_exec_trig_conta_obs_w = 'S') then

	if (TG_OP = 'DELETE') then

		insert into pls_conta_log(
			nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao
		) values (
			nextval('pls_conta_log_seq'), LOCALTIMESTAMP, OLD.nm_usuario,
			LOCALTIMESTAMP, NEW.nm_usuario, OLD.nr_seq_conta,
			OLD.nr_seq_conta_proc, null, OLD.nm_usuario,
			LOCALTIMESTAMP, 'Exclusão - ds_observacao anterior : '||OLD.ds_observacao||' ds_observacao nova :  ' || pls_util_pck.enter_w||' '||dbms_utility.format_call_stack
		);
	end if;

	if (TG_OP = 'UPDATE') then

		insert into pls_conta_log(
			nr_sequencia,dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
			nr_seq_conta_proc, nr_seq_conta_mat, nm_usuario_alteracao,
			dt_alteracao, ds_alteracao
		) values (
			nextval('pls_conta_log_seq'), LOCALTIMESTAMP, NEW.nm_usuario,
			LOCALTIMESTAMP, NEW.nm_usuario, NEW.nr_seq_conta,
			NEW.nr_seq_conta_proc, null, NEW.nm_usuario,
			LOCALTIMESTAMP, 'Modificação - ds_observacao anterior : '||OLD.ds_observacao||' ds_observacao nova:  '||NEW.ds_observacao || pls_util_pck.enter_w ||' '||dbms_utility.format_call_stack
		);
	end if;
end if;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conta_obs_a500_atual() FROM PUBLIC;

CREATE TRIGGER pls_conta_obs_a500_atual
	BEFORE UPDATE OR DELETE ON pls_conta_observacao_a500 FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conta_obs_a500_atual();
