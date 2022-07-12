-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW uremh_w_nf_avulsa_dest (nr_sequencia, ds_emitente, nr_cpf_cgc, ds_endereco, ds_municipio, ds_bairro, sg_estado, ds_cep, nr_telefone, nr_ie, dt_emissao, dt_entrada_saida, dt_alta) AS select	a.nr_sequencia,
	substr(coalesce(obter_dados_pf_pj(null, a.cd_cgc, 'N'), obter_nome_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta)))),1,254) ds_emitente,
	substr(obter_cgc_cpf_editado(coalesce(a.cd_cgc,obter_cgc_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta))))),1,20) nr_cpf_cgc,
	substr(obter_dados_pf_pj(null, coalesce(a.cd_cgc,obter_cgc_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta)))), 'EN'),1,254) ds_endereco,
	substr(obter_dados_pf_pj(null, coalesce(a.cd_cgc,obter_cgc_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta)))), 'CI'),1,254) ds_municipio,
	substr(obter_dados_pf_pj(null, coalesce(a.cd_cgc,obter_cgc_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta)))), 'B'),1,254) ds_bairro,
	substr(obter_dados_pf_pj(null, coalesce(a.cd_cgc,obter_cgc_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta)))), 'UF'),1,254) sg_estado,
	substr(obter_dados_pf_pj(null, coalesce(a.cd_cgc,obter_cgc_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta)))), 'CEP'),1,15) ds_cep,
	substr(obter_dados_pf_pj(null, coalesce(a.cd_cgc,obter_cgc_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta)))), 'T'),1,30) nr_telefone,
	substr(obter_dados_pf_pj(null, coalesce(a.cd_cgc,obter_cgc_convenio(Obter_Convenio_Atendimento(Obter_Atendimento_Conta(a.nr_interno_conta)))), 'IE'),1,30) nr_ie,
	a.dt_emissao,
	a.dt_entrada_saida,
	null dt_alta
FROM  	nota_fiscal a
where  	a.nr_seq_protocolo is not null
and	obter_se_nota_entrada_saida(a.nr_sequencia) = 'S'

union all

select	a.nr_sequencia,
	substr(coalesce(obter_nome_pf(a.cd_pessoa_fisica), obter_dados_pf_pj(null, a.cd_cgc, 'N')),1,254),
	substr(obter_cgc_cpf_editado(coalesce(obter_cpf_pessoa_fisica(a.cd_pessoa_fisica),a.cd_cgc)),1,20),
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'EN'),1,254),
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'CI'),1,254),
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'B'),1,254),
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'UF'),1,254),
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'CEP'),1,15),
	substr(coalesce(obter_telefone_pf(a.cd_pessoa_fisica,'9'),obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'T')),1,255),
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'IE'),1,15),
	a.dt_emissao,
	a.dt_entrada_saida,
	obter_dados_atendimento(obter_atendimento_conta(nr_interno_conta), 'DA')
from	nota_fiscal a
where	((a.nr_interno_conta is not null AND a.nr_seq_protocolo is null) or
	(a.nr_interno_conta is null AND a.nr_seq_protocolo is null))
and	obter_se_nota_entrada_saida(a.nr_sequencia) = 'S'

union all

select	a.nr_sequencia,
	substr(obter_dados_pf_pj(null, e.cd_cgc, 'N'),1,254),
	substr(obter_cgc_cpf_editado(e.cd_cgc),1,20),
	substr(obter_dados_pf_pj(null, e.cd_cgc, 'EN'),1,254),
	substr(obter_dados_pf_pj(null, e.cd_cgc, 'CI'),1,254),
	substr(obter_dados_pf_pj(null, e.cd_cgc, 'B'),1,254),
	substr(obter_dados_pf_pj(null, e.cd_cgc, 'UF'),1,254),
	substr(obter_dados_pf_pj(null, e.cd_cgc, 'CEP'),1,15),
	substr(obter_dados_pf_pj(null, e.cd_cgc, 'T'),1,255),
	substr(obter_dados_pf_pj(null, e.cd_cgc, 'IE'),1,15),
	a.dt_emissao,
	a.dt_entrada_saida,
	obter_dados_atendimento(obter_atendimento_conta(nr_interno_conta), 'DA')
from	nota_fiscal a,
	estabelecimento e
where	obter_se_nota_entrada_saida(a.nr_sequencia) = 'E'
and	a.cd_estabelecimento = e.cd_estabelecimento;
