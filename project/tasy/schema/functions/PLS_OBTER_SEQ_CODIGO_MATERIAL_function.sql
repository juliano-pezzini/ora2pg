-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_codigo_material ( nr_seq_material_p pls_material.nr_sequencia%type, cd_material_ops_p pls_material.cd_material_ops%type, ie_tentar_conv_p text default 'S', dt_material_conta_p timestamp default clock_timestamp()) RETURNS varchar AS $body$
DECLARE

		
ds_retorno_w		varchar(255);
nr_seq_material_w	pls_material.nr_sequencia%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
ie_ocorrencia_w 	pls_controle_estab.ie_ocorrencia%type := pls_obter_se_controle_estab('CMO');
parametro_material_w	varchar(1) := 'S';
			

BEGIN
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;


select	coalesce(max(ie_dt_atend_material), 'N')
into STRICT	parametro_material_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_w;


if (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

	select	max(cd_material_ops)
	into STRICT	ds_retorno_w
	from	pls_material
	where	nr_sequencia	= nr_seq_material_p;

elsif (cd_material_ops_p IS NOT NULL AND cd_material_ops_p::text <> '') then

	if (parametro_material_w = 'S') then
		
		if (ie_ocorrencia_w = 'S') then
	
			if (coalesce(ie_tentar_conv_p,'S') = 'S') then
				select max(nr_sequencia)
				into STRICT	nr_seq_material_w
				from (
					SELECT	nr_sequencia
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and	coalesce(dt_limite_utilizacao, dt_exclusao) > dt_material_conta_p
					and	dt_inclusao <= dt_material_conta_p
					and	cd_estabelecimento = cd_estabelecimento_w
					
union all

					SELECT nr_sequencia
					from pls_material
					where	cd_material_ops	= cd_material_ops_p
					and 	coalesce(dt_limite_utilizacao::text, '') = ''
					and 	coalesce(dt_exclusao::text, '') = ''
					and	dt_inclusao <= dt_material_conta_p
					and	cd_estabelecimento = cd_estabelecimento_w
					) alias9;
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					begin
						select max(nr_sequencia)
						into STRICT	nr_seq_material_w
						from (
							SELECT	nr_sequencia
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric
							and	coalesce(dt_limite_utilizacao, dt_exclusao) > dt_material_conta_p
							and	dt_inclusao <= dt_material_conta_p
							and	cd_estabelecimento = cd_estabelecimento_w
							
union all

							SELECT	nr_sequencia
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric 
							and 	coalesce(dt_limite_utilizacao::text, '') = ''
							and 	coalesce(dt_exclusao::text, '') = ''
							and	dt_inclusao <= dt_material_conta_p							
							and	cd_estabelecimento = cd_estabelecimento_w
							) alias8;
						
						if (coalesce(nr_seq_material_w::text, '') = '') then
							select	max(nr_sequencia)
							into STRICT	nr_seq_material_w
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric
							and	cd_estabelecimento = cd_estabelecimento_w;
						end if;
						
					exception
					when others then
						nr_seq_material_w := null;
					end;
					
					if (coalesce(nr_seq_material_w::text, '') = '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_material_w
						from	pls_material
						where	cd_material_ops	= cd_material_ops_p
						and	cd_estabelecimento = cd_estabelecimento_w;
					end if;
				end if;
			end if;
			
			if (coalesce(ie_tentar_conv_p,'S') = 'N') then
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_material_w
				from	pls_material
				where	cd_material_ops		= cd_material_ops_p
				and	coalesce(dt_limite_utilizacao, dt_exclusao) > dt_material_conta_p
				and	dt_inclusao <= dt_material_conta_p
				and	cd_estabelecimento 	= cd_estabelecimento_w;
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					select	max(nr_sequencia)
					into STRICT	nr_seq_material_w
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and	cd_estabelecimento = cd_estabelecimento_w;
				end if;
			end if;
			
			if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
				ds_retorno_w := to_char(nr_seq_material_w);
			end if;
		else			
			if (coalesce(ie_tentar_conv_p,'S') = 'S') then
				select max(nr_sequencia)
				into STRICT	nr_seq_material_w
				from (
					SELECT	nr_sequencia
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and	coalesce(dt_limite_utilizacao, dt_exclusao) > dt_material_conta_p
					and	dt_inclusao <= dt_material_conta_p					
					
union all

					SELECT	nr_sequencia
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and 	coalesce(dt_limite_utilizacao::text, '') = ''
					and 	coalesce(dt_exclusao::text, '') = ''
					and	dt_inclusao <= dt_material_conta_p
					) alias6;
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					begin
						select max(nr_sequencia)
						into STRICT	nr_seq_material_w
						from (
							SELECT	nr_sequencia
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric
							and	coalesce(dt_limite_utilizacao, dt_exclusao) > dt_material_conta_p
							and	dt_inclusao <= dt_material_conta_p
							
union all

							SELECT	nr_sequencia
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric 
							and 	coalesce(dt_limite_utilizacao::text, '') = ''
							and 	coalesce(dt_exclusao::text, '') = ''
							and	dt_inclusao <= dt_material_conta_p
							) alias8;
						
						if (coalesce(nr_seq_material_w::text, '') = '') then
							select	max(nr_sequencia)
							into STRICT	nr_seq_material_w
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric;
						end if;
						
					exception
					when others then
						nr_seq_material_w := null;
					end;
					
					if (coalesce(nr_seq_material_w::text, '') = '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_material_w
						from	pls_material
						where	cd_material_ops	= cd_material_ops_p;
					end if;
				end if;
			end if;
			
			if (coalesce(ie_tentar_conv_p,'S') = 'N') then
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_material_w
				from	pls_material
				where	cd_material_ops		= cd_material_ops_p
				and	coalesce(dt_limite_utilizacao, dt_exclusao) > dt_material_conta_p
				and	dt_inclusao <= dt_material_conta_p;
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					select	max(nr_sequencia)
					into STRICT	nr_seq_material_w
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and 	coalesce(dt_limite_utilizacao::text, '') = ''
					and 	coalesce(dt_exclusao::text, '') = ''
					and	dt_inclusao <= dt_material_conta_p;
				end if;
			end if;
			
			if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
				ds_retorno_w := to_char(nr_seq_material_w);
			end if;
		end if;
		
	else
		
		if (ie_ocorrencia_w = 'S') then
		
			if (coalesce(ie_tentar_conv_p,'S') = 'S') then
				select max(nr_sequencia)
				into STRICT	nr_seq_material_w
				from (
					SELECT	nr_sequencia
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and	coalesce(dt_referencia, to_date('30/12/1899', 'dd/mm/yyyy')) = to_date('30/12/1899', 'dd/mm/yyyy')
					and	cd_estabelecimento = cd_estabelecimento_w
					
union all

					SELECT	nr_sequencia
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and	dt_referencia > clock_timestamp()
					and	cd_estabelecimento = cd_estabelecimento_w
					) alias8;
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					begin
						select max(nr_sequencia)
						into STRICT	nr_seq_material_w
						from (
							SELECT	nr_sequencia
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric
							and	coalesce(dt_referencia, to_date('30/12/1899', 'dd/mm/yyyy')) = to_date('30/12/1899', 'dd/mm/yyyy')
							and	cd_estabelecimento = cd_estabelecimento_w
							
union all

							SELECT	nr_sequencia
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric 
							and	dt_referencia > clock_timestamp()
							and	cd_estabelecimento = cd_estabelecimento_w
							) alias9;
						
						if (coalesce(nr_seq_material_w::text, '') = '') then
							select	max(nr_sequencia)
							into STRICT	nr_seq_material_w
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric
							and	cd_estabelecimento = cd_estabelecimento_w;
						end if;
						
					exception
					when others then
						nr_seq_material_w := null;
					end;
					
					if (coalesce(nr_seq_material_w::text, '') = '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_material_w
						from	pls_material
						where	cd_material_ops	= cd_material_ops_p
						and	cd_estabelecimento = cd_estabelecimento_w;
					end if;
				end if;
			end if;
			
			if (coalesce(ie_tentar_conv_p,'S') = 'N') then
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_material_w
				from	pls_material
				where	cd_material_ops		= cd_material_ops_p
				and	dt_fim_vigencia_ref 	> clock_timestamp()
				and	cd_estabelecimento 	= cd_estabelecimento_w;
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					select	max(nr_sequencia)
					into STRICT	nr_seq_material_w
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and	cd_estabelecimento = cd_estabelecimento_w;
				end if;
			end if;
			
			if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
				ds_retorno_w := to_char(nr_seq_material_w);
			end if;
		else
			if (coalesce(ie_tentar_conv_p,'S') = 'S') then
				select max(nr_sequencia)
				into STRICT	nr_seq_material_w
				from (
					SELECT	nr_sequencia
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and	coalesce(dt_referencia, to_date('30/12/1899', 'dd/mm/yyyy')) = to_date('30/12/1899', 'dd/mm/yyyy')
					
union all

					SELECT	nr_sequencia
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p
					and	dt_referencia > clock_timestamp()
					) alias7;
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					begin
						select max(nr_sequencia)
						into STRICT	nr_seq_material_w
						from (
							SELECT	nr_sequencia
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric
							and	coalesce(dt_referencia, to_date('30/12/1899', 'dd/mm/yyyy')) = to_date('30/12/1899', 'dd/mm/yyyy')
							
union all

							SELECT	nr_sequencia
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric 
							and	dt_referencia > clock_timestamp()
							) alias9;
						
						if (coalesce(nr_seq_material_w::text, '') = '') then
							select	max(nr_sequencia)
							into STRICT	nr_seq_material_w
							from	pls_material
							where	cd_material_ops_number	= (cd_material_ops_p)::numeric;
						end if;
						
					exception
					when others then
						nr_seq_material_w := null;
					end;
					
					if (coalesce(nr_seq_material_w::text, '') = '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_material_w
						from	pls_material
						where	cd_material_ops	= cd_material_ops_p;
					end if;
				end if;
			end if;
			
			if (coalesce(ie_tentar_conv_p,'S') = 'N') then
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_material_w
				from	pls_material
				where	cd_material_ops		= cd_material_ops_p
				and	dt_fim_vigencia_ref 	> clock_timestamp();
				
				if (coalesce(nr_seq_material_w::text, '') = '') then
					select	max(nr_sequencia)
					into STRICT	nr_seq_material_w
					from	pls_material
					where	cd_material_ops	= cd_material_ops_p;
				end if;
			end if;
			
			if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
				ds_retorno_w := to_char(nr_seq_material_w);
			end if;
		end if;
	end if;	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_codigo_material ( nr_seq_material_p pls_material.nr_sequencia%type, cd_material_ops_p pls_material.cd_material_ops%type, ie_tentar_conv_p text default 'S', dt_material_conta_p timestamp default clock_timestamp()) FROM PUBLIC;
