-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_interditar_leito ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_interno_p bigint) AS $body$
DECLARE

nr_seq_evento_w		bigint;
cd_pessoa_fisica_w	varchar(10);
cd_estabelecimento_w	integer;
cd_unidade_w		varchar(255);

 
c01 CURSOR FOR 
	SELECT	nr_seq_evento 
	from	regra_envio_sms 
	where	ie_evento_disp		= 'INTER' 
	and	cd_estabelecimento = cd_estabelecimento_p 
	and	coalesce(ie_situacao,'A') = 'A';

BEGIN
 
select 	Obter_Dados_Usuario_Opcao(nm_usuario_p,'C') 
into STRICT	cd_pessoa_fisica_w
;
 
open c01;
	loop 
	fetch c01 into 
		nr_seq_evento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		CALL gerar_evento_paciente(nr_seq_evento_w,null,cd_pessoa_fisica_w,null,nm_usuario_p,null,null,null,null,null,null,null,null,null,null,'N',nr_seq_interno_p);
		end;
	end loop;
	close c01;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_interditar_leito ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_interno_p bigint) FROM PUBLIC;

