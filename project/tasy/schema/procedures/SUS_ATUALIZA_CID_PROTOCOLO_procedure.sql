-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualiza_cid_protocolo ( nr_seq_protocolo_p bigint , ie_subscreve_cid_p text ) AS $body$
DECLARE

					 
nr_atendimento_w		bigint;
cd_medico_executor_w	varchar(10);
cd_cid_w			varchar(4);
nr_sequencia_w		bigint;

c01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_atendimento, 
		a.cd_medico_executor 
	from	procedimento_paciente a, 
		conta_paciente b 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	b.nr_seq_protocolo	= nr_seq_protocolo_p 
	and	(((coalesce(cd_doenca_cid::text, '') = '') and (ie_subscreve_cid_p = 'N')) or (ie_subscreve_cid_p = 'S'));


BEGIN 
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w, 
	nr_atendimento_w, 
	cd_medico_executor_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	cd_cid_w := sus_atualiza_cid_proc(nr_atendimento_w, cd_medico_executor_w, cd_cid_w);
	 
	update	procedimento_paciente 
	set	cd_doenca_cid 	= cd_cid_w 
	where	nr_sequencia	= nr_sequencia_w;
	 
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualiza_cid_protocolo ( nr_seq_protocolo_p bigint , ie_subscreve_cid_p text ) FROM PUBLIC;

