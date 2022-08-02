-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_inserir_pf_curso (nr_seq_agenda_p bigint, nr_seq_pac_reab_p text, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

 
qt_vagas_w		bigint;
qt_candidatos_w		bigint;	
nr_seq_agenda_w		bigint;	
nr_seq_curso_w		bigint;
nm_paciente_w		varchar(255);
ds_enter_w		varchar(20)	:= chr(10)||chr(13);
ie_gestao_pacientes_w	varchar(1);
			

BEGIN 
 
ie_gestao_pacientes_w := obter_param_usuario(7041, 39, Obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p, ie_gestao_pacientes_w);
 
ds_erro_p := 	'';
 
select	max(coalesce(qt_max_pessoas,0)), 
	max(nr_seq_curso) 
into STRICT	qt_vagas_w, 
	nr_seq_curso_w 
from	tre_agenda 
where	nr_sequencia = nr_seq_agenda_p;
 
 
select	count(*) 
into STRICT	qt_candidatos_w 
from	tre_candidato 
where	coalesce(ie_cancelamento,'N') = 'N' 
and	nr_seq_agenda = nr_seq_agenda_p;
 
select	substr(obter_nome_pf(cd_pessoa_fisica_p),1,255) 
into STRICT	nm_paciente_w
;
 
if (qt_candidatos_w >= qt_vagas_w) then 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262014); -- Não é possível inserir o paciente para esta agenda. O Limite de vagas será excedido! 
elsif (coalesce(nr_seq_pac_reab_p::text, '') = '') and (ie_gestao_pacientes_w = 'S') then
	ds_erro_p	:= ds_erro_p||nm_paciente_w || ds_enter_w;
else 
	begin 
 
	insert into tre_candidato( nr_sequencia, 
				  dt_atualizacao,     
				  nm_usuario,       
				  dt_atualizacao_nrec,   
				  nm_usuario_nrec,     
				  cd_pessoa_fisica,    
			 	  nr_seq_agenda,      
				  ie_cancelamento,     
				  nr_pac_reabilitacao) 
			values ( nextval('tre_candidato_seq'), 
				  clock_timestamp(), 
				  nm_usuario_p, 
				  clock_timestamp(), 
				  nm_usuario_p, 
				  cd_pessoa_fisica_p, 
				  nr_seq_agenda_p, 
				  'N', 
				  nr_seq_pac_reab_p);
				  
	update	tre_pf_lista_espera 
	set	ie_status = 'T' 
	where	nr_seq_curso 		= nr_seq_curso_w 
	and	cd_pessoa_fisica 	= cd_pessoa_fisica_p;
	 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_inserir_pf_curso (nr_seq_agenda_p bigint, nr_seq_pac_reab_p text, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

