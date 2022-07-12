-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_aval_atend ( nr_seq_tipo_aval_p text, nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
nm_avaliador_w	varchar(100);
dt_avaliacao_w	timestamp;	
dt_liberacao_w	timestamp;
ds_retorno_w	varchar(255);
					

BEGIN 
if (nr_seq_tipo_aval_p IS NOT NULL AND nr_seq_tipo_aval_p::text <> '') then 
	select	max(obter_nome_pf(cd_medico)), 
		max(dt_avaliacao), 
		max(dt_liberacao) 
	into STRICT	nm_avaliador_w, 
		dt_avaliacao_w, 
		dt_liberacao_w 
	from	med_avaliacao_paciente 
	where	nr_sequencia	=	(	SELECT	max(nr_sequencia) 
						from	med_avaliacao_paciente 
						where	nr_atendimento		=	nr_atendimento_p 
						and	 obter_se_contido(nr_seq_tipo_avaliacao, nr_seq_tipo_aval_p) = 'S' 
						and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''));
						 
	if (ie_opcao_p = 'DA') then 
		ds_retorno_w	:= to_char(dt_avaliacao_w,'dd/mm/yyyy hh24:mi:ss');
	elsif (ie_opcao_p = 'DL') then 
		ds_retorno_w	:= to_char(dt_liberacao_w,'dd/mm/yyyy hh24:mi:ss');
	elsif (ie_opcao_p = 'AV') then 
		ds_retorno_w	:= nm_avaliador_w;
	end if;
 
end if;
		 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_aval_atend ( nr_seq_tipo_aval_p text, nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

