-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_desc_tipo_atend_od (cd_tipo_atend_od_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter  e descriação do tipo de atendimento
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
ds_retorno_w
Retorna descrição  do atendimento, da tabela  tiss_tipo_atend_odont
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w	tiss_tipo_atend_odont.ds_tipo%type;


BEGIN

if (cd_tipo_atend_od_p IS NOT NULL AND cd_tipo_atend_od_p::text <> '')	then
	select	a.ds_tipo
	into STRICT	ds_retorno_w
	from	tiss_tipo_atend_odont a
	where	a.cd_tipo = cd_tipo_atend_od_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_desc_tipo_atend_od (cd_tipo_atend_od_p text) FROM PUBLIC;

