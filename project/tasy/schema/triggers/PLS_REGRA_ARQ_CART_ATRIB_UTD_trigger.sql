-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_arq_cart_atrib_utd ON pls_regra_arq_cart_atrib CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_arq_cart_atrib_utd() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
if (NEW.qt_tamanho is not null) then 
	if (NEW.ds_cabecalho is not null) then 
		if (length(NEW.ds_cabecalho) > NEW.qt_tamanho) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort('Não é possível cadastrar o cabeçalho com tamanho maior que o tamanho definido para o atributo.');
		end if;
	end if;
	 
	if (NEW.vl_padrao is not null) then 
		if (length(NEW.vl_padrao) > NEW.qt_tamanho) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort('Não é possível cadastrar o valor padrão com tamanho maior que o tamanho definido para o atributo.');
		end if;
	end if;
	 
	if (NEW.vl_fixo_inicio is not null) then 
		if (length(NEW.vl_fixo_inicio) > NEW.qt_tamanho) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort('Não é possível cadastrar o Valor início com tamanho maior que o tamanho definido para o atributo.');
		end if;
	end if;
end if;
 
if (NEW.cd_caracter_completar is not null and NEW.ie_posicao_completar is null) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort('É necessário informar a posição do caractere que será utilizado para completar o atributo.');
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_arq_cart_atrib_utd() FROM PUBLIC;

CREATE TRIGGER pls_regra_arq_cart_atrib_utd
	BEFORE INSERT OR UPDATE ON pls_regra_arq_cart_atrib FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_arq_cart_atrib_utd();
