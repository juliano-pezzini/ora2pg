-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_evento_sae ( nr_seq_resultado_p bigint, nr_seq_item_examinar_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_evento_w			bigint;
qt_reg_w				bigint;
cd_estabelecimento_w	smallint;
cd_perfil_w				bigint;


BEGIN

cd_estabelecimento_w		:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);
cd_perfil_w					:= coalesce(obter_perfil_ativo,0);

Select 	coalesce(max(nr_seq_evento),0)
into STRICT   	nr_seq_evento_w
from   	regra_eventos_result_sae
where	coalesce(cd_estabelecimento,cd_estabelecimento_w)	= cd_estabelecimento_w
and		coalesce(cd_perfil,cd_perfil_w)	= cd_perfil_w
and		nr_seq_resultado = nr_seq_resultado_p
and		nr_seq_item_examinar = nr_seq_item_examinar_p;

return nr_seq_evento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_evento_sae ( nr_seq_resultado_p bigint, nr_seq_item_examinar_p bigint) FROM PUBLIC;

