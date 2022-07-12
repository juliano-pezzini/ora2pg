-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_paciente_nf_pagador_v (cd_pagador, ds_pagador, nr_interno_conta, nr_atendimento, ds_label_cgc_cpf, cd_cpf_cgc, ds_endereco, ds_bairro, ds_municipio, ds_uf, cd_cep, ds_pais) AS select	a.cd_pessoa_fisica cd_pagador,
	d.nm_pessoa_fisica ds_pagador, 
	c.nr_interno_conta, 
	c.nr_atendimento, 
	'CPF' ds_label_cgc_cpf, 
	d.nr_cpf cd_cpf_cgc, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'E'),1,200) ds_endereco, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'B'),1,200) ds_bairro, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'CI'),1,200) ds_municipio, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'UF'),1,200) ds_uf, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'CEP'),1,200) cd_cep, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'PAIS'),1,200) ds_pais 
FROM	pessoa_fisica d, 
	conta_paciente c, 
	nota_fiscal a 
where	a.nr_interno_conta	= c.nr_interno_conta 
and	a.cd_pessoa_fisica	= d.cd_pessoa_fisica 

union
 
select	a.cd_cgc cd_pagador, 
	d.ds_razao_social ds_pagador, 
	c.nr_interno_conta, 
	c.nr_atendimento, 
	'CNPJ' ds_label_cgc_cpf, 
	d.cd_cgc, 
	coalesce(d.ds_endereco, substr(obter_compl_pj(d.cd_cgc, 1, 'EN'),1,200)) ds_endereco, 
	coalesce(d.ds_bairro, substr(obter_compl_pj(d.cd_cgc, 1, 'B'),1,200)) ds_bairro, 
	coalesce(d.ds_municipio, substr(obter_compl_pj(d.cd_cgc, 1, 'CI'),1,200)) ds_municipio, 
	coalesce(d.sg_estado, substr(obter_compl_pj(d.cd_cgc, 1, 'UF'),1,200)) ds_uf, 
	coalesce(d.cd_cep, substr(obter_compl_pj(d.cd_cgc, 1, 'CEP'),1,200)) cd_cep, 
	substr(Obter_nome_pais(d.nr_seq_pais),1,200) ds_pais 
from	pessoa_juridica d, 
	conta_paciente c, 
	nota_fiscal a 
where	a.nr_interno_conta	= c.nr_interno_conta 
and	a.cd_cgc		= d.cd_cgc 

union
 
select	a.cd_pessoa_fisica cd_pagador, 
	d.nm_pessoa_fisica ds_pagador, 
	c.nr_interno_conta, 
	b.nr_atendimento, 
	'CPF' ds_label_cgc_cpf, 
	d.nr_cpf cd_cpf_cgc, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'E'),1,200) ds_endereco, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'B'),1,200) ds_bairro, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'CI'),1,200) ds_municipio, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'UF'),1,200) ds_uf, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'CEP'),1,200) cd_cep, 
	substr(OBTER_COMPL_PF(d.cd_pessoa_fisica, 1, 'PAIS'),1,200) ds_pais 
from	pessoa_fisica d, 
	conta_paciente c, 
	atendimento_paciente b, 
	atendimento_pagador a 
where	a.nr_atendimento	= b.nr_atendimento 
and	b.nr_atendimento	= c.nr_atendimento 
and	a.cd_pessoa_fisica	= d.cd_pessoa_fisica 
and 	not exists (select 1 from nota_fiscal w where w.nr_interno_conta = c.nr_interno_conta) 

union
 
select	a.cd_cgc cd_pagador, 
	d.ds_razao_social ds_pagador, 
	c.nr_interno_conta, 
	b.nr_atendimento, 
	'CNPJ' ds_label_cgc_cpf, 
	d.cd_cgc, 
	coalesce(d.ds_endereco, substr(obter_compl_pj(d.cd_cgc, 1, 'EN'),1,200)) ds_endereco, 
	coalesce(d.ds_bairro, substr(obter_compl_pj(d.cd_cgc, 1, 'B'),1,200)) ds_bairro, 
	coalesce(d.ds_municipio, substr(obter_compl_pj(d.cd_cgc, 1, 'CI'),1,200)) ds_municipio, 
	coalesce(d.sg_estado, substr(obter_compl_pj(d.cd_cgc, 1, 'UF'),1,200)) ds_uf, 
	coalesce(d.cd_cep, substr(obter_compl_pj(d.cd_cgc, 1, 'CEP'),1,200)) cd_cep, 
	substr(Obter_nome_pais(d.nr_seq_pais),1,200) ds_pais 
from	pessoa_juridica d, 
	conta_paciente c, 
	atendimento_paciente b, 
	atendimento_pagador a 
where	a.nr_atendimento	= b.nr_atendimento 
and	b.nr_atendimento	= c.nr_atendimento 
and	a.cd_cgc		= d.cd_cgc 
and 	not exists (select 1 from nota_fiscal w where w.nr_interno_conta = c.nr_interno_conta);
