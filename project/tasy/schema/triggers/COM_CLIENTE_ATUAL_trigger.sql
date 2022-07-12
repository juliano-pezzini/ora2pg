-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS com_cliente_atual ON com_cliente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_com_cliente_atual() RETURNS trigger AS $BODY$
DECLARE

nr_sequencia_w		bigint;

BEGIN		

if (coalesce(NEW.ie_fase_venda,0) <> coalesce(OLD.ie_fase_venda,0)) then
	BEGIN

	select	nextval('com_cliente_log_seq')
	into STRICT	nr_sequencia_w
	;

	insert into com_cliente_log(	nr_sequencia,
		nr_seq_cliente,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_log,
		dt_log,
		ie_classificacao,
		ie_fase_venda,
		nr_seq_canal)
	values (
		nr_sequencia_w,
		NEW.nr_sequencia,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		1,
		LOCALTIMESTAMP,
		null,
		NEW.ie_fase_venda,
		null);
	
end;

end if;

if (coalesce(NEW.ie_classificacao,0) <> coalesce(OLD.ie_classificacao,0)) then
	BEGIN

	select	nextval('com_cliente_log_seq')
	into STRICT	nr_sequencia_w
	;

	insert into com_cliente_log(	nr_sequencia,
		nr_seq_cliente,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_log,
		dt_log,
		ie_classificacao,
		ie_fase_venda,
		nr_seq_canal)
	values (
		nr_sequencia_w,
		NEW.nr_sequencia,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		2,
		LOCALTIMESTAMP,
		NEW.ie_classificacao,
		null,
		null);
		
	end;
	
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_com_cliente_atual() FROM PUBLIC;

CREATE TRIGGER com_cliente_atual
	AFTER INSERT OR UPDATE ON com_cliente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_com_cliente_atual();
