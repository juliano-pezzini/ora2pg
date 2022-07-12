-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_pagar_baixa_cc_aftins ON titulo_pagar_baixa_cc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_pagar_baixa_cc_aftins() RETURNS trigger AS $BODY$
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
/* Grava o agendamento da informacao para atualizacao do fluxo de caixa. */


CALL gravar_agend_fluxo_caixa(NEW.nr_titulo,NEW.nr_seq_baixa,'TPB',NEW.dt_atualizacao,'I',NEW.nm_usuario);
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_pagar_baixa_cc_aftins() FROM PUBLIC;

CREATE TRIGGER titulo_pagar_baixa_cc_aftins
	AFTER INSERT ON titulo_pagar_baixa_cc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_pagar_baixa_cc_aftins();

