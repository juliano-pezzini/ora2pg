-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS oft_receita_pend_atual ON med_receita CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_oft_receita_pend_atual() RETURNS trigger AS $BODY$
declare

PRAGMA AUTONOMOUS_TRANSACTION;

qt_reg_w	               smallint;
ie_tipo_w		            varchar(10);
cd_pessoa_fisica_w	varchar(30);
nr_atendimento_w    bigint;
ie_libera_exames_oft_w	varchar(5);
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

select	coalesce(max(ie_libera_exames_oft),'N')
into STRICT	ie_libera_exames_oft_w
from	parametro_medico
where	cd_estabelecimento = obter_estabelecimento_ativo;

if (ie_libera_exames_oft_w = 'S') then
	if (TG_OP = 'INSERT') or (TG_OP = 'UPDATE') then
		
		if (obter_funcao_ativa = 3010) then
			if (NEW.dt_liberacao is null) then
				ie_tipo_w := 'RECL';
			elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
				   ie_tipo_w := 'XRECL';
			end if;
		end if;
		
     SELECT	MAX(a.nr_atendimento_hosp),
                  MAX(a.cd_pessoa_fisica)
      INTO STRICT	   nr_atendimento_w,
                  cd_pessoa_fisica_w
      FROM     med_receita a WHERE a.nr_sequencia = NEW.nr_sequencia;

		BEGIN
		if (ie_tipo_w	is not null) then
			
      CALL Gerar_registro_pendente_PEP(
        cd_tipo_registro_p => ie_tipo_w,
        nr_sequencia_registro_p => NEW.nr_sequencia,
        cd_pessoa_fisica_p => cd_pessoa_fisica_w,
        nr_atendimento_p => nr_atendimento_w,  
        nm_usuario_p => NEW.nm_usuario,
        nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
    );
		end if;
		exception
			when others then
			null;
		end;		

	elsif (obter_funcao_ativa = 3010)  and (TG_OP = 'DELETE') then
            delete 	from pep_item_pendente
            where 	IE_TIPO_REGISTRO = 'RECL'
            and	      nr_seq_registro = OLD.nr_sequencia
            and	      coalesce(IE_TIPO_PENDENCIA,'L')	= 'L';
		
            commit;
    end if;	
	
	commit;
end if;

<<Final>>
qt_reg_w	:= 0;
  END;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_oft_receita_pend_atual() FROM PUBLIC;

CREATE TRIGGER oft_receita_pend_atual
	AFTER INSERT OR UPDATE OR DELETE ON med_receita FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_oft_receita_pend_atual();
