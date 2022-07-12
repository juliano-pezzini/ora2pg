-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_permite_bio_cirur ( cd_medico_p pessoa_fisica.cd_pessoa_fisica%type) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Validar se o medico esta apto a fazer checkin/checkout na execucao cirurgica
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ x] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
	

ds_retorno_w			varchar(1)	:= 'S';
	

BEGIN

--Verifica se o medico nao esta com participacao cirurgica em andamento.
select	CASE WHEN count(1)=0 THEN 'S'  ELSE 'N' END
into STRICT	ds_retorno_w
from	pls_controle_biometria_med
where	cd_medico	= cd_medico_p
and	(dt_check_in IS NOT NULL AND dt_check_in::text <> '')
and	coalesce(dt_check_out::text, '') = '';

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_permite_bio_cirur ( cd_medico_p pessoa_fisica.cd_pessoa_fisica%type) FROM PUBLIC;

