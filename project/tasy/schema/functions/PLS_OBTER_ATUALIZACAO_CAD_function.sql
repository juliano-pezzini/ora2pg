-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_atualizacao_cad ( nr_seq_segurado_p bigint, ie_origem_validacao_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_solic_alt_w		bigint	:= null;
cd_pessoa_fisica_w		varchar(10) 	:= '';
ie_valida_tasy_w		varchar(1)	:= 'N';
ie_valida_portal_w		varchar(1)	:= 'N';
qt_dias_atualizacao_w		integer 	:= 0;
nr_seq_regra_atualizacao_w	bigint	:= null;
qt_atualizacao_w		integer	:= null;



C01 CURSOR FOR
	SELECT 	nr_sequencia,
		qt_dias_atualizacao
	from	pls_regra_atualizacao_cad
	where	dt_inicio_vigencia <= clock_timestamp()
	and 	(((dt_fim_vigencia IS NOT NULL AND dt_fim_vigencia::text <> '') and dt_fim_vigencia > clock_timestamp()) or (coalesce(dt_fim_vigencia::text, '') = ''))
	and	((ie_origem_validacao_p = 'P' and ie_valida_portal = 'S')  or ( ie_origem_validacao_p = 'T' and ie_valida_tasy = 'S' ));


BEGIN

select 	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	pls_segurado
where	nr_sequencia		= nr_seq_segurado_p
and	ie_tipo_segurado	in ('B','A','R')
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and (coalesce(dt_limite_utilizacao::text, '') = '' or dt_limite_utilizacao >= clock_timestamp());


if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
	select	coalesce(max(a.nr_sequencia),0)
	into STRICT	nr_seq_solic_alt_w
	from	tasy_solic_alteracao a,
		tasy_solic_alt_campo b
	where	coalesce(a.dt_analise::text, '') = ''
	and	a.nr_sequencia = b.nr_seq_solicitacao
	and	b.nm_tabela in ('PESSOA_FISICA', 'COMPL_PESSOA_FISICA')
	and (b.ds_chave_simples = cd_pessoa_fisica_w
		or (substr(b.ds_chave_composta,1,length('CD_PESSOA_FISICA='||cd_pessoa_fisica_w)) = 'CD_PESSOA_FISICA='||cd_pessoa_fisica_w));


	if ( nr_seq_solic_alt_w = 0 ) then
		open C01;
		loop
		fetch C01 into
			nr_seq_regra_atualizacao_w,
			qt_dias_atualizacao_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if ( (qt_dias_atualizacao_w IS NOT NULL AND qt_dias_atualizacao_w::text <> '') and qt_dias_atualizacao_w > 0 ) then
				select	count(1)
				into STRICT	qt_atualizacao_w
				from	pessoa_fisica
				where	cd_pessoa_fisica = cd_pessoa_fisica_w
				and	((coalesce(dt_revisao::text, '') = '')
				or	((dt_revisao + qt_dias_atualizacao_w) <= clock_timestamp()));

				if ( qt_atualizacao_w > 0 ) then
					exit;
				end if;
			end if;
			nr_seq_regra_atualizacao_w := 0;
			end;
		end loop;
		close C01;
	end if;
end if;

return	nr_seq_regra_atualizacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_atualizacao_cad ( nr_seq_segurado_p bigint, ie_origem_validacao_p text) FROM PUBLIC;
