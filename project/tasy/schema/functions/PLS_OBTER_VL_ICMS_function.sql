-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_vl_icms ( nr_seq_operadora_p pls_protocolo_conta.nr_sequencia%type, dt_vigencia_p timestamp, nm_usuario_p text, nr_seq_material_p pls_material_unimed.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter valor de ICMS apartir do UF da operadora congenere
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
			
ds_retorno_w	pls_regra_icms.vl_perc_icms%type;
uf_operadora_w	pessoa_juridica.sg_estado%type;
ie_generico_w	pls_material_unimed.ie_generico%type := 'A';


BEGIN
if (nr_seq_operadora_p IS NOT NULL AND nr_seq_operadora_p::text <> '') then
	select	a.sg_estado
	into STRICT	uf_operadora_w
	from	pessoa_juridica	a,
		pls_congenere	b
	where	b.cd_cgc	= a.cd_cgc
	and	b.nr_sequencia	= nr_seq_operadora_p;

		if (uf_operadora_w IS NOT NULL AND uf_operadora_w::text <> '') then
			
			if (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then
				select	max(b.ie_generico)
				into STRICT	ie_generico_w
				from	pls_material_a900	a,
					pls_material_unimed	b
				where	b.cd_material		= a.cd_material_a900
				and 	b.nr_sequencia =  (	SELECT max(nr_sequencia) from (
												SELECT	b.nr_sequencia
												from	pls_material_a900	a,
													pls_material_unimed	b
												where	a.nr_seq_material	= nr_seq_material_p
												and	b.cd_material		= a.cd_material_a900
												and 	coalesce(a.dt_fim_vigencia::text, '') = ''
												and	a.dt_inicio_vigencia < dt_vigencia_p
												
union all

												select	b.nr_sequencia
												from	pls_material_a900	a,
													pls_material_unimed	b
												where	a.nr_seq_material	= nr_seq_material_p
												and	b.cd_material		= a.cd_material_a900
												and 	a.dt_fim_vigencia > dt_vigencia_p
												and 	a.dt_inicio_vigencia < dt_vigencia_p) alias5);
							
				if (coalesce(ie_generico_w::text, '') = '') then
					
					select	max(b.ie_generico)
					into STRICT	ie_generico_w
					from	pls_material_a900	a,
						pls_material_unimed	b
					where	a.nr_seq_material	= nr_seq_material_p
					and	b.cd_material		= a.cd_material_a900;
					
					if (coalesce(ie_generico_w::text, '') = '') then
					
						select coalesce(max(a.ie_generico),'N')
						into STRICT ie_generico_w
						from	pls_material_unimed a,
								pls_material b
						where b.nr_seq_material_unimed = a.nr_sequencia
						and		b.nr_sequencia = nr_seq_material_p;
					
					end if;
					
				end if;
			end if;	
			
			select	coalesce(max(a.vl_perc_icms),0)
			into STRICT	ds_retorno_w
			from	pls_regra_icms		a,
				pls_regra_icms_uf	b
			where	b.nr_seq_regra_icms	= a.nr_sequencia
			and	b.sg_estado		= uf_operadora_w
			and	((b.ie_generico		= ie_generico_w) or (b.ie_generico = 'A'))
			and	dt_vigencia_p between	a.dt_inicio_vigencia and a.dt_fim_vigencia_ref;
		end if;

	return	ds_retorno_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_vl_icms ( nr_seq_operadora_p pls_protocolo_conta.nr_sequencia%type, dt_vigencia_p timestamp, nm_usuario_p text, nr_seq_material_p pls_material_unimed.nr_sequencia%type) FROM PUBLIC;

