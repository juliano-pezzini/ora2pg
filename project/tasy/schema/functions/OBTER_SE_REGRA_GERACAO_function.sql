-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_geracao ( nr_seq_regra_p bigint, nr_seq_episodio_p bigint, nr_seq_tipo_admissao_fat_p bigint, cd_setor_atendimento_p bigint default null) RETURNS varchar AS $body$
DECLARE


ie_regra_geracao_w 			varchar(1);
nr_seq_tipo_episodio_w 		episodio_paciente.nr_seq_tipo_episodio%type;


BEGIN
	select	CASE WHEN count(1)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_regra_geracao_w
	from	wl_regra_geracao rg,
			wl_regra_item ri,
			wl_regra_worklist rw
	where	rg.nr_seq_regra_item = ri.nr_sequencia
	and		rg.nr_seq_item = rw.nr_sequencia
	and		ri.nr_seq_regra = rw.nr_sequencia
	and		ri.ie_situacao = 'A'
	and		rg.nr_seq_regra_item = nr_seq_regra_p;
	
	if (ie_regra_geracao_w = 'N') then
	
		select 	max(x.nr_seq_tipo_episodio)
		into STRICT	nr_seq_tipo_episodio_w
		from	episodio_paciente x
		where	x.nr_sequencia = nr_seq_episodio_p;
		
		select	coalesce(max('S'),'N')
		into STRICT	ie_regra_geracao_w
		from	wl_regra_geracao rg
		where	rg.nr_seq_regra_item = nr_seq_regra_p
		and 	coalesce(rg.nr_seq_tipo_episodio,nr_seq_tipo_episodio_w) = nr_seq_tipo_episodio_w
		and (coalesce(nr_seq_tipo_admissao_fat_p::text, '') = '' or (coalesce(rg.nr_seq_tipo_admissao_fat,nr_seq_tipo_admissao_fat_p) = nr_seq_tipo_admissao_fat_p))
		and (coalesce(cd_setor_atendimento_p::text, '') = '' or (coalesce(rg.cd_setor_atendimento,cd_setor_atendimento_p) = cd_setor_atendimento_p));
		
	end if;
	
	return ie_regra_geracao_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_geracao ( nr_seq_regra_p bigint, nr_seq_episodio_p bigint, nr_seq_tipo_admissao_fat_p bigint, cd_setor_atendimento_p bigint default null) FROM PUBLIC;

