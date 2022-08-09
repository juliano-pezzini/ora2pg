-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_triagem_paciente ( nr_seq_triagem_p bigint, nm_usuario_p text, ds_justificativa_p text default null) AS $body$
DECLARE

			 
nr_atendimento_w	bigint;			
cd_pessoa_fisica_w	varchar(10);
ie_cancelar_atendimento_w varchar(1);
cd_estabelecimento_w		integer;


BEGIN 
if (nr_seq_triagem_p	> 0) then 
 
	select	coalesce(max(nr_atendimento),0), 
			max(cd_pessoa_fisica), 
			coalesce(cd_estabelecimento_w,0) 
	into STRICT	nr_atendimento_w, 
			cd_pessoa_fisica_w, 
			cd_estabelecimento_w 
	from	triagem_pronto_atend 
	where	nr_sequencia = nr_seq_triagem_p;
	 
	ie_cancelar_atendimento_w := Obter_Param_Usuario(9037, 27, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_cancelar_atendimento_w);
	 
	if (nr_atendimento_w > 0) and (ie_cancelar_atendimento_w = 'S') then 
		CALL cancelar_atendimento_paciente(nr_atendimento_w,nm_usuario_p,null,obter_dados_usuario_opcao(nm_usuario_p,'C'),'');
	else	 
		update	triagem_pronto_atend 
		set	dt_cancelamento = clock_timestamp(), 
			ie_status_paciente = 'C' 
		where	nr_Sequencia = nr_seq_triagem_p;
	 
	end if;
	 
	if (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '') then 
		update  triagem_pronto_atend  
		set    nm_usuario_cancel = nm_usuario_p, 
			 ds_justificativa_cancel = ds_justificativa_p 
		where   nr_sequencia    = nr_seq_triagem_p;
	end if;
 
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_triagem_paciente ( nr_seq_triagem_p bigint, nm_usuario_p text, ds_justificativa_p text default null) FROM PUBLIC;
