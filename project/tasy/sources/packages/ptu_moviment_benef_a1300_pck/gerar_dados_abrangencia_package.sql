-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE ptu_mov_abrang_record AS (	nr_seq_mov_seg_plano	dbms_sql.number_table,
						sg_estado		dbms_sql.varchar2_table,
						cd_municipio_ibge	dbms_sql.varchar2_table);


CREATE OR REPLACE PROCEDURE ptu_moviment_benef_a1300_pck.gerar_dados_abrangencia ( dados_plano_benef_w dados_plano_benef_record) AS $body$
DECLARE

	
	ptu_mov_abrang_w		ptu_mov_abrang_record;
	index_w				integer := 1;
	nr_seq_plano_w			bigint;
	
	
BEGIN
	
	for i in dados_plano_benef_w.nr_seq_plano.first..dados_plano_benef_w.nr_seq_plano.count loop
		begin
		if (dados_plano_benef_w.ie_abrangencia(i) in ('2','4')) then
			if (current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano.exists(dados_plano_benef_w.nr_seq_plano(i))) then
				for j in current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano(dados_plano_benef_w.nr_seq_plano(i)).sg_estado.first..abrangencia_atend_w(dados_plano_benef_w.nr_seq_plano(i)).sg_estado.count loop
					begin
					ptu_mov_abrang_w.nr_seq_mov_seg_plano(index_w)	:= dados_plano_benef_w.nr_seq_mov_seg_plano(i);
					ptu_mov_abrang_w.sg_estado(index_w)		:= current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano(dados_plano_benef_w.nr_seq_plano(i)).sg_estado(j);
					ptu_mov_abrang_w.cd_municipio_ibge(index_w)	:= current_setting('ptu_moviment_benef_a1300_pck.abrangencia_atend_w')::tb_abran_plano(dados_plano_benef_w.nr_seq_plano(i)).cd_municipio_ibge(j);
					index_w	:= index_w + 1;
					end;
				end loop;
			else
				CALL ptu_moviment_benef_a1300_pck.gravar_log_inco_vetor(	null,null,dados_plano_benef_w.NR_SEQ_MOV_BENEF_SEG(i),
							dados_plano_benef_w.cd_pessoa_fisica(i),dados_plano_benef_w.nr_seq_segurado(i),
							wheb_mensagem_pck.get_texto(1107806)/*Falta a informacao de area de atuacao do produto do beneficiario (informacao obrigatoria para produtos de grupos municipais e estaduais)*/
);
			end if;
		end if;
		
		end;
	end loop;
	
	forall i in ptu_mov_abrang_w.nr_seq_mov_seg_plano.first .. ptu_mov_abrang_w.nr_seq_mov_seg_plano.last
		insert into ptu_mov_benef_seg_abrang(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_mov_seg_plano,sg_estado,cd_municipio_ibge)
		values (	nextval('ptu_mov_benef_seg_abrang_seq'),clock_timestamp(),get_nm_usuario,clock_timestamp(),get_nm_usuario,
				ptu_mov_abrang_w.nr_seq_mov_seg_plano(i),ptu_mov_abrang_w.sg_estado(i),ptu_mov_abrang_w.cd_municipio_ibge(i));
	
	PERFORM set_config('ptu_moviment_benef_a1300_pck.qt_total_r309_w', current_setting('ptu_moviment_benef_a1300_pck.qt_total_r309_w')::ptu_mov_benef_trailer.qt_total_r309%type + ptu_mov_abrang_w.nr_seq_mov_seg_plano.count, false);
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_moviment_benef_a1300_pck.gerar_dados_abrangencia ( dados_plano_benef_w dados_plano_benef_record) FROM PUBLIC;