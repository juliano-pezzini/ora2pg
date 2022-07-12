-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pf_protocolo_opme ( cd_pessoa_p text, nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_retorno_w		varchar(1) := 'N';


BEGIN 
 
if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') and (cd_pessoa_p IS NOT NULL AND cd_pessoa_p::text <> '') then 
	select	coalesce(MAX('S'),'N') 
	into STRICT	ie_retorno_w 
	from  lote_producao_comp a 
	where  a.nr_seq_protocolo = nr_seq_protocolo_p 
	and (obter_nome_paciente_lote_opme(a.nr_lote_producao,'C')) = cd_pessoa_p;	
 
end if;
 
 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pf_protocolo_opme ( cd_pessoa_p text, nr_seq_protocolo_p bigint) FROM PUBLIC;

