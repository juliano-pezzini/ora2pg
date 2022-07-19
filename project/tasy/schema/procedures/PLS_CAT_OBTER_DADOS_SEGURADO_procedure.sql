-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cat_obter_dados_segurado ( nr_seq_segurado_p bigint, nm_usuario_p text, nm_mae_p INOUT text, dt_nascimento_p INOUT timestamp, ie_sexo_p INOUT bigint, ie_estado_civil_p INOUT bigint, nr_ctps_p INOUT pessoa_fisica.nr_ctps%type, nr_serie_ctps_p INOUT pessoa_fisica.nr_serie_ctps%type, dt_emissao_ctps_p INOUT timestamp, uf_emissora_ctps_p INOUT text, nr_identidade_p INOUT text, dt_emissao_ci_p INOUT timestamp, sg_emissora_ci_p INOUT text, ds_orgao_emissor_ci_p INOUT pessoa_fisica.ds_orgao_emissor_ci%type, nr_pis_pasep_p INOUT text, ds_endereco_p INOUT text, ds_complemento_p INOUT text, ds_bairro_p INOUT text, cd_cep_p INOUT text, ds_municipio_p INOUT text, sg_estado_p INOUT text, nr_ddd_telefone_p INOUT text, nr_telefone_p INOUT text, cd_cbo_p INOUT text) AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);
nm_mae_w			varchar(60);
dt_nascimento_w			timestamp;
ie_sexo_w			smallint;/* Dom 4 */
ie_estado_civil_w		smallint;/* Dom 5 */
nr_ctps_w			pessoa_fisica.nr_ctps%type;
nr_serie_ctps_w			pessoa_fisica.nr_serie_ctps%type;
dt_emissao_ctps_w		timestamp;
uf_emissora_ctps_w		pessoa_fisica.uf_emissora_ctps%type;
nr_identidade_w			varchar(15);
dt_emissao_ci_w			timestamp;
sg_emissora_ci_w		varchar(2);
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
nr_pis_pasep_w			varchar(11);
ds_endereco_w			varchar(100);
ds_complemento_w		varchar(40);
ds_bairro_w			varchar(80);
cd_cep_w			varchar(15);
ds_municipio_w			varchar(100);
sg_estado_w			compl_pessoa_fisica.sg_estado%type;
nr_ddd_telefone_w		varchar(3);
nr_telefone_w			varchar(15);
cd_cbo_w			varchar(6);


BEGIN

/* Obter dados do segurado */

select	cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

/* Obter dados da pessoa fisica */

select	dt_nascimento,
	CASE WHEN ie_sexo='F' THEN 3 WHEN ie_sexo='M' THEN 1 END ,
	CASE WHEN ie_estado_civil='1' THEN 1 WHEN ie_estado_civil='2' THEN 2 WHEN ie_estado_civil='5' THEN 3 WHEN ie_estado_civil='3' THEN 4 WHEN ie_estado_civil='6' THEN 4 WHEN ie_estado_civil='4' THEN 5 WHEN ie_estado_civil='7' THEN 5 WHEN ie_estado_civil='9' THEN 5 END ,
	nr_ctps,
	nr_serie_ctps,
	dt_emissao_ctps,
	uf_emissora_ctps,
	nr_identidade,
	dt_emissao_ci,
	sg_emissora_ci,
	ds_orgao_emissor_ci,
	nr_pis_pasep
into STRICT	dt_nascimento_w,
	ie_sexo_w,
	ie_estado_civil_w,
	nr_ctps_w,
	nr_serie_ctps_w,
	dt_emissao_ctps_w,
	uf_emissora_ctps_w,
	nr_identidade_w,
	dt_emissao_ci_w,
	sg_emissora_ci_w,
	ds_orgao_emissor_ci_w,
	nr_pis_pasep_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

/* Obter dados complementares da pessoa física */

begin
select	ds_endereco,
	ds_complemento,
	ds_bairro,
	cd_cep,
	obter_sus_municipio(cd_municipio_ibge),
	sg_estado,
	nr_ddd_telefone,
	nr_telefone
into STRICT	ds_endereco_w,
	ds_complemento_w,
	ds_bairro_w,
	cd_cep_w,
	ds_municipio_w,
	sg_estado_w,
	nr_ddd_telefone_w,
	nr_telefone_w
from	compl_pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_w
and	ie_tipo_complemento	= 1;
exception
	when others then
	ds_endereco_w	:= '';
end;

/* Obter dados complementares do segurado */

begin
select	cd_cbo
into STRICT	cd_cbo_w
from	pls_segurado_compl
where	nr_seq_segurado	= nr_seq_segurado_p;
exception
	when others then
	cd_cbo_w	:= '';
end;

/* Obter dados da mãe */

begin
select	nm_contato
into STRICT	nm_mae_w
from	compl_pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_w
and	ie_tipo_complemento	= 5;
exception
	when others then
	nm_mae_w	:= '';
end;

nm_mae_p		:= nm_mae_w;
dt_nascimento_p		:= dt_nascimento_w;
ie_sexo_p		:= ie_sexo_w;
ie_estado_civil_p	:= ie_estado_civil_w;
nr_ctps_p		:= nr_ctps_w;
nr_serie_ctps_p		:= nr_serie_ctps_w;
dt_emissao_ctps_p	:= dt_emissao_ctps_w;
uf_emissora_ctps_p	:= uf_emissora_ctps_w;
nr_identidade_p		:= nr_identidade_w;
dt_emissao_ci_p		:= dt_emissao_ci_w;
sg_emissora_ci_p	:= sg_emissora_ci_w;
ds_orgao_emissor_ci_p	:= ds_orgao_emissor_ci_w;
nr_pis_pasep_p		:= nr_pis_pasep_w;
ds_endereco_p		:= ds_endereco_w;
ds_complemento_p	:= ds_complemento_w;
ds_bairro_p		:= substr(ds_bairro_w,1,40);
cd_cep_p		:= cd_cep_w;
ds_municipio_p		:= ds_municipio_w;
sg_estado_p		:= sg_estado_w;
nr_ddd_telefone_p	:= nr_ddd_telefone_w;
nr_telefone_p		:= nr_telefone_w;
cd_cbo_p		:= cd_cbo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cat_obter_dados_segurado ( nr_seq_segurado_p bigint, nm_usuario_p text, nm_mae_p INOUT text, dt_nascimento_p INOUT timestamp, ie_sexo_p INOUT bigint, ie_estado_civil_p INOUT bigint, nr_ctps_p INOUT pessoa_fisica.nr_ctps%type, nr_serie_ctps_p INOUT pessoa_fisica.nr_serie_ctps%type, dt_emissao_ctps_p INOUT timestamp, uf_emissora_ctps_p INOUT text, nr_identidade_p INOUT text, dt_emissao_ci_p INOUT timestamp, sg_emissora_ci_p INOUT text, ds_orgao_emissor_ci_p INOUT pessoa_fisica.ds_orgao_emissor_ci%type, nr_pis_pasep_p INOUT text, ds_endereco_p INOUT text, ds_complemento_p INOUT text, ds_bairro_p INOUT text, cd_cep_p INOUT text, ds_municipio_p INOUT text, sg_estado_p INOUT text, nr_ddd_telefone_p INOUT text, nr_telefone_p INOUT text, cd_cbo_p INOUT text) FROM PUBLIC;

