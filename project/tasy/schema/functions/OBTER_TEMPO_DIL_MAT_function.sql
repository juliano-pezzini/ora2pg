-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_dil_mat ( nr_seq_paciente_p bigint, cd_material_p bigint, cd_diluente_p bigint, ie_via_aplicacao_p text default null) RETURNS bigint AS $body$
DECLARE


qt_minuto_aplicacao_w	smallint;
cd_estabelecimento_w	bigint;
qt_idade_w				bigint;
qt_peso_w				bigint;
cd_pessoa_fisica_w		varchar(10);


BEGIN
select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	paciente_setor
where	nr_seq_paciente = nr_seq_paciente_p;

cd_estabelecimento_w 	:= obter_estabelecimento_ativo;
qt_idade_w 				:= obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A');
qt_peso_w				:= obter_peso_pf(cd_pessoa_fisica_w);

select	max(qt_minuto_aplicacao)
into STRICT	qt_minuto_aplicacao_w
from	material_diluicao
where	cd_material 	= cd_material_p
and		cd_diluente 	= cd_diluente_p
and		cd_estabelecimento	= cd_estabelecimento_w
and		qt_idade_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,999)
and		qt_peso_w  between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999)
and		((coalesce(ie_via_aplicacao_p::text, '') = '') or (ie_via_aplicacao = ie_via_aplicacao_p));

return	qt_minuto_aplicacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_dil_mat ( nr_seq_paciente_p bigint, cd_material_p bigint, cd_diluente_p bigint, ie_via_aplicacao_p text default null) FROM PUBLIC;
