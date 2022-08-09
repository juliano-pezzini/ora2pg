-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_atualiza_nraih_laudo ( nr_seq_protocolo_p bigint) AS $body$
DECLARE

 
nr_atendimento_w		bigint;
nr_aih_w			bigint;
nr_sequencia_w			bigint;
nr_interno_conta_w		bigint;
nr_aih_correta_w		bigint;

c01 CURSOR FOR 
SELECT	a.nr_atendimento, 
	b.nr_aih, 
	b.nr_sequencia 
from	conta_paciente		c, 
  	sus_aih     		b, 
  	sus_laudo_paciente		a 
where	a.nr_atendimento   = b.nr_atendimento 
and	a.nr_aih    	<> b.nr_aih 
and	b.nr_interno_conta	= c.nr_interno_conta 
and 	c.nr_seq_protocolo	= nr_seq_protocolo_p 
and	not exists (SELECT 1 from sus_laudo_paciente x where x.nr_aih = b.nr_aih and x.ie_tipo_laudo_sus = 0) 
group by 	a.nr_atendimento, 
	b.nr_aih, 
	b.nr_sequencia;


BEGIN 
open c01;
	loop 
	fetch c01 into 
		nr_atendimento_w, 
		nr_aih_w, 
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
 
		select	nr_interno_conta 
		into STRICT	nr_interno_conta_w 
		from	sus_aih 
		where	nr_aih		= nr_aih_w 
		and	nr_sequencia	= nr_Sequencia_w;
 
		if (nr_aih_w	> 0) then 
			update	sus_laudo_paciente 
			set	nr_aih			= nr_aih_w, 
				nr_seq_aih		= nr_sequencia_w, 
				nr_interno_conta	= nr_interno_conta_w 
			where	nr_atendimento		= nr_atendimento_w 
			and	not exists (SELECT 1 from sus_laudo_paciente where nr_atendimento = nr_atendimento_w and nr_aih = nr_aih_w);						
			commit;
		end if;
		end;
	end loop;
	close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_atualiza_nraih_laudo ( nr_seq_protocolo_p bigint) FROM PUBLIC;
