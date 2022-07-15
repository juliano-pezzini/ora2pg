-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_c010_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
tp_registro_w			varchar(4);
nr_linha_w			bigint := qt_linha_p;
nr_seq_registro_w			bigint := nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= ds_separador_p;

c01 CURSOR FOR 
SELECT	'C010' tp_registro, 
	a.cd_cgc, 
	'2' ie_indicador_escricao, 
	a.cd_estabelecimento 
from	estabelecimento a, 
	pessoa_juridica	d 
where	a.cd_cgc	= d.cd_cgc 
and 	a.cd_estabelecimento = cd_estabelecimento_p 
and	d.ie_situacao	= 'A'  LIMIT 1;

vet01	C01%RowType;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	 
	ds_linha_w	:= substr(	sep_w || vet01.tp_registro	|| 
				sep_w	|| vet01.cd_cgc			|| 
				sep_w	|| vet01.ie_indicador_escricao	|| sep_w ,1,8000);
	 
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w		:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;
 
	insert into fis_efd_arquivo( 
		nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		nr_seq_controle_efd, 
		nr_linha, 
		cd_registro, 
		ds_arquivo, 
		ds_arquivo_compl) 
	values (	nr_seq_registro_w, 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nr_seq_controle_p, 
		nr_linha_w, 
		vet01.tp_registro, 
		ds_arquivo_w, 
		ds_arquivo_compl_w);
	end;
	 
	SELECT * FROM fis_reg_C100_efd_piscofins(	nr_seq_controle_p, nm_usuario_p, vet01.cd_estabelecimento, dt_inicio_p, dt_fim_p, cd_empresa_p, ds_separador_p, nr_linha_w, nr_seq_registro_w) INTO STRICT nr_linha_w, nr_seq_registro_w;
	 
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
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_c010_efd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

