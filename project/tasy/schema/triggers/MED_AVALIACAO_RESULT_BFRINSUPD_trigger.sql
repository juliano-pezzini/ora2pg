-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS med_avaliacao_result_bfrinsupd ON med_avaliacao_result CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_med_avaliacao_result_bfrinsupd() RETURNS trigger AS $BODY$
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    ie_liberado_w med_avaliacao_result.dt_liberacao%type;

BEGIN
    if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
        select  max(a.dt_liberacao)
        into STRICT    ie_liberado_w
        from    med_avaliacao_paciente a,
                med_avaliacao_result b
        where   a.nr_sequencia = b.nr_seq_avaliacao
        and     b.nr_seq_avaliacao = NEW.nr_seq_avaliacao;
		
        if ((ie_liberado_w is not null) and (OLD.QT_RESULTADO <> NEW.QT_RESULTADO) or (OLD.DS_RESULTADO <> NEW.DS_RESULTADO)) then
            CALL wheb_mensagem_pck.exibir_mensagem_abort('A avaliacao ja esta liberada.');
        end if;

        NEW.ds_stack := substr(OLD.ds_stack||'| Log: '||dbms_utility.format_call_stack||'| Fim Log |',1,4000);
    end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_med_avaliacao_result_bfrinsupd() FROM PUBLIC;

CREATE TRIGGER med_avaliacao_result_bfrinsupd
	BEFORE INSERT OR UPDATE ON med_avaliacao_result FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_med_avaliacao_result_bfrinsupd();
