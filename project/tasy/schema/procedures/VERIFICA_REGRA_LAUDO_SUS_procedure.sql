-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_regra_laudo_sus ( cd_pessoa_fisica_p text, cd_agenda_p bigint, ds_mensagem_p INOUT text) AS $body$
DECLARE

 
nr_regra_agenda_w	bigint;
ds_mensagem_w	varchar(300);
nr_apac_w	bigint	:= 0;
nr_seq_interno_w	bigint;
			

BEGIN 
ds_mensagem_w := null;
-- verifica se existe regra para a agenda 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_regra_agenda_w 
from 	agenda_regra_laudo_sus 
where	cd_agenda = cd_agenda_p;
 
 
--se existir regra verifica se a pessoa possuir laudo, e esse laudo não possua nr_apac e possua tipo_laudo_apac 
if (nr_regra_agenda_w > 0) then 
 
	 
	select	coalesce(max(nr_seq_interno),0) 
	into STRICT	nr_seq_interno_w 
	from	sus_laudo_paciente 
	where	obter_pessoa_atendimento(nr_Atendimento, 'C') = cd_pessoa_fisica_p 
	and 	not coalesce(ie_tipo_laudo_apac::text, '') = '';
	 
	if (nr_seq_interno_w > 0) then 
		 
		select	coalesce(max(nr_apac),0) 
		into STRICT	nr_apac_w 
		from	sus_laudo_paciente 
		where	nr_seq_interno	= nr_seq_interno_w;	
	 
	end if;
	 
	if (nr_apac_w = 0) and (nr_seq_interno_w <> 0) then 
		 
		ds_mensagem_w := null;
	else 
		ds_mensagem_w := wheb_mensagem_pck.get_texto(796895);
	 
	end if;
end if;
 
ds_mensagem_p := ds_mensagem_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_regra_laudo_sus ( cd_pessoa_fisica_p text, cd_agenda_p bigint, ds_mensagem_p INOUT text) FROM PUBLIC;
