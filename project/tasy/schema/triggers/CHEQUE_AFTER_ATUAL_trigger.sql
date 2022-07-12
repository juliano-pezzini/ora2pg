-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cheque_after_atual ON cheque CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cheque_after_atual() RETURNS trigger AS $BODY$
declare
nr_cheque_atual_w	varchar(30);
qt_registro_w		bigint;

BEGIN

if (TG_OP = 'UPDATE') then
	if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
		BEGIN
		nr_cheque_atual_w	:= NEW.nr_cheque;

		select	count(*)
		into STRICT	qt_registro_w
		from	cheque_bordero_titulo a
		where	a.nr_seq_cheque	= NEW.nr_sequencia
		and	a.nr_cheque <> nr_cheque_atual_w
		and	a.nr_cheque is not null;

		if (qt_registro_w > 0) then

			update	cheque_bordero_titulo a
			set	nr_cheque 		= nr_cheque_atual_w
			where	a.nr_seq_cheque	= NEW.nr_sequencia
			and	a.nr_cheque <> nr_cheque_atual_w
			and	a.nr_cheque is not null;
		end if;
		end;
	end if;
	/* Grava o agendamento da informação para atualização do fluxo de caixa. */

	CALL gravar_agend_fluxo_caixa(NEW.nr_sequencia,null,'CP',coalesce(NEW.dt_prev_pagamento,NEW.dt_vencimento),'A',NEW.nm_usuario);
elsif (TG_OP = 'INSERT') then
	/* Grava o agendamento da informação para atualização do fluxo de caixa. */

	CALL gravar_agend_fluxo_caixa(NEW.nr_sequencia,null,'CP',coalesce(NEW.dt_prev_pagamento,NEW.dt_vencimento),'I',NEW.nm_usuario);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cheque_after_atual() FROM PUBLIC;

CREATE TRIGGER cheque_after_atual
	AFTER INSERT OR UPDATE ON cheque FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cheque_after_atual();
