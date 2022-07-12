-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_autor_propaci (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/* 
IE_OPCAO_P 
1 - Retorna mensagem de consistencia 
2 - Retorna qual a regra 
*/
 
 
 
nr_atendimento_w	bigint;
cd_convenio_w		bigint;
dt_procedimento_w	timestamp;
cd_procedimento_w	bigint;
ie_tipo_atendimento_w	smallint;
ie_origem_proced_w	bigint;
cd_setor_atendimento_w	bigint;
qt_procedimento_w	double precision;
cd_plano_w		varchar(10) := '';
ds_erro_w		varchar(255) := '';
ds_retorno_w		varchar(255) := '';
ie_regra_w		varchar(10) := null;
nr_seq_regra_retorno_w	bigint;
nr_seq_proc_interno_w	bigint;
cd_categoria_w		varchar(10);
cd_estabelecimento_w	smallint;
cd_medico_exec_w	varchar(10);
ie_glosa_w			regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_preco_w		regra_ajuste_proc.nr_sequencia%type;

BEGIN
 
begin 
select	a.nr_atendimento, 
	a.cd_convenio, 
	a.dt_procedimento,	 
	a.cd_procedimento, 
	a.ie_origem_proced, 
	a.qt_procedimento, 
	b.ie_tipo_atendimento, 
	obter_plano_convenio_atend(b.nr_atendimento,'C'), 
	a.cd_setor_atendimento, 
	a.nr_seq_proc_interno, 
	substr(obter_categoria_atendimento(b.nr_atendimento),1,10), 
	b.cd_estabelecimento, 
	a.cd_medico_executor 
into STRICT	nr_atendimento_w, 
	cd_convenio_w, 
	dt_procedimento_w, 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	qt_procedimento_w, 
	ie_tipo_atendimento_w, 
	cd_plano_w, 
	cd_setor_atendimento_w, 
	nr_seq_proc_interno_w, 
	cd_categoria_w, 
	cd_estabelecimento_w, 
	cd_medico_exec_w 
from	atendimento_paciente b, 
	procedimento_paciente a 
where	a.nr_atendimento	= b.nr_atendimento 
and	a.nr_sequencia		= nr_sequencia_p;
 
 
SELECT * FROM consiste_plano_convenio(nr_atendimento_w, cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w, 0, /*qt_procedimento_w, -- Francisco - 10/10/08 Troquei por 0 por causa da consiste_autorizacao_proc */
 
		ie_tipo_atendimento_w, cd_plano_w, null, ds_erro_w, cd_setor_atendimento_w, null, ie_regra_w, null, nr_seq_regra_retorno_w, nr_seq_proc_interno_w, cd_categoria_w, cd_estabelecimento_w, null, cd_medico_exec_w, '', ie_glosa_w, nr_seq_regra_preco_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_retorno_w, ie_glosa_w, nr_seq_regra_preco_w;
 
exception 
	when others then 
		ds_erro_w		:= null;
		ie_regra_w		:= null;
end;
 
if (ie_opcao_p = '1') then 
	if (ie_regra_w = 6) then	-- se consiste na conta 
		ds_retorno_w		:= ds_erro_w;
	end if;
elsif (ie_opcao_p = '2') then 
	ds_retorno_w	:= ie_regra_w;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_autor_propaci (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
