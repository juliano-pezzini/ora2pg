-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remover_marcacao_item (nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ageint_item_p bigint) AS $body$
DECLARE


ie_tipo_agendamento_w		agenda_integrada_item. ie_tipo_agendamento %type;
nr_seq_agenda_exame_w		agenda_integrada_item. nr_seq_agenda_exame %type;
nr_seq_agenda_cons_w		agenda_integrada_item. nr_seq_agenda_cons %type;
nr_seq_ageint_w			agenda_integrada_item. nr_seq_agenda_int %type;
cd_agenda_w			agenda.cd_agenda%type;
ie_canc_agenda_transf_w		varchar(1);
qt_integrada_w			bigint;
qt_reg_w			smallint;
nr_seq_status_cancel_w		agenda_integrada_Status.nr_sequencia%type;

procedure cancelar_ageint is
	;
BEGIN
	select 	coalesce(max(1), 0)
	into STRICT	qt_reg_w
	from 	agenda_integrada_item a
	where 	a.nr_seq_agenda_int = nr_seq_ageint_w
	and 	not exists (SELECT 1 from agenda_paciente x where x.nr_sequencia = a.nr_seq_agenda_exame and x.ie_status_agenda = 'C')
	and 	not exists (select 1 from agenda_consulta x where x.nr_sequencia = a.nr_seq_agenda_cons and x.ie_status_agenda = 'C');
	
	if (qt_reg_w = 0) then
		select	min(nr_sequencia)
		into STRICT	nr_seq_status_cancel_w
		from	AGENDA_INTEGRADA_STATUS
		where 	ie_status_tasy	= 'CA'
		and		coalesce(ie_situacao, 'A')	= 'A';
	
		CALL Ageint_Alterar_Status(
			nr_seq_status_cancel_w,
			nr_seq_ageint_w,
			'',
			nm_usuario_p,
			cd_Estabelecimento_p);
	end if;
	
	end;

begin

select 	max(ie_tipo_agendamento),
	max(nr_seq_agenda_int),
	max(nr_seq_agenda_exame),
	max(nr_seq_agenda_cons)
into STRICT	ie_tipo_agendamento_w,
	nr_seq_ageint_w,
	nr_seq_agenda_exame_w,
	nr_seq_agenda_cons_w
from 	agenda_integrada_item
where 	nr_sequencia = nr_seq_ageint_item_p;

delete	FROM ageint_marcacao_usuario
where	nr_seq_ageint_item = nr_seq_ageint_item_p;

if (ie_tipo_agendamento_w = 'E') then
	-- ageexame
	select 	max(cd_agenda)
	into STRICT	cd_agenda_w
	from 	agenda_paciente
	where 	nr_sequencia = nr_seq_agenda_exame_w;
	
	update	agenda_paciente
	set	ie_transferido = 'S'
	where	nr_sequencia = nr_seq_agenda_exame_w;
	CALL alterar_status_agenda(cd_Agenda_w, nr_seq_agenda_exame_w, 'C', '',WHEB_MENSAGEM_PCK.get_texto(277354), 'N', nm_usuario_p);
else
	-- agecons
	ie_canc_agenda_transf_w := obter_param_usuario(821, 180, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_canc_agenda_transf_w);
	if (ie_canc_agenda_transf_w = 'N') then

		select	count(*)
		into STRICT	qt_integrada_w
		from	agenda_integrada_item
		where	nr_seq_agenda_cons	= nr_seq_agenda_cons_w;
	
		if (qt_integrada_w > 0) then
			ie_canc_agenda_transf_w	:= 'S';
		end if;
	
	end if;
	
	if (ie_canc_agenda_transf_w = 'S') then	
		update	agenda_consulta
		set		ie_status_agenda		= 'C',
				nm_usuario_status		= nm_usuario_p,
				dt_status				= clock_timestamp(),
				dt_cancelamento			= clock_timestamp(),
				ds_motivo_status		= wheb_mensagem_pck.get_texto(790940),
				nm_usuario				= nm_usuario_p,
				ie_transferido			= 'S'
		where	nr_sequencia			= nr_seq_agenda_cons_w;
	else
		/* excluir registro origem */

		delete from agenda_consulta
		where nr_sequencia = nr_seq_agenda_cons_w;
	end if;
end if;

cancelar_ageint;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remover_marcacao_item (nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ageint_item_p bigint) FROM PUBLIC;
