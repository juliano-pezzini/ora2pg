-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS exame_laboratorio_insert ON exame_laboratorio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_exame_laboratorio_insert() RETURNS trigger AS $BODY$
declare
reg_integracao_w		gerar_int_padrao.reg_integracao;
ds_param_adicional_w		varchar(100);
BEGIN

if (length(NEW.nr_seq_exame) > 8) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184939);
end if;

if (NEW.nm_exame is not null) then
	NEW.nm_exame_loc	:= upper(elimina_acentuacao(NEW.nm_exame));
end if;

if (NEW.nr_seq_superior is null) then
  reg_integracao_w.cd_estab_documento :=obter_estabelecimento_ativo();
	ds_param_adicional_w := 'operacao_p=INSERT;';
	reg_integracao_w := gerar_int_padrao.gravar_integracao('309', NEW.nr_seq_exame, NEW.nm_usuario, reg_integracao_w, ds_param_adicional_w);
end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_exame_laboratorio_insert() FROM PUBLIC;

CREATE TRIGGER exame_laboratorio_insert
	BEFORE INSERT ON exame_laboratorio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_exame_laboratorio_insert();

