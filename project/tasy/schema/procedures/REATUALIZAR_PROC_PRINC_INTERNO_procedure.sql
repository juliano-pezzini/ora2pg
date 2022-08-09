-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (nr_interno_conta bigint);


CREATE OR REPLACE PROCEDURE reatualizar_proc_princ_interno ( nr_seq_protocolo_p bigint, nr_atendimento_p bigint, dt_parametro_P timestamp, nm_usuario_p text) AS $body$
DECLARE

type Vetor is table of campos index by integer;

dt_parametro_inicio_w       	timestamp;
dt_parametro_fim_w        	timestamp;
nr_interno_conta_w			bigint;
i					integer;
k					integer;
Vetor_Conta_w				Vetor;

nr_atendimento_w			bigint;
ie_tipo_atendimento_w		bigint;
cd_procedimento_w			bigint;
ie_origem_proced_w			bigint;

C01 CURSOR FOR 
	SELECT distinct a.nr_interno_conta 
	from 	Conta_paciente a 
	where	dt_mesano_referencia between dt_parametro_inicio_w and dt_parametro_fim_w 
	and	nr_seq_protocolo_p	= 0 
	and	coalesce(nr_atendimento_p::text, '') = '' 
	
union
 
	SELECT distinct a.nr_interno_conta 
	from 	Conta_paciente a 
	where	nr_seq_protocolo	= nr_seq_protocolo_p 
	
union
 
	select distinct a.nr_interno_conta 
	from 	Conta_paciente a 
	where	nr_atendimento	= nr_atendimento_p 
	and	(nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '');


BEGIN 
 
dt_parametro_fim_w         := last_day(Trunc(dt_parametro_p,'dd')) + 86399/86400;
dt_parametro_Inicio_w		 := trunc(dt_parametro_p,'month');
	 
i	:= 1;
OPEN C01;
LOOP 
FETCH C01 into	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	Vetor_conta_w[i].nr_interno_conta := nr_interno_conta_w;
	i := i + 1;
END LOOP;
close c01;
 
i := Vetor_Conta_w.count;
FOR k in 1.. i LOOP 
	begin 
	nr_interno_conta_w	:= Vetor_Conta_w[k].nr_interno_conta;
	select	a.nr_atendimento, 
		b.ie_tipo_atendimento 
	into STRICT	nr_atendimento_w, 
		ie_tipo_atendimento_w 
	from	atendimento_paciente b, 
		conta_paciente a 
	where	nr_interno_conta	= nr_interno_conta_w 
	and	a.nr_atendimento	= b.nr_atendimento;
	SELECT * FROM obter_proc_princ_interno(nr_atendimento_w, ie_tipo_atendimento_w, cd_procedimento_w, ie_origem_proced_w, 0) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	if (coalesce(cd_procedimento_w,0) > 0) then 
		update	eis_conta_paciente 
		set	cd_procedimento	= cd_procedimento_w, 
			ie_origem_proced	= ie_origem_proced_w 
		where	nr_interno_conta	= nr_interno_conta_w;
	end if;
	/*if	(trunc(k /500) = (k / 500)) then 
		insert into logxxxxx_tasy values(sysdate, 'Tasy', 1002, 'Contas Atualizadas Reg: ' || k || '/' || i); 
	end if; 
	commit;*/
 
	end;
END LOOP;
--insert into logxxxxx_tasy values(sysdate, 'Tasy', 1002, 'Final da atualização de ' || i || ' Contas'); 
Commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reatualizar_proc_princ_interno ( nr_seq_protocolo_p bigint, nr_atendimento_p bigint, dt_parametro_P timestamp, nm_usuario_p text) FROM PUBLIC;
