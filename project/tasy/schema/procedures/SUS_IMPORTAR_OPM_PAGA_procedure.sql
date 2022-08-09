-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_importar_opm_paga ( nr_aih_p bigint, cd_processo_p bigint, cd_proc_realizado_p bigint, cd_proc_opm_p bigint, qt_opm_p bigint, ds_opm_p text, cd_cgc_fornecedor_p text, ds_fornecedor_p text, nr_nota_fiscal_p text, nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
dt_apres_w	timestamp;


BEGIN 
 
select	dt_mesano_referencia 
into STRICT	dt_apres_w 
from	protocolo_convenio 
where	nr_seq_protocolo	= nr_seq_protocolo_p;
 
insert into sus_aih_opm_paga( 
			nr_sequencia, 
			nr_aih, 
			nr_processo, 
			dt_apresentacao, 
			cd_cgc_fornecedor, 
			cd_proc_realizado, 
			cd_proc_opm, 
			qt_opm, 
			dt_atualizacao, 
			nm_usuario, 
			ds_opm, 
			ds_fornecedor, 
			nr_nota_fiscal, 
			nr_seq_protocolo, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec) 
		values ( 
			nextval('sus_aih_opm_paga_seq'), 
			nr_aih_p, 
			cd_processo_p, 
			dt_apres_w, 
			cd_cgc_fornecedor_p, 
			cd_proc_realizado_p, 
			cd_proc_opm_p, 
			qt_opm_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			ds_opm_p, 
			ds_fornecedor_p, 
			nr_nota_fiscal_p, 
			nr_seq_protocolo_p, 
			clock_timestamp(), 
			nm_usuario_p);
 
commit;	
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_importar_opm_paga ( nr_aih_p bigint, cd_processo_p bigint, cd_proc_realizado_p bigint, cd_proc_opm_p bigint, qt_opm_p bigint, ds_opm_p text, cd_cgc_fornecedor_p text, ds_fornecedor_p text, nr_nota_fiscal_p text, nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
