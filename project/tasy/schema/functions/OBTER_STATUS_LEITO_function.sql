-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_leito ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_estabelecimento_p bigint, ie_ocupado_p text) RETURNS varchar AS $body$
DECLARE

 
ie_status_unidade_w		varchar(5);
ie_sexo_w			varchar(5);
ie_classif_etaria_w		varchar(5);
ie_temporario_w			varchar(5);
ie_paciente_isolado_w		varchar(5);
ie_status_w			varchar(2) := 'L';
nr_atendimento_w		bigint;


BEGIN 
 
--Obtem os dados do leito em questão 
select	nr_atendimento, 
	ie_status_unidade, 
	ie_sexo, 
	substr(obter_classif_etaria(cd_estabelecimento_p, cd_pessoa_fisica, 'C'),1,10), 
	ie_temporario     
into STRICT	nr_atendimento_w, 
	ie_status_unidade_w, 
	ie_sexo_w, 
	ie_classif_etaria_w, 
	ie_temporario_w 
from	ocupacao_unidade_v 
where	cd_setor_atendimento	= cd_setor_atendimento_p 
and	cd_unidade_basica	= cd_unidade_basica_p 
and	cd_unidade_compl	= cd_unidade_compl_p;
 
--Obtem se paciente isolado 
select	coalesce(max(ie_paciente_isolado),'N') 
into STRICT	ie_paciente_isolado_w 
from	atendimento_paciente 
where	nr_atendimento		= nr_atendimento_w;
 
--Verificação dos status 
if (ie_status_unidade_w = 'P') then 
	if (ie_sexo_w = 'M') then 
		if (ie_classif_etaria_w = 'A') then 
			if (ie_ocupado_p = 'S') then 
				ie_status_w := 'O';
			else 
				ie_status_w := 'DM';
			end if;
		elsif (ie_classif_etaria_w = 'I') then 
			if (ie_ocupado_p = 'S') then 
				ie_status_w := 'O';
			else 
				ie_status_w := 'IM';
			end if;
		elsif (ie_classif_etaria_w = 'C') then 
			if (ie_ocupado_p = 'S') then 
				ie_status_w := 'O';
			else 
				ie_status_w := 'CM';
			end if;
		elsif (ie_classif_etaria_w = 'L') then 
			if (ie_ocupado_p = 'S') then 
				ie_status_w := 'O';
			else 
				ie_status_w := 'AM';
			end if;
		end if;
	else 
		if (ie_classif_etaria_w = 'A') then 
			if (ie_ocupado_p = 'S') then 
				ie_status_w := 'O';
			else 
				ie_status_w := 'DF';
			end if;
		elsif (ie_classif_etaria_w = 'I') then 
			if (ie_ocupado_p = 'S') then 
				ie_status_w := 'O';
			else 
				ie_status_w := 'IF';
			end if;
		elsif (ie_classif_etaria_w = 'C') then 
			if (ie_ocupado_p = 'S') then 
				ie_status_w := 'O';
			else 
				ie_status_w := 'CF';
			end if;
		elsif (ie_classif_etaria_w = 'L') then 
			if (ie_ocupado_p = 'S') then 
				ie_status_w := 'O';
			else 
				ie_status_w := 'AF';
			end if;
		end if;
	end if;
else 
	if (ie_status_unidade_w = 'L' and ie_temporario_w = 'S') then 
		ie_status_w := 'TL';
	else 
		if (ie_status_unidade_w = 'L') then 
			ie_status_w := 'L';
		elsif (ie_status_unidade_w = 'H') then 
			ie_status_w := 'H';
		elsif (ie_status_unidade_w = 'M') then 
			ie_status_w := 'M';
		elsif (ie_status_unidade_w = 'I') then 
			ie_status_w := 'I';
		elsif (ie_status_unidade_w = 'A') then 
			ie_status_w := 'A';
		elsif (ie_status_unidade_w = 'O') then 
			ie_status_w := 'OF';
		elsif (ie_status_unidade_w = 'R') then 
			ie_status_w := 'R';
		elsif (ie_status_unidade_w = 'G') then 
			ie_status_w := 'G';			
		elsif (ie_status_unidade_w = 'E') then 
			ie_status_w := 'E';
		elsif (ie_status_unidade_w = 'C') then 
			ie_status_w := 'C';
		end if;
	end if;
end if;
 
--Verifica isolamento 
if (ie_paciente_isolado_w = 'S') then 
	if (ie_sexo_w = 'M') then 
		if (ie_ocupado_p = 'S') then 
			ie_status_w := 'O';
		else 
			ie_status_w := 'OM';
		end if;
	else 
		if (ie_ocupado_p = 'S') then 
			ie_status_w := 'O';
		else 
			ie_status_w := 'OF';
		end if;
	end if;
end if;
 
return ie_status_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_leito ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_estabelecimento_p bigint, ie_ocupado_p text) FROM PUBLIC;

