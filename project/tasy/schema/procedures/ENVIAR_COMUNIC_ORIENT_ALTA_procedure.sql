-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_comunic_orient_alta ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_evento_w			bigint;
dt_alta_w			timestamp;
qt_idade_w			bigint;	
cd_pessoa_fisica_w		varchar(10);

C01 CURSOR FOR 
	SELECT	nr_seq_evento 
	from	regra_envio_sms 
	where	cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_evento_disp		= 'AHPOA' 
	and	coalesce(dt_alta_w::text, '') = '' 
	and	qt_idade_w between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999);


BEGIN 
 
select	max(cd_pessoa_fisica), 
		max(dt_alta) 
into STRICT	cd_pessoa_fisica_w, 
		dt_alta_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
qt_idade_w	:= coalesce(obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A'),0);
 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_evento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin		 
		CALL gerar_evento_paciente(nr_seq_evento_w,nr_atendimento_p,cd_pessoa_fisica_w,null,nm_usuario_p,null);
		end;
	end loop;
	close C01;
 
commit;
	 
end if;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_comunic_orient_alta ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

