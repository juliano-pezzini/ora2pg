-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS mprev_atendimento_update ON mprev_atendimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_mprev_atendimento_update() RETURNS trigger AS $BODY$
declare

nr_atendimento_w	mprev_atendimento.nr_sequencia%type;

BEGIN
select	count(1)
into STRICT	nr_atendimento_w
from	mprev_atend_domicilio a
where 	nr_seq_atendimento = NEW.nr_sequencia;

if	((OLD.ie_forma_atendimento is not null) and (OLD.ie_forma_atendimento <> coalesce(NEW.ie_forma_atendimento,OLD.ie_forma_atendimento)) and (nr_atendimento_w > 0)) then
	/*antes de alterar a forma de atendimento é necessário excluir os dados do atendimento domiciliar!*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(881004, '');
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_mprev_atendimento_update() FROM PUBLIC;

CREATE TRIGGER mprev_atendimento_update
	BEFORE UPDATE ON mprev_atendimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_mprev_atendimento_update();
