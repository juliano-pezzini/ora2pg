-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Registro 0005: dados complementares do contribuinte*/

CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0005_edoc () AS $body$
DECLARE


nr_seq_fis_sef_edoc_0005_w	fis_sef_edoc_0005.nr_sequencia%type;
ds_nome_resp_w			fis_sef_edoc_0005.ds_nome_resp%type;
cd_cpf_resp_w			fis_sef_edoc_0005.cd_cpf_resp%type;
cd_assin_w        		fis_sef_edoc_0005.cd_assin%type;


BEGIN
begin

select	b.nm_pessoa_fisica	ds_nome_resp,
	b.nr_cpf		cd_cpf_resp,
	(select y.cd_qualificacao from dnrc_qualif_assinante y where y.nr_sequencia = a.nr_seq_qualif_dnrc)	cd_assin
into STRICT	ds_nome_resp_w,
	cd_cpf_resp_w,
	cd_assin_w
from	empresa_estab_resp a,
	pessoa_fisica b
where	a.cd_pessoa_fisica		= b.cd_pessoa_fisica
and 	current_setting('fis_sef_edoc_reg_geral_pck.dt_fim_apuracao_w')::fis_sef_edoc_controle.dt_fim_apuracao%type		between	a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia, current_setting('fis_sef_edoc_reg_geral_pck.dt_fim_apuracao_w')::fis_sef_edoc_controle.dt_fim_apuracao%type)
and 	coalesce(a.ie_resp_legal_gov, 'N')	= 'S'
and 	((a.cd_estab_exclusivo 		= current_setting('fis_sef_edoc_reg_geral_pck.cd_estabelecimento_w')::fis_sef_edoc_controle.cd_estabelecimento%type)
	or ((coalesce(a.cd_estab_exclusivo::text, '') = '')
		and (not exists (	SELECT	1
					from	empresa_estab_resp c
					where	current_setting('fis_sef_edoc_reg_geral_pck.dt_fim_apuracao_w')::fis_sef_edoc_controle.dt_fim_apuracao%type	between	c.dt_inicio_vigencia and coalesce(c.dt_fim_vigencia, current_setting('fis_sef_edoc_reg_geral_pck.dt_fim_apuracao_w')::fis_sef_edoc_controle.dt_fim_apuracao%type)
					and 	c.cd_estab_exclusivo 	= current_setting('fis_sef_edoc_reg_geral_pck.cd_estabelecimento_w')::fis_sef_edoc_controle.cd_estabelecimento%type  LIMIT 1))))  LIMIT 1;

exception
when others then
	ds_nome_resp_w	:= null;
	cd_cpf_resp_w	:= null;
	cd_assin_w 	:= null;
end;

/*Pega a sequencia da taleba fis_sef_edoc_0005 para o insert*/

select	nextval('fis_sef_edoc_0005_seq')
into STRICT	nr_seq_fis_sef_edoc_0005_w
;

insert into fis_sef_edoc_0005(	nr_sequencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					cd_reg,
					ds_nome_resp,
					cd_assin,
					cd_cpf_resp,
					cd_cep,
					ds_end,
					nr_num,
					ds_compl,
					ds_bairro,
					cd_cep_cp,
					cd_cp,
					nr_seq_controle,
					nr_fone,
					nr_fax,
					ds_email
					)
					SELECT	nr_seq_fis_sef_edoc_0005_w							nr_sequencia,
						clock_timestamp()										dt_atualizacao,
						clock_timestamp()										dt_atualizacao_nrec,
						current_setting('fis_sef_edoc_reg_geral_pck.nm_usuario_w')::usuario.nm_usuario%type									nm_usuario,
						current_setting('fis_sef_edoc_reg_geral_pck.nm_usuario_w')::usuario.nm_usuario%type									nm_usuario_nrec,
						'0005'										cd_reg,
						ds_nome_resp_w									ds_nome_resp,
						cd_assin_w										cd_assin,
						cd_cpf_resp_w									cd_cpf_resp,
						c.cd_cep									cd_cep,
						c.ds_endereco									ds_end,
						c.nr_endereco									nr_num,
						c.ds_complemento								ds_compl,
						c.ds_bairro									ds_bairro,
						null										cd_cep_cp,
						null										cd_cp,
						current_setting('fis_sef_edoc_reg_geral_pck.nr_seq_controle_w')::fis_sef_edoc_controle.nr_sequencia%type								nr_seq_controle,
						substr(elimina_caracteres_telefone(c.nr_ddd_telefone || c.nr_telefone),1,10)	nr_fone,
						substr(elimina_caracteres_telefone(c.nr_ddd_fax || c.nr_fax),1,10)		nr_fax,
						substr(obter_dados_pf_pj_estab(b.cd_estabelecimento,null,b.cd_cgc,'M'),1,255)	ds_email
					from	estabelecimento b,
						pessoa_juridica c
					where	b.cd_cgc = c.cd_cgc
					and	b.cd_estabelecimento = current_setting('fis_sef_edoc_reg_geral_pck.cd_estabelecimento_w')::fis_sef_edoc_controle.cd_estabelecimento%type
					and	c.ie_situacao = 'A';

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0005_edoc () FROM PUBLIC;
