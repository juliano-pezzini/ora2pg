-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_recalcular_valores_result ( dt_referencia_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ X ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
dt_referencia_w		timestamp;


BEGIN 
if (length(dt_referencia_p) <= 7) then 
	dt_referencia_w	:= to_date('01/' || dt_referencia_p);
else 
	dt_referencia_w	:= to_date(dt_referencia_p);
end if;
 
delete	from pls_segurado_valores 
where	dt_mesano_referencia	= dt_referencia_w;
 
commit;
 
delete	from pls_resultado 
where	dt_mes_referencia	= dt_referencia_w 
and	coalesce(ie_importacao,'N')	= 'N';
 
commit;
 
CALL pls_gerar_valores_result_benef(	dt_referencia_w, 
				nm_usuario_p, 
				cd_estabelecimento_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_recalcular_valores_result ( dt_referencia_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

