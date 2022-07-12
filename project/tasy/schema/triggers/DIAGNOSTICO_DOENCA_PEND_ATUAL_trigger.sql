-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS diagnostico_doenca_pend_atual ON diagnostico_doenca CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_diagnostico_doenca_pend_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
ie_tipo_w		varchar(10);
ie_lib_diag_medico_w	varchar(10);
nr_seq_classif_diag_w		wl_worklist.nr_seq_classif_diag%type;
ie_usa_case_w				varchar(1);
nr_seq_episodio_w			episodio_paciente.nr_sequencia%type;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

select	max(ie_lib_diag_medico)
into STRICT	ie_lib_diag_medico_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (coalesce(ie_lib_diag_medico_w,'N') = 'S') then
	if (NEW.dt_liberacao is null) then
		ie_tipo_w := 'D';
	elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
		ie_tipo_w := 'XD';
	end if;
	if (ie_tipo_w	is not null) then

     CALL Gerar_registro_pendente_PEP(
      cd_tipo_registro_p => ie_tipo_w,
      nr_sequencia_registro_p => NEW.nr_seq_interno,
      cd_pessoa_fisica_p => obter_pessoa_atendimento(NEW.nr_atendimento,'C'),
      nr_atendimento_p => NEW.nr_atendimento, 
      nm_usuario_p => NEW.nm_usuario,
      nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
    );

	end if;
end if;

if (NEW.dt_liberacao is not null) and (OLD.dt_liberacao is null) then

	select	obter_uso_case(wheb_usuario_pck.get_nm_usuario)
	into STRICT	ie_usa_case_w
	;
	
	if (ie_usa_case_w = 'S') then
		select	nr_seq_episodio
		into STRICT	nr_seq_episodio_w
		from	atendimento_paciente
		where	nr_atendimento = NEW.nr_atendimento;

		select	max(coalesce(c.nr_sequencia,0))
		into STRICT	nr_seq_classif_diag_w
		from	classificacao_diagnostico c,
				medic_diagnostico_doenca d
		where	c.nr_sequencia	= d.nr_seq_classificacao
		and		d.nr_atendimento	= NEW.nr_atendimento
		and		d.cd_doenca	= NEW.cd_doenca
		and		d.dt_diagnostico	= NEW.dt_diagnostico
		and		c.ie_situacao = 'A'
		and		d.ie_situacao = 'A';
		
	else

		select	max(coalesce(c.nr_sequencia,0))
		into STRICT	nr_seq_classif_diag_w
		from	classificacao_diagnostico c,
				medic_diagnostico_doenca d
		where	c.nr_sequencia	= d.nr_seq_classificacao
		and		d.nr_atendimento in (SELECT x.nr_atendimento from atendimento_paciente x, episodio_paciente y where x.nr_seq_episodio = y.nr_sequencia and y.nr_sequencia = nr_seq_episodio_w)
		and		d.cd_doenca	= NEW.cd_doenca
		and		d.dt_diagnostico = NEW.dt_diagnostico
		and		c.ie_situacao = 'A'
		and		d.ie_situacao = 'A';
	
	end if;
	
	CALL wl_gerar_finalizar_tarefa('DG','F',NEW.nr_atendimento,obter_pessoa_atendimento(NEW.nr_atendimento,'C'),wheb_usuario_pck.get_nm_usuario,LOCALTIMESTAMP,'N',null,null,null,null,null,null,null,null,NEW.nr_seq_interno,null,NEW.ie_tipo_diagnostico,null,null,null,null,null,nr_seq_classif_diag_w);

end if;

<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_diagnostico_doenca_pend_atual() FROM PUBLIC;

CREATE TRIGGER diagnostico_doenca_pend_atual
	AFTER INSERT OR UPDATE ON diagnostico_doenca FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_diagnostico_doenca_pend_atual();
