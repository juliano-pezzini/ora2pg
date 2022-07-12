-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_servico_hc ( nr_seq_servico_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_servicos_w				varchar(4000);
ie_exibir_procedimentos_w		varchar(1);

BEGIN

ie_exibir_procedimentos_w := obter_param_usuario(867, 91, obter_perfil_ativo, Wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_exibir_procedimentos_w);

if (ie_exibir_procedimentos_w = 'S') and (nr_seq_servico_p IS NOT NULL AND nr_seq_servico_p::text <> '') then

	select	max(ds_servico)
	into STRICT	ds_servicos_w
	from	hc_servico
	where	nr_sequencia = nr_seq_servico_p;WITH RECURSIVE cte AS (


elsif (ie_exibir_procedimentos_w = 'N') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	max(ltrim(ds_servico,', ')) ds_servico
	into STRICT	ds_servicos_w
	from (
		SELECT	a.ds_servico,
		row_number() over (order by ds_servico) as fila
		from	hc_servico a,
			hc_paciente_servico b,
			paciente_home_care c
		where	a.nr_sequencia = b.nr_seq_servico
		and	b.nr_seq_pac_home_care = c.nr_sequencia
		and	c.cd_pessoa_fisica = cd_pessoa_fisica_p) alias7 WHERE fila = 1
  UNION ALL


elsif (ie_exibir_procedimentos_w = 'N') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	c.ds_servicos_w || ', ' || max(ltrim(ds_servico,', ')) ds_servico
	into STRICT	ds_servicos_w
	from (
		SELECT	a.ds_servico,
		row_number() over (order by ds_servico) as fila
		from	hc_servico a,
			hc_paciente_servico b,
			paciente_home_care c
		where	a.nr_sequencia = b.nr_seq_servico
		and	b.nr_seq_pac_home_care = c.nr_sequencia
		and	c.cd_pessoa_fisica = cd_pessoa_fisica_p) JOIN cte c ON (c.prior fila = alias7.(fila-1) and level <)

) SELECT * FROM cte WHERE connect_by_isleaf = 1;
;
end if;

return	substr(ds_servicos_w, 1, 255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_servico_hc ( nr_seq_servico_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

