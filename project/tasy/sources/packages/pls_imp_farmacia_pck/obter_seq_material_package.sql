-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_imp_farmacia_pck.obter_seq_material ( cd_ean_w brasindice_preco.cd_ean%type) RETURNS PLS_MATERIAL.NR_SEQUENCIA%TYPE AS $body$
DECLARE


cd_material_w     pls_material.cd_material%type;
nr_seq_material_w   pls_material.nr_sequencia%type;


BEGIN

  --Procura um EAN na Brasindice COM TUSS

  select max(y.nr_sequencia)
  into STRICT  nr_seq_material_w
  from  brasindice_preco x,
	pls_material y,
	tuss_material_item z
  where z.nr_sequencia = y.nr_seq_tuss_mat_item
  and x.cd_tuss = z.cd_material_tuss
  and x.cd_ean = cd_ean_w
  and x.dt_inicio_vigencia = (SELECT max(d.dt_inicio_vigencia)
         from brasindice_preco d
         where d.cd_tuss  = z.cd_material_tuss);
	
	if (coalesce(nr_seq_material_w::text, '') = '') then --Procura um EAN na Brasindice SEM TUSS
	
	select max(y.nr_sequencia)
	into STRICT nr_seq_material_w
	from 	brasindice_preco x,
		pls_material y
	where x.cd_tiss = y.cd_tiss_brasindice
	and x.cd_ean = cd_ean_w
	and x.dt_inicio_vigencia = (SELECT max(d.dt_inicio_vigencia)
		from brasindice_preco d
		where d.cd_ean = x.cd_ean);
		
	end if;
	
	if (coalesce(nr_seq_material_w::text, '') = '') then -- Procura um EAN na Simpro COM TUSS
	
	select max(y.nr_sequencia)
	into STRICT nr_seq_material_w
	from 	simpro_preco  x,
		pls_material y,
		tuss_material_item z
	where z.nr_sequencia = y.nr_seq_tuss_mat_item
	and x.cd_tuss = z.cd_material_tuss
	and x.nr_codigo_barra = cd_ean_w 
	and x.dt_vigencia = (SELECT max(d.dt_vigencia)
		from simpro_preco d
		where d.cd_tuss = z.cd_material_tuss);
	
	end if;
	
	if (coalesce(nr_seq_material_w::text, '') = '') then -- Procura um EAN na Simpro SEM TUSS
	
	select max(y.nr_sequencia)
	into STRICT nr_seq_material_w
	from 	simpro_preco x,
		pls_material y
	where x.cd_simpro = y.cd_simpro
	and x.nr_codigo_barra = cd_ean_w
	and x.dt_vigencia = (SELECT max(d.dt_vigencia)
		from simpro_preco d
		where d.nr_codigo_barra = x.nr_codigo_barra);
		
	end if;
	
	if (coalesce(nr_seq_material_w::text, '') = '') then --Procura um EAN que tenha sido cadastrado direto como codigo de material
	
	select max(nr_sequencia)
	into STRICT nr_seq_material_w
	from pls_material
	Where cd_material_ops = cd_ean_w
	and (coalesce(dt_exclusao::text, '') = ''
		or dt_exclusao >= trunc(clock_timestamp()));
	end if;

  return nr_seq_material_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_imp_farmacia_pck.obter_seq_material ( cd_ean_w brasindice_preco.cd_ean%type) FROM PUBLIC;
