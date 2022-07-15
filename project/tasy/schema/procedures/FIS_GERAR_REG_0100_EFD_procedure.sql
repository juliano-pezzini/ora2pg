-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_reg_0100_efd (nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE

 
nr_seq_regra_efd_w		bigint;
nr_versao_efd_w			varchar(5);
tp_registro_w			varchar(4);
nr_linha_w			bigint := qt_linha_p;
nr_seq_registro_w		bigint := nr_sequencia_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= ds_separador_p;

c01 CURSOR FOR 
SELECT	distinct 
		'0100' tp_registro, 
		substr(obter_nome_pf(c.cd_contabilista),1,60) nm_contabilista, 
		substr(obter_dados_pf(c.cd_contabilista, 'CPF'),1,11) nr_cpf, 
		substr(lpad(coalesce(c.nr_crc,0),11,0),1,11) nr_crc,	 
		substr(elimina_caractere_especial(obter_compl_pf(c.cd_contabilista,2,'CEP')),1,255) cd_cep, 
		substr(obter_compl_pf(c.cd_contabilista,2,'EN'),1,255)ds_endereco, 
		substr(obter_compl_pf(c.cd_contabilista,2,'NR'),1,255)nr_endereco, 
		substr(obter_compl_pf(c.cd_contabilista,2,'CO'),1,255)ds_complemento, 
		substr(obter_compl_pf(c.cd_contabilista,2,'B'),1,255)ds_bairro, 
		substr(elimina_caracteres_telefone(obter_compl_pf(c.cd_contabilista,2,'DDT') || obter_compl_pf(c.cd_contabilista,2,'T')),1,10) nr_telefone, 
		substr(elimina_caracteres_telefone(obter_compl_pf(c.cd_contabilista,2,'DDF') || obter_compl_pf(c.cd_contabilista,2,'FAX')),1,10) nr_fax, 
		substr(coalesce(obter_dados_pf_pj_estab(a.cd_estabelecimento,null,a.cd_cgc,'M'), 
		obter_dados_pf_pj_estab(a.cd_estabelecimento,c.cd_contabilista,null,'M')),1,255) ds_email, 
		substr((obter_compl_pf(c.cd_contabilista, 1, 'CDMDV')),1,7) cd_localidade 
from		pessoa_juridica b, 
		estabelecimento a, 
		empresa c 
where		a.cd_cgc = b.cd_cgc 
and		c.cd_empresa	= a.cd_empresa 
and		b.ie_situacao	= 'A' 
and		c.cd_empresa	= cd_empresa_p 
and		a.cd_estabelecimento = cd_estabelecimento_p;

vet01	C01%RowType;


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	 
	ds_linha_w	:= substr(	sep_w || vet01.tp_registro		|| 
							sep_w || vet01.nm_contabilista	|| 
				sep_w || vet01.nr_cpf		|| 
				sep_w || vet01.nr_crc		|| 
				sep_w || ''				|| 
				sep_w || vet01.cd_cep		|| 
				sep_w || vet01.ds_endereco		|| 
				sep_w || vet01.nr_endereco		|| 
				sep_w || vet01.ds_complemento	|| 
				sep_w || vet01.ds_bairro		|| 
				sep_w || vet01.nr_telefone		|| 
				sep_w || vet01.nr_fax		|| 
				sep_w || vet01.ds_email		|| 
				sep_w || vet01.cd_localidade		|| sep_w,1,8000);
	 
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
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
-- REVOKE ALL ON PROCEDURE fis_gerar_reg_0100_efd (nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

