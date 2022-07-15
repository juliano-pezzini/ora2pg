-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lfpd_registro_b460 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


contador_w		bigint := 0;
ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
ds_linha_w		varchar(8000);
nr_linha_w		bigint	:= qt_linha_p;
nr_seq_registro_w	bigint	:= nr_sequencia_p;
sep_w			varchar(1)	:= ds_separador_p;

c01 CURSOR FOR
	SELECT	'B460' cd_registro,
		a.ie_tipo_deducao ie_tipo_deducao,
		replace(campo_mascara(a.vl_deducao,2),'.',',') vl_deducao,
		a.nr_processo nr_processo,
		a.ie_origem tipo_origem_processo,
		a.ds_processo ds_processo,
		'' cd_observacao,
		a.nr_sequencia nr_sequencia
	from	lfpd_regra_reg_b460 a,
		fis_lfpd_controle b,
		fis_lfpd_regra c
	where	a.nr_seq_controle	= b.nr_sequencia
	and 	b.nr_seq_regra_lfpd	= c.nr_sequencia
	and 	b.nr_sequencia		= nr_seq_controle_p;

vet01	c01%RowType;


BEGIN

open c01;
loop
fetch c01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	contador_w := contador_w + 1;

	ds_linha_w	:= substr(	 sep_w	|| vet01.cd_registro		|| sep_w
						|| vet01.ie_tipo_deducao	|| sep_w
						|| vet01.vl_deducao		|| sep_w
						|| vet01.nr_processo		|| sep_w
						|| vet01.tipo_origem_processo	|| sep_w
						|| vet01.ds_processo		|| sep_w
						|| vet01.cd_observacao		|| sep_w, 1, 8000);

	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	insert into fis_lfpd_arquivo(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_linha,
						ds_arquivo,
						ds_arquivo_compl,
						cd_registro,
						nr_seq_controle_lfpd)
				values (	nextval('fis_lfpd_arquivo_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_linha_w,
						ds_arquivo_w,
						ds_arquivo_compl_w,
						vet01.cd_registro,
						nr_seq_controle_p);

	SELECT * FROM lfpd_registro_B465(nr_seq_controle_p, vet01.nr_sequencia, nm_usuario_p, cd_estabelecimento_p, dt_inicio_p, dt_fim_p, ds_separador_p, qt_linha_p, nr_sequencia_p) INTO STRICT qt_linha_p, nr_sequencia_p;

	if (mod(contador_w,100) = 0) then
		commit;
	end if;

	end;
end loop;
close c01;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lfpd_registro_b460 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

