-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_estrut_mat_atual_tot ON pls_estrutura_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_estrut_mat_atual_tot() RETURNS trigger AS $BODY$
declare
BEGIN

-- se alguma estrutura for apagada, seta para limpar a tabela que grava as estruturas e seus respectivos materiais
if (TG_OP = 'DELETE') then
	CALL pls_gerencia_upd_obj_pck.marcar_para_atualizacao(	'PLS_ESTRUTURA_MATERIAL_TM',
								wheb_usuario_pck.get_nm_usuario,
								'PLS_ESTRUT_MAT_ATUAL_TOT',
								'nr_seq_estrutura_p=' || OLD.nr_sequencia);

	CALL pls_gerencia_upd_obj_pck.marcar_para_atualizacao(	'PLS_ESTRUTURA_OCOR_TM',
								wheb_usuario_pck.get_nm_usuario,
								'PLS_ESTRUT_MAT_ATUAL_TOT',
								'nr_seq_estrutura_p=' || OLD.nr_sequencia);
end if;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_estrut_mat_atual_tot() FROM PUBLIC;

CREATE TRIGGER pls_estrut_mat_atual_tot
	BEFORE INSERT OR UPDATE OR DELETE ON pls_estrutura_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_estrut_mat_atual_tot();

