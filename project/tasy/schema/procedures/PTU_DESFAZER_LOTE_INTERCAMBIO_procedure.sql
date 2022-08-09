-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_desfazer_lote_intercambio ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_intercambio_w		bigint;
nr_seq_empresa_w		bigint;
nr_seq_benef_w			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	ptu_intercambio
	where	nr_seq_lote_envio	= nr_seq_lote_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	ptu_intercambio_empresa
	where	nr_seq_intercambio	= nr_seq_intercambio_w;

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	ptu_intercambio_benef
	where	nr_seq_empresa	= nr_seq_empresa_w;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_intercambio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		nr_seq_empresa_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		open C03;
		loop
		fetch C03 into	
			nr_seq_benef_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			delete	FROM ptu_benef_preexistencia
			where	nr_seq_beneficiario	= nr_seq_benef_w;
			
			delete	FROM ptu_beneficiario_compl
			where	nr_seq_beneficiario	= nr_seq_benef_w;
			
			delete	FROM ptu_beneficiario_contato
			where	nr_seq_beneficiario	= nr_seq_benef_w;
			
			delete	FROM ptu_benef_plano_agregado
			where	nr_seq_beneficiario	= nr_seq_benef_w;
			
			delete	FROM ptu_beneficiario_carencia
			where	nr_seq_beneficiario	= nr_seq_benef_w;
			
			delete	FROM ptu_intercambio_consist
			where	nr_seq_inter_benef	= nr_seq_benef_w;
			
			delete	FROM ptu_intercambio_benef
			where	nr_sequencia		= nr_seq_benef_w;
			end;
		end loop;
		close C03;
		end;
		
		delete	FROM ptu_intercambio_plano
		where	nr_seq_empresa	= nr_seq_empresa_w;
		
		delete	FROM ptu_intercambio_empresa
		where	nr_sequencia	= nr_seq_empresa_w;
		
	end loop;
	close C02;
	
	delete	FROM ptu_intercambio
	where	nr_sequencia	= nr_seq_intercambio_w;
	
	end;
end loop;
close C01;

update	pls_segurado_alteracao
set	nr_seq_lote_envio	 = NULL
where	nr_seq_lote_envio	= nr_seq_lote_p;

update	ptu_intercambio_lote_envio
set	dt_geracao_lote		 = NULL,
	dt_geracao_arquivo	 = NULL
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_desfazer_lote_intercambio ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
