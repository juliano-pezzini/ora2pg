-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_convenio_pck.tiss_obter_versao ( cd_convenio_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp default null, ie_tipo_tiss_p text default null) RETURNS varchar AS $body$
DECLARE

				
nr_seq_xml_projeto_w	bigint;
ds_versao_w		varchar(50);
current_setting('tiss_convenio_pck.dt_referencia_w')::timestamp		timestamp;
indice_w		bigint;

nr_seq_tiss_conv_w	tiss_convenio.nr_sequencia%type;
ie_versao_tiss_w	tiss_convenio.ie_versao_tiss%type;
ie_tipo_tiss_w		tiss_convenio.ie_tipo_tiss%type;


BEGIN
nr_seq_xml_projeto_w := 0;
PERFORM set_config('tiss_convenio_pck.dt_referencia_w', coalesce(coalesce(tiss_convenio_pck.get_dt_referencia_tiss(),dt_referencia_p),current_setting('tiss_convenio_pck.dt_referencia_local_w')::timestamp), false);
ie_tipo_tiss_w := coalesce(ie_tipo_tiss_p, '7');

for i in 1..versoes_w.count loop
	begin
	if (current_setting('tiss_convenio_pck.versoes_w')::Vetor[i].cd_convenio	= cd_convenio_p) and (current_setting('tiss_convenio_pck.versoes_w')::Vetor[i].cd_estabelecimento = cd_estabelecimento_p) and (current_setting('tiss_convenio_pck.versoes_w')::Vetor[i].dt_referencia	= current_setting('tiss_convenio_pck.dt_referencia_w')::timestamp) and (current_setting('tiss_convenio_pck.versoes_w')::Vetor[i].ie_tipo_tiss	= ie_tipo_tiss_w) then
		return current_setting('tiss_convenio_pck.versoes_w')::Vetor[i].ds_versao;
	end if;
	end;
end loop;

TISS_OBTER_VALORES(cd_convenio_p,
	cd_estabelecimento_p, 
	ie_tipo_tiss_w,
	current_setting('tiss_convenio_pck.dt_referencia_w')::timestamp, 
	nr_seq_xml_projeto_w, 
	ie_versao_tiss_w, 
	nr_seq_tiss_conv_w);

if (nr_seq_xml_projeto_w > 0
	and (ie_versao_tiss_w IS NOT NULL AND ie_versao_tiss_w::text <> '')) then
	
	ds_versao_w := ie_versao_tiss_w;
	
else

	nr_seq_xml_projeto_w	:= tiss_convenio_pck.tiss_obter_xml_projeto(cd_convenio_p, cd_estabelecimento_p, '7',current_setting('tiss_convenio_pck.dt_referencia_w')::timestamp);

	select	max(ds_versao)
	into STRICT	ds_versao_w
	from	xml_projeto
	where	nr_sequencia	= nr_seq_xml_projeto_w;

end if;

indice_w	:= current_setting('tiss_convenio_pck.versoes_w')::Vetor.count+1;

current_setting('tiss_convenio_pck.versoes_w')::Vetor[indice_w].cd_convenio		:= cd_convenio_p;
current_setting('tiss_convenio_pck.versoes_w')::Vetor[indice_w].cd_estabelecimento	:= cd_estabelecimento_p;
current_setting('tiss_convenio_pck.versoes_w')::Vetor[indice_w].dt_referencia	:= current_setting('tiss_convenio_pck.dt_referencia_w')::timestamp;
current_setting('tiss_convenio_pck.versoes_w')::Vetor[indice_w].ds_versao		:= ds_versao_w;
current_setting('tiss_convenio_pck.versoes_w')::Vetor[indice_w].ie_tipo_tiss	:= ie_tipo_tiss_w;

return ds_versao_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_convenio_pck.tiss_obter_versao ( cd_convenio_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp default null, ie_tipo_tiss_p text default null) FROM PUBLIC;