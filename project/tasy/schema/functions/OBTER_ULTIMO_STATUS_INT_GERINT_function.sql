-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_status_int_gerint (nr_atendimento_p bigint, nr_sequencia_p bigint, nr_protocolo_solicitacao_p text) RETURNS varchar AS $body$
DECLARE


ds_ultimo_status varchar(255);
cd_estab_ativo bigint;


BEGIN

	begin

		cd_estab_ativo := obter_estabelecimento_ativo;	
		
		select ie_situacao
		into STRICT	ds_ultimo_status
		 from (
		  SELECT *
		  FROM (SELECT substr(obter_valor_dominio(8590, ie_situacao), 1, 255) ie_situacao, ge.dt_atualizacao
				  FROM gerint_evento_integracao ge
				 WHERE ( ( (coalesce(ge.nr_seq_solic_inter::text, '') = '' and coalesce(nr_sequencia_p::text, '') = '') or ge.nr_seq_solic_inter  = nr_sequencia_p )
				   AND ( (coalesce(ge.nr_atendimento::text, '') = '' and coalesce(nr_atendimento_p::text, '') = '') or ge.nr_atendimento = nr_atendimento_p)
				   AND ( coalesce(ge.cd_estabelecimento::text, '') = ''  or ge.cd_estabelecimento = cd_estab_ativo) )
				
union
 
				select substr(obter_valor_dominio(8590, ie_situacao), 1, 255) ie_situacao, ge.dt_atualizacao
				FROM gerint_evento_integracao ge
				where ge.nr_protocolo_solicitacao = nr_protocolo_solicitacao_p        
				 ) alias15ORDER BY dt_atualizacao DESC
				 ) alias16 LIMIT 1;

	exception
	when others then
		ds_ultimo_status := obter_desc_expressao(331222);
	end;

return	ds_ultimo_status;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultimo_status_int_gerint (nr_atendimento_p bigint, nr_sequencia_p bigint, nr_protocolo_solicitacao_p text) FROM PUBLIC;

