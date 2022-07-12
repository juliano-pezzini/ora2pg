-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_termo (nr_atendimento_p bigint, qt_idade_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

			 
/*Legenda: 
N = Nome; 
S = Sexo; 
NA = Nacionalidade; 
DTN = Data de Nascimento; 
EC = Estado Civil; 
RG = Identidade; 
CPF = CPF; 
END = Endereço 
CEP = CEP; 
TL = Telefone.*/
 
 
nm_retorno_w	varchar(255);
			

BEGIN 
 
if (qt_idade_p < 18) then 
 
	if (ie_opcao_p = 'N') then 
		begin 
	 
		select	substr(nm_responsavel,1,255) 
		into STRICT	nm_retorno_w 
		from	atendimento_paciente_v 
		where 	nr_atendimento 	= nr_atendimento_p;
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'S') then 
		begin 
	 
		select CASE WHEN obter_dados_pf(cd_pessoa_responsavel,'SE')='F' THEN wheb_mensagem_pck.get_texto(796001)  ELSE wheb_mensagem_pck.get_texto(796000) END 	 
		into STRICT	nm_retorno_w 
		from	atendimento_paciente_v 
		where 	nr_atendimento 	= nr_atendimento_p;
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'NA') then 
		begin 
	 
		select 	OBTER_DESC_NACIONALIDADE(a.cd_nacionalidade) 
		into STRICT	nm_retorno_w 
		from 	pessoa_fisica a 
		where 	a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_responsavel 
						from	atendimento_paciente_v b 
						where 	b.nr_atendimento 	= nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'DTN') then 
		begin 
	 
		select 	a.dt_nascimento 
		into STRICT	nm_retorno_w 
		from 	pessoa_fisica a 
		where 	a.cd_pessoa_fisica = 	(SELECT	b.cd_pessoa_responsavel 
						from	atendimento_paciente_v b 
						where	b.nr_atendimento  = nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'EC') then 
		begin 
	 
		select Obter_Valor_Dominio(5,a.ie_estado_civil) 
		into STRICT 	nm_retorno_w 
		from  	pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_responsavel 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'RG') then 
		begin 
	 
		select a.nr_identidade 
		into STRICT 	nm_retorno_w 
		from  	pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_responsavel 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'CPF') then 
		begin 
	 
		select a.nr_cpf 
		into STRICT 	nm_retorno_w 
		from  	pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_responsavel 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'END') then 
		begin 
	 
		select wheb_mensagem_pck.get_texto(796002) || ': ' || a.ds_endereco ||'nº '|| a.nr_endereco 
		into STRICT 	nm_retorno_w 
		from  	compl_pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_responsavel 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p) 
		and   a.ie_tipo_complemento = 1;
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'CEP') then 
		begin 
	 
		select a.cd_cep 
		into STRICT 	nm_retorno_w 
		from  	compl_pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_responsavel 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p) 
		and   a.ie_tipo_complemento = 1;
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'TL') then 
		begin 
	 
		select a.nr_telefone 
		into STRICT 	nm_retorno_w 
		from  	compl_pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_responsavel 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento = nr_atendimento_p) 
		and   a.ie_tipo_complemento = 1;
	 
		end;
	end if;
end if;
 
if (qt_idade_p >= 18) then 
	if (ie_opcao_p = 'N') then 
		begin 
	 
		select	substr(nm_paciente,1,255) 
		into STRICT	nm_retorno_w 
		from	atendimento_paciente_v 
		where 	nr_atendimento 	= nr_atendimento_p;
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'S') then 
		begin 
	 
		select CASE WHEN obter_dados_pf(cd_pessoa_fisica,'SE')='F' THEN wheb_mensagem_pck.get_texto(796001)  ELSE wheb_mensagem_pck.get_texto(796000) END  
		into STRICT	nm_retorno_w 
		from	atendimento_paciente_v 
		where 	nr_atendimento 	= nr_atendimento_p;
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'NA') then 
		begin 
	 
		select 	OBTER_DESC_NACIONALIDADE(a.cd_nacionalidade) 
		into STRICT	nm_retorno_w 
		from 	pessoa_fisica a 
		where 	a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_fisica 
						from	atendimento_paciente_v b 
						where 	b.nr_atendimento 	= nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'DTN') then 
		begin 
	 
		select 	a.dt_nascimento 
		into STRICT	nm_retorno_w 
		from 	pessoa_fisica a 
		where 	a.cd_pessoa_fisica = 	(SELECT	b.cd_pessoa_fisica 
						from	atendimento_paciente_v b 
						where	b.nr_atendimento  = nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'EC') then 
		begin 
	 
		select Obter_Valor_Dominio(5,a.ie_estado_civil) 
		into STRICT 	nm_retorno_w 
		from  	pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_fisica 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'RG') then 
		begin 
	 
		select a.nr_identidade 
		into STRICT 	nm_retorno_w 
		from  	pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_fisica 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'CPF') then 
		begin 
	 
		select a.nr_cpf 
		into STRICT 	nm_retorno_w 
		from  	pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_fisica 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p);
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'END') then 
		begin 
	 
		select wheb_mensagem_pck.get_texto(796002) || ': ' || a.ds_endereco ||'nº '|| a.nr_endereco 
		into STRICT 	nm_retorno_w 
		from  	compl_pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_fisica 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p) 
		and   a.ie_tipo_complemento = 1;
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'CEP') then 
		begin 
	 
		select a.cd_cep 
		into STRICT 	nm_retorno_w 
		from  	compl_pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_fisica 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento  = nr_atendimento_p) 
		and   a.ie_tipo_complemento = 1;
	 
		end;
	end if;
	 
	if (ie_opcao_p = 'TL') then 
		begin 
	 
		select a.nr_telefone 
		into STRICT 	nm_retorno_w 
		from  	compl_pessoa_fisica a 
		where  a.cd_pessoa_fisica =	(SELECT b.cd_pessoa_fisica 
						from 	atendimento_paciente_v b 
						where 	b.nr_atendimento = nr_atendimento_p) 
		and   a.ie_tipo_complemento = 1;
	 
		end;
	end if;
end if;
 
return	nm_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_termo (nr_atendimento_p bigint, qt_idade_p bigint, ie_opcao_p text) FROM PUBLIC;
