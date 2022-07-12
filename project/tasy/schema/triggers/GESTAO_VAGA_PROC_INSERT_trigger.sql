-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS gestao_vaga_proc_insert ON gestao_vaga_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_gestao_vaga_proc_insert() RETURNS trigger AS $BODY$
Declare

PRAGMA AUTONOMOUS_TRANSACTION;

nr_seq_autor_proc_w		bigint;
cont_w				    integer;

BEGIN

select	count(*)
into STRICT	cont_w
from	autorizacao_convenio where		nr_seq_gestao 	= NEW.nr_seq_gestao LIMIT 1;
        		
		if (cont_w > 0) then
        nr_seq_autor_proc_w := gerar_autor_vaga(NEW.nr_seq_gestao, null, NEW.nm_usuario, nr_seq_autor_proc_w, NEW.cd_procedimento, NEW.ie_origem_proced, NEW.nr_seq_proc_interno);
        end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_gestao_vaga_proc_insert() FROM PUBLIC;

CREATE TRIGGER gestao_vaga_proc_insert
	AFTER INSERT OR UPDATE ON gestao_vaga_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_gestao_vaga_proc_insert();

