-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_status_carteira (cd_usuario_plano_p text) RETURNS varchar AS $body$
DECLARE

 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade:  Obter o status da carteirinha 
---------------------------------------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ x ] Tasy (Delphi/Java) [ x ] Portal [ ] Relatórios [ ] Outros: 
 ---------------------------------------------------------------------------------------------------------------------------------------------------- 
Pontos de atenção:  
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/					 
 
ds_retorno_w		varchar(30) := '';


BEGIN 
 
select	substr(pls_obter_dados_segurado(a.nr_sequencia,'DS'),1,50) ds_situacao 
into STRICT	ds_retorno_w 
from	pls_segurado_carteira x, pls_segurado a 
where	x.cd_usuario_plano	= cd_usuario_plano_p 
and	a.nr_sequencia		= x.nr_seq_segurado 
group by substr(pls_obter_dados_segurado(a.nr_sequencia,'DS'),1,50);
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_status_carteira (cd_usuario_plano_p text) FROM PUBLIC;

