-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_alterar_setor_realizar (nr_seq_paciente_p bigint, nr_seq_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_todos_dias_p text, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w	paciente_setor.cd_estabelecimento%type;
cd_estabelecimento_ww	paciente_setor.cd_estabelecimento%type;
cd_estab_setor_w		setor_atendimento.cd_estabelecimento%type;
ds_estabelecimento_w	w_pendencia_agequi.ds_estabelecimento%type;
nr_seq_pend_agenda_w	PACIENTE_ATENDIMENTO.NR_SEQ_PEND_AGENDA%type;


BEGIN

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	paciente_setor
where	nr_seq_paciente = nr_seq_paciente_p;

select	max(cd_estabelecimento)
into STRICT	cd_estab_setor_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p;

begin
	select	distinct
			a.NR_SEQ_PEND_AGENDA
	into STRICT	nr_seq_pend_agenda_w
	from	PACIENTE_ATENDIMENTO a,
			PACIENTE_SETOR B
	where	a.NR_SEQ_PACIENTE = B.NR_SEQ_PACIENTE
	and		B.NR_SEQ_PACIENTE = nr_seq_paciente_p;
exception
		when others then
		select	max(a.NR_SEQ_PEND_AGENDA)
		into STRICT	nr_seq_pend_agenda_w
		from	PACIENTE_ATENDIMENTO a,
				PACIENTE_SETOR B
		where	a.NR_SEQ_PACIENTE = B.NR_SEQ_PACIENTE
		and		B.NR_SEQ_PACIENTE = nr_seq_paciente_p
		and 	A.NR_SEQ_ATENDIMENTO = NR_SEQ_ATENDIMENTO_P;
		end;

if (cd_estabelecimento_w <> cd_estab_setor_w) and (coalesce(cd_estab_setor_w::text, '') = '')then
	cd_estabelecimento_ww := cd_estabelecimento_w;
elsif (cd_estab_setor_w IS NOT NULL AND cd_estab_setor_w::text <> '') then
	cd_estabelecimento_ww := cd_estab_setor_w;
end if;

if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') and (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
	if (ie_todos_dias_p = 'S') then
		update 	paciente_setor
		set		cd_setor_atendimento = cd_setor_atendimento_p,
				cd_estabelecimento = coalesce(cd_estabelecimento_ww, wheb_usuario_pck.get_cd_estabelecimento)
		where 	nr_seq_paciente = nr_seq_paciente_p;

		update	paciente_atendimento b
		set		cd_setor_atendimento = cd_setor_atendimento_p,
				cd_estabelecimento = coalesce(cd_estabelecimento_ww, wheb_usuario_pck.get_cd_estabelecimento)
		where 	nr_seq_paciente = nr_seq_paciente_p
		and 	Qt_Obter_Se_Dia_Agendado(b.nr_seq_atendimento, coalesce(b.dt_real, b.dt_prevista)) = 'N'
		and 	coalesce(nr_prescricao::text, '') = '';

		update autorizacao_convenio
		set 	cd_setor_origem 	= cd_setor_atendimento_p,
			cd_estabelecimento 	= coalesce(cd_estabelecimento_ww, wheb_usuario_pck.get_cd_estabelecimento),
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_paciente_setor   = nr_seq_paciente_p;

		select	OBTER_NOME_ESTABELECIMENTO(coalesce(cd_estabelecimento_ww, wheb_usuario_pck.get_cd_estabelecimento))
		into STRICT	ds_estabelecimento_w
		;

		if (ds_estabelecimento_w IS NOT NULL AND ds_estabelecimento_w::text <> '') then
			begin
			update	w_pendencia_agequi
			set		ds_estabelecimento = ds_estabelecimento_w
			where	nr_seq_paciente = nr_seq_paciente_p;

			update	qt_pendencia_agenda
			set		cd_estabelecimento = coalesce(cd_estabelecimento_ww, wheb_usuario_pck.get_cd_estabelecimento)
			where 	nr_sequencia = nr_seq_pend_agenda_w;

			exception
			when others then
				null;
			end;
		end if;
	else
		update	paciente_atendimento
		set		cd_setor_atendimento = cd_setor_atendimento_p,
				cd_estabelecimento = coalesce(cd_estabelecimento_ww, wheb_usuario_pck.get_cd_estabelecimento)
		where 	nr_seq_atendimento   = nr_seq_atendimento_p;


		update autorizacao_convenio
		set 	cd_setor_origem 	= cd_setor_atendimento_p,
			cd_estabelecimento 	= coalesce(cd_estabelecimento_ww, wheb_usuario_pck.get_cd_estabelecimento),
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_paciente   	= nr_seq_atendimento_p;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_alterar_setor_realizar (nr_seq_paciente_p bigint, nr_seq_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_todos_dias_p text, nm_usuario_p text) FROM PUBLIC;
