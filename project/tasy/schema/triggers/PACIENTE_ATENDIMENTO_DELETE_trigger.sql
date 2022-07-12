-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_atendimento_delete ON paciente_atendimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_atendimento_delete() RETURNS trigger AS $BODY$
declare

dt_cancelamento_w		timestamp;
dt_atual_w			timestamp;
nr_seq_quimio_w			bigint;
nr_seq_autor_w			bigint := 0;
nr_seq_estagio_w		bigint;
ie_cancela_autor_w		varchar(1);
nm_usuario_w			varchar(15) := wheb_usuario_pck.Get_Nm_Usuario;
nr_seq_autor_dia_w		bigint;
pragma autonomous_transaction;
BEGIN
  BEGIN

if (OLD.nr_seq_agenda_cons is not null) then

	select	dt_agenda
	into STRICT	dt_atual_w
	from 	agenda_consulta
	where	nr_sequencia	= OLD.nr_seq_agenda_cons;


	select	/*+ INDEX(AGENDA_CONSULTA AGECONS_I4) */		coalesce(max(dt_agenda), dt_atual_w)
	into STRICT	dt_cancelamento_w
	from	agenda_consulta
	where	trunc(dt_agenda, 'mi') = trunc(dt_atual_w, 'mi');

	update	agenda_consulta
	set	ie_status_agenda	= 'C',
		dt_agenda		= dt_cancelamento_w + 1/86400,
		nm_usuario		= OLD.nm_usuario,
		dt_atualizacao		= LOCALTIMESTAMP
	where	nr_sequencia		= OLD.nr_seq_agenda_cons;
end if;

select	max(coalesce(nr_sequencia, 0))
into STRICT	nr_seq_quimio_w
from	agenda_quimio
where	nr_seq_atendimento = OLD.nr_seq_atendimento;

if (nr_seq_quimio_w > 0) then

	update	agenda_quimio
	set	ie_status_agenda	= 'C',
		dt_cancelada		= LOCALTIMESTAMP,
		nm_usuario		= OLD.nm_usuario,
		dt_atualizacao		= LOCALTIMESTAMP,
		--ds_observacao		= 'Dia excluído'
		ds_observacao		= wheb_mensagem_pck.get_texto(309988)
	where	nr_sequencia		= nr_seq_quimio_w;

	update	agenda_quimio
	set	nr_seq_atendimento  = NULL
	where	nr_sequencia = nr_seq_quimio_w;

end if;

delete	FROM agenda_quimio_marcacao
where	nr_seq_atendimento = OLD.nr_seq_atendimento;

select	coalesce(max(a.nr_sequencia),0)
into STRICT	nr_seq_autor_dia_w
from	autorizacao_convenio a
where	nr_seq_paciente = OLD.nr_seq_atendimento;


BEGIN
select	a.nr_sequencia
into STRICT	nr_seq_autor_w
from	autorizacao_convenio a
where	a.nr_seq_paciente_setor = OLD.nr_seq_paciente
and	a.nr_ciclo	  	= OLD.nr_ciclo
and	a.nr_seq_paciente is null
and	coalesce(nr_seq_autor_dia_w,0) = 0
and	not exists (	SELECT 	1
			from	paciente_atendimento x
			where	x.nr_ciclo = a.nr_ciclo
			and	x.nr_seq_paciente = a.nr_seq_paciente_setor
			and	x.ds_dia_ciclo <> OLD.ds_dia_ciclo) LIMIT 1;
exception
when others then
	nr_seq_autor_w := 0;
end;

ie_cancela_autor_w := obter_param_usuario(281, 1428, obter_perfil_ativo, OLD.nm_usuario, OLD.cd_estabelecimento, ie_cancela_autor_w);

BEGIN
select	a.nr_sequencia
into STRICT	nr_seq_estagio_w
from	estagio_autorizacao a
where	a.cd_empresa	= obter_empresa_estab(OLD.cd_estabelecimento)
and	a.ie_situacao	= 'A'
and	a.ie_interno	= '70'  LIMIT 1;
exception
when others then
	nr_seq_estagio_w	:= null;
end;

if (nr_seq_autor_w > 0) then --Verifica autorizações geradas para o ciclo
	BEGIN
		if (coalesce(ie_cancela_autor_w,'N') = 'S') and (nr_seq_estagio_w is not null) then
			update	autorizacao_convenio
			set	nr_seq_estagio	= nr_seq_estagio_w,
				nm_usuario	= nm_usuario_w,
				dt_atualizacao	= LOCALTIMESTAMP
			where	nr_sequencia 	= nr_seq_autor_w;

			--gerar_historico_autorizacao(nr_seq_autor_w,null,null,'Cancelado pela exclusão do tratamento oncológico.',nm_usuario_w);
			CALL gerar_historico_autorizacao(nr_seq_autor_w,null,null,wheb_mensagem_pck.get_texto(309989),nm_usuario_w);
		else
			delete
			from	autorizacao_convenio
			where	nr_sequencia = nr_seq_autor_w;
		end if;
	end;

elsif (coalesce(ie_cancela_autor_w,'N') = 'S') and --Verifica autorizações geradas para o dia.
	(nr_seq_estagio_w is not null) and (coalesce(nr_seq_autor_dia_w,0) > 0) then

	/*
	begin
	select	a.nr_sequencia
	into	nr_seq_autor_w
	from	autorizacao_convenio a
	where	a.nr_seq_paciente 	= :old.nr_seq_atendimento
	and	a.nr_ciclo	  	= :old.nr_ciclo
	and	a.ds_dia_ciclo		= :old.ds_dia_ciclo
	and	rownum			= 1;
	exception
	when others then
		nr_seq_autor_w	:= 0;
	end;*/
	if (nr_seq_autor_dia_w > 0) then
		update	autorizacao_convenio
		set	nr_seq_estagio	= nr_seq_estagio_w,
			nm_usuario	= nm_usuario_w,
			dt_atualizacao	= LOCALTIMESTAMP,
			nr_seq_paciente	 = NULL
		where	nr_sequencia 	= nr_seq_autor_dia_w;

		--gerar_historico_autorizacao(nr_seq_autor_dia_w,null,null,'Cancelado pela exclusão do tratamento oncológico.',:old.nm_usuario);
		CALL gerar_historico_autorizacao(nr_seq_autor_dia_w,null,null,wheb_mensagem_pck.get_texto(309989),OLD.nm_usuario);

	end if;
end if;

commit;
  END;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_atendimento_delete() FROM PUBLIC;

CREATE TRIGGER paciente_atendimento_delete
	BEFORE DELETE ON paciente_atendimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_atendimento_delete();
