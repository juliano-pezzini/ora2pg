-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_sped_ecd_pck.persistir_registros_em_lote (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) AS $body$
DECLARE


type vetor_nr_sequencia is table of ctb_sped_registro.nr_sequencia%type index by integer;
v_nr_sequencia_w   vetor_nr_sequencia;

type vetor_ds_arquivo is table of ctb_sped_registro.ds_arquivo%type index by integer;
v_ds_arquivo_w   vetor_ds_arquivo;

type vetor_ds_arquivo_compl is table of ctb_sped_registro.ds_arquivo_compl%type index by integer;
v_ds_arquivo_compl_w   vetor_ds_arquivo_compl;

type vetor_cd_registro is table of ctb_sped_registro.cd_registro%type index by integer;
v_cd_registro_w   vetor_cd_registro;

type vetor_nr_linha is table of ctb_sped_registro.nr_linha%type index by integer;
v_nr_linha_w   vetor_nr_linha;
				
BEGIN

if (regra_sped_p.registros.count > 0) then
	/* Manter compatibilidade oracle 10g */

	for i in regra_sped_p.registros.first .. regra_sped_p.registros.last loop
		v_nr_sequencia_w(i)		:= regra_sped_p.registros[i].nr_sequencia;
		v_ds_arquivo_w(i)		:= regra_sped_p.registros[i].ds_arquivo;
		v_ds_arquivo_compl_w(i)		:= regra_sped_p.registros[i].ds_arquivo_compl;
		v_cd_registro_w(i)		:= regra_sped_p.registros[i].cd_registro;
		v_nr_linha_w(i)			:= regra_sped_p.registros[i].nr_linha;

	end loop;
	forall indice in regra_sped_p.registros.first .. regra_sped_p.registros.last
		insert into ctb_sped_registro( 
			nr_sequencia,          
			ds_arquivo,            
			dt_atualizacao,        
			nm_usuario,            
			dt_atualizacao_nrec,  
			nm_usuario_nrec,       
			nr_seq_controle_sped,  
			ds_arquivo_compl,      
			cd_registro,           
			nr_linha,
			ds_documento)
		values ( v_nr_sequencia_w(indice),
			v_ds_arquivo_w(indice),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			regra_sped_p.nr_seq_controle,
			v_ds_arquivo_compl_w(indice),
			v_cd_registro_w(indice),
			v_nr_linha_w(indice),
			regra_sped_p.ds_documento
		);
	commit;	
	regra_sped_p.registros.delete;
	v_nr_sequencia_w.delete;
	v_ds_arquivo_w.delete;	
	v_ds_arquivo_compl_w.delete;	
	v_cd_registro_w.delete;	
        v_nr_linha_w.delete;		
end if;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_sped_ecd_pck.persistir_registros_em_lote (regra_sped_p INOUT ctb_sped_ecd_pck.regra_sped, nm_usuario_p text) FROM PUBLIC;