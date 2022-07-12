-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_receber_befdelete ON titulo_receber CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_receber_befdelete() RETURNS trigger AS $BODY$
BEGIN

if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S')	= 'S')  then
/* Grava o agendamento da informação para atualização do fluxo de caixa. */


CALL gravar_agend_fluxo_caixa(OLD.nr_titulo,null,'TR',coalesce(OLD.dt_pagamento_previsto,OLD.dt_vencimento),'E',OLD.nm_usuario);

end if;

RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_receber_befdelete() FROM PUBLIC;

CREATE TRIGGER titulo_receber_befdelete
	BEFORE DELETE ON titulo_receber FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_receber_befdelete();
