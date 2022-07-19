-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_reap_opm ( nr_seq_conta_reap_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_interno_conta_w		bigint;
qt_opm_w		bigint;
cd_barras_w		varchar(255);
vl_unitario_w		double precision;
vl_opm_w		double precision;
cd_opm_w		bigint;
ds_opm_w		varchar(255);
cd_autorizacao_w	varchar(255);
nr_seq_tiss_tabela_w	bigint;
cd_tabela_xml_w		varchar(10);

c01 CURSOR FOR
SELECT 	qt_opm,
	cd_barras,
	vl_unitario,
	vl_opm,
	cd_material,
	substr(coalesce(ds_opm,obter_desc_material(cd_material)),1,254),
	a.nr_seq_tiss_tabela
from	tiss_reap_opm a
where	a.nr_seq_conta  = nr_seq_conta_reap_p;


BEGIN

select	nr_interno_conta,
	cd_autorizacao
into STRICT	nr_interno_conta_w,
	cd_autorizacao_w
from	tiss_reap_conta
where	nr_sequencia	= nr_seq_conta_reap_p;

open c01;
loop
fetch c01 into
	qt_opm_w,
	cd_barras_w,
	vl_unitario_w,
	vl_opm_w,
	cd_opm_w,
	ds_opm_w,
	nr_seq_tiss_tabela_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select  nextval('tiss_conta_opm_exec_seq')
	into STRICT    nr_sequencia_w
	;

	select	max(cd_tabela_xml)
	into STRICT	cd_tabela_xml_w
	from	tiss_tipo_tabela
	where	nr_sequencia	= nr_seq_tiss_tabela_w;

	insert into tiss_conta_opm_exec(
		nr_sequencia,
		nr_seq_reap_conta,
		cd_autorizacao,
		dt_atualizacao,
		nr_interno_conta,
		qt_opm,
		cd_barras,
		vl_unitario_opm,
		vl_opm,
		cd_opm,
		ds_opm,
		nm_usuario,
		cd_tabela)
	values (	nr_sequencia_w,
		nr_seq_conta_reap_p,
		cd_autorizacao_w,
		clock_timestamp(),
		nr_interno_conta_w,
		qt_opm_w,
		cd_barras_w,
		vl_unitario_w,
		vl_opm_w,
		lpad(cd_opm_w,8,0),
		ds_opm_w,
		nm_usuario_p,
		cd_tabela_xml_w);

end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_reap_opm ( nr_seq_conta_reap_p bigint, nm_usuario_p text) FROM PUBLIC;

