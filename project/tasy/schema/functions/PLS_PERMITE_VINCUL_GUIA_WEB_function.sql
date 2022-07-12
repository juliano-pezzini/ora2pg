-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_permite_vincul_guia_web ( cd_estabelecimento_p bigint, nr_seq_guia_p text) RETURNS varchar AS $body$
DECLARE

       
qt_reg_conta_w     bigint 	:= 0;
ie_retorno_w      varchar(1) := 'S';
ie_guia_unica_w			varchar(2);

/* 
ie_retorno_w = 
  'N'   : Não 
  'S'   : Sim 
*/
 
     

BEGIN 
 
	/* 
	Verifica na função OPS - Gestão de operadoras > Parâmetros OPS > Contas médicas se a regra 
	bloqueia o uso de uma guia por mais de uma conta.(atributo IE_GUIA_UNICA, tabela PLS_PARAMETROS) 
	*/
 
	select	coalesce(max(a.ie_guia_unica),'N') 
	into STRICT	ie_guia_unica_w 
	from  	pls_parametros a 
	where 	a.cd_estabelecimento	= cd_estabelecimento_p;
	 
	if ( ie_guia_unica_w = 'S' ) then 
		 
		/* Verifica se a guia ja foi vinculada à outra conta */
 
		select count(1)  
		into STRICT  qt_reg_conta_w 
		from  pls_conta  
		where  nr_seq_guia = nr_seq_guia_p 
		and   ie_status not in ('C','U');
			 
		if ( qt_reg_conta_w > 0) then 
			ie_retorno_w := 'N';
		end if;
	 
	end if;
 
return  ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_permite_vincul_guia_web ( cd_estabelecimento_p bigint, nr_seq_guia_p text) FROM PUBLIC;

