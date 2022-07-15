-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_data_proc_agrup_ipe ( nr_seq_procedimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w		bigint;
dt_procedimento_w		timestamp;
dt_procedimento_ww	timestamp;
nr_sequencia_w		bigint;
nr_atendimento_w		bigint;
nr_interno_conta_w		bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;


C01 CURSOR FOR
SELECT	nr_sequencia
from	procedimento_paciente
where	cd_procedimento	= cd_procedimento_w
and	ie_origem_proced	= ie_origem_proced_w
and	nr_atendimento	= nr_atendimento_w
and	nr_interno_conta	= nr_interno_conta_w
and	nr_sequencia	<> nr_seq_procedimento_p
and	dt_procedimento	= dt_procedimento_w;


BEGIN

select	nr_atendimento,
	nr_interno_conta,
	cd_procedimento,
	ie_origem_proced,
	dt_procedimento
into STRICT	nr_atendimento_w,
	nr_interno_conta_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	dt_procedimento_w
from	procedimento_paciente
where	nr_sequencia = nr_seq_procedimento_p;

select	count(*)
into STRICT	qt_existe_w
from	procedimento_paciente
where	cd_procedimento	= cd_procedimento_w
and	ie_origem_proced	= ie_origem_proced_w
and	nr_atendimento	= nr_atendimento_w
and	nr_interno_conta	= nr_interno_conta_w
and	dt_procedimento	= dt_procedimento_w
and	nr_sequencia 	<> nr_seq_procedimento_p;

dt_procedimento_ww := dt_procedimento_w;

if (qt_existe_w > 0) then
	begin
	open C01;
	loop
	fetch C01 into
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		dt_procedimento_ww := dt_procedimento_ww + 1/86400; --Adiciona um segundo à data do procedimento
		update	procedimento_paciente
		set	dt_procedimento 	= dt_procedimento_ww,
			dt_conta		= dt_procedimento_ww,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_sequencia_w;
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
-- REVOKE ALL ON PROCEDURE alterar_data_proc_agrup_ipe ( nr_seq_procedimento_p bigint, nm_usuario_p text) FROM PUBLIC;

