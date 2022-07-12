-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_moviment_benef_a1300_pck.preparar_pre_dados_geracao () AS $body$
DECLARE

	
	nr_seq_regiao_w			bigint;
	index_w				integer	:= 1;
	nr_seq_plano_w			bigint;
	
	C01 CURSOR FOR
		SELECT	nr_sequencia nr_seq_parentesco,
			cd_ptu
		from	grau_parentesco;
	
	C02 CURSOR FOR
		SELECT	a.nr_sequencia
		from	pls_plano		a
		where	a.ie_abrangencia	in ('GE','GM')
		and	a.ie_tipo_operacao	= 'B';
	
	C03 CURSOR FOR
		SELECT	b.cd_municipio_ibge,
			b.sg_estado,
			b.nr_seq_regiao,
			a.nr_sequencia nr_seq_plano,
			a.ie_abrangencia
		from	pls_plano_area		b,
			pls_plano		a
		where	b.nr_seq_plano		= a.nr_sequencia
		and	a.ie_abrangencia	in ('GE','GM')
		and	a.ie_tipo_operacao	= 'B'
		and	a.nr_sequencia		= nr_seq_plano_w;
	
	C04 CURSOR FOR
		SELECT	b.sg_uf_municipio,
			b.cd_municipio_ibge
		from	pls_regiao_local	b,
			pls_regiao		a
		where	b.nr_seq_regiao		= a.nr_sequencia
		and	a.nr_sequencia		= nr_seq_regiao_w;
	
	
BEGIN
	
	current_setting('ptu_moviment_benef_a1300_pck.grau_parentesco_w')::grau_parentesco_v.delete;
	
	--Armazena todos os grau de parentesco do sistema, junto com o codigo do PTU

	for r_c01_w in C01 loop
		begin
		current_setting('ptu_moviment_benef_a1300_pck.grau_parentesco_w')::grau_parentesco_v[index_w].nr_seq_parentesco	:= r_c01_w.nr_seq_parentesco;
		current_setting('ptu_moviment_benef_a1300_pck.grau_parentesco_w')::grau_parentesco_v[index_w].cd_ptu		:= r_c01_w.cd_ptu;
		
		index_w	:= index_w + 1;
		end;
	end loop;
	
	index_w	:= 1;
	
	current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano.delete;
	
	--Armazena todos os produtos de abrangencia de grupos

	for r_c02_w in C02 loop
		begin
		
		nr_seq_plano_w	:= r_c02_w.nr_sequencia;
		index_w	:= 1;
		
		for r_c03_w in C03 loop
			begin
			if (r_c03_w.nr_seq_regiao IS NOT NULL AND r_c03_w.nr_seq_regiao::text <> '') then
				nr_seq_regiao_w	:= r_c03_w.nr_seq_regiao;
				for r_c04_w in C04 loop
					begin
					
					if (r_c03_w.ie_abrangencia = 'GM') then
						current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano[nr_seq_plano_w].sg_estado(index_w)	:= '';
					else
						current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano[nr_seq_plano_w].sg_estado(index_w)	:= coalesce(r_c04_w.sg_uf_municipio, r_c03_w.sg_estado);
					end if;
					
					if (r_c03_w.ie_abrangencia = 'GE') then
						current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano[nr_seq_plano_w].cd_municipio_ibge(index_w)	:= '';
					else
						current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano[nr_seq_plano_w].cd_municipio_ibge(index_w)	:= coalesce(r_c04_w.cd_municipio_ibge, r_c03_w.cd_municipio_ibge);
					end if;
					
					index_w	:= index_w + 1;
					end;
				end loop;
			else
				current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano[nr_seq_plano_w].sg_estado(index_w)		:= r_c03_w.sg_estado;
				current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano[nr_seq_plano_w].cd_municipio_ibge(index_w)	:= r_c03_w.cd_municipio_ibge;
				index_w	:= index_w + 1;
			end if;
			end;
		end loop;
		end;
	end loop;
	
	--Limpar o vetor de inconsistencias

	current_setting('ptu_moviment_benef_a1300_pck.log_inconsistencias_w')::log_inconsistencias_record.nr_seq_mov_empresa.delete;
	current_setting('ptu_moviment_benef_a1300_pck.log_inconsistencias_w')::log_inconsistencias_record.nr_seq_contrato.delete;
	current_setting('ptu_moviment_benef_a1300_pck.log_inconsistencias_w')::log_inconsistencias_record.nr_seq_mov_segurado.delete;
	current_setting('ptu_moviment_benef_a1300_pck.log_inconsistencias_w')::log_inconsistencias_record.cd_pessoa_fisica.delete;
	current_setting('ptu_moviment_benef_a1300_pck.log_inconsistencias_w')::log_inconsistencias_record.nr_seq_segurado.delete;
	current_setting('ptu_moviment_benef_a1300_pck.log_inconsistencias_w')::log_inconsistencias_record.ds_inconsistencia.delete;
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_moviment_benef_a1300_pck.preparar_pre_dados_geracao () FROM PUBLIC;