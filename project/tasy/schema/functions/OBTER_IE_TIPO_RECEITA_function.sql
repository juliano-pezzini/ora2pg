-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ie_tipo_receita (ie_tipo_receita_p text, nr_prescricao_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_gerado_w	 varchar(1) := 'N';


BEGIN

select coalesce(max('S'),'N')
into STRICT  ie_gerado_w
from  w_gerar_receita
where nm_usuario    = nm_usuario_p
and	  nr_prescricao = nr_prescricao_p
and   upper(coalesce(ie_tipo_receita,'P')) = upper(ie_tipo_receita_p)  LIMIT 1;

return ie_gerado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ie_tipo_receita (ie_tipo_receita_p text, nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
