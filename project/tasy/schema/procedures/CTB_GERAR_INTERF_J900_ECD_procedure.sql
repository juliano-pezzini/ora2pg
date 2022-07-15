-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_interf_j900_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


			

ds_natureza_w			varchar(80);
nr_livro_w			varchar(6);
dt_inicio_w			timestamp;
dt_final_w			timestamp;
ds_razao_social_w			pessoa_juridica.ds_razao_social%type;
ds_arquivo_w			varchar(4000);
ds_compl_arquivo_w		varchar(4000);
ds_linha_w			varchar(8000);
nr_linha_w			bigint := qt_linha_p;
nr_seq_registro_w			bigint := nr_sequencia_p;
sep_w				varchar(1) := '|';
tp_registro_w			varchar(15) := 'J900';

c01 CURSOR FOR
SELECT	substr(obter_nome_pf_pj(null,a.cd_cgc),1,255) ds_razao_social
from	estabelecimento a
where   cd_estabelecimento = cd_estabelecimento_p;


BEGIN

select	lpad(nr_livro,6,0),
	ds_natureza_livro
into STRICT	nr_livro_w,
	ds_natureza_w
from	ctb_sped_controle
where	nr_sequencia = nr_seq_controle_p;

dt_inicio_w	:= trunc(dt_inicio_p);
dt_final_w	:= trunc(dt_fim_p);

open C01;
loop
fetch C01 into	
	ds_razao_social_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	
	ds_linha_w	:= substr(		sep_w || tp_registro_w	 		||
					sep_w || 'TERMO DE ENCERRAMENTO' 	|| 
					sep_w || nr_livro_w 				|| 
					sep_w || ds_natureza_w 			|| 
					sep_w || ds_razao_social_w 		 	|| 
					sep_w || '#QT_LINHAS' 			|| 
					sep_w || to_char(dt_inicio_w,'ddmmyyyy') 	|| 
					sep_w || to_char(dt_final_w,'ddmmyyyy') 		|| sep_w,1,8000);
	
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;	
	
	insert into ctb_sped_registro(
			nr_sequencia,
			ds_arquivo,                     
			dt_atualizacao,                 
			nm_usuario,                     
			dt_atualizacao_nrec,            
			nm_usuario_nrec,                
			nr_seq_controle_sped,           
			ds_arquivo_compl,               
			cd_registro,
			nr_linha)
		values (
			nr_seq_registro_w,
			ds_arquivo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_controle_p,
			ds_compl_arquivo_w,
			tp_registro_w,
			nr_linha_w);

	end;
end loop;
close C01;

commit;
qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_interf_j900_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

