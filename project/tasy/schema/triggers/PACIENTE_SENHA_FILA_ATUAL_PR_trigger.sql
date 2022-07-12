-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_senha_fila_atual_pr ON paciente_senha_fila CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_senha_fila_atual_pr() RETURNS trigger AS $BODY$
declare
qt_simultaneas_w	fila_espera_senha.qt_simultaneas%type;
qt_senha_simultaneas_w	bigint;
ds_fila_w		fila_espera_senha.ds_fila%type;

pragma autonomous_transaction;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger <> 'N') then

	select	max(qt_simultaneas),
		max(ds_fila)
	into STRICT	qt_simultaneas_w,
		ds_fila_w
	from	fila_espera_senha
	where	nr_sequencia = NEW.nr_seq_fila_senha;

	if (qt_simultaneas_w is not null and
		NEW.nr_seq_fila_senha <> OLD.nr_seq_fila_senha) then
		
		BEGIN
			select	count(a.nr_sequencia)
			into STRICT	qt_senha_simultaneas_w
			from	paciente_senha_fila a
			where	a.nr_seq_fila_senha = NEW.nr_seq_fila_senha
			and	dt_inutilizacao is null
			and	dt_fim_atendimento is null
			and	dt_utilizacao is null;	
		exception
			when	others then
				qt_senha_simultaneas_w := 0;
		end;
		
		if (qt_senha_simultaneas_w >= qt_simultaneas_w) then
			commit;
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1034121, 'FILA='|| ds_fila_w);
		end if;
	end if;
end if;

commit;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_senha_fila_atual_pr() FROM PUBLIC;

CREATE TRIGGER paciente_senha_fila_atual_pr
	BEFORE INSERT OR UPDATE ON paciente_senha_fila FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_senha_fila_atual_pr();
