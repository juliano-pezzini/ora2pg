-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_orient_preparo (nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, nr_seq_tipo_classif_pac_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_orientacao_w		varchar(4000) := '';
qt_idade_w		bigint;
ds_orient_paciente_w	varchar(4000) := '';
nr_seq_classif_w	bigint;
ds_orient_pac_preparo_w	varchar(4000);

ds_separador_w			varchar(25);

ie_utiliza_formatacao_w		varchar(1)	:= 'N';

C02 CURSOR FOR	 
	SELECT	ds_orient_preparo 
	from	proc_interno_pac_orient 
	where	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0) 
	and	coalesce(ie_situacao,'A') = 'A' 
	and	qt_idade_w between coalesce(qt_idade_min, qt_idade_w) and coalesce(qt_idade_max, qt_idade_w) 
	and (coalesce(nr_seq_classif, coalesce(nr_seq_classif_w,0)) = coalesce(nr_seq_classif_w,0)) 
	and (coalesce(nr_seq_tipo_classif_pac, coalesce(nr_seq_tipo_classif_pac_p,0)) = coalesce(nr_seq_tipo_classif_pac_p,0)) 
	and (coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,1)) = coalesce(cd_estabelecimento_p,1)) 
	order by	coalesce(nr_seq_proc_interno,0),	 
		coalesce(nr_seq_classif,0);

 

BEGIN 
 
ie_utiliza_formatacao_w := Obter_Param_Usuario(869, 91, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_utiliza_formatacao_w);
 
if (ie_utiliza_formatacao_w = 'S') then 
	ds_separador_w	:= '\par ';
else	 
	ds_separador_w	:= chr(13) || chr(10);
end if;
 
 
select	coalesce(max(campo_numerico(obter_idade_pf(cd_pessoa_fisica, clock_timestamp(), 'A'))),0) 
into STRICT	qt_idade_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
select	coalesce(max(nr_seq_classif),0) 
into STRICT	nr_seq_classif_w 
from	proc_interno 
where	nr_sequencia = nr_seq_proc_interno_p;
 
 
open C02;
loop 
fetch C02 into	 
	ds_orient_pac_preparo_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	ds_orient_pac_preparo_w	:= ds_orient_pac_preparo_w;
	end;
end loop;
close C02;
 
ds_orientacao_w	:= '';
ds_orientacao_w	:= substr(wheb_mensagem_pck.get_texto(791276) || ': ' || ds_separador_w || 
			 ds_separador_w || ds_orient_pac_preparo_w,1,4000);
	 
 
return ds_orientacao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_orient_preparo (nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, nr_seq_tipo_classif_pac_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

