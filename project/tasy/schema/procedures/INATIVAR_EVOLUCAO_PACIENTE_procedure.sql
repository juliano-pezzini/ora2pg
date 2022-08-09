-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_evolucao_paciente ( cd_evolucao_p bigint, ds_justificativa_p text, nm_usuario_p text) AS $body$
DECLARE

		 
		 
nr_seq_evento_w			bigint;
ie_evolucao_clinica_w		varchar(3);
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
qt_idade_w			bigint;
cd_estabelecimento_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_seq_evento 
	from	regra_envio_sms 
	where	cd_estabelecimento	= cd_estabelecimento_w 
	and	ie_evento_disp = 'IEV' 
	and (coalesce(cd_tipo_evolucao,ie_evolucao_clinica_w)	= ie_evolucao_clinica_w) 
	and	qt_idade_w between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999)	 
	and	coalesce(ie_situacao,'A') = 'A';
		

BEGIN 
 
if (cd_evolucao_p IS NOT NULL AND cd_evolucao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	update	evolucao_paciente 
	set	ie_situacao = 'I', 
		dt_inativacao = clock_timestamp(), 
		nm_usuario_inativacao = nm_usuario_p, 
		ds_justificativa = ds_justificativa_p 
	where cd_evolucao = cd_evolucao_p;
	 
	commit;
	 
	cd_estabelecimento_w		:= wheb_usuario_pck.get_cd_estabelecimento;
	 
	select	max(nr_atendimento), 
		max(cd_pessoa_fisica) 
	into STRICT	nr_atendimento_w, 
		cd_pessoa_fisica_w		 
	from	evolucao_paciente 
	where	cd_evolucao 	= cd_evolucao_p;
	 
	qt_idade_w	:= coalesce(obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A'),0);
	 
	select 	max(ie_evolucao_clinica) 
	into STRICT	ie_evolucao_clinica_w 
	from 	evolucao_paciente 
	where 	cd_evolucao = cd_evolucao_p;	
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_evento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		CALL gerar_evento_paciente(nr_seq_evento_w,nr_atendimento_w,cd_pessoa_fisica_w,null,wheb_usuario_pck.get_nm_usuario,null,null,null,null,null,null,null,null,null,null,'S',null,null,cd_evolucao_p);
		end;
	end loop;
	close C01;
	 
	end;
end if;
 
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_evolucao_paciente ( cd_evolucao_p bigint, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;
