-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION agente_anest_pck.obter_agente_anestesico ( ie_tipo_agente_p bigint, cd_estabelecimento_p bigint, ie_tipo_Halogenado_p bigint default null) RETURNS bigint AS $body$
DECLARE
	
	nr_seq_agente_anest_w  		bigint;
	ie_tipo_Halogenado_w		bigint	:= coalesce(ie_tipo_Halogenado_p,0);
	
	
BEGIN
	
	if (ie_tipo_Halogenado_w	> 0 )then
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_agente_anest_w
		from	agente_anestesico
		where	ie_situacao = 'A'
		and	coalesce(cd_estabelecimento, coalesce( cd_estabelecimento_p, 0)) =  coalesce( cd_estabelecimento_p, 0)
		and	IE_HALOG_TIPO	= ie_tipo_Halogenado_w;
		
		if (nr_seq_agente_anest_w IS NOT NULL AND nr_seq_agente_anest_w::text <> '') then
			return nr_seq_agente_anest_w;
		end if;
		
	end if;
	

	if (ie_tipo_agente_p = 2) then
		select 	max(nr_sequencia)
		into STRICT	nr_seq_agente_anest_w
		from	agente_anestesico
		where	ie_integracao = 'N2O'
		and	ie_situacao = 'A'
		and	coalesce(IE_HALOG_TIPO::text, '') = ''
		and	coalesce(cd_estabelecimento, coalesce( cd_estabelecimento_p, 0)) =  coalesce( cd_estabelecimento_p, 0);
	elsif (ie_tipo_agente_p = 3) then
		select 	max(nr_sequencia)
		into STRICT	nr_seq_agente_anest_w
		from	agente_anestesico
		where	ie_integracao = 'O2'
		and	ie_situacao = 'A'
		and 	ie_forma_farmaceutica <> 'LG'
		and	coalesce(IE_HALOG_TIPO::text, '') = ''
		and	coalesce(cd_estabelecimento, coalesce( cd_estabelecimento_p, 0)) =  coalesce( cd_estabelecimento_p, 0);
	elsif (ie_tipo_agente_p = 4) then
		select 	max(nr_sequencia)
		into STRICT	nr_seq_agente_anest_w
		from	agente_anestesico
		where	ie_integracao = 'O2'
		and 	ie_forma_farmaceutica = 'LG'
		and	coalesce(IE_HALOG_TIPO::text, '') = ''
		and	ie_situacao = 'A'
		and	coalesce(cd_estabelecimento, coalesce( cd_estabelecimento_p, 0)) =  coalesce( cd_estabelecimento_p, 0);
	end if;
	
	return nr_seq_agente_anest_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION agente_anest_pck.obter_agente_anestesico ( ie_tipo_agente_p bigint, cd_estabelecimento_p bigint, ie_tipo_Halogenado_p bigint default null) FROM PUBLIC;