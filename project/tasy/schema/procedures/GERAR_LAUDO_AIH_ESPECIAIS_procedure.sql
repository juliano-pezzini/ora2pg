-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_laudo_aih_especiais ( nr_interno_conta_p bigint) AS $body$
DECLARE

 
 
cd_procedimento_w	bigint;
nr_atendimento_w	bigint;
nr_sequencia_w		bigint;
qt_proced_laudo_w	bigint;
qt_procedimento_w	bigint;

c01 CURSOR FOR 
	SELECT	cd_procedimento, 
		nr_atendimento, 
		nr_sequencia 
	from	procedimento_paciente 
	where	nr_interno_conta	= nr_interno_conta_p;


BEGIN 
 
open c01;
LOOP 
FETCH c01 into 
	cd_procedimento_w, 
	nr_atendimento_w, 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	begin 
	select	sum(qt_procedimento_solic) 
	into STRICT	qt_proced_laudo_w 
	from	sus_laudo_paciente 
	where	nr_atendimento		= nr_atendimento_w 
	and	cd_procedimento_solic	= cd_procedimento_w 
	and	nr_interno_conta	= nr_interno_conta_p;
	exception 
		when others then 
			qt_proced_laudo_w	:= 0;
	end;
 
	if (qt_proced_laudo_w	= 0) then 
		CALL Gerar_Laudo_Sus_Aih(nr_sequencia_w);
	else 
		begin 
		select	sum(qt_procedimento) 
		into STRICT	qt_procedimento_w 
		from	Procedimento_paciente 
		where	nr_atendimento		= nr_atendimento_w 
		and	nr_interno_conta	= nr_interno_conta_p 
		and	coalesce(cd_motivo_exc_conta::text, '') = '' 
		and	cd_procedimento 	= cd_procedimento_w;
		exception 
			when others then 
				qt_procedimento_w	:= 0;
		end;
		 
		if (qt_proced_laudo_w	< qt_procedimento_w) then 
			update	sus_laudo_paciente 
			set	qt_procedimento_solic	= qt_procedimento_w 
			where	nr_atendimento		= nr_atendimento_w 
			and	nr_interno_conta	= nr_interno_conta_p 
			and	cd_procedimento_solic 	= cd_procedimento_w;	
		end if;
	end if;
	end;
END LOOP;
CLOSE C01;
	 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_laudo_aih_especiais ( nr_interno_conta_p bigint) FROM PUBLIC;
