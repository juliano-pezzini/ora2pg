-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_mat_conversao ( cd_material_p text, ie_tipo_despesa_p text, nm_usuario_p text, ie_envio_receb_p text, nr_seq_contrato_p bigint, nr_seq_ops_congenere_p bigint, nr_seq_prestador_p bigint, nr_seq_material_p INOUT bigint, cd_material_envio_p INOUT text, ds_material_envio_p INOUT text, ie_tipo_tabela_p INOUT bigint, nr_seq_regra_p INOUT bigint, ie_tipo_conversao_p bigint default null) AS $body$
DECLARE


/*

	Para conversão de materiais, passado novo parâmetro ie_tipo_conversao_p. Anteriormente não passava, então apenas estou tratando 
	quando for 8 ou 9. Caso vier nulo, vai manter comportamento padrão para todas as conversões já utilizadas.
	
	8- Digitação de contas pelo portal
	9 - Complemento de contas
	
	Obs: Caso não for passado valor para parâmetro ie_tipo_conversao_p, então mantém comportamento normal das conversões já existentes. 
*/
				
				
ds_material_envio_w		varchar(255);
cd_material_envio_w		varchar(30);
cd_material_w			bigint;
ie_tipo_tabela_w		smallint;	
ie_valido_w				varchar(1);	
cd_mat_comparar_w		pls_material.cd_material_ops%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_material,
		a.nr_sequencia 	nr_sequencia,
		a.ie_complemento,
		a.ie_digitacao_portal,
		a.ie_xml,
		a.nr_seq_material_orig,
		a.ie_tipo_regra_mat,
		a.cd_material_orig_inicial,
		a.cd_material_orig_final
	from	pls_conversao_mat a
	where	clock_timestamp() between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,clock_timestamp())
	and (a.ie_tipo_despesa_mat = coalesce(ie_tipo_despesa_p,a.ie_tipo_despesa_mat) 	or coalesce(a.ie_tipo_despesa_mat::text, '') = '')
	and (a.ie_envio_receb = 'R' or coalesce(a.ie_envio_receb::text, '') = '')
	and (a.nr_seq_prestador = nr_seq_prestador_p or coalesce(a.nr_seq_prestador::text, '') = '')
	and 	a.ie_tipo_regra_mat = 'C'
	
union all

	SELECT	a.nr_seq_material,
		a.nr_sequencia	nr_sequencia,
		a.ie_complemento,
		a.ie_digitacao_portal,
		a.ie_xml,
		a.nr_seq_material_orig,
		a.ie_tipo_regra_mat,
		a.cd_material_orig_inicial,
		a.cd_material_orig_final
	from	pls_conversao_mat a
	where	clock_timestamp() between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,clock_timestamp())
	and (a.ie_tipo_despesa_mat = coalesce(ie_tipo_despesa_p,a.ie_tipo_despesa_mat) 	or coalesce(a.ie_tipo_despesa_mat::text, '') = '')
	and (a.ie_envio_receb = 'R' or coalesce(a.ie_envio_receb::text, '') = '')
	and (a.nr_seq_prestador = nr_seq_prestador_p or coalesce(a.nr_seq_prestador::text, '') = '')
	and 	a.ie_tipo_regra_mat = 'S'
	and 	(a.nr_seq_material_orig IS NOT NULL AND a.nr_seq_material_orig::text <> '')
	
union all

	select	a.nr_seq_material,
		a.nr_sequencia	nr_sequencia,
		a.ie_complemento,
		a.ie_digitacao_portal,
		a.ie_xml,
		a.nr_seq_material_orig,
		a.ie_tipo_regra_mat,
		a.cd_material_orig_inicial,
		a.cd_material_orig_final
	from	pls_conversao_mat a
	where	clock_timestamp() between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,clock_timestamp())
	and (a.ie_tipo_despesa_mat = coalesce(ie_tipo_despesa_p,a.ie_tipo_despesa_mat) 	or coalesce(a.ie_tipo_despesa_mat::text, '') = '')
	and (a.ie_envio_receb = 'R' or coalesce(a.ie_envio_receb::text, '') = '')
	and (a.nr_seq_prestador = nr_seq_prestador_p or coalesce(a.nr_seq_prestador::text, '') = '')
	and 	coalesce(a.ie_tipo_regra_mat,'N') = 'N'
	order by
		nr_sequencia;

