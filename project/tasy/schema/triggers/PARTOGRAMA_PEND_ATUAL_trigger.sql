-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS partograma_pend_atual ON partograma CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_partograma_pend_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
ie_tipo_w		varchar(10);
ie_lib_atestado_w	varchar(10);
nm_usuario_w        varchar(15);
BEGIN
  BEGIN
	if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
		goto Final;
	end if;
	BEGIN
	if 	((TG_OP = 'INSERT') OR (TG_OP = 'UPDATE')) then
		if (NEW.dt_liberacao is null) then
			ie_tipo_w := 'PART';
		elsif	(OLD.dt_liberacao is null AND NEW.dt_liberacao is not null)
			OR (OLD.NR_SEQ_ASSINATURA is null AND NEW.NR_SEQ_ASSINATURA is not null) then
			ie_tipo_w := 'XPART';
		end if;
		if (ie_tipo_w	is not null) then
      CALL Gerar_registro_pendente_PEP(
        cd_tipo_registro_p => ie_tipo_w,
        nr_sequencia_registro_p => NEW.nr_sequencia,
        cd_pessoa_fisica_p => substr(obter_pessoa_atendimento(NEW.nr_atendimento,'C'),1,255),
        nr_atendimento_p => NEW.nr_atendimento, 
        nm_usuario_p => NEW.nm_usuario,
        nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
      );
		end if;
	elsif (TG_OP = 'DELETE') THEN
		delete from pep_item_pendente
		where 	nr_seq_registro = OLD.nr_sequencia
		and	coalesce(IE_TIPO_PENDENCIA,'L')	= 'L'
		and	IE_TIPO_REGISTRO = 'PART';
		
		commit;
	end if;
exception
when others then
	null;
end;
<<Final>>
qt_reg_w	:= 0;
  END;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_partograma_pend_atual() FROM PUBLIC;

CREATE TRIGGER partograma_pend_atual
	AFTER INSERT OR UPDATE OR DELETE ON partograma FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_partograma_pend_atual();
