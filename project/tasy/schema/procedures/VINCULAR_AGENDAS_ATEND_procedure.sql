-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_agendas_atend (ds_lista_agenda_p text, nr_atendimento_p bigint, cd_pessoa_atendimento_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

		 
ds_lista_agenda_w	varchar(255);	
tam_lista_w		varchar(255);	
ie_pos_virgula_w	varchar(255);
nr_sequencia_w		bigint;
nr_seq_agenda_w		varchar(255);
nr_seq_agenda_lis_w	varchar(255);

 

BEGIN 
 
ds_lista_agenda_w := substr(ds_lista_agenda_p,1,255);
 
while(ds_lista_agenda_w IS NOT NULL AND ds_lista_agenda_w::text <> '') and (trim(both ds_lista_agenda_w) <> ',') loop 
	tam_lista_w		:= length(ds_lista_agenda_w);
	ie_pos_virgula_w	:= position(',' in ds_lista_agenda_w);
	if (ie_pos_virgula_w <> 0) then 
		nr_seq_agenda_w		:= substr(ds_lista_agenda_w,1,(ie_pos_virgula_w - 1));
		ds_lista_agenda_w	:= trim(both substr(ds_lista_agenda_w,(ie_pos_virgula_w + 1), tam_lista_w));
		CALL vinc_atendimento_agenda_EUP(nr_seq_agenda_w,nr_atendimento_p,cd_pessoa_atendimento_p,nm_usuario_p,cd_estabelecimento_p);
	end if;
end loop;
 
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_agendas_atend (ds_lista_agenda_p text, nr_atendimento_p bigint, cd_pessoa_atendimento_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

