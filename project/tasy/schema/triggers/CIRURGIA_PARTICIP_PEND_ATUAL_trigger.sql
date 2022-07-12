-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cirurgia_particip_pend_atual ON cirurgia_participante CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cirurgia_particip_pend_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w  		smallint;
ie_tipo_w  		varchar(10);
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
nr_seq_atend_cons_pepa_w cirurgia.nr_seq_atend_cons_pepa%type;
ie_libera_partic_w	varchar(5);

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'N')  then
	goto Final;
end if;

select	coalesce(max(ie_libera_partic),'N')
into STRICT		ie_libera_partic_w
from		parametro_medico
where		cd_estabelecimento = obter_estabelecimento_ativo;

if (ie_libera_partic_w = 'S') then	
	if (NEW.dt_liberacao is null) then
		ie_tipo_w := 'CP';
	elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
		ie_tipo_w := 'XCP';
	end if;
	
	select max(c.nr_atendimento),
		max(c.cd_pessoa_fisica)
	into STRICT	nr_atendimento_w,
		cd_pessoa_fisica_w
	from	cirurgia c
	where	c.nr_cirurgia = NEW.nr_cirurgia;
	
	
	if ((ie_tipo_w is not null) and (coalesce(cd_pessoa_fisica_w,0) > 0)) then

    select max(b.nr_seq_atend_cons_pepa)
    into STRICT nr_seq_atend_cons_pepa_w
    from cirurgia b
    where	b.nr_cirurgia = NEW.nr_cirurgia;

    CALL Gerar_registro_pendente_PEP(
      cd_tipo_registro_p => ie_tipo_w,
      nr_sequencia_registro_p => NEW.nr_seq_interno,
      cd_pessoa_fisica_p =>  cd_pessoa_fisica_w,
      nr_atendimento_p => nr_atendimento_w, 
      nm_usuario_p => NEW.nm_usuario,
      nr_atend_cons_pepa_p=> nr_seq_atend_cons_pepa_w
    );
	end if;
end if;

<<Final>>
qt_reg_w := 0;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cirurgia_particip_pend_atual() FROM PUBLIC;

CREATE TRIGGER cirurgia_particip_pend_atual
	AFTER INSERT OR UPDATE ON cirurgia_participante FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cirurgia_particip_pend_atual();
