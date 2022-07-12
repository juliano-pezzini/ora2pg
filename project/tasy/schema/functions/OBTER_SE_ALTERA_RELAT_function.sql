-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_altera_relat ( nr_seq_relatorio_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

 
cd_classificacao_w		varchar(1);
ie_retorno_w			varchar(1) := 'S';
qt_registro_w			bigint;


BEGIN 
 
select	upper(substr(cd_classif_relat,1,1)) 
into STRICT	cd_classificacao_w 
from	relatorio 
where	nr_sequencia	= nr_seq_relatorio_p;
 
if (cd_classificacao_w = 'W') then 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	usuario_grupo_des 
	where	nm_usuario_grupo = nm_usuario_p;
	 
	if (qt_registro_w = 0) then 
		ie_retorno_w	:= 'N';
	end if;
end if;
 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_altera_relat ( nr_seq_relatorio_p bigint, nm_usuario_p text) FROM PUBLIC;
