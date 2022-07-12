-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sl_obter_dados_servico (nr_seq_servico_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE

				 
ds_retorno_w			varchar(255);
cd_unidade_basica_w		varchar(10);	
cd_unidade_compl_w		varchar(10);
cd_setor_atendimento_w		integer;
nm_executor_inic_serv_w		varchar(90);
ds_setor_atendimento_w		varchar(90);
nr_seq_unidade_w		bigint;
cd_executor_inic_serv_w		varchar(10);

BEGIN
 
select 	max(nr_seq_unidade), 
	max(cd_executor_inic_serv), 
	max(substr(obter_nome_pf(cd_executor_inic_serv),1,90)) 
into STRICT	nr_seq_unidade_w, 
	cd_executor_inic_serv_w, 
	nm_executor_inic_serv_w 
from	sl_unid_atend 
where	nr_sequencia = nr_seq_servico_p;
 
if (nr_seq_unidade_w IS NOT NULL AND nr_seq_unidade_w::text <> '') then 
 
	select	cd_unidade_basica, 
		cd_unidade_compl, 
		cd_setor_atendimento, 
		substr(obter_nome_setor(cd_setor_atendimento),1,90) 
	into STRICT	cd_unidade_basica_w, 
		cd_unidade_compl_w, 
		cd_setor_atendimento_w, 
		ds_setor_atendimento_w 
	from	unidade_atendimento 
	where	nr_seq_interno = nr_seq_unidade_w;
 
end if;
 
if (ie_opcao_p = 0) then 
	 
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(305720, null) || ' '|| ds_setor_atendimento_w || ' - ' || wheb_mensagem_pck.get_texto(307008,null) || ' ' || cd_unidade_basica_w || cd_unidade_compl_w; -- Setor:		Unidade: 
elsif (ie_opcao_p = 1) then 
 
	ds_retorno_w	:= nm_executor_inic_serv_w;
 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sl_obter_dados_servico (nr_seq_servico_p bigint, ie_opcao_p bigint) FROM PUBLIC;
