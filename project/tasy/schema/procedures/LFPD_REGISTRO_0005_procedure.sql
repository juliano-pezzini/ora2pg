-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lfpd_registro_0005 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


contador_w		bigint := 0;
ds_arquivo_w		varchar(4000);
ds_arquivo_compl_w	varchar(4000);
ds_linha_w		varchar(8000);
nr_linha_w		bigint := qt_linha_p;
nr_seq_registro_w	bigint := nr_sequencia_p;
sep_w			varchar(1) := ds_separador_p;

cd_cgc_w		varchar(14);

c01 CURSOR FOR
	SELECT	'0005' 					cd_registro,
		j.nm_fantasia				nm_fantasia,
		j.cd_cep				cd_cep,
		j.ds_endereco				ds_endereco,
		j.nr_endereco				nr_endereco,
		j.ds_complemento			ds_complemento,
		j.ds_bairro				ds_bairro,
		''					cd_cep_cp,
		''					cd_caixa_postal,
		j.nr_ddd_telefone || j.nr_telefone	nr_telefone,
		j.nr_ddd_fax || j.nr_fax		nr_fax,
		e.ds_email				ds_email
	from	pessoa_juridica j,
		pessoa_juridica_estab e
	where	e.cd_cgc = j.cd_cgc
	and	j.cd_cgc = cd_cgc_w
	and	e.cd_estabelecimento = cd_estabelecimento_p;

vet01	c01%RowType;


BEGIN

begin
select	cd_cgc
into STRICT	cd_cgc_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p;
exception when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266524,'CD_ESTABELECIMENTO_P=' || cd_estabelecimento_p);
end;

open c01;
loop
fetch c01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	contador_w := contador_w + 1;

	ds_linha_w	:= substr(	sep_w || vet01.cd_registro 		||
					sep_w || vet01.nm_fantasia 		||
					sep_w || vet01.cd_cep 			||
					sep_w || vet01.ds_endereco 		||
					sep_w || vet01.nr_endereco 		||
					sep_w || vet01.ds_complemento 		||
					sep_w || vet01.ds_bairro 		||
					sep_w || vet01.cd_cep_cp 		||
					sep_w || vet01.cd_caixa_postal 		||
					sep_w || vet01.nr_telefone 		||
					sep_w || vet01.nr_fax 			||
					sep_w || vet01.ds_email 		|| sep_w, 1, 8000);

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
-- REVOKE ALL ON PROCEDURE lfpd_registro_0005 ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
