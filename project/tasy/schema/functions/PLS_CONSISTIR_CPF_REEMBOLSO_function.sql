-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_consistir_cpf_reembolso ( nr_seq_conta_p bigint) RETURNS varchar AS $body$
DECLARE

				 
ds_retorno_w			varchar(255);
nr_seq_protocolo_w		bigint;
cd_pessoa_fisica_w		varchar(10);
cd_medico_executor_w		varchar(10);
cd_resp_credito_w		varchar(14);
nr_seq_segurado_w		bigint;
cd_beneficiario_w		varchar(10);
nr_cpf_beneficiario_w		varchar(11);
nr_cpf_resp_credito_w		varchar(11);
nr_cpf_pf_documento_w		varchar(11);
nr_cpf_medico_exec_w		varchar(11);
qt_idade_w			bigint;


BEGIN 
 
begin 
select	nr_seq_protocolo, 
	cd_pessoa_fisica, 
	cd_medico_executor 
into STRICT	nr_seq_protocolo_w, 
	cd_pessoa_fisica_w, 
	cd_medico_executor_w 
from	pls_conta 
where	nr_sequencia	= nr_seq_conta_p;
exception 
when others then 
	nr_seq_protocolo_w	:= 0;
	cd_pessoa_fisica_w	:= 'X';
	cd_medico_executor_w	:= 'X';
end;
 
select	max(nr_seq_segurado) 
into STRICT	nr_seq_segurado_w 
from	pls_protocolo_conta 
where	nr_sequencia	= nr_seq_protocolo_w;
 
select	coalesce(max(cd_pessoa_fisica),'X') 
into STRICT	cd_beneficiario_w 
from	pls_segurado 
where	nr_sequencia	= nr_seq_segurado_w;
if (cd_beneficiario_w <> 'X') then 
	qt_idade_w := Obter_Idade_PF(cd_beneficiario_w,clock_timestamp(),'A');
	if (coalesce(qt_idade_w,18) > 17 ) then 
		select	coalesce(max(nr_cpf),'X') 
		into STRICT	nr_cpf_beneficiario_w 
		from	pessoa_fisica 
		where	cd_pessoa_fisica	= cd_beneficiario_w;
		 
		if (nr_cpf_beneficiario_w = 'X') then 
			ds_retorno_w	:= ds_retorno_w || 'Beneficiário (' || cd_beneficiario_w || ') não possui CPF informado!' || chr(13)||chr(10);
		end if;
	end if;
end if;
 
/* Verificar se o responsável crédito do protocolo é pessoa FISICA */
 
cd_resp_credito_w	:= pls_obter_resp_credito_prot(nr_seq_protocolo_w, 'C');
if (cd_resp_credito_w IS NOT NULL AND cd_resp_credito_w::text <> '') and (length(cd_resp_credito_w) < 14) then 
	select	coalesce(max(nr_cpf),'X') 
	into STRICT	nr_cpf_resp_credito_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica	= cd_resp_credito_w;	
 
	if (nr_cpf_resp_credito_w = 'X') then 
		ds_retorno_w	:= 'Responsável crédito (' || cd_resp_credito_w || ') não possui CPF informado!' || chr(13)||chr(10);
	end if;
end if;
 
if (cd_pessoa_fisica_w <> 'X') then 
	select	coalesce(max(nr_cpf),'X') 
	into STRICT	nr_cpf_pf_documento_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
	 
	if (nr_cpf_pf_documento_w = 'X') then 
		ds_retorno_w	:= ds_retorno_w || 'PF Documento (' || cd_pessoa_fisica_w || ') não possui CPF informado!' || chr(13)||chr(10);
	end if;
end if;
 
if (cd_medico_executor_w <> 'X') then 
	select	coalesce(max(nr_cpf),'X') 
	into STRICT	nr_cpf_medico_exec_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica	= cd_medico_executor_w;
	 
	if (nr_cpf_medico_exec_w = 'X') then 
		ds_retorno_w	:= ds_retorno_w || 'Médico executor (' || cd_medico_executor_w || ') não possui CPF informado!' || chr(13)||chr(10);
	end if;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_consistir_cpf_reembolso ( nr_seq_conta_p bigint) FROM PUBLIC;

