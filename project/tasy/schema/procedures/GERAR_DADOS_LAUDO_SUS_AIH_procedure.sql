-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dados_laudo_sus_aih ( nr_interno_conta_p bigint, nr_atendimento_p bigint, dt_emissao_p INOUT timestamp, nr_aih_p INOUT bigint, nr_seq_aih_p INOUT bigint, cd_medico_requisitante_p INOUT text, cd_diretor_clinico_p INOUT text) AS $body$
DECLARE

 
cd_estabelecimento_w	smallint;


BEGIN 
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
select	cd_diretor_clinico	 
into STRICT	cd_diretor_clinico_p 
from	sus_parametros 
where	cd_estabelecimento = cd_estabelecimento_w;
 
begin 
select	dt_emissao, 
	cd_medico_responsavel, 
	nr_aih, 
	nr_sequencia 
into STRICT	dt_emissao_p, 
	cd_medico_requisitante_p,	 
	nr_aih_p, 
	nr_seq_aih_p 
from 	sus_aih 
where	nr_interno_conta = nr_interno_conta_p;	
exception 
	when others then 
 
	select	dt_entrada, 
		cd_medico_resp 
	into STRICT	dt_emissao_p, 
		cd_medico_requisitante_p 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
 
	nr_aih_p	:= null;
	nr_seq_aih_p	:= null;
end;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_laudo_sus_aih ( nr_interno_conta_p bigint, nr_atendimento_p bigint, dt_emissao_p INOUT timestamp, nr_aih_p INOUT bigint, nr_seq_aih_p INOUT bigint, cd_medico_requisitante_p INOUT text, cd_diretor_clinico_p INOUT text) FROM PUBLIC;

