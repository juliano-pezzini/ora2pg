-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proximo_nivel_dispo (nr_seq_processo_p bigint, ie_tipo_pre_cadastro_p text, cd_tipo_pessoa_fisica_p text, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


retorno_w 	smallint := null;


BEGIN							

	if (ie_tipo_pre_cadastro_p = 'FPF') then
		select min(pa.nr_nivel)
		into STRICT retorno_w
			from processo_avaliacao pa
			where pa.cd_tipo_pessoa = cd_tipo_pessoa_fisica_p 
			and pa.ie_tipo_processo = ie_tipo_pre_cadastro_p
			and pa.nr_nivel > coalesce((SELECT max(pca.nr_nivel) 
							   from PRE_CAD_AVALIACAO pca 
							   where pca.NR_SEQ_PRECAD_PF = nr_seq_processo_p), 0)
			and exists (select nr_sequencia 
						from USUARIO_PROCESSO_AVAL usu
						where pa.nr_sequencia = USU.NR_PROCESSO_AVAL);
							
	elsif (ie_tipo_pre_cadastro_p = 'FPJ') then
		select min(pa.nr_nivel)
		into STRICT retorno_w
		from processo_avaliacao pa 
		where pa.cd_tipo_pessoa = cd_tipo_pessoa_fisica_p 
		and pa.ie_tipo_processo = ie_tipo_pre_cadastro_p
		and pa.nr_nivel > coalesce((SELECT max(pca.nr_nivel) 
						from PRE_CAD_AVALIACAO pca 
						where pca.NR_SEQ_PRECAD_PJ = nr_seq_processo_p
						),0)
		and exists (select nr_sequencia 
						from USUARIO_PROCESSO_AVAL usu
						where pa.nr_sequencia = USU.NR_PROCESSO_AVAL);
	elsif (ie_tipo_pre_cadastro_p = 'MAT') then
		select min(pa.nr_nivel)
		into STRICT retorno_w
		from processo_avaliacao pa 
		where pa.ie_tipo_processo = ie_tipo_pre_cadastro_p
		and pa.nr_nivel > coalesce((
						   SELECT max(pca.nr_nivel) 
						   from pre_cad_avaliacao pca 
						   where pca.nr_seq_precad_mat = nr_seq_processo_p
						  ),0)
		and exists (SELECT nr_sequencia 
						from USUARIO_PROCESSO_AVAL usu
						where pa.nr_sequencia = USU.NR_PROCESSO_AVAL);
	end if;
	
		
	return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proximo_nivel_dispo (nr_seq_processo_p bigint, ie_tipo_pre_cadastro_p text, cd_tipo_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
