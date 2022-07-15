-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lfpd_registro_b465 ( nr_seq_controle_p bigint, nr_seq_regra_B460_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


contador_w		bigint := 0;
ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
ds_linha_w		varchar(8000);
nr_linha_w		bigint	:= qt_linha_p;
nr_seq_registro_w	bigint	:= nr_sequencia_p;
sep_w			varchar(1)	:= ds_separador_p;

c01 CURSOR FOR
	SELECT	'B465' cd_registro,
		a.ie_indicador_compensacao ie_indicador_compensacao,
		replace(campo_mascara(a.vl_credito,2),'.',',') vl_credito,
		replace(campo_mascara(a.vl_compensacao,2),'.',',') vl_compensacao,
		substr(to_char(a.dt_prestacao_servico, 'ddmmyyyy'),3,8) dt_periodo_fiscal,
		replace(campo_mascara(a.vl_resultante,2),'.',',') vl_resultante,
		'' cd_observacao
	from	lfpd_regra_reg_b465 a,
		lfpd_regra_reg_b460 b
	where	a.nr_seq_regra_B460	= b.nr_sequencia
	and 	b.nr_sequencia		= nr_seq_regra_B460_p;

vet01	c01%RowType;


BEGIN

open c01;
loop
fetch c01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	contador_w := contador_w + 1;

	ds_linha_w	:= substr(	 sep_w	|| vet01.cd_registro			|| sep_w
						|| vet01.ie_indicador_compensacao	|| sep_w
						|| vet01.vl_credito			|| sep_w
						|| vet01.vl_compensacao			|| sep_w
						|| vet01.dt_periodo_fiscal		|| sep_w
						|| vet01.vl_resultante			|| sep_w
						|| vet01.cd_observacao			|| sep_w, 1, 8000);

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
-- REVOKE ALL ON PROCEDURE lfpd_registro_b465 ( nr_seq_controle_p bigint, nr_seq_regra_B460_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

