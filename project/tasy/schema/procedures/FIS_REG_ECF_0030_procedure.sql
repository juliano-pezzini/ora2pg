-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_reg_ecf_0030 ( nr_seq_controle_p text, ds_separador_p text, cd_estabelecimento_p text, nm_usuario_p text, cd_empresa_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_scp_p text) AS $body$
DECLARE



nr_seq_registro_w		bigint := nr_sequencia_p;
nr_linha_w			bigint := qt_linha_p;
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(4000);
sep_w				varchar(2) := ds_separador_p;
tp_registro_w			varchar(5);

dt_inicio_apuracao_w		timestamp;
ds_endereco_w			varchar(255);
nr_endereco_w			varchar(255);
ds_complemento_w		varchar(255);
ds_bairro_w			varchar(255);
sg_estado_w			varchar(255);
cd_municipio_w			varchar(255);
cd_cep_w			varchar(255);
nr_ddd_telefone_w		varchar(255);
nr_telefone_w			varchar(255);
ds_email_w			varchar(255);
nr_seq_cnae_w			bigint;
cd_cnae_w			varchar(7);
cd_nat_juridica_w		varchar(4);
cd_municipio_ibge_w		varchar(7);
telefone_w			varchar(20);
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;


BEGIN

cd_estabelecimento_w:= cd_estabelecimento_p;

if (ie_scp_p = 'S') then
	begin
	
	select	cd_estab_socio_ost_scp
	into STRICT	cd_estabelecimento_w
	from	estabelecimento a
	where	a.cd_estabelecimento = cd_estabelecimento_p;
	
	exception
	when others then
		cd_estabelecimento_w:= null;
	end;
end if;

select	substr((obter_dados_pf_pj(null, cd_cgc, 'R')),  1,150) ds_endereco,
	substr((obter_dados_pf_pj(null, cd_cgc, 'NR')), 1,6  ) nr_endereco,
	substr((obter_dados_pf_pj(null, cd_cgc, 'CO')), 1,50 ) ds_complemento,
	substr((obter_dados_pf_pj(null, cd_cgc, 'B')),  1,50 ) ds_bairro,
	substr((obter_dados_pf_pj(null, cd_cgc, 'UF')), 1,2  ) sg_estado,
	substr((obter_dados_pf_pj(null, cd_cgc, 'CDM')),1,7  ) cd_municipio,
	substr((obter_dados_pf_pj(null, cd_cgc, 'CEP')),1,8  ) cd_cep,
	obter_dados_pf_pj(null, cd_cgc, 'DDT') nr_ddd_telefone,
	obter_dados_pf_pj(null, cd_cgc, 'T') nr_telefone,
	substr((obter_dados_pf_pj_estab(CASE WHEN ie_scp_p='S' THEN (select max(cd_estab_socio_ost_scp) from estabelecimento where	cd_estabelecimento = cd_estabelecimento_p)  ELSE cd_estabelecimento_p END ,null, cd_cgc, 'M')),  1,115) ds_email,
	substr(elimina_caractere_especial(obter_dados_cnae(obter_dados_pf_pj(null, cd_cgc, 'CNAE'),'CD')),1,7) cd_cnae
into STRICT	ds_endereco_w,
	nr_endereco_w,
	ds_complemento_w,
	ds_bairro_w,
	sg_estado_w,
	cd_municipio_w,
	cd_cep_w,
	nr_ddd_telefone_w,
	nr_telefone_w,
	ds_email_w,
	cd_cnae_w
from	estabelecimento
where   cd_estabelecimento = cd_estabelecimento_w;


select	substr(elimina_caractere_especial(cd_nat_juridica),1,4)
into STRICT 	cd_nat_juridica_w
from	sup_natureza_juridica
where	nr_sequencia = (SELECT max(a.nr_seq_natureza_juridica)
			from	fis_regra_ecf_0020 a,
				fis_controle_ecf b
			where	a.nr_seq_lote	= b.nr_seq_lote
			and	a.cd_empresa	= cd_empresa_p
			and 	b.nr_sequencia	= nr_seq_controle_p);

tp_registro_w		:= '0030';
cd_municipio_ibge_w 	:= elimina_Caracteres_Especiais(substr(cd_municipio_w || substr(calcula_digito('MODULO10', cd_municipio_w),1,1),1,7));
telefone_w 		:= substr((nr_ddd_telefone_w || nr_telefone_w),1,15);

ds_linha_w	:= substr(	sep_w || tp_registro_w 				|| -- Registro (1)
				sep_w || cd_nat_juridica_w			|| -- Código da natureza jurídica, conforme tabela do Sped (2)
				sep_w || cd_cnae_w				|| -- Código da atividade econômica (CNAE-Fiscal) (3)
				sep_w || ds_endereco_w				|| -- Endereço (4)
				sep_w || nr_endereco_w				|| -- Número (5)
				sep_w || ds_complemento_w			|| -- Complemento (6)
				sep_w || ds_bairro_w				|| -- Bairro/Distrito (7)
				sep_w || sg_estado_w				|| -- UF, conforme do tabela do Sped (8)
				sep_w || cd_municipio_ibge_w			|| -- Código do Município, conforme tabela do Sped (9)
				sep_w || cd_cep_w				|| -- CEP (10)
				sep_w || telefone_w				|| -- DDD + número de telefone (11)
				sep_w || ds_email_w				|| sep_w,1,8000); -- Correio eletrônico (12)
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
	tp_registro_w,
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
-- REVOKE ALL ON PROCEDURE fis_reg_ecf_0030 ( nr_seq_controle_p text, ds_separador_p text, cd_estabelecimento_p text, nm_usuario_p text, cd_empresa_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_scp_p text) FROM PUBLIC;

