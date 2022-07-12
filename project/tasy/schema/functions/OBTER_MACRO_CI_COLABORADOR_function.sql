-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_macro_ci_colaborador ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, nr_seq_aux_p bigint default null) RETURNS varchar AS $body$
DECLARE

 
ds_mensagem_w			regra_envio_novo_usu_pf.ds_mensagem%type;
nm_pessoa_fisica_w  		pessoa_fisica.nm_pessoa_fisica%type;
ds_setor_atendimento_w		setor_atendimento.ds_setor_atendimento%type;
sg_conselho_w			conselho_profissional.sg_conselho%type;
ds_codigo_prof_w			pessoa_fisica.ds_codigo_prof%type;
ds_vinculo_medico_w		varchar(255);
dt_admissao_w			varchar(20);
dt_admissao_hosp_w		varchar(20);
ds_cobra_pf_pj_w			varchar(255);
nm_pessoa_juridica_w		varchar(150);
ds_cargo_w			varchar(255);
ds_observacao_w			pessoa_fisica.ds_observacao%type;
ds_categoria_w			varchar(255);
ds_especialidade_w		varchar(255);
ie_regra_w			regra_envio_novo_usu_pf.ie_regra%type;
ds_cbo_saude_w			varchar(255);
ie_privilegio_w			medico_privilegio.ie_privilegio%type;
ie_forma_w			medico_privilegio.ie_forma%type;
ds_privilegio_w			medico_privilegio.ds_privilegio%type;
ds_tipo_privilegio_w			varchar(255);
ds_forma_w			varchar(255);

 
/* macros 
NOME 
SETOR	(Somente desligamento) 
CONSELHO 
CODIGOPROF 
VINCULOMEDICO 
DATAADMISSAO 
PADRAORECEBIMENTO 
ENTIDADEJURIDICA 
CATEGORIA 
ESPECIALIDADE 
*/
 
 

BEGIN 
 
begin 
select	ie_regra 
into STRICT	ie_regra_w 
from	regra_envio_novo_usu_pf 
where	nr_sequencia = nr_sequencia_p;
exception 
when others then 
	null;
end;
 
select	SUBSTR(OBTER_NOME_PF(CD_PESSOA_FISICA),0,60), 
	substr(Obter_Conselho_Profissional(nr_seq_conselho,'S'),1,10), 
	ds_codigo_prof, 
	substr(obter_desc_cargo(cd_cargo),1,255) ds_cargo, 
	ds_observacao, 
	to_char(dt_admissao_hosp,'dd/mm/yyyy') dt_admissao, 
	substr(obter_cbo_saude(nr_seq_cbo_saude),1,255) 
into STRICT	nm_pessoa_fisica_w, 
	sg_conselho_w, 
	ds_codigo_prof_w, 
	ds_cargo_w, 
	ds_observacao_w, 
	dt_admissao_hosp_w, 
	ds_cbo_saude_w 
from	pessoa_fisica 
where	cd_pessoa_fisica = cd_pessoa_fisica_p;
 
begin 
select 	substr(obter_valor_dominio(3,ie_vinculo_medico),1,100), 
	to_char(dt_admissao,'dd/mm/yyyy'), 
	substr(obter_valor_dominio(28, ie_cobra_pf_pj),1,100), 
	substr(obter_dados_pf_pj(null, cd_cgc, 'N'),1,150), 
	substr(obter_desc_categ_medico(nr_seq_categoria),1,255), 
	substr(obter_especialidade_medico(cd_pessoa_fisica,'D'),1,255) 
into STRICT	ds_vinculo_medico_w, 
	dt_admissao_w, 
	ds_cobra_pf_pj_w, 
	nm_pessoa_juridica_w, 
	ds_categoria_w, 
	ds_especialidade_w 
from 	medico 
where 	cd_pessoa_fisica = cd_pessoa_fisica_p;
exception 
	when others then 
	ds_vinculo_medico_w	:= '@VINCULOMEDICO';	
	ds_cobra_pf_pj_w  	:= '@PADRAORECEBIMENTO';
	nm_pessoa_juridica_w	:= '@ENTIDADEJURIDICA';
	ds_categoria_w		:= '@CATEGORIA';
	ds_especialidade_w	:= '@ESPECIALIDADE';
end;
 
if (ie_regra_w not in ('NM','CA','CC')) then 
	dt_admissao_w := dt_admissao_hosp_w;
end if;
 
select 	max(substr(obter_nome_setor(cd_setor_atendimento),1,100)) 
into STRICT	ds_setor_atendimento_w 
from	usuario 
where	cd_pessoa_fisica = cd_pessoa_fisica_p;
 
select	ds_mensagem 
into STRICT	ds_mensagem_w 
from	regra_envio_novo_usu_pf 
where	nr_sequencia = nr_sequencia_p;
 
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@NOME',nm_pessoa_fisica_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@SETOR',ds_setor_atendimento_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@CONSELHO',sg_conselho_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@CODIGOPROF',ds_codigo_prof_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@VINCULOMEDICO',ds_vinculo_medico_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@DATAADMISSAO',dt_admissao_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@PADRAORECEBIMENTO',ds_cobra_pf_pj_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ENTIDADEJURIDICA',nm_pessoa_juridica_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@CARGO',ds_cargo_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@OBSPF',ds_observacao_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@CATEGORIA',ds_categoria_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ESPECIALIDADE',ds_especialidade_w),1,2000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@CBOSAUDE',ds_cbo_saude_w),1,2000);
 
 
if	(nr_seq_aux_p > 0 AND ie_regra_w = 'EA') then 
	begin 
	select	ie_privilegio, 
		ie_forma, 
		ds_privilegio 
	into STRICT	ie_privilegio_w, 
		ie_forma_w, 
		ds_privilegio_w	 
	from	medico_privilegio 
	where 	nr_sequencia = nr_seq_aux_p;
		 
	select	substr(Obter_Valor_Dominio(4620,ie_privilegio_w),1,255) 
	into STRICT	ds_tipo_privilegio_w 
	;
	 
	select	substr(Obter_Valor_Dominio(4621,ie_forma_w),1,255) 
	into STRICT	ds_forma_w 
	;
	 
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@TIPO_PRIVILEGIO',ds_tipo_privilegio_w),1,2000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@FORMA_ATUACAO',ds_forma_w),1,2000);	
	end;
end if;
 
return ds_mensagem_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_macro_ci_colaborador ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, nr_seq_aux_p bigint default null) FROM PUBLIC;
