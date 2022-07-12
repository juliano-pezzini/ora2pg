-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_dados_producao_v (nr_seq_producao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(255);
nr_sequencia_w		bigint;
nr_seq_derivado_w		bigint;
nr_seq_doacao_w		bigint;
nr_seq_reserva_w		bigint;
nr_seq_transfusao_w	bigint;
nr_bolsa_w		varchar(20);
cd_barras_w		varchar(30);
qt_volume_w		bigint;
ie_irradiado_w		varchar(2);
ds_tipo_doacao_w		varchar(100);
ds_derivado_w		varchar(255);
dt_vencimento_w		timestamp;
dt_producao_w		timestamp;
nm_entidade_emp_w		varchar(255);
cd_pessoa_fisica_w	varchar(10);
nm_pessoa_fisica_w	varchar(100);
dt_doacao_w		timestamp;
pr_hematocrito_w		bigint;
nr_sangue_w		varchar(20);	
ds_justificativa_w	varchar(255);


BEGIN 
if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then 
	select	x.nr_sequencia, 
		x.nr_seq_derivado, 
		x.nr_seq_doacao, 
		x.nr_seq_reserva, 
		x.nr_seq_transfusao, 
		x.nr_bolsa, 
		x.cd_barras, 
		x.qt_volume, 
		x.ie_irradiado, 
		x.ds_tipo_doacao, 
		x.ds_derivado, 
		trunc(x.dt_vencimento), 
		trunc(x.dt_producao), 
		nm_pessoa_fisica nm_entidade_emp, 
		x.ds_justificativa 
	into STRICT	nr_sequencia_w, 
		nr_seq_derivado_w, 
		nr_seq_doacao_w, 
		nr_seq_reserva_w, 
		nr_seq_transfusao_w, 
		nr_bolsa_w,	 
		cd_barras_w, 
		qt_volume_w, 
		ie_irradiado_w, 
		ds_tipo_doacao_w, 
		ds_derivado_w, 
		dt_vencimento_w, 
		dt_producao_w, 
		nm_entidade_emp_w, 
		ds_justificativa_w 
	from	san_producao_v x 
	where	x.nr_sequencia = nr_seq_producao_p;
	 
	 
	select	cd_pessoa_fisica, 
		obter_nome_pf(cd_pessoa_fisica), 
		dt_doacao, 
		pr_hematocrito, 
		nr_sangue 
	into STRICT	cd_pessoa_fisica_w, 
		nm_pessoa_fisica_w, 
		dt_doacao_w, 
		pr_hematocrito_w, 
		nr_sangue_w 
	from  	san_doacao 
	where 	nr_sequencia = nr_seq_doacao_w;
	 
	 
	if (ie_opcao_p = 'C') then 
		ds_retorno_w:=	cd_pessoa_fisica_w;
	elsif (ie_opcao_p = 'D') then 
		ds_retorno_w:= to_char(dt_doacao_w,'dd/mm/yyyy hh24:mi:ss');
	elsif (ie_opcao_p = 'P') then 
		ds_retorno_w:= pr_hematocrito_w;
	elsif (ie_opcao_p = 'INI') then 
		ds_retorno_w:= obter_iniciais_nome(cd_pessoa_fisica_w,NULL);
	elsif (ie_opcao_p = 'DV') then 
		ds_retorno_w:= dt_vencimento_w;
	elsif (ie_opcao_p = 'S') then 
		ds_retorno_w:= nr_sangue_w;
	elsif (ie_opcao_p = 'N') then 
		ds_retorno_w:= nr_seq_doacao_w;
	elsif (ie_opcao_p = 'M') then 
		ds_retorno_w:= nm_pessoa_fisica_w;
	elsif (ie_opcao_p = 'V') then 
		ds_retorno_w:= qt_volume_w;
	elsif (ie_opcao_p = 'DP') then 
		ds_retorno_w:= dt_producao_w;
	elsif (ie_opcao_p = 'IR') then 
		ds_retorno_w:= ie_irradiado_w;
	elsif (ie_opcao_p = 'DS') then 
		ds_retorno_w:= ds_derivado_w;
	elsif (ie_opcao_p = 'J') then 
		ds_retorno_w:= ds_justificativa_w;
	else 
		null;
	end if;
 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_dados_producao_v (nr_seq_producao_p bigint, ie_opcao_p text) FROM PUBLIC;
