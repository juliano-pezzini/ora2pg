-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ehr_template_conteudo_delete ON ehr_template_conteudo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ehr_template_conteudo_delete() RETURNS trigger AS $BODY$
declare
NR_LINKED_DATA_ELEMENT_C CONSTANT EHR_ELEMENTO.NR_SEQUENCIA%TYPE DEFAULT 1613;

dt_liberacao_w	timestamp;

BEGIN

select	max(dt_liberacao)
into STRICT	dt_liberacao_w
from	ehr_template
where	nr_sequencia = OLD.nr_seq_template;

if (dt_liberacao_w is not null) then
	CALL wheb_mensagem_pck.EXIBIR_MENSAGEM_ABORT(253037);
end	if;

  IF OLD.nr_seq_elemento = NR_LINKED_DATA_ELEMENT_C AND OLD.nr_seq_linked_data IS NOT NULL THEN
    CALL ehr_alterar_tabela_linked(OLD.nr_seq_template, OLD.nr_seq_linked_data, 'DROP');
  END IF;

RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ehr_template_conteudo_delete() FROM PUBLIC;

CREATE TRIGGER ehr_template_conteudo_delete
	BEFORE DELETE ON ehr_template_conteudo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ehr_template_conteudo_delete();

