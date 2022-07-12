-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cirurgia_participante_insert ON cirurgia_participante CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cirurgia_participante_insert() RETURNS trigger AS $BODY$
DECLARE
 
ds_origem_w		varchar(1800);
ie_gerar_particip_w	varchar(255);
 
BEGIN 
 
ds_origem_w := substr(dbms_utility.format_call_stack,1,1800);
 
ie_gerar_particip_w := Obter_Valor_Param_Usuario(872, 448, Obter_Perfil_Ativo, NEW.nm_usuario, 0);
 
if (ie_gerar_particip_w = 'S') and (wheb_usuario_pck.get_cd_funcao = 872) then 
	 
	if (NEW.cd_pessoa_fisica is not null) then 
		CALL Ajustar_Participante_Proc( 
				'INSERT', 
				NEW.nr_cirurgia, 
				NEW.nr_sequencia, 
				NEW.ie_funcao, 
				NEW.cd_pessoa_fisica, 
				NEW.nm_participante, 
				NEW.nr_seq_procedimento, 
				NEW.nm_usuario);
	end if;
 
elsif (coalesce(ie_gerar_particip_w,'X') <> 'U') then 
	 
	CALL Ajustar_Participante_Proc( 
			'INSERT', 
			NEW.nr_cirurgia, 
			NEW.nr_sequencia, 
			NEW.ie_funcao, 
			NEW.cd_pessoa_fisica, 
			NEW.nm_participante, 
			NEW.nr_seq_procedimento, 
			NEW.nm_usuario);
end if;
 
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cirurgia_participante_insert() FROM PUBLIC;

CREATE TRIGGER cirurgia_participante_insert
	AFTER INSERT ON cirurgia_participante FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cirurgia_participante_insert();
