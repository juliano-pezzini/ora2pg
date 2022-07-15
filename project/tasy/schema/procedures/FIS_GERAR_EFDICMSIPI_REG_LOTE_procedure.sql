-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_efdicmsipi_reg_lote ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_registro_w			fis_efd_icmsipi_registros.ds_registros%type;
ds_registros_compl_w 		fis_efd_icmsipi_registros.ds_registros_compl%type;
nr_ordem_w 			fis_efd_icmsipi_registros.nr_ordem%type;
ie_nivel_w 			fis_efd_icmsipi_registros.ie_nivel%type;


c01 CURSOR FOR
SELECT  a.ds_registros,
	a.ds_registros_compl,
	a.nr_ordem,
	a.ie_nivel
from fis_efd_icmsipi_registros a
where a.ie_situacao 	= 'A'
order by a.nr_sequencia asc;


BEGIN

open c01;
loop
fetch c01 into	
	ds_registro_w,
	ds_registros_compl_w,
	nr_ordem_w,
	ie_nivel_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
		
	insert into fis_efd_icmsipi_reg_lote(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_lote,
		ds_registro,
		ds_registros_compl,
		ie_gerar,
		nr_ordem,
		ie_nivel)
	values (	nextval('fis_efd_icmsipi_reg_lote_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_sequencia_p,
		ds_registro_w,
		ds_registros_compl_w,
		'S',
		nr_ordem_w,
		ie_nivel_w);
	
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_efdicmsipi_reg_lote ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

