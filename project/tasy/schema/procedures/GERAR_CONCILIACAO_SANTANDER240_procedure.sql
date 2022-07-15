-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_conciliacao_santander240 (nr_seq_extrato_p bigint, nm_usuario_p text) AS $body$
DECLARE



vl_saldo_inicial_w	double precision;
vl_saldo_final_w	double precision;
dt_saldo_inicial_w	timestamp;
dt_saldo_final_w	timestamp;
cd_registro_w		smallint;
cd_agencia_w		smallint;
cd_conta_w		integer;
ie_tipo_registro_w	varchar(1);
cd_historico_w		varchar(4);
ds_historico_w		varchar(25);
nr_documento_w		integer;
dt_movto_w		timestamp;
vl_extrato_w		double precision;
ie_deb_cred_w		varchar(1);
ie_natureza_w		varchar(1);
cd_categoria_w		varchar(3);
nr_seq_conta_w		bigint;

c01 CURSOR FOR
SELECT	substr(ds_conteudo,1,1),
	substr(ds_conteudo,18,4),
	substr(ds_conteudo,22,7),
	substr(ds_conteudo,42,1),
	substr(ds_conteudo,43,3),
	substr(ds_conteudo,46,4),
	substr(ds_conteudo,50,25),
	substr(ds_conteudo,75,6),
	substr(ds_conteudo,81,6),
	somente_numero(substr(ds_conteudo,87,16)) || ',' || LPAD(somente_numero(substr(ds_conteudo,103,2)),2,0),
	substr(ds_conteudo,105,1),
	CASE WHEN substr(ds_conteudo,183,1)='1' THEN 'D' WHEN substr(ds_conteudo,183,1)='2' THEN 'B'  ELSE 'V' END
from	w_interf_concil
where	substr(ds_conteudo,1,1) = '1'
and	substr(ds_conteudo,42,1) = '1'
and	nr_seq_conta = nr_seq_conta_w;


BEGIN

select	nr_seq_conta
into STRICT	nr_seq_conta_w
from	banco_extrato
where	nr_sequencia	= nr_seq_extrato_p;

select	somente_numero(substr(ds_conteudo,87,16)) || ',' || somente_numero(substr(ds_conteudo,103,2)),
	substr(ds_conteudo,81,6)
into STRICT	vl_saldo_inicial_w,
	dt_saldo_inicial_w
from	w_interf_concil
where	substr(ds_conteudo,1,1) = '1'
and	substr(ds_conteudo,42,1) = '0'
and	nr_seq_conta	= nr_seq_conta_w;

select	somente_numero(substr(ds_conteudo,87,16)) || ',' || somente_numero(substr(ds_conteudo,103,2)),
	substr(ds_conteudo,81,6)
into STRICT	vl_saldo_final_w,
	dt_saldo_final_w
from	w_interf_concil
where	substr(ds_conteudo,1,1) = '1'
and	substr(ds_conteudo,42,1) = '2'
and	nr_seq_conta	= nr_seq_conta_w;

open c01;
loop
fetch c01 into
	cd_registro_w,
	cd_agencia_w,
	cd_conta_w,
	ie_tipo_registro_w,
	cd_categoria_w,
	cd_historico_w,
	ds_historico_w,
	nr_documento_w,
	dt_movto_w,
	vl_extrato_w,
	ie_deb_cred_w,
	ie_natureza_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	insert into banco_extrato_lanc(cd_agencia_origem,
		cd_categoria,
		cd_historico,
		ds_historico,
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_movimento,
		ie_conciliacao,
		ie_deb_cred,
		ie_natureza,
		nm_usuario,
		nm_usuario_nrec,
		nr_documento,
		nr_seq_extrato,
		nr_sequencia,
		vl_lancamento)
	values (cd_agencia_w,
		cd_categoria_w,
		cd_historico_w,
		ds_historico_w,
		clock_timestamp(),
		clock_timestamp(),
		dt_movto_w,
		'N',
		ie_deb_cred_w,
		ie_natureza_w,
		nm_usuario_p,
		nm_usuario_p,
		nr_documento_w,
		nr_seq_extrato_p,
		nextval('banco_extrato_lanc_seq'),
		vl_extrato_w);
end loop;
close c01;

update	banco_extrato
set	vl_saldo_inicial = vl_saldo_inicial_w,
	vl_saldo_final	= vl_saldo_final_w,
	dt_inicio	= dt_saldo_inicial_w,
	dt_final	= dt_saldo_final_w
where	nr_sequencia	= nr_seq_extrato_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_conciliacao_santander240 (nr_seq_extrato_p bigint, nm_usuario_p text) FROM PUBLIC;

