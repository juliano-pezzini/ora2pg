-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_interf_j990_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE



ds_arquivo_w			varchar(4000);
ds_compl_arquivo_w		varchar(4000);
ds_linha_w			varchar(8000);
nr_linha_w			bigint := qt_linha_p;
nr_seq_registro_w			bigint := nr_sequencia_p;
qt_linhas_w			bigint;
sep_w				varchar(1) := '|';
tp_registro_w			varchar(15) := 'J990';


BEGIN

select (select count(*) + 1
	from	ctb_sped_registro
	where	nr_seq_controle_sped	= nr_seq_controle_p
	and	substr(cd_registro,1,1)	= 'J') qt_linhas
into STRICT	qt_linhas_w
;

ds_linha_w	:= substr(		sep_w || tp_registro_w 		||
				sep_w || qt_linhas_w 		|| sep_w,1,8000);

ds_arquivo_w		:= substr(ds_linha_w,1,4000);
ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
nr_seq_registro_w		:= nr_seq_registro_w + 1;
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
	values (	nr_seq_registro_w,
		ds_arquivo_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		ds_compl_arquivo_w,
		tp_registro_w,
		nr_linha_w);
commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_interf_j990_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

