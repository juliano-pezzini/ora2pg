-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_eis_acerto_conta (dt_referencia_p timestamp) AS $body$
DECLARE

 
nr_interno_conta_w	bigint;
nr_seq_protocolo_w	bigint;
ie_status_protocolo_w	smallint;

c01 CURSOR FOR 
	SELECT	nr_interno_conta 
	from	eis_conta_paciente 
	where	trunc(dt_referencia, 'month') = dt_referencia_p 
	group by nr_interno_conta;


BEGIN 
 
open	c01;
loop 
fetch	c01 into nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	select	coalesce(max(nr_seq_protocolo),0) 
	into STRICT	nr_seq_protocolo_w 
	from	conta_paciente 
	where	nr_interno_conta	= nr_interno_conta_w;
	 
 
	select	coalesce(max(ie_status_protocolo),0) 
	into STRICT	ie_status_protocolo_w 
	from	protocolo_convenio 
	where	nr_seq_protocolo	= nr_seq_protocolo_w;
 
 
	if (ie_status_protocolo_w <> 0) then 
		update	eis_conta_paciente 
		set	ie_status_protocolo	=ie_status_protocolo_w 
		where	nr_interno_conta	= nr_interno_conta_w;
	end if;
 
 
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_eis_acerto_conta (dt_referencia_p timestamp) FROM PUBLIC;
