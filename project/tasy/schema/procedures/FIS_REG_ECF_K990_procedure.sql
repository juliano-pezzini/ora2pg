-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_reg_ecf_k990 ( nr_seq_controle_p text, ds_separador_p text, cd_estabelecimento_p text, nm_usuario_p text, cd_empresa_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


nr_seq_registro_w		bigint := nr_sequencia_p;	
nr_linha_w			bigint := qt_linha_p;
ds_arquivo_w			varchar(4000);	
ds_arquivo_compl_w		varchar(4000);	
ds_linha_w			varchar(4000);
sep_w				varchar(2) := ds_separador_p;
qt_linhas_w			bigint;

BEGIN

select (select count(*) + 1
	from	fis_ecf_arquivo
	where	nm_usuario 		= nm_usuario_p
	and	nr_seq_controle_ecf 	= nr_seq_controle_p
	and	substr(cd_registro,1,1)	= 'K') qt_linhas
into STRICT	qt_linhas_w	
;

ds_linha_w	:= substr(sep_w || 'K990' || sep_w || qt_linhas_w || sep_w,1,8000);

ds_arquivo_w		:= substr(ds_linha_w,1,4000);
ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
nr_seq_registro_w	:= nr_seq_registro_w + 1;
nr_linha_w		:= nr_linha_w + 1;

insert into fis_ecf_arquivo(
	nr_sequencia,
	nm_usuario,
	dt_atualizacao,
	nm_usuario_nrec,
	dt_atualizacao_nrec,
	nr_seq_controle_ecf,
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
	'K990',
	ds_arquivo_w,
	ds_arquivo_compl_w);
commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_reg_ecf_k990 ( nr_seq_controle_p text, ds_separador_p text, cd_estabelecimento_p text, nm_usuario_p text, cd_empresa_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

