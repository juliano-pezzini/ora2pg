-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pacs_inserir_imagem_laudo ( nr_seq_laudo_p bigint, ds_arquivo_imagem_p text, nm_usuario_p text, ds_uid_p text) AS $body$
DECLARE

/* 
uid_p 	unique key from image_pacs 
*/
										 
 
ie_exist_w	varchar(1);
nr_seq_imagem_w	laudo_paciente_imagem.nr_seq_imagem%type;


BEGIN 
 
select	CASE WHEN count(*)=0 THEN 'n'  ELSE 's' END  
into STRICT 	ie_exist_w 
from 	laudo_paciente_imagem a 
where 	a.nr_sequencia = nr_seq_laudo_p 
and 	a.ds_arquivo_imagem = ds_arquivo_imagem_p;
 
if (ie_exist_w = 'n') then 
 
	select	coalesce(max(a.nr_seq_imagem),0)+1 
	into STRICT 	nr_seq_imagem_w 
	from 	laudo_paciente_imagem a 
	where 	a.nr_sequencia = nr_seq_laudo_p;
 
	insert into laudo_paciente_imagem( 
		nr_sequencia, 
		nr_seq_imagem, 
		ds_arquivo_imagem, 
		nm_usuario, 
		dt_atualizacao, 
		pacs_id) 
	values ( nr_seq_laudo_p, 
		nr_seq_imagem_w, 
		ds_arquivo_imagem_p, 
		nm_usuario_p, 
		clock_timestamp(), 
		ds_uid_p);
 
	commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pacs_inserir_imagem_laudo ( nr_seq_laudo_p bigint, ds_arquivo_imagem_p text, nm_usuario_p text, ds_uid_p text) FROM PUBLIC;
