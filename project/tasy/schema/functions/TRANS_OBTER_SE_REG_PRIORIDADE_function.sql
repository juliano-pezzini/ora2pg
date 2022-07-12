-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION trans_obter_se_reg_prioridade ( nm_usuario_p text, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
cd_pessoa_fisica_w		varchar(10);
ie_regra_prioridade_w		varchar(1);
ie_possui_solicitacao_aberta_w	varchar(1);
nr_sequencia_w			bigint;


BEGIN 
cd_pessoa_fisica_w := substr(obter_pf_usuario(nm_usuario_p, 'C'), 10);
 
select	max(ie_regra_prioridade) 
into STRICT	ie_regra_prioridade_w 
from	trans_solicitacao 
where	nr_sequencia = nr_sequencia_p 
and	cd_transportador = cd_pessoa_fisica_w;
 
select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  
into STRICT	ie_possui_solicitacao_aberta_w 
from	trans_solicitacao 
where	nr_sequencia <> nr_sequencia_p 
and	ie_status not in (8, 9) 
and	cd_transportador = cd_pessoa_fisica_w 
and	ie_regra_prioridade = 'S' 
and	coalesce(ie_regra_prioridade_w, 'N') = 'N';
 
If (ie_possui_solicitacao_aberta_w = 'S') then 
	return 'S';
else 
	return 'N';
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION trans_obter_se_reg_prioridade ( nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;

