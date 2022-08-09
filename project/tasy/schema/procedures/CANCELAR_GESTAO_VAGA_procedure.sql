-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_gestao_vaga ( nr_seq_agenda_p bigint, cd_motivo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_gestao_w		bigint;
nr_seq_motivo_gv_w	bigint;
cd_pessoa_fisica_w	varchar(10);
nm_paciente_reserva_GV_w	varchar(255);
qt_existe_leito_w		bigint;
cd_unidade_basica_w	varchar(10);
cd_unidade_compl_w	varchar(10);
cd_setor_desejado_w	integer;
nr_atendimento_w		bigint;



C01 CURSOR FOR
		SELECT	nr_sequencia
		from	gestao_vaga a
		where	a.nr_seq_agenda = nr_seq_agenda_p;

BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	begin
	/* Obter se a agenda possui registro na gestao de vagas */

	open C01;
	loop
	fetch C01 into
		nr_seq_gestao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (nr_seq_gestao_w > 0) then
			begin
			select	CASE WHEN coalesce(max(nr_seq_motivo_gv),0)=0 THEN  null  ELSE coalesce(max(nr_seq_motivo_gv),0) END
			into STRICT	nr_seq_motivo_gv_w
			from	agenda_motivo_cancelamento
			where	cd_motivo = cd_motivo_p
			and		cd_estabelecimento = cd_estabelecimento_p
			and		ie_agenda in ('CI','T');

			select	cd_pessoa_fisica,
					cd_unidade_basica,
					cd_unidade_compl,
					cd_setor_desejado,
					coalesce(nr_atendimento,0),
					nm_paciente
			into STRICT	cd_pessoa_fisica_w,
					cd_unidade_basica_w,
					cd_unidade_compl_w,
					cd_setor_desejado_w,
					nr_atendimento_w,
					nm_paciente_reserva_GV_w
			from	gestao_vaga
			where	nr_sequencia = nr_seq_gestao_w;

			select	count(*)
			into STRICT	qt_existe_leito_w
			from	unidade_atendimento
			where (cd_paciente_reserva	= cd_pessoa_fisica_w or nr_atendimento = nr_atendimento_w or nm_pac_reserva = nm_paciente_reserva_GV_w)
			and		cd_unidade_basica		= cd_unidade_basica_w
			and		cd_unidade_compl		= cd_unidade_compl_w
			and		cd_setor_atendimento	= cd_setor_desejado_w;

			if (qt_existe_leito_w > 0) then

				update	unidade_atendimento
				set		ie_status_unidade	= CASE WHEN ie_status_unidade='R' THEN  'L'  ELSE ie_status_unidade END ,
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						cd_paciente_reserva	 = NULL,
						nm_usuario_reserva	 = NULL,
						nm_pac_reserva		 = NULL
				where	cd_unidade_basica		= cd_unidade_basica_w
				and		cd_unidade_compl		= cd_unidade_compl_w
				and		cd_setor_atendimento	= cd_setor_desejado_w;

			end if;

			update	gestao_vaga
			set		ie_status			= 'C',
					nr_seq_motivo_cancel	= nr_seq_motivo_gv_w
			where	nr_sequencia		= nr_seq_gestao_w;
			end;
		end if;
		end;
	end loop;
	close C01;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_gestao_vaga ( nr_seq_agenda_p bigint, cd_motivo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
