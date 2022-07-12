-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS saldo_estoque_lote_log ON saldo_estoque_lote CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_saldo_estoque_lote_log() RETURNS trigger AS $BODY$
BEGIN

if (TG_OP = 'INSERT') then
	BEGIN
	insert into saldo_estoque_lote_log(
			 CD_ESTABELECIMENTO,
			 CD_LOCAL_ESTOQUE,
			 CD_MATERIAL,
			 DT_MESANO_REFERENCIA,
			 NR_SEQ_LOTE,
			 QT_ESTOQUE,
			 DT_ATUALIZACAO,
			 NM_USUARIO,
			 IE_ACAO,
			 DS_STACK)
	values (
			 NEW.CD_ESTABELECIMENTO,
			 NEW.CD_LOCAL_ESTOQUE,
			 NEW.CD_MATERIAL,
			 NEW.DT_MESANO_REFERENCIA,
			 NEW.NR_SEQ_LOTE,
			 NEW.QT_ESTOQUE,
			 NEW.DT_ATUALIZACAO,
			 NEW.NM_USUARIO,
			'I',
			substr(dbms_utility.format_call_stack,1,4000));

	end;
elsif (TG_OP = 'UPDATE') then
	BEGIN

	insert into saldo_estoque_lote_log(
			 CD_ESTABELECIMENTO,
			 CD_LOCAL_ESTOQUE,
			 CD_MATERIAL,
			 DT_MESANO_REFERENCIA,
			 NR_SEQ_LOTE,
			 QT_ESTOQUE,
			 DT_ATUALIZACAO,
			 NM_USUARIO,
			 IE_ACAO,
			 DS_STACK)
	values (
			 OLD.CD_ESTABELECIMENTO,
			 OLD.CD_LOCAL_ESTOQUE,
			 OLD.CD_MATERIAL,
			 OLD.DT_MESANO_REFERENCIA,
			 OLD.NR_SEQ_LOTE,
			 OLD.QT_ESTOQUE,
			 OLD.DT_ATUALIZACAO,
			 OLD.NM_USUARIO,
			'U',
			substr(dbms_utility.format_call_stack,1,4000));

	end;
else
	BEGIN

	insert into saldo_estoque_lote_log(
			 CD_ESTABELECIMENTO,
			 CD_LOCAL_ESTOQUE,
			 CD_MATERIAL,
			 DT_MESANO_REFERENCIA,
			 NR_SEQ_LOTE,
			 QT_ESTOQUE,
			 DT_ATUALIZACAO,
			 NM_USUARIO,
			 IE_ACAO,
			 DS_STACK)
	values (
			 OLD.CD_ESTABELECIMENTO,
			 OLD.CD_LOCAL_ESTOQUE,
			 OLD.CD_MATERIAL,
			 OLD.DT_MESANO_REFERENCIA,
			 OLD.NR_SEQ_LOTE,
			 OLD.QT_ESTOQUE,
			 OLD.DT_ATUALIZACAO,
			 OLD.NM_USUARIO,
			'D',
			substr(dbms_utility.format_call_stack,1,4000));

	end;
end if;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_saldo_estoque_lote_log() FROM PUBLIC;

CREATE TRIGGER saldo_estoque_lote_log
	BEFORE INSERT OR UPDATE OR DELETE ON saldo_estoque_lote FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_saldo_estoque_lote_log();

