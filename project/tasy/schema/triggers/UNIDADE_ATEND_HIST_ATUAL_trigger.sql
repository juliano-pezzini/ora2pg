-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS unidade_atend_hist_atual ON unidade_atend_hist CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_unidade_atend_hist_atual() RETURNS trigger AS $BODY$
declare

isInsertorUpdate_w varchar(10);

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger <> 'N') then

if (TG_OP = 'INSERT') then
	isInsertorUpdate_w := 'INSERT';
else
	isInsertorUpdate_w := 'UPDATE';
end if;

INSERT INTO ADT_STACK(
            nr_sequencia,
			DT_ATUALIZACAO,
			NM_USUARIO,
			DT_ATUALIZACAO_NREC,
            NM_USUARIO_NREC,
            NM_TABELA,
			DS_CHAVE_SIMPLES,
			DS_STACK,
			DS_ACAO
		)
		VALUES (
            nextval('adt_stack_seq'),
			LOCALTIMESTAMP,
			wheb_usuario_pck.get_nm_usuario,
            LOCALTIMESTAMP,
            wheb_usuario_pck.get_nm_usuario,
			'UNIDADE_ATEND_HIST',
            to_char(NEW.nr_sequencia),
			('nr_seq_unidade: '||NEW.nr_seq_unidade||' perfil: '||wheb_usuario_pck.get_cd_perfil||' funcao: '||wheb_usuario_pck.get_cd_funcao||' Stack: '||substr(dbms_utility.format_call_stack,1,3500)),
			isInsertorUpdate_w
		);

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_unidade_atend_hist_atual() FROM PUBLIC;

CREATE TRIGGER unidade_atend_hist_atual
	BEFORE INSERT OR UPDATE ON unidade_atend_hist FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_unidade_atend_hist_atual();

