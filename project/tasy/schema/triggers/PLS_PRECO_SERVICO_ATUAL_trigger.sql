-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_preco_servico_atual ON pls_preco_servico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_preco_servico_atual() RETURNS trigger AS $BODY$
declare
BEGIN
-- qualquer coisa que acontecer manda atualizar o grupo na tabela
if (TG_OP = 'DELETE') then
	CALL pls_gerencia_upd_obj_pck.marcar_para_atualizacao(	'PLS_GRUPO_SERVICO_TM',
								wheb_usuario_pck.get_nm_usuario,
								'PLS_PRECO_SERVICO_ATUAL',
								'nr_seq_grupo_p=' || OLD.nr_seq_grupo);
else
	CALL pls_gerencia_upd_obj_pck.marcar_para_atualizacao(	'PLS_GRUPO_SERVICO_TM',
								wheb_usuario_pck.get_nm_usuario,
								'PLS_PRECO_SERVICO_ATUAL',
								'nr_seq_grupo_p=' || NEW.nr_seq_grupo);
end if;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_preco_servico_atual() FROM PUBLIC;

CREATE TRIGGER pls_preco_servico_atual
	BEFORE INSERT OR UPDATE OR DELETE ON pls_preco_servico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_preco_servico_atual();

