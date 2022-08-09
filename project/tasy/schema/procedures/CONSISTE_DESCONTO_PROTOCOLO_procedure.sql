-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_desconto_protocolo (nr_seq_protocolo_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

 
 
ds_erro_w		varchar(2000):= '';
qt_desconto_w		bigint;
qt_sem_estrutura_w	bigint;
nr_interno_conta_w	bigint;
ie_corpo_msg_w		varchar(1):= 'N';

c01 CURSOR FOR 
	SELECT	nr_interno_conta 
	from	conta_paciente 
	where	nr_seq_protocolo	= nr_seq_protocolo_p;


BEGIN 
 
select	count(*) 
into STRICT	qt_desconto_w 
from	conta_paciente_desconto b, 
	conta_paciente a 
where	a.nr_interno_conta	= b.nr_interno_conta 
and	a.nr_seq_protocolo	= nr_seq_protocolo_p;
 
if (qt_desconto_w > 0) then 
	ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(281534) || chr(13) || chr(10);
end if;
 
 
 
open	c01;
loop 
fetch	c01 into 
	nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	select 	count(*) 
	into STRICT 	qt_sem_estrutura_w 
	from 	conta_paciente_v 
	where 	nr_interno_conta	= nr_interno_conta_w 
	and	coalesce(cd_motivo_exc_conta::text, '') = '' 
	and 	somente_numero(coalesce(ie_emite_conta_honor, ie_emite_conta)) = 0;
 
	if (qt_sem_estrutura_w > 0) then 
		if (ie_corpo_msg_w = 'N') then 
			ds_erro_w := ds_erro_w || WHEB_MENSAGEM_PCK.get_texto(281535) || chr(13) || chr(10);
			ie_corpo_msg_w:= 'S';
		end if;
		ds_erro_w := ds_erro_w || nr_interno_conta_w || ', ';
	end if;
 
	end;
end loop;	
close c01;
 
ds_erro_p	:= substr(ds_erro_w,1,255);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_desconto_protocolo (nr_seq_protocolo_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
