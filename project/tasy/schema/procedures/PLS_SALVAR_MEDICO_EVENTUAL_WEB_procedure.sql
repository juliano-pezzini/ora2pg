-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_salvar_medico_eventual_web (nm_pessoa_fisica_p text, nr_seq_conselho_p bigint, nr_crm_p text, uf_crm_p text, nm_usuario_p text, nr_cpf_p text, dt_nascimento_p text, cd_estabelecimento_p bigint, nr_seq_cbo_p bigint, cd_pessoa_fisica_p INOUT text) AS $body$
DECLARE

				  
cd_pessoa_fisica_w		varchar(10);
qt_especialidade_w		bigint;
qt_tiss_cbo_saude_w		bigint;
cd_versao_tiss_w		pls_versao_tiss.cd_versao_tiss%type;
cd_especialidade_w		tiss_cbo_saude.cd_especialidade%type;
				

BEGIN 
 
cd_versao_tiss_w := pls_obter_versao_tiss;
 
if (nr_seq_cbo_p IS NOT NULL AND nr_seq_cbo_p::text <> '') then 
	select 	max(cd_especialidade) 
	into STRICT 	cd_especialidade_w 
	from 	tiss_cbo_saude 
	where 	nr_seq_cbo_saude = nr_seq_cbo_p 
	and		ie_versao = cd_versao_tiss_w 
	and		coalesce(cd_pessoa_fisica::text, '') = '';
end if;
 
select	nextval('pessoa_fisica_seq') 
into STRICT	cd_pessoa_fisica_w
;
 
cd_pessoa_fisica_p := cd_pessoa_fisica_w;
 
insert into	pessoa_fisica( cd_pessoa_fisica, nm_usuario, dt_atualizacao, 
								nm_pessoa_fisica, ie_tipo_pessoa, nr_seq_conselho, 
								nr_cpf, dt_nascimento, nr_seq_cbo_saude) 
						values (cd_pessoa_fisica_w, nm_usuario_p, clock_timestamp(), 
								nm_pessoa_fisica_p, 1, nr_seq_conselho_p, 
								nr_cpf_p, to_date(dt_nascimento_p, 'dd/mm/yyyy'), nr_seq_cbo_p);
		 
insert 	into	medico( cd_pessoa_fisica, nr_crm, nm_guerra, 
						ie_vinculo_medico, dt_atualizacao, nm_usuario, 
						ie_corpo_clinico, ie_corpo_assist, uf_crm, 
						ie_situacao) 
				values (cd_pessoa_fisica_w, nr_crm_p, nm_pessoa_fisica_p, 
						9, clock_timestamp(), nm_usuario_p, 
						'N','N', uf_crm_p, 
						'A');
						 
if (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') then 
	select 	count(1) 
	into STRICT	qt_especialidade_w 
	from 	medico_especialidade a 
	where	a.cd_pessoa_fisica 	= cd_pessoa_fisica_w 
	and		a.cd_especialidade	= cd_especialidade_w;
	 
	select 	count(1) 
	into STRICT	qt_tiss_cbo_saude_w 
	from 	tiss_cbo_saude a 
	where	a.nr_seq_cbo_saude	= nr_seq_cbo_p 
	and		a.ie_versao		= cd_versao_tiss_w 
	and		a.cd_pessoa_fisica	= cd_pessoa_fisica_w 
	and		a.cd_especialidade	= cd_especialidade_w;
	 
	if (qt_especialidade_w = 0) then 
		insert into medico_especialidade(cd_pessoa_fisica, cd_especialidade, dt_atualizacao, 
										 nm_usuario, nr_seq_prioridade) 
								values (cd_pessoa_fisica_p, cd_especialidade_w, clock_timestamp(), 
										 nm_usuario_p, 1);
	end if;
	 
	if (qt_tiss_cbo_saude_w = 0) then		 
		insert into tiss_cbo_saude(nr_sequencia, dt_atualizacao, nm_usuario, 
								  dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_cbo_saude, 
								  ie_versao, cd_pessoa_fisica, cd_especialidade, 
								  cd_convenio) 
						 values (nextval('tiss_cbo_saude_seq'), clock_timestamp(), nm_usuario_p, 
								  clock_timestamp(), nm_usuario_p, nr_seq_cbo_p, 
								  cd_versao_tiss_w, cd_pessoa_fisica_p, cd_especialidade_w, 
								  null);
	end if;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_salvar_medico_eventual_web (nm_pessoa_fisica_p text, nr_seq_conselho_p bigint, nr_crm_p text, uf_crm_p text, nm_usuario_p text, nr_cpf_p text, dt_nascimento_p text, cd_estabelecimento_p bigint, nr_seq_cbo_p bigint, cd_pessoa_fisica_p INOUT text) FROM PUBLIC;

