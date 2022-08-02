-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_lag_consistir_cobert_mat ( nr_seq_lote_guia_imp_p bigint, nr_seq_lote_mat_imp_p bigint, nr_seq_guia_plano_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Consistir se o 'Material informado não coberto'.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_despesa_w		varchar(10);
cd_material_w			varchar(10);
ie_tipo_atendimento_ww		varchar(2);
ie_tipo_atendimento_w		varchar(2);
ie_regulamentacao_w		varchar(2);
ie_sexo_ww			varchar(2);
ie_sexo_w			varchar(2);
ie_tipo_cobertura_ww		varchar(1)	:= 'X';
ie_tipo_cobertura_w		varchar(1)	:= 'X';
ie_cobertura_ww			varchar(1) 	:= 'N';
ie_estrut_mat_w			varchar(1);
ie_cobertura_w			varchar(1)	:= 'N';
nr_seq_grupo_material_w		bigint;
nr_seq_estrut_regra_w		bigint;
nr_seq_estrut_mat_w		bigint;
nr_seq_cobertura_ww		bigint;
nr_seq_cobertura_w		bigint;
nr_seq_contrato_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_material_w		bigint;
nr_seq_plano_w			bigint;

c01 CURSOR FOR
	SELECT	a.ie_cobertura,
		c.nr_sequencia,
		c.ie_tipo_atendimento,
		c.ie_sexo,
		CASE WHEN coalesce(c.nr_seq_plano::text, '') = '' THEN 'C'  ELSE 'P' END ,
		a.nr_seq_grupo_material,
		a.nr_seq_estrut_mat
	from	pls_cobertura c,
		pls_tipo_cobertura b,
		pls_cobertura_mat a
	where	c.nr_seq_tipo_cobertura		= b.nr_sequencia
	and	a.nr_seq_tipo_cobertura 	= b.nr_sequencia
	and (a.nr_seq_material		= nr_seq_material_w or coalesce(a.nr_seq_material::text, '') = '')
	and	coalesce(a.ie_tipo_despesa, ie_tipo_despesa_w) = ie_tipo_despesa_w
	and	c.nr_sequencia	in (
					SELECT	x.nr_sequencia
					from	pls_cobertura x
					where	x.nr_seq_contrato		= nr_seq_contrato_w
					and (coalesce(nr_seq_plano_contrato::text, '') = ''	or nr_seq_plano_contrato	= nr_seq_plano_w)
					
union

					select	x.nr_sequencia
					from	pls_cobertura x
					where	x.nr_seq_plano	= nr_seq_plano_w
					and 	not exists (
						select 1
						from 	pls_cobertura x
						where	x.nr_seq_contrato	= nr_seq_contrato_w
						and (coalesce(nr_seq_plano_contrato::text, '') = ''	or nr_seq_plano_contrato	= nr_seq_plano_w)
						)
					)
	order by
		ie_tipo_despesa,
		a.nr_seq_estrut_mat,
		a.nr_seq_material;

BEGIN

select	cd_material
into STRICT	cd_material_w
from	pls_lote_anexo_mat_imp
where	nr_sequencia	= nr_seq_lote_mat_imp_p;

begin
	select	nr_sequencia,
		ie_tipo_despesa,
		nr_seq_estrut_mat
	into STRICT	nr_seq_material_w,
		ie_tipo_despesa_w,
		nr_seq_estrut_mat_w
	from	pls_material
	where	cd_material_ops = cd_material_w;
exception
when others then
	nr_seq_material_w	:= null;
	ie_tipo_despesa_w	:= null;
	nr_seq_estrut_mat_w	:= null;
end;

begin
select	nr_seq_plano,
	nr_seq_contrato
into STRICT	nr_seq_plano_w,
	nr_seq_contrato_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_w;
exception
when others then
	nr_seq_plano_w		:= 0;
	nr_seq_contrato_w	:= 0;
end;

select	max(ie_regulamentacao)
into STRICT	ie_regulamentacao_w
from	pls_plano
where	nr_sequencia	= nr_seq_plano_w;

if (ie_regulamentacao_w in ('P','A','R')) then
	open c01;
	loop
	fetch c01 into
		ie_cobertura_ww,
		nr_seq_cobertura_ww,
		ie_tipo_atendimento_ww,
		ie_sexo_ww,
		ie_tipo_cobertura_ww,
		nr_seq_grupo_material_w,
		nr_seq_estrut_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ie_estrut_mat_w		:= 'S';

		if (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
			if (pls_obter_se_mat_estrutura(nr_seq_material_w, nr_seq_estrut_regra_w) = 'N') then
				ie_estrut_mat_w	:= 'N';
			end if;
		end if;

		if (ie_estrut_mat_w = 'S') then
			if (nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then
				if (pls_se_grupo_preco_material(nr_seq_grupo_material_w, nr_seq_material_w) = 'S') then
					ie_cobertura_w		:= ie_cobertura_ww;
					nr_seq_cobertura_w	:= nr_seq_cobertura_ww;
					ie_tipo_atendimento_w	:= ie_tipo_atendimento_ww;
					ie_sexo_w		:= ie_sexo_ww;
					ie_tipo_cobertura_w	:= ie_tipo_cobertura_ww;
				else
					ie_cobertura_w		:= 'N';
					nr_seq_cobertura_w	:= nr_seq_cobertura_ww;
					ie_tipo_atendimento_w	:= ie_tipo_atendimento_ww;
					ie_sexo_w		:= ie_sexo_ww;
					ie_tipo_cobertura_w	:= ie_tipo_cobertura_ww;
				end if;
			else
				ie_cobertura_w		:= ie_cobertura_ww;
				nr_seq_cobertura_w	:= nr_seq_cobertura_ww;
				ie_tipo_atendimento_w	:= ie_tipo_atendimento_ww;
				ie_sexo_w		:= ie_sexo_ww;
				ie_tipo_cobertura_w	:= ie_tipo_cobertura_ww;
			end if;

			/*Caso houver cobertura para o material então sai do cursor*/

			if (ie_cobertura_w = 'S') then
				exit;
			end if;
		end if;
		end;
	end loop;
	close c01;

	if (ie_cobertura_w	= 'N') then

		CALL pls_inserir_anexo_glosa_aut('2006', nr_seq_lote_guia_imp_p, null, nr_seq_lote_mat_imp_p, '', nm_usuario_p);

	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_lag_consistir_cobert_mat ( nr_seq_lote_guia_imp_p bigint, nr_seq_lote_mat_imp_p bigint, nr_seq_guia_plano_p bigint, nm_usuario_p text) FROM PUBLIC;

