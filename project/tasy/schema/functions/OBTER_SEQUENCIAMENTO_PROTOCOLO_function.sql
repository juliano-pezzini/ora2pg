-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sequenciamento_protocolo (cd_protooclo_p bigint, nr_seq_material_p bigint, nr_seq_medicacao_p bigint, nr_ciclo_p bigint, ds_ciclo_p bigint) RETURNS varchar AS $body$
DECLARE


nr_sequenciamento_w	regra_sequencia_medic.nr_sequenciamento%type;
ie_existe_regra_w		varchar(1) := 'N';


BEGIN

if (cd_protooclo_p IS NOT NULL AND cd_protooclo_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') and (nr_seq_medicacao_p IS NOT NULL AND nr_seq_medicacao_p::text <> '') then

	select 	coalesce(max('S'),'N')
	into STRICT	ie_existe_regra_w
	from 	regra_sequencia_medic
	where 	cd_protocolo     = cd_protooclo_p
	and	nr_seq_material  = nr_seq_material_p
	and	nr_seq_medicacao = nr_seq_medicacao_p;

	if (coalesce(ie_existe_regra_w,'N') = 'S') then
	   select max(nr_sequenciamento)
	   into STRICT	 nr_sequenciamento_w
	   from  regra_sequencia_medic
	   where cd_protocolo     = cd_protooclo_p
	   and	 nr_seq_material  = nr_seq_material_p
	   and	 nr_seq_medicacao = nr_seq_medicacao_p
	   and	 obter_se_contido(nr_ciclo_p,replace(upper(ds_ciclos),'C','')) = 'S'
	   and	 obter_se_contido(ds_ciclo_p,replace(upper(ds_dias),'D','')) = 'S';
	end if;
 end if;

return nr_sequenciamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sequenciamento_protocolo (cd_protooclo_p bigint, nr_seq_material_p bigint, nr_seq_medicacao_p bigint, nr_ciclo_p bigint, ds_ciclo_p bigint) FROM PUBLIC;

