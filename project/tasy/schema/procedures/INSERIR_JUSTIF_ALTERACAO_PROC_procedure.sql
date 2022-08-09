-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_justif_alteracao_proc ( nr_seq_procedimento_p bigint, nr_seq_justificativa_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_proc_w		bigint;


BEGIN

if (coalesce(nr_seq_procedimento_p,0) > 0) then

	select	max(cd_procedimento),
		max(ie_origem_proced)
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w
	from	procedimento_paciente
	where	nr_sequencia = nr_seq_procedimento_p;

	select	count(*)
	into STRICT	qt_proc_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p;

	if (coalesce(qt_proc_w,0) > 0) then

		begin
		insert into propaci_alteracao_proc(
			nr_sequencia,
			nr_seq_propaci,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_justificativa,
			cd_procedimento,
			ie_origem_proced,
			cd_procedimento_ant,
			ie_origem_proc_ant
		) values (
			nextval('propaci_alteracao_proc_seq'),
			nr_seq_procedimento_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_justificativa_p,
			cd_procedimento_p,
			ie_origem_proced_p,
			cd_procedimento_w,
			ie_origem_proced_w
		);
		exception
			when others then
				cd_procedimento_w	:= 0;
				ie_origem_proced_w	:= 0;
		end;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_justif_alteracao_proc ( nr_seq_procedimento_p bigint, nr_seq_justificativa_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) FROM PUBLIC;