C02 CURSOR FOR
	SELECT	a.cd_material_envio,
		a.ds_material_envio,
		a.ie_tipo_tabela,
		a.nr_sequencia
	from	pls_conversao_mat a
	where	clock_timestamp() between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,clock_timestamp())
	and (cd_material_w >= a.cd_material_orig_inicial				or coalesce(a.cd_material_orig_inicial::text, '') = '')
	and (cd_material_w <= a.cd_material_orig_final				or coalesce(a.cd_material_orig_final::text, '') = '')
	and (a.ie_tipo_despesa_mat = coalesce(ie_tipo_despesa_p,a.ie_tipo_despesa_mat) 	or coalesce(a.ie_tipo_despesa_mat::text, '') = '')
	and	((coalesce(a.nr_seq_contrato::text, '') = '') or (a.nr_seq_contrato = nr_seq_contrato_p))
	and	((coalesce(a.nr_seq_ops_congenere::text, '') = '') or (a.nr_seq_ops_congenere = nr_seq_ops_congenere_p))
	and (a.nr_seq_prestador = nr_seq_prestador_p or coalesce(a.nr_seq_prestador::text, '') = '')
	and	a.ie_envio_receb = 'E'
	order by
		a.nr_sequencia;	
	
BEGIN
cd_material_envio_p	:= null;
ds_material_envio_p	:= null;
nr_seq_material_p	:= null;

begin
cd_material_w	:= (cd_material_p)::numeric;

exception
when others then
	cd_material_w	:= null;
end;

if (coalesce(ie_envio_receb_p, 'R') = 'R') then
	if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
		
		for r_c01_w in C01 loop
				
			--Se o tipo de restrição do material for por sequêcia, então obtém a sequência do material OPS, à partir da sequência apontada na regra

			--e após isso, comparar com o cd_material obtido no processo de importação. 
			ie_valido_w := 'S';			
			if (r_c01_w.ie_tipo_regra_mat = 'C') then		
				ie_valido_w := 'N';
				if ((cd_material_p >= r_c01_w.cd_material_orig_inicial				or coalesce(r_c01_w.cd_material_orig_inicial::text, '') = '') and (cd_material_p <= r_c01_w.cd_material_orig_final				or coalesce(r_c01_w.cd_material_orig_final::text, '') = ''))
				then
					ie_valido_w := 'S';
					
				elsif ((to_char(cd_material_w) >= r_c01_w.cd_material_orig_inicial				or coalesce(r_c01_w.cd_material_orig_inicial::text, '') = '') and (to_char(cd_material_w) <= r_c01_w.cd_material_orig_final				or coalesce(r_c01_w.cd_material_orig_final::text, '') = ''))
				then
					ie_valido_w := 'S';
				end if;
								
			end if;
			
			
			if (r_c01_w.ie_tipo_regra_mat = 'S') then
				ie_valido_w := 'N';
				
				cd_mat_comparar_w := pls_obter_seq_codigo_material(r_c01_w.nr_seq_material_orig , null);
				if ( cd_material_p = cd_mat_comparar_w) then
					ie_valido_w := 'S';
				end if;
			
			end if;
									
			if (ie_valido_w = 'S') then
				--Se conversão estiver sendo chamada do complemento ou da digitação de contas, a regra apenas é válida

				--caso ie_complemento = 'S' ou ie_digitacao_portal = 'S', respectivamente. Senão mantém comportamento normla

				--da verificação da regra
				if (ie_tipo_conversao_p = 9) then
					if (r_c01_w.ie_complemento = 'S') then
						nr_seq_material_p 	:= r_c01_w.nr_seq_material;
						nr_seq_regra_p		:= r_c01_w.nr_sequencia;
					end if;
				elsif (ie_tipo_conversao_p = 8) then
					
					if (r_c01_w.ie_digitacao_portal = 'S') then
						nr_seq_material_p 	:= r_c01_w.nr_seq_material;
						nr_seq_regra_p		:= r_c01_w.nr_sequencia;
					end if;
				else
					nr_seq_material_p 	:= r_c01_w.nr_seq_material;
					nr_seq_regra_p		:= r_c01_w.nr_sequencia;
				end if;
			end if;
		
		end loop;
						
	end if;
elsif (coalesce(ie_envio_receb_p,'R') = 'E') then

		open C02;
		loop
		fetch C02 into	
			cd_material_envio_w,
			ds_material_envio_w,
			ie_tipo_tabela_w,
			nr_seq_regra_p;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			cd_material_envio_p	:= cd_material_envio_w;
			ds_material_envio_p	:= ds_material_envio_w;
			ie_tipo_tabela_p	:= ie_tipo_tabela_w;
			end;
		end loop;
		close C02;
end if;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_mat_conversao ( cd_material_p text, ie_tipo_despesa_p text, nm_usuario_p text, ie_envio_receb_p text, nr_seq_contrato_p bigint, nr_seq_ops_congenere_p bigint, nr_seq_prestador_p bigint, nr_seq_material_p INOUT bigint, cd_material_envio_p INOUT text, ds_material_envio_p INOUT text, ie_tipo_tabela_p INOUT bigint, nr_seq_regra_p INOUT bigint, ie_tipo_conversao_p bigint default null) FROM PUBLIC;

