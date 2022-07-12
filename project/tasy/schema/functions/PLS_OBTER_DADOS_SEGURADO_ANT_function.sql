-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_segurado_ant ( nr_seq_segurado_p bigint, nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_seg_sib_ant_w		bigint;
nm_pessoa_fisica_w		pls_pessoa_fisica.nm_pessoa_fisica%type;
dt_nascimento_w			varchar(10);
ie_sexo_w			varchar(1);
nr_cpf_w			varchar(11);
nm_mae_pessoa_fisica_w		varchar(60);
ds_endereco_w			varchar(40);
nr_endereco_w			integer;
ds_bairro_w			varchar(40);
cd_municipio_ibge_w		varchar(6);
sg_estado_w			pls_segurado_sib.sg_estado%type;
cd_cep_w			varchar(15);
nr_cartao_nac_sus_w		varchar(16);
nr_identidade_w			varchar(15);
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
cd_nacionalidade_w		varchar(8);
dt_geracao_w			timestamp;
nr_pis_pasep_w			varchar(11);
ds_resultado_w			varchar(255);

/* opção:
N	- nome do beneficiario
DN	- data de nascimento do beneficiario
S	- sexo do beneficiario
NM	- nome da mae do beneficiario
E	- endereco do beneficiario
NR	- numero do endereco do beneficiario
B	- bairro do beneficiario
M	- municipio do beneficiario
SG	- sigla do estado do beneficiario
CEP	- cep do beneficiario
CNS	- cns do beneficiario
I	- identidade do beneficiario
OI	- orgão emissor do beneficiario
NA	- nacionalidade do beneficiario
PIS	- numero pis do beneficiario
CPF	- numero de cpf do beneficiário
*/
BEGIN

select 	max(nr_sequencia)
into STRICT	nr_seq_seg_sib_ant_w
from 	pls_segurado_sib
where	nr_sequencia < nr_sequencia_p
and	nr_seq_segurado = nr_seq_segurado_p;

ds_resultado_w := '';

if (nr_seq_seg_sib_ant_w > 0) then
	select 	nm_pessoa_fisica,
		to_char(dt_nascimento,'dd/mm/yyyy'),
		ie_sexo,
		nr_cpf,
		nm_mae_pessoa_fisica,
		ds_endereco,
		nr_endereco,
		ds_bairro,
		cd_municipio_ibge,
		sg_estado,
		cd_cep,
		nr_cartao_nac_sus,
		nr_identidade,
		ds_orgao_emissor_ci,
		cd_nacionalidade,
		nr_pis_pasep
	into STRICT	nm_pessoa_fisica_w,
		dt_nascimento_w,
		ie_sexo_w,
		nr_cpf_w,
		nm_mae_pessoa_fisica_w,
		ds_endereco_w,
		nr_endereco_w,
		ds_bairro_w,
		cd_municipio_ibge_w,
		sg_estado_w,
		cd_cep_w,
		nr_cartao_nac_sus_w,
		nr_identidade_w,
		ds_orgao_emissor_ci_w,
		cd_nacionalidade_w,
		nr_pis_pasep_w
	from 	pls_segurado_sib
	where	nr_sequencia = nr_seq_seg_sib_ant_w;

	if (ie_opcao_p = 'N') then
		ds_resultado_w := nm_pessoa_fisica_w;
	elsif (ie_opcao_p = 'DN') then
		ds_resultado_w := dt_nascimento_w;
	elsif (ie_opcao_p = 'S') then
		ds_resultado_w := ie_sexo_w;
	elsif (ie_opcao_p = 'NM') then
		ds_resultado_w := nm_mae_pessoa_fisica_w;
	elsif (ie_opcao_p = 'CPF') then
		ds_resultado_w := nr_cpf_w;
	elsif (ie_opcao_p = 'E') then
		ds_resultado_w := ds_endereco_w;
	elsif (ie_opcao_p = 'NR') then
		ds_resultado_w := nr_endereco_w;
	elsif (ie_opcao_p = 'B') then
		ds_resultado_w := ds_bairro_w;
	elsif (ie_opcao_p = 'M') then
		ds_resultado_w := cd_municipio_ibge_w;
	elsif (ie_opcao_p = 'SG') then
		ds_resultado_w := sg_estado_w;
	elsif (ie_opcao_p = 'CEP') then
		ds_resultado_w := cd_cep_w;
	elsif (ie_opcao_p = 'CNS') then
		ds_resultado_w := nr_cartao_nac_sus_w;
	elsif (ie_opcao_p = 'I') then
		ds_resultado_w := nr_identidade_w;
	elsif (ie_opcao_p = 'OI') then
		ds_resultado_w := ds_orgao_emissor_ci_w;
	elsif (ie_opcao_p = 'NA') then
		ds_resultado_w := cd_nacionalidade_w;
	elsif (ie_opcao_p = 'PIS') then
		ds_resultado_w := nr_pis_pasep_w;
	end if;
end if;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_segurado_ant ( nr_seq_segurado_p bigint, nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
