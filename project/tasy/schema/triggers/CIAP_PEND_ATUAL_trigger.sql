-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ciap_pend_atual ON ciap_atendimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ciap_pend_atual() RETURNS trigger AS $BODY$
declare

ie_tipo_w		varchar(10);

BEGIN
	if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
		BEGIN
		if (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') then
			if (NEW.dt_liberacao is null) then
				ie_tipo_w := 'CIAP';
				
			elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
				ie_tipo_w := 'XCIAP';
				
			end if;
		end if;

		if (ie_tipo_w	is not null) then
			CALL Gerar_registro_pendente_PEP(cd_tipo_registro_p 		=> ie_tipo_w,
										nr_sequencia_registro_p => NEW.nr_sequencia,
										cd_pessoa_fisica_p 		=> substr(obter_pessoa_atendimento(NEW.nr_atendimento,'C'),1,255), 
										nr_atendimento_p 		=> NEW.nr_atendimento, 
										nm_usuario_p 			=> NEW.nm_usuario,
										nr_atend_cons_pepa_p	=> NEW.nr_seq_atend_cons_pepa);
		end if;
        end;
		
	elsif (TG_OP = 'DELETE') THEN
		delete from pep_item_pendente
		where 	nr_seq_registro = OLD.nr_sequencia
		and	coalesce(IE_TIPO_PENDENCIA,'L')	= 'L'
		and	IE_TIPO_REGISTRO = 'CIAP';
		
		commit;
	end if;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ciap_pend_atual() FROM PUBLIC;

CREATE TRIGGER ciap_pend_atual
	AFTER INSERT OR UPDATE OR DELETE ON ciap_atendimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ciap_pend_atual();

